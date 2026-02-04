Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC0635950
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 16:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770221400; cv=none; b=cQttWLLWsNhXEpQqx8OGnhQDFOr4wXacv+gL+vsztPhL1SUdDsHLIcXPT+g/KPIiR9+WrsFQIz+7/u39PYAtMcoVai2qjOdgOo1ShosRLOqOBo/+obfhEbu/a43rF7Toy/1oaQZscklyniqa1Xolj2GG5LEt5zUPHKD9lAOzTOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770221400; c=relaxed/simple;
	bh=r5jkgBASvfahYDIpNq482tH9/i78Bx5EpWMZOjx0RnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TlCszaFWTjDi8FfGQZk4PgYJ7illOy0Pxf/5MyQjwmkjSAWMQjKyX6c8qucxMZeXGoz68vKsf1So+sp8u2RXrMyvKQLt0BKO02wngZUvWIauUGz6BS+OM/j01hZ6I5Bey9Da+XDWzNtGQwNgZjkWr5DnTTdvAOtlS1YyyFYZ9g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iotCLpR+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Zx17HLZh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iotCLpR+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Zx17HLZh"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614CIkF6200363
	for <patches@lists.linux.dev>; Wed, 4 Feb 2026 16:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Cfk2AxvSUaOW6gTcg737om3J
	rAPlsakGmZKpL4ObUwU=; b=iotCLpR+MUNKsJaGaSaLwpHUjtrsFLqlafbgHX47
	QEq1AOjsjDh87wO13lUIj8MSyXlPbLm9icxg1UVJA4g3EX1SG2/qv5RaoCChX5Ve
	EpxiQRQjsWclmrEINKGbfJ581H+s6+2dneGGHsGtQTKOByV4wHx1mX0fMOFWCKBt
	hC1DHFFDbKwJSOdufwbidZZ/RwLMStXJuEd4utvc8FboH8DP4frVq6E4dMDRfsj9
	f9cYM03E6QvB5bRZ8ivO58Zs2V1lLm9hHmQjEJGQooXx2fNpauUOqVD3WPFStd4M
	xF07fj+1+5DhTvpmq1FrKzJLvlzfl2MyO23pOuv4zAWU4Q==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c3yp59xum-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 04 Feb 2026 16:09:59 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2b8295e5703so10997629eec.0
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 08:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770221399; x=1770826199; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cfk2AxvSUaOW6gTcg737om3JrAPlsakGmZKpL4ObUwU=;
        b=Zx17HLZh5Iz9F/EgARkxvY+LlKbjvJFl1WwLBoLZXdcJdCjHmXs+0zK5Rs+ZY3i2Wg
         yG7sTPkWbiz909XEHn2KuCQ5YnUaUUZ0IvEaIyvBfiGKS+SNMoisYmrKN0bqTE7winJK
         70H11ujFHFlJN4eb9/rnl/RD2EzvQSFw+Lmhgsi682NBQkjnTS0Oqu54yyBwLrrKSCR1
         g1lpik5gVGebl8qKK/taaFCCyJ4kAJH609G2d56Lt5/IBBT8EwJbtFFkv7bewSrUW7+c
         ISxydEIqSrKYLYybbhwEV4T74IivUBaqoCdK4SzDd+zmHK4djCO4tZTqX3iTgr1UWPTe
         qQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770221399; x=1770826199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cfk2AxvSUaOW6gTcg737om3JrAPlsakGmZKpL4ObUwU=;
        b=oMm9UfF16PorANUN7zMh1qSn7JH/pwLpfALqR8lq+YnGb3wn9jomgy57I//VilhLhF
         07oPRPA4c0w/ho0MnxPqTX9o2GkfznP9qEl+gFyMLSx12lHgIpfj4AQXTQbi97Ev5/QY
         bKIqDReAMQrTouWxYDktPc0nBdckbm6Prt1zgIw3weXexBAFfzoJI+QfFp0VLIaCgmjb
         AICG10DKl33Uipb3RyEyXEQO+p853BO6BFUuhs/LLDHf1lkUgiFOYtB5URMU26CcWrId
         34SjWOh6bEyj+7XyrNhyvwIy41VjlNjlfwG4ylGiq0RglMOuZpenp6lquC2R8J96+FuU
         qEkg==
X-Forwarded-Encrypted: i=1; AJvYcCXb8ENsttop2w3y4aV7PyKmN8UZyBgmnn/xMEf90hn3qnMOuPyTc4fgUucj4MwF+iTEJSbiXkWd@lists.linux.dev
X-Gm-Message-State: AOJu0YyOAZgtpZHRHeWN6Y0gKEbMJIRO1fi5ZFrnWP5CL6dL+k8C/q2P
	5CUdZz7J5JDrCVBmhcwUSLFL4RUdVJcgiFCbGTtSi96L6UoLFvlZsmGz24Ww8vj+M3JwSOHANHv
	1KtkEv2p77RkXO6FSSynIyGwO82ZDoZEigIZ0DNByuCPaMf5e1NDYNY6kKMRp
