import request from '@/api/request'

export function selectBrand() {
  return request({
    url: '/gms/brand/select',
    method: 'get'
  })
}

export function add(data) {
  const formData = new FormData()
  formData.append('brand', new Blob([JSON.stringify(data)], {
    type: 'application/json'
  }))
  return request({
    url: '/gms/brand',
    method: 'post',
    data: formData,
    headers: { 'Content-Type': 'multipart/mixed' }
  })
}

export function edit(data) {
  const formData = new FormData()
  formData.append('brand', new Blob([JSON.stringify(data)], {
    type: 'application/json'
  }))
  return request({
    url: '/gms/brand',
    method: 'put',
    data: formData,
    headers: { 'Content-Type': 'multipart/mixed' }
  })
}

export function del(ids) {
  return request({
    url: '/gms/brand',
    method: 'delete',
    data: ids
  })
}

export default { add, edit, del }

