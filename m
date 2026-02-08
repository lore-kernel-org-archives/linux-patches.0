Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E092F6937
	for <patches@lists.linux.dev>; Sun,  8 Feb 2026 19:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770578959; cv=none; b=jyuJ88Ww87LDa/C1GBHI/z7ngZH4/qSmBxiMfjDFpuueVGeYb9Pk6Fw2h7yxqad9wIHgX/hT89P1X1Db9o7T10DqwBlNL/h98j09APuz2ga77dMLZJILWfIuFLAmKz4pqXaBRvhrZUdlJ366NVWCrVaI5/uJDffyW+H0KQmoDUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770578959; c=relaxed/simple;
	bh=uJk/HTTQjHpgXXPF2B5GOFPeJOXoDW3E8CeIFbCNL1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=klGIzbLNApWBO4GF9hjoqxPCispqre3oXjIX4de4JENFwAx4Ttc+kOPf4OGJDc5s4i2fEMJ9OeJsqXA8sHrGseZhjOjQb9Ga2HTwd+geOhKK5F41gOz+mYFTW3cEXXKV86ZEZGsjenkwYEUyMBNp1x6fUdLeZGCSii0Lv1oHTbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kqVizE69; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kqVizE69"
Message-ID: <2768471c-4b50-4b34-a87a-35fbc49019b7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770578956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gnfwf6iR8d8srvLc5E+dFDSiCa06IAOvwSZx90D2AH8=;
	b=kqVizE69r608iPYE1KmoDKJ7c7ucoy6BWv3swvgR7YhIB9Uvd29QfV+DPK9JribauojKRu
	O9/RdmGNraSHQsop42/ehz+tYZDNj0APU6oILJ3ylm6R16nT0qyjBm5/dWLxBdiA7ykrLX
	8KKKKpaMOvXyt0U9ROoA//uW+50DF98=
Date: Sun, 8 Feb 2026 11:29:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 06/10] RDMA/bnxt_re: Add compatibility checks to the uapi
 path
To: Jason Gunthorpe <jgg@nvidia.com>,
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
 Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
 Selvin Xavier <selvin.xavier@broadcom.com>,
 Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: patches@lists.linux.dev
References: <6-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <6-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/2/5 17:45, Jason Gunthorpe 写道:
> Check that the driver data is properly sized and properly zeroed by
> calling ib_copy_validate_udata_in().
> 
> Use git history to find the commit introducing each req struct and use
> that to select the end member.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> ---
>   drivers/infiniband/hw/bnxt_re/ib_verbs.c | 29 +++++++++++++-----------
>   1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index f19b55c13d5809..2942ff44f6a547 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -1655,9 +1655,11 @@ int bnxt_re_create_qp(struct ib_qp *ib_qp, struct ib_qp_init_attr *qp_init_attr,
>   	qp = container_of(ib_qp, struct bnxt_re_qp, ib_qp);
>   
>   	uctx = rdma_udata_to_drv_context(udata, struct bnxt_re_ucontext, ib_uctx);
> -	if (udata)
> -		if (ib_copy_from_udata(&ureq, udata,  min(udata->inlen, sizeof(ureq))))
> -			return -EFAULT;
> +	if (udata) {
> +		rc = ib_copy_validate_udata_in(udata, ureq, qp_handle);
> +		if (rc)
> +			return rc;
> +	}
>   
>   	rc = bnxt_re_test_qp_limits(rdev, qp_init_attr, dev_attr);
>   	if (!rc) {
> @@ -1847,9 +1849,11 @@ static int bnxt_re_init_user_srq(struct bnxt_re_dev *rdev,
>   	int bytes = 0;
>   	struct bnxt_re_ucontext *cntx = rdma_udata_to_drv_context(
>   		udata, struct bnxt_re_ucontext, ib_uctx);
> +	int rc;
>   
> -	if (ib_copy_from_udata(&ureq, udata, sizeof(ureq)))
> -		return -EFAULT;
> +	rc = ib_copy_validate_udata_in(udata, ureq, srq_handle);
> +	if (rc)
> +		return rc;
>   
>   	bytes = (qplib_srq->max_wqe * qplib_srq->wqe_size);
>   	bytes = PAGE_ALIGN(bytes);
> @@ -3156,10 +3160,10 @@ int bnxt_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>   	cq->qplib_cq.sg_info.pgshft = PAGE_SHIFT;
>   	if (udata) {
>   		struct bnxt_re_cq_req req;
> -		if (ib_copy_from_udata(&req, udata, sizeof(req))) {
> -			rc = -EFAULT;
> +
> +		rc = ib_copy_validate_udata_in(udata, req, cq_handle);
> +		if (rc)
>   			goto fail;
> -		}
>   
>   		cq->umem = ib_umem_get(&rdev->ibdev, req.cq_va,
>   				       entries * sizeof(struct cq_base),
> @@ -3289,10 +3293,9 @@ int bnxt_re_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
>   		entries = dev_attr->max_cq_wqes + 1;
>   
>   	/* uverbs consumer */
> -	if (ib_copy_from_udata(&req, udata, sizeof(req))) {
> -		rc = -EFAULT;
> +	rc = ib_copy_validate_udata_in(udata, req, cq_va);
> +	if (rc)
>   		goto fail;
> -	}
>   
>   	cq->resize_umem = ib_umem_get(&rdev->ibdev, req.cq_va,
>   				      entries * sizeof(struct cq_base),
> @@ -4391,8 +4394,8 @@ int bnxt_re_alloc_ucontext(struct ib_ucontext *ctx, struct ib_udata *udata)
>   	if (_is_host_msn_table(rdev->qplib_res.dattr->dev_cap_flags2))
>   		resp.comp_mask |= BNXT_RE_UCNTX_CMASK_MSN_TABLE_ENABLED;
>   
> -	if (udata->inlen >= sizeof(ureq)) {
> -		rc = ib_copy_from_udata(&ureq, udata, min(udata->inlen, sizeof(ureq)));
> +	if (udata->inlen) {
> +		rc = ib_copy_validate_udata_in(udata, ureq, comp_mask);
>   		if (rc)
>   			goto cfail;
>   		if (ureq.comp_mask & BNXT_RE_COMP_MASK_REQ_UCNTX_POW2_SUPPORT) {

