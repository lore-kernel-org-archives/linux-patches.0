Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8206F2C3258
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751030303; cv=none; b=G/i3ndjgMOGJfsQW5cT6P9MD3CPyryaabqLzadT9nNvYvrJPoLSRHLVQ3NDcrWGlHUeDGED/u8UV/ovoxLeyztbOdqqALCJUFIZqcOcq+p0pRqgX1nSrsq/Hopt5y3iNFnWYlb4PS/8e1Ho8FRU9309fQvBd0QNwIXIxJXtfCPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751030303; c=relaxed/simple;
	bh=DASYvfhNb+2DE4FVIzEICu3iK7wNmHwBQ/TclEhRxEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rFfHvi6ijfdrRC1lk6VXW6cECmyNHdICY1kvFNXa3DjeBUla3+tw9ae4eMzzF0l0FTOGyvTIuqV4JEAiKNfNuMMOEEb99C+6ZEkwirsZ0oZMHeAJ3IXjIJbdB4Rqy3ZUbi9Y5STW0Ew5+hbfTE6CBrJL3rRcxYdzJO99BCHe36I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H/TZJRlv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H/TZJRlv"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55RCHDeR027611
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 13:18:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	B3DKye6fgw14zQoKRPlEfu7aezVTsZmbUNecwjwCMbU=; b=H/TZJRlvPlkKe58P
	mYf0/uRMYn4I00zjGoKaOV/SEIvqHaBa1iw3jehG1TbF9XoKxf/ykbVTnQHLzfdJ
	7SZFgonKBD9YcyfwqAui1NR6k0MWoJ3Xs6ceB0dIvZZN+X6xnZCLhCKwA7g4kjrM
	DyfoGHDTYN0DuXFVgfTu/VHeUzyoelae67zJC27ElCKtzhJTvLqN7XP+WelnmRgK
	1e+GmEuWYgIzN1Rwt0W7GJq7apZ4m3G/vDOdlAq59cmo0ndUzYgxc4ezH3nxkKLI
	CKqyjdhTXNf9pxV4/UZKccO7tu9jneBf1zTAQjQ8/l7HiUqeGC7V7vZ8N8RKk/SP
	J3OnUQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47ec26hbb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Fri, 27 Jun 2025 13:18:21 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6fac0b29789so4000326d6.2
        for <patches@lists.linux.dev>; Fri, 27 Jun 2025 06:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751030300; x=1751635100;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B3DKye6fgw14zQoKRPlEfu7aezVTsZmbUNecwjwCMbU=;
        b=srODUSMZisMnLYqisVupmHQiALErFa6YAECFD21PGHZ0C+0x4V1bvXoQbQCsKDGrwR
         CSNkt5saS8Ns4rL/y6HNTHhUkormc3G/U2E6mCGsegKeHnX44D6o6abfDfYiRI1R0++B
         0xFR22KFgYocoxr8HPukq5hCQ5Az8b51HgFOSoo49IL2C0rRXjU89ICjWCqhFzJy7mNm
         pDPpHmd527K94McS8jdzYU9DNp3lPv/uGkIrPcMYlXd51o80LiRShRt8F6skWXgI/ydA
         xBkmWJb1GNLfzipJWbMnu4OTiFyAdXGRZ3hRnSTCrsM1tAWDw1sruEGimUUo7OpGtoE9
         9Trw==
X-Gm-Message-State: AOJu0YzV8bAQgz1wp7yUmYolN5B78BQm+hLgDuNxUxn2npHnYZovUTXV
	tf067EgLgiwPZTtIjAqWE3LnMYDgu1A6ycIWzd2+RdkjV0TTCmeSlg/jBpgRHj6xsiand4pXCr2
	cOf1lcCgPBtkPhrZen+f0wyFarjTM0fdEszB3CoFxRbN3y5Oi0QhkjUZa6HWb
