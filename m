Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE8B224AF1
	for <patches@lists.linux.dev>; Tue,  5 May 2026 22:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778021235; cv=none; b=qSUrisfWFWXIB/IXAT2hH+M+MxbdDBH/17u5c4g/r87a8odoVweES9/JRr430TZqim5H/UDH1oB9aU1kyya4vKGBynm1beuLDC46Wh86jZNvP2M2Irj5WNFg1pVcJHlVaumisQ13oBCpq2SOH/cqGjpU94DT6ZXP1vK/gt7tWXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778021235; c=relaxed/simple;
	bh=ThAZON2qJ1bfOCpmOWqCdEaMPjyOeWFL9PwzOSaVDHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fMf2DaSA+uiNiWdGp0UNaZ9lkq1FqJdcyS0C0xl41qfrXXWY7Sspef9tC8qzarCxALGzkTD4Hspc+DyOehMH4SH4kPQRXmi7Rmcj+PBHRV6udulzWn7V+/hcw5hBQej7fTOKGaNc4va8MPKtXbW24SlRQ3RZECc5uHxISWp7akM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nGLZ2qSW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UXp92ayj; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nGLZ2qSW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UXp92ayj"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 645HxCa83091523
	for <patches@lists.linux.dev>; Tue, 5 May 2026 22:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=80QsdjvMKgByQ+N3vQwQVN1P
	Ot2Azp0fZNR7U+S/ywA=; b=nGLZ2qSW7qAP5IVLc38deKesNE4nEEYyU+ewj6Fz
	7BHEEClAsMXCAyFHJckZhk3z+nMe4UQQx4I39gumjZrmCnUch5jJCoKvQLLbVpqG
	Cu6uTPx0UgrYCDeZrs+t1xG65UADU/Wq/tr6DVhgTylph7zQiaTPgB/ohRlpLS9Z
	iWu/cjQrz+Z5GlHc5uvoSOkus2kGFIbdZz2P6ldJzrhoVBg/6BstxoQj9NSHicz3
	cFk/HxsYqh/0Oqd0uyK7cVuGbyC84ZpnfgJl3ZVjHYIbHkNUanzoG4bkOg9af99U
	XkOCPrli0Ndu6uU5hjdVBucJKSPe5Ympn8/iJ/+56UE5eQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dyfct2kb5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Tue, 05 May 2026 22:47:13 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2c0f6593ef5so8232423eec.1
        for <patches@lists.linux.dev>; Tue, 05 May 2026 15:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778021233; x=1778626033; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=80QsdjvMKgByQ+N3vQwQVN1POt2Azp0fZNR7U+S/ywA=;
        b=UXp92ayjZu68AfjPYPlPEKuxtJ3l1wNWASeBYdmb/drx9uU/9ACi41cOrsBNMcBFUx
         jbpKI/Ml2uXwOzChyFqGPR4H7zDu4FJDSP+5tZqMefS86iYXawWr4ul8cG1Ja07RoAlh
         eYUdl1DwFiwV93m8lOAc3NV+yXCC1jQMwQbmdNKF+Lwxg0LkJgcVuptplWvAObtibX2u
         4sMPh0ZLwVoUv+VTwm2Tt2nESumSyflim/6612aYba//gHX2KxtSu7X1XGK4Okcs/Qft
         G3R2iwcRlvItsHkrX6edzBBtpJuZJ01IlGaR8Zv5ijpFsXS41LtKtM7HIXTg7hnixrnq
         LEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778021233; x=1778626033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=80QsdjvMKgByQ+N3vQwQVN1POt2Azp0fZNR7U+S/ywA=;
        b=tUWAjP+dtqUEskIBdCLUl6isF1GqaBg7tOMOLPeBeS8q/moZaWeZGt9xi2DNb2jn/C
         BtJTEe3itG0aJKBzSsMxLpKvwiRuTOPekBR4A7BvApwBXWkhbHbeC0MKQcZwckYXgV/r
         jIE2UHEgXAppHBd46W0f+u+qd84Bkybwmvy/tsOg1LAIeH00//pwUmIvhYkbNrUk8Q7G
         dd7bMJNbChUDmI+3Mp7ujXWgM7zc8gVMqhevhnoZRwUpm/Ua4cTWUJfdeDHxQ0WUgIjn
         CLIT/fPQtbTnShHjr7Bwfgi22YP84sb1aNuxIzQdARykjRfWMiYI5UeZOfNP7b7OqxK4
         krsw==
