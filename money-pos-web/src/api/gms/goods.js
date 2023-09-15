import request from '@/api/request'

export function add(data) {
  const formData = new FormData()
  formData.append('goods', new Blob([JSON.stringify(data)], {
    type: 'application/json'
  }))
  formData.append('pic', data.picFile)
  return request({
    url: '/gms/goods',
    method: 'post',
    data: formData,
    headers: { 'Content-Type': 'multipart/mixed' }
  })
}

export function edit(data) {
  const formData = new FormData()
  formData.append('goods', new Blob([JSON.stringify(data)], {
    type: 'application/json'
  }))
  formData.append('pic', data.picFile)
  return request({
    url: '/gms/goods',
    method: 'put',
    data: formData,
    headers: { 'Content-Type': 'multipart/mixed' }
  })
}

export function del(ids) {
  return request({
    url: '/gms/goods',
    method: 'delete',
    data: ids
  })
}

export function split(data) {
  return request({
    url: '/gms/goods/split',
    method: 'post',
    data: data,
    headers: { 'Content-Type': 'application/json' }
  })
}

export default { add, edit, del,split }