X-Gm-Gg: ASbGncud5VuTh1OUW7rTZqcT0wcOys2P/YhnUDaVplpYByPergitL8nOyCuxRL8T42K
	zyRzwKpgrCdc6eKMczUPdiFGuKOSXAom8JyBRLmlJgBzO0nLeAmsnmRVCJWctPWule19MzojwbQ
	L+W5nyGBgNYiGigUyraAkYVLr12P8nIHWSy/9IW0wz91pep+4Svdib9Us4s0oNNlmcsr+snjxS5
	hxt8BUJNla3LxJQQfoIKNuJwlioQZkUsKjnkddUE+VWmIYzVsJU7dkcovYdhezWjES4L55x45Js
	RMRflHbBbsW6lfrfQWytz3kuzmoeygcQ11OXsV8Y5yqLlaSuZGresUBycsHNbJgs6esa0s/kFLX
	IliY=
X-Received: by 2002:a05:620a:45ac:b0:7c5:9ab7:3012 with SMTP id af79cd13be357-7d4439b767amr166877785a.11.1751030300387;
        Fri, 27 Jun 2025 06:18:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUjyId3keHx2+y/xDg8fhhpls0ND2oa3mIvMxjZRcmTvKRosNCivFewSfNCRcPy9zLXcv5QQ==
X-Received: by 2002:a05:620a:45ac:b0:7c5:9ab7:3012 with SMTP id af79cd13be357-7d4439b767amr166875985a.11.1751030299816;
        Fri, 27 Jun 2025 06:18:19 -0700 (PDT)
Received: from [192.168.143.225] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353659f7dsm121431966b.45.2025.06.27.06.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jun 2025 06:18:19 -0700 (PDT)
Message-ID: <6aa7ce8e-b963-4b93-981b-771726349b73@oss.qualcomm.com>
Date: Fri, 27 Jun 2025 15:18:16 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/msm: Remove ops->pgsize_bitmap
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, linux-arm-msm@vger.kernel.org,
        Rob Clark <robin.clark@oss.qualcomm.com>,
        Robin Murphy
 <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <0-v1-662aad101e51+45-iommu_rm_ops_pgsize_msm_jgg@nvidia.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <0-v1-662aad101e51+45-iommu_rm_ops_pgsize_msm_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI3MDExMCBTYWx0ZWRfX2yquvt/YdIEp
 mmOwh0MKzkA1pSSPCJI8I21wZKJyCuIa43goGa0A2oZxSPAP5bHXZHoTgBnbwk+CWU624H6eQoi
 kfpIGCtz1iEcySK1szNlVrhtvUPkKT7QNiRq0ALRBW+VjKCa8uq+/TTp8Fsyb7yrSQxih2qkHsT
 VHwdqFKqb1ChawfgZcGLkr6yRx/qZr1EjbAd9GI/NGfTLs7/Qzc2r/POSDfrbwwLPuU0bKN1FTN
 r8xjevK98BOSrcrYTyrvVDZVUg5M/SSFAMHEHCDMrUSD+1DMuaz9iNDHMZF9RBoYVcNBAzketBL
 RFwoSjB9TMJFH/EI8tHwEhdVFYpn4ipjZxNPVTpfADKQqB9ULB5h/wWYsQo5ZOhs8k4GHjL3r2T
 vbk/92/NOn5I+rKKeNQlXt+EMNE8azb+RjvnU3U3ZxEo337KF52aBhdyht+wONhMq/Iwev25
X-Authority-Analysis: v=2.4 cv=XPQwSRhE c=1 sm=1 tr=0 ts=685e9a1d cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8
 a=KFRqgpUkTpDQm5BOWHkA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-GUID: KExdFRfzL4qGfkpvq8UuCiFBdVH9cc5z
X-Proofpoint-ORIG-GUID: KExdFRfzL4qGfkpvq8UuCiFBdVH9cc5z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-27_04,2025-06-26_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 clxscore=1011 suspectscore=0 mlxscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=984 bulkscore=0
 priorityscore=1501 adultscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2506270110

On 6/27/25 3:02 PM, Jason Gunthorpe wrote:
> This driver just uses a constant, put it in domain_alloc_paging and use
> the domain's value instead of ops during finalise.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/msm_iommu.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> This is the missed patch for the ARM32 build, nothing is remarkable here.

This driver is a computer museum candidate and I have no way to
validate things, but the changes look trivial, so:

Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
