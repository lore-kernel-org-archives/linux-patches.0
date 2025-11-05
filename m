Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7B22D6E61;
	Wed,  5 Nov 2025 07:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762329527; cv=none; b=G6bQ0GkCuodtFBdHpcbqP/QVMtLKFe/j5klz9JjgYmyJf/h1q4P+yLfNziNvqrb3Ykz6mWSiuon6fUzpMxkGjKzRvgIfjp7LjHof5Pmo35F0V36MISC9oht0HQbFZQmLJtypt4br3ZCs8CwSW4WJ6LQ/OcT41HkbOJjoQgAomZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762329527; c=relaxed/simple;
	bh=ejmf0LYtGv54COp6AgkfEFUKHQrBNAEk+1crHgWUcek=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A/iC38Vg+R1zWIErMLoUWGF01pZHmzTblJzJV9goTvaebSPXOwPpjWdr4M1OsEtbwe4viPmfuBNjLfOEaxKkQ6ls5osyJCBHp5tEVzgCR0Lm3z2HyVgBwY2hF/tgByvXyXiJmPFVbDDi8UVFT9YwDMbKZbmAiA8Oj0RwGMoQeew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=0AZehmGW; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="0AZehmGW"
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5A55L2GY465486;
	Tue, 4 Nov 2025 23:58:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=QP8yWRbPuUYOOh9yRKCF
	fuc9UFzcFCHQzQMKDZyG7Lk=; b=0AZehmGWd32aDJd6DXaUMtefNtrVrBqOS89e
	F10YjCxOKKdSXY9x0eqTh/G0Gx5vopS3oO00b7XFUjwqK8zeeXDXc5alExdMphMd
	z6LpRPPOPppaBWry80zPz5pFv9neCY21BAGHfgYlWecpm1KRmYW6fbdbBedb5XhZ
	IhXNoyFEFJsb9pTYSCX1Fp9UCjeHIUw618CUlKCZqDuqhvzeqw6SZV+849QsUf1w
	fXNLnMdV0Hp7QNKg/oJHCDCcTPMfGFjylNJupPNGfrFXgFaJwXncpWmN//T9hKGf
	MtkhFGvNZ5F6UtmCp/3UA4SULhJK2ueCbVGK+ADKuWhKnAr6zA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a80by0n04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 04 Nov 2025 23:58:30 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 5 Nov 2025 07:58:28 +0000
Date: Tue, 4 Nov 2025 23:58:24 -0800
From: Alex Mastro <amastro@fb.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <iommu@lists.linux.dev>,
        Joerg Roedel
	<joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
        <linaro-mm-sig@lists.linaro.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Shuah
 Khan <shuah@kernel.org>, Sumit Semwal <sumit.semwal@linaro.org>,
        Will Deacon
	<will@kernel.org>, Leon Romanovsky <leon@kernel.org>,
        Nicolin Chen
	<nicolinc@nvidia.com>, <patches@lists.linux.dev>,
        Simona Vetter
	<simona.vetter@ffwll.ch>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        Xu
 Yilun <yilun.xu@linux.intel.com>
Subject: Re: [PATCH 3/8] iommufd: Allow a DMABUF to be revoked
Message-ID: <aQsDoHM+eGN0uLhk@devgpu015.cco6.facebook.com>
References: <0-v1-64bed2430cdb+31b-iommufd_dmabuf_jgg@nvidia.com>
 <3-v1-64bed2430cdb+31b-iommufd_dmabuf_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3-v1-64bed2430cdb+31b-iommufd_dmabuf_jgg@nvidia.com>
X-Proofpoint-GUID: qZJProPDOAPs2uyJdjZB9QHuvfQJCGRs
X-Proofpoint-ORIG-GUID: qZJProPDOAPs2uyJdjZB9QHuvfQJCGRs
X-Authority-Analysis: v=2.4 cv=Y9X1cxeN c=1 sm=1 tr=0 ts=690b03a6 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=x0DUne6oTFOVQpvc-HAA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDA1OCBTYWx0ZWRfX2Qkc85mMaTMS
 oxLfWawui3IoOYFhh3mRL4dGLEZ4TjPEvzvRlQ4RHYbQpqwxFiqFD+gAb+DaEuGCTjbQZzWLKo6
 fSK2287FfM4K6mzbY5PY20qKAH/XCFKBpJqMgh7LE1nAzPgxBBGv5U66r0e8ODUSxMkbWmUGtqR
 VK84opxtnPF8WiiETdTLdr97FbNeBDuSMrWUIiVt6Ago/eFd8Vu0LDa4IjZaPmaOsnc83nBjTS2
 XK0Lv+kBvo4fbIoxvPhF0SYIOWYwxX20dhlA7Fn7o2V8sGXbBF6Br5PDn00+d4W1OiTqujqfVUV
 4NMYzgq8IxX67+S3VZGfSdoKjLGktqKsxpfmfsXOK8nRv9t7lvDURkqI8H2NdBPnGd6O6Buzxmj
 Tj1mxbkA0aSXWzLiIVpioH52IUEOBA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_03,2025-11-03_03,2025-10-01_01

On Mon, Oct 27, 2025 at 02:31:02PM -0300, Jason Gunthorpe wrote:
> @@ -1024,8 +1027,15 @@ static int iopt_fill_domain(struct io_pagetable *iopt,
>  			continue;
>  
>  		mutex_lock(&pages->mutex);
> +		if (iopt_is_dmabuf(pages)) {
> +			rc = iopt_dmabuf_track_domain(pages, area, domain);
> +			if (rc)
> +				goto out_unfill;

I think this error path results in locking pages->mutex recursively. Needs a
mutex_unlock(&pages->mutex)?

> +		}
>  		rc = iopt_area_fill_domain(area, domain);
>  		if (rc) {
> +			if (iopt_is_dmabuf(pages))
> +				iopt_dmabuf_untrack_domain(pages, area, domain);
>  			mutex_unlock(&pages->mutex);
>  			goto out_unfill;
>  		}
 
