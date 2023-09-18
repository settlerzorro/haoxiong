import request from '@/api/request'


export function add(data) {
  return request({
      url: '/oms/expenditure',
      method: 'post',
      data
  })
}

export function edit(data) {
  return request({
        url: '/oms/expenditure',
        method: 'put',
        data
    })
}

export function del(ids) {
  return request({
    url: '/oms/expenditure',
    method: 'delete',
    data: ids
  })
}

export default { add, edit, del }