X-Forwarded-Encrypted: i=1; AFNElJ8fND9w5XCHHr2X3L/LQmGlYNFcGQbpHcfnlYX2GCIIhyJLmzaM7rvfRGuw0KpbOEgm8r9DSuwX@lists.linux.dev
X-Gm-Message-State: AOJu0Yyh7w6wU/FddYL08r6/u0y+KLr2WjLDQWrVIMRn27nZyTEcF1Ho
	rzm4wi9yR6kMKJ7way6uqe7H4T0H3N/ZJj6YY4XJ5l+BhKp8zGs9wR8UVk+TDD7f6P9rppf3Kqb
	62zAd0jmol59wXpwfkLCxc5SKXjp7HDlZXn0940nHZ8P+UksvVVSCqd4r+OfN
X-Gm-Gg: AeBDieuRU1ZQ6XraP0DDZm/4U47W8EpsXbDg9lOCTcH11xhnts+b2P/WiydW8y15Dq+
	jZ2tAwCH14FrVpo2540nhguSVqq53yqSrMWCfTSdfxuUPH2Pdwccw72b2YKg8yvN1e3AJRR8FOI
	rgjmEB3VQAylM3lzedqzmB0ztceAECejKkEktRgOcuoQBICpZwEQa9HjtWaNMfAYSdtxsx5FouF
	RTyXN/xr2KZi8NOwIDYw7JGY3fyeibKYimGOrdAvQc60b3rSP1xCc0jZrhTWB3EDwxZXtCLOCPB
	Naq3lBXRYKfoHCSUe6TpzXXAa1ca8J021or14ZorzQMcTMdrfwrY4DIoaKxSlaxP0k6E02lopKf
	9PhzmhHFsY/wwnpFgbEOTm8FnSywStvxycKuxHy/ogA==
X-Received: by 2002:a05:7300:bb8a:b0:2ed:e14:7f5e with SMTP id 5a478bee46e88-2f54b899b3dmr493952eec.34.1778021233028;
        Tue, 05 May 2026 15:47:13 -0700 (PDT)
X-Received: by 2002:a05:7300:bb8a:b0:2ed:e14:7f5e with SMTP id 5a478bee46e88-2f54b899b3dmr493936eec.34.1778021232461;
        Tue, 05 May 2026 15:47:12 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f56d5c5027sm828041eec.10.2026.05.05.15.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 15:47:12 -0700 (PDT)
Date: Tue, 5 May 2026 17:47:10 -0500
From: Andrew Jones <andrew.jones@oss.qualcomm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
        iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
        linux-riscv@lists.infradead.org, Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Tomasz Jeznach <tjeznach@rivosinc.com>, Will Deacon <will@kernel.org>,
        Fangyu Yu <fangyu.yu@linux.alibaba.com>, patches@lists.linux.dev
Subject: Re: [PATCH 7/7] iommu/riscv: Add NAPOT range invalidation support
Message-ID: <oe75yk2fx2c7wg73xrikppw2gxxe2e6bsvkktowbo64ftldy7p@53gjjzhu6cy5>
References: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
 <7-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
X-Proofpoint-GUID: kPN-M06bxj-65UyBptbPVRKXBxtwganB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDIyMiBTYWx0ZWRfX7E9gDBofU7a6
 DXiNZl5BNz8bePCz0mtHIgzPcKorfHd3BJOrBHI5588T5dzBqRI22Pzht9Bjm6+kfVsM7PDCs2H
 Mnre40SpX+2o51eICBBQDHGx3V6C1lGo/klKDEnRdM4kNRYpZOk2EKShM+QPPQgTRbyCImaLA4W
 +PvbJvczdpRMVLHK7bI5sc08imKOHAga7lB1y+K7Wg9e5WrJU07hVP+Dmd5o6r+lcqBQgAsGdl3
 APW0rT2NKEZsBzuyTi4mUkNJELUYLIBOdkFgfQVOFzAvTGFZQDpGwVgudZTSRsq8a6vO8CCaVE1
 9qIGyDShFDbYmP5jRZDs3eLoVJ51rJQ8siPcn+A1EURVMa9QQvFhyAD9eGoeAbwf2NXruPRNX/f
 ufg0i43NU/VE7WRbs7L1k6eV76RPkUWZXVSZ7O0Mdhc2qKsPrkLtNMxVQs3LtCa1PtnG51Sa+P7
 tyieMRm33MCEv1oz6Wg==