X-Gm-Gg: AZuq6aLXohSM3QEGitYR3furVGm84lt392sbB9YrIqL3rkmbNDqOZurhZgFUS/eQFXv
	lHogOBuZNoPX5a5GWTjI9c4fKkv1QqpJJMEl8iT5HBhmbUaK3rt4sB+EfNPINhtzOGDhywgZlbE
	TCoMOXK6UV54kVWYVzPRaEeC8RPYMJHT+wo6FbyxkP+mFUeftenug0RSOzSDW5qeoygT1QKCEDh
	YL93xyAJU3sBS1+cDVSoEJNNAtKmWxlEysFveX6Bt7hdDu+gPKqEsl+z0YpjTWH3OTbIPpKFQ2U
	xoPmAfu/DuCspFj++ifAhCmp3j+bidi7IIwzVcTMgJH9YIuYIorimcK2fLgSfaQ4MsmO3WvSgAb
	tZJNlz/SKUKscdgoFM+M=
X-Received: by 2002:a05:7301:1296:b0:2a4:3593:646b with SMTP id 5a478bee46e88-2b832a556a6mr1776495eec.27.1770221398520;
        Wed, 04 Feb 2026 08:09:58 -0800 (PST)
X-Received: by 2002:a05:7301:1296:b0:2a4:3593:646b with SMTP id 5a478bee46e88-2b832a556a6mr1776447eec.27.1770221396480;
        Wed, 04 Feb 2026 08:09:56 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832f8e78esm1613358eec.16.2026.02.04.08.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 08:09:55 -0800 (PST)
Date: Wed, 4 Feb 2026 10:09:54 -0600
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
        iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
        linux-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Tomasz Jeznach <tjeznach@rivosinc.com>, Will Deacon <will@kernel.org>,
        lihangjing@bytedance.com, Xu Lu <luxu.kernel@bytedance.com>,
        patches@lists.linux.dev, xieyongji@bytedance.com
Subject: Re: [PATCH v2 5/5] iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
Message-ID: <5vwi2ayg7mr7ug7ydlyonlrcser5o44pycjsjhg7nyvppuwhhx@gd3s5x6gzhhe>
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <5-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <dn7bsft2qvjod3sm6omneq37pwr2jtdzgobapy6obpgccg7soc@ctvs3c2w4vob>
 <20260130234434.GK2223369@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130234434.GK2223369@nvidia.com>
X-Proofpoint-ORIG-GUID: 7huirPyBb9g2_u5o03O0AyDFzt8kujb8
X-Authority-Analysis: v=2.4 cv=cquWUl4i c=1 sm=1 tr=0 ts=69836f57 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=mqPRyWp8_4GUfDidQbUA:9 a=CjuIK1q_8ugA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDEyMiBTYWx0ZWRfX+jLbX3WW9BHd
 ifucVAHozGzR7H+Hb+YhCL1b6Y+PXErP6Y0zEUPkkgtT5v5iuPolQUdFFmcXu5cTCVBmIx/hjie
 Mhhuby5NYRtmuz36fkZE2v5PrNULiT7jc/OZjRoHVsMyV3SE24N+1b5TN5IFKhVX+W6xQp1w3Md
 DMH5IVph5hUZIgZu5HzQCk+H68Ki7j9rJWqiYDwyddDTVx9D4YlXbvRPYaHlA67LOrrJMsjfOPD
 1CCtWZAOKtj9JsxZmFn6YBB5tvPlxUjzUCj2TXgKB1Z8xDtLCMfRCob6rTjgTFtm8QWPxVLnUPv
 IybcEPXlLJW6ufwZb0XZU5vZ3EeLLqN/vGVCzWWvQRqLIB79PnWCWG0R6j4BckXstzlS8jX/e+C
 9IA0Z+1FWJ6LNMRy+CGvVU1oJgUr9MEUwLdtnhJXmJB20+CdEZ3UtOE/nqKHHVPlmwktU5qn26I
 QD6IgIwHe/sLpoNrDtw==
X-Proofpoint-GUID: 7huirPyBb9g2_u5o03O0AyDFzt8kujb8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_05,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 clxscore=1015 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602040122

On Fri, Jan 30, 2026 at 07:44:34PM -0400, Jason Gunthorpe wrote:
> On Fri, Jan 30, 2026 at 01:58:51PM -0600, Andrew Jones wrote:
> > >  config RISCV_IOMMU
> > >  	bool "RISC-V IOMMU Support"
> > > -	depends on RISCV && 64BIT
> > > -	default y
> > > +	default RISCV
> > > +	depends on (RISCV || COMPILE_TEST) && 64BIT
> > > +	depends on GENERIC_MSI_IRQ
> > 
> > This new depends isn't called out in the commit message. Maybe it should
> > even be its own patch with a fixes d5f88acdd6ff ("iommu/riscv: Add support
> > for platform msi") tag, but, either way, thanks for the fix.
> 
> I think if riscv has a 32 bit configuration with iommu HW available
> then you'd want a different fix to make it work.. Probably include one
> of the high/low headers to get emulated writeq
> 
> This is just intended to make it work with COMPILE_TEST on eg ARM32.

I was pointing out the new 'depends on GENERIC_MSI_IRQ'. We had the
64BIT already.

Thanks,
drew