X-Proofpoint-ORIG-GUID: kPN-M06bxj-65UyBptbPVRKXBxtwganB
X-Authority-Analysis: v=2.4 cv=NtXhtcdJ c=1 sm=1 tr=0 ts=69fa7371 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=cvcws7F5//HeuvjG1O1erQ==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=Ikd4Dj_1AAAA:8 a=h2i9vGFyncx6_ar2YjIA:9 a=CjuIK1q_8ugA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 bulkscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050222

On Fri, Apr 10, 2026 at 12:57:08PM -0300, Jason Gunthorpe wrote:
> Use the RISC-V IOMMU Address Range Invalidation extension
> (capabilities.S, spec section 9.3) to invalidate an IOVA range with
> a single IOTINVAL.VMA command using NAPOT-encoded addressing.
> 
> One iommu_iotlb_gather maps to one NAPOT invalidation command. The
> smallest power-of-two aligned range covering the gather is used since
> over-invalidation is always safe.
> 
> S and NL seem to be orthogonal in the spec, so if NL is not
> supported then global invalidation is probably always going to happen
> as wiping a large range without a table change is not common.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/riscv/iommu-bits.h | 17 +++++++++++++
>  drivers/iommu/riscv/iommu.c      | 43 +++++++++++++++++++++++++++-----
>  2 files changed, 54 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
> index f01b49ac815586..32b3ad3ac9ae59 100644
> --- a/drivers/iommu/riscv/iommu-bits.h
> +++ b/drivers/iommu/riscv/iommu-bits.h
> @@ -64,6 +64,7 @@
>  #define RISCV_IOMMU_CAPABILITIES_PD17		BIT_ULL(39)
>  #define RISCV_IOMMU_CAPABILITIES_PD20		BIT_ULL(40)
>  #define RISCV_IOMMU_CAPABILITIES_NL		BIT_ULL(42)
> +#define RISCV_IOMMU_CAPABILITIES_S		BIT_ULL(43)
>  
>  /**
>   * enum riscv_iommu_igs_settings - Interrupt Generation Support Settings
> @@ -475,6 +476,7 @@ struct riscv_iommu_command {
>  #define RISCV_IOMMU_CMD_IOTINVAL_GV		BIT_ULL(33)
>  #define RISCV_IOMMU_CMD_IOTINVAL_GSCID		GENMASK_ULL(59, 44)
>  #define RISCV_IOMMU_CMD_IOTINVAL_NL		BIT_ULL(34)
> +#define RISCV_IOMMU_CMD_IOTINVAL_S		BIT_ULL(9)

We should add a comment here that this is actually bit 73, i.e.

#define RISCV_IOMMU_CMD_IOTINVAL_S           BIT_ULL(9)	/* bit 73 (dword1 bit 9) */

because...

>  /* dword1[61:10] is the 4K-aligned page address */
>  #define RISCV_IOMMU_CMD_IOTINVAL_ADDR		GENMASK_ULL(61, 10)
>  
> @@ -731,6 +733,21 @@ static inline void riscv_iommu_cmd_inval_set_nl(struct riscv_iommu_command *cmd)
>  	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_NL;
>  }
>  
> +/*
> + * Set NAPOT-encoded address for range invalidation (S=1).
> + * sz_lg2: log2 of total range in bytes, must be >= 13 (8KiB, 2 pages).
> + * addr must be naturally aligned to 2^sz_lg2.
> + */
> +static inline void riscv_iommu_cmd_inval_set_napot(
> +	struct riscv_iommu_command *cmd, u64 addr, unsigned int sz_lg2)
> +{
> +	u64 pfn = addr >> 12;
> +
> +	pfn |= BIT_U64(sz_lg2 - 13) - 1;
> +	cmd->dword1 = FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, pfn);
> +	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_AV | RISCV_IOMMU_CMD_IOTINVAL_S;

...here we're setting the wrong dword. This should be

	cmd->dword1 = FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, pfn) |
		      RISCV_IOMMU_CMD_IOTINVAL_S;
	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_AV;

Thanks,
drew
