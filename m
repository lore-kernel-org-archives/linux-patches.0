Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0F7370D6D
	for <patches@lists.linux.dev>; Thu,  7 May 2026 09:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778145570; cv=none; b=R/sp9acd7bNezfIunydhkmzXwi3xiYPRKM4+BsInvr1gJ+XJFjJ34Y4mp976DeCUMsKF2wiH3mADVQgi1FQ2HZPjT0DDI14phtqPBvqVHUcrCrfX7g8/ws7fqwcou8f48BhZqgMsltktE8s1DbGVmZ1M36YU1vMIiNVEZIaCCvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778145570; c=relaxed/simple;
	bh=EZaHkIGeRa8Cqf7NOtrBHdoqBmjyas3YmU01n1qoVnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aejOHYBIZPvjZ0YiED5kiqeJ1OWKVzMCnChg7I7KBmaXiQhVVoUHy1lwrxbnSYU9OkeTjhWfO/Ktr7IYK7la6dPKs2eSFxrKyRp17Bu5bZOzxF9ZYbiiJMBCG2SchhYlbin0KlA2Y/CCaDpkkS38z3rE+vGsJ4Bl/zOKnio2BdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RZebRYqk; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RZebRYqk"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so67935e9.1
        for <patches@lists.linux.dev>; Thu, 07 May 2026 02:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778145560; x=1778750360; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/1NONxnec+n06CLcBCODwxosB4SRQUb5g6JkJE9QSFI=;
        b=RZebRYqkhfXxI8thoXFKh8C3SMvbEiq0IdbArjKAxeXFRC9/t8RnPbuhTbFhXJZBkF
         ogEmJOj41gE65jSBK42rFC/7z82h9+YYEzh9mlPW1ARWDwiOqYtTeQvWXE3p03cWSscR
         FkYP0L1wSTAoa6Wyd98xDID8NBIJndvbTOqqlJPy+c5LzvK5l2QMvucFzbZi4cWHMd08
         bA22Q2f1sZQHda6Mqp7bcJbM56Uv7M7dODDWU5guuSn7SIT4YX9kcfBJK8pNiWijg11G
         1jkuOqNCsFGu+cnp2LtMuxKTomdQvjre/LjPkVTGFH2bOtzlFi//yeys17j1NsOgWMU7
         rHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778145560; x=1778750360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/1NONxnec+n06CLcBCODwxosB4SRQUb5g6JkJE9QSFI=;
        b=Y6kPwyOs1grhHviYrJLKtb1Tl2spI5faGpFoqaMttMfl0/mHWqW6MYvXDONlA3zN7o
         87L0ndHY9wXVvB3Py4SWOvHicgujqayFZnaHr/5qLXoDDjY5t3y7g68V1dIZtLgaO808
         zfCq2h3sZ8QHvrTLix95JzIJDEUn8Btp3nq2C4w4XKclNXhW4OlZ2cMOzvXk+qKKhprE
         8FhhRgyix5YAJLPdOFEFD1AnW2V5v4EEegnqfhij8r79nFZhIPM/oO//dRdR89lhiFCE
         2SU/zblOz8lHRg/byIUg9xv/JPxZI6mSzsOTaiTmJ1ujhtCfrBDo7vWwdqihCiOjQqH/
         W5VA==
X-Forwarded-Encrypted: i=1; AFNElJ8e9ktXxVhPAauh1VhYM8nTj4CduLUw3MgewmmwJ/kTUo3LuKYhFNksrxu9Oz+Bq/YRnz2E6Iao@lists.linux.dev
X-Gm-Message-State: AOJu0YyqWIHKzRDRi8P9GdX9TRd//tqXpZptbN4quaZbR5BN3V5Dm6JO
	wRdo7qwr/PYTx7ETiEXJ5/hbzhNU3purmvoseT59L9rMiT7ze9ftYu7tWaUL0gD2qQ==
X-Gm-Gg: AeBDieuoryWz6kFZsyhXMbTTGEHT7u5vq43P6ef4uwQroVRJs3ifQwzbv4k99KzVNpP
	ufFWc0rbsiyAnGV44XoJJlSCE04B+d2JnztHuDhG3T+ZzMADmTsicDCd+zh6mvns2kxWHMpekVk
	sSWWQbDW7apexZGO4z7R1ayDY2fdHjpIHCqhRLRhs/XW3f/KIq0pUuk1GHDSqDb9jlxpzTFf7B8
	lENrq0DrrNmVtVaK4bDCkYezd444FEAQoJHlw42twiQrMLozdmSaLEXqD1AcKnztUMcXunO1xw/
	g0BeGZ2JNl8qnX3iUYLRazueVAWEDBpj7PEODm2AqAGl4kX9LcLJlu/WsOlCgihnqY5fbURRkOT
	iXZw6CUO/1NU3DjtcI+YIjVp3DcQjestYwdI8XW/HfyQnkAIA/B5W2WKLcOySE4uPXcHyizwn89
	GrvlyDglOCeWXwnMA2dj5+OA7YM1bWc1gcC/AiRFgS3UpiGDCUfyyQmBRR9ObCh/FjLTmZbH54H
	31SHhcLa8oNj9Xh
X-Received: by 2002:a05:600d:844a:10b0:48a:5d95:d33e with SMTP id 5b1f17b1804b1-48e5d45d196mr626835e9.6.1778145559566;
        Thu, 07 May 2026 02:19:19 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-450524831cdsm20663750f8f.5.2026.05.07.02.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 02:19:18 -0700 (PDT)
Date: Thu, 7 May 2026 09:19:14 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH 1/9] iommu/arm-smmu-v3: Add struct arm_smmu_cmd to
 represent the HW format command
Message-ID: <afxZEgun2BjHJ-WJ@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <1-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:10AM -0300, Jason Gunthorpe wrote:
> Like STE/CD, add a wrapper struct around the u64 array to represent the
> already FIELD_PREP'd command data. Unlike the STE/CD this is a u64
> because the command submission path will have the swap to le64.
> 
> This makes the API clearer when a u64 is referring to a formatted
> command and makes the following changes easier to follow.
> 
> Move the command constants out of the struct and into an enum alongside
> the rest of the constants defining the HW format so the entire HW format
> is self contained and independent of struct arm_smmu_cmdq_ent.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 48 ++++++++++++---------
>  1 file changed, 28 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index ef42df4753ec4d..092179f689e9f1 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -390,6 +390,10 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
>  
>  #define CMDQ_PROD_OWNED_FLAG		Q_OVERFLOW_FLAG
>  
> +struct arm_smmu_cmd {
> +	u64 data[CMDQ_ENT_DWORDS];
> +};
> +
>  /*
>   * This is used to size the command queue and therefore must be at least
>   * BITS_PER_LONG so that the valid_map works correctly (it relies on the
> @@ -426,6 +430,8 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
>  #define CMDQ_ATC_1_SIZE			GENMASK_ULL(5, 0)
>  #define CMDQ_ATC_1_ADDR_MASK		GENMASK_ULL(63, 12)
>  
> +#define ATC_INV_SIZE_ALL 52
> +
>  #define CMDQ_PRI_0_SSID			GENMASK_ULL(31, 12)
>  #define CMDQ_PRI_0_SID			GENMASK_ULL(63, 32)
>  #define CMDQ_PRI_1_GRPID		GENMASK_ULL(8, 0)
> @@ -447,6 +453,28 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
>  #define CMDQ_SYNC_0_MSIDATA		GENMASK_ULL(63, 32)
>  #define CMDQ_SYNC_1_MSIADDR_MASK	GENMASK_ULL(51, 2)
>  
> +enum arm_smmu_cmdq_opcode {
> +	CMDQ_OP_PREFETCH_CFG = 0x1,
> +	CMDQ_OP_CFGI_STE = 0x3,
> +	CMDQ_OP_CFGI_ALL = 0x4,
> +	CMDQ_OP_CFGI_CD = 0x5,
> +	CMDQ_OP_CFGI_CD_ALL = 0x6,
> +	CMDQ_OP_TLBI_NH_ALL = 0x10,
> +	CMDQ_OP_TLBI_NH_ASID = 0x11,
> +	CMDQ_OP_TLBI_NH_VA = 0x12,
> +	CMDQ_OP_TLBI_NH_VAA = 0x13,
> +	CMDQ_OP_TLBI_EL2_ALL = 0x20,
> +	CMDQ_OP_TLBI_EL2_ASID = 0x21,
> +	CMDQ_OP_TLBI_EL2_VA = 0x22,
> +	CMDQ_OP_TLBI_S12_VMALL = 0x28,
> +	CMDQ_OP_TLBI_S2_IPA = 0x2a,
> +	CMDQ_OP_TLBI_NSNH_ALL = 0x30,
> +	CMDQ_OP_ATC_INV = 0x40,
> +	CMDQ_OP_PRI_RESP = 0x41,
> +	CMDQ_OP_RESUME = 0x44,
> +	CMDQ_OP_CMD_SYNC = 0x46,
> +};
> +
>  /* Event queue */
>  #define EVTQ_ENT_SZ_SHIFT		5
>  #define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
> @@ -520,15 +548,10 @@ struct arm_smmu_cmdq_ent {
>  
>  	/* Command-specific fields */
>  	union {
> -		#define CMDQ_OP_PREFETCH_CFG	0x1
>  		struct {
>  			u32			sid;
>  		} prefetch;
>  
> -		#define CMDQ_OP_CFGI_STE	0x3
> -		#define CMDQ_OP_CFGI_ALL	0x4
> -		#define CMDQ_OP_CFGI_CD		0x5
> -		#define CMDQ_OP_CFGI_CD_ALL	0x6
>  		struct {
>  			u32			sid;
>  			u32			ssid;
> @@ -538,16 +561,6 @@ struct arm_smmu_cmdq_ent {
>  			};
>  		} cfgi;
>  
> -		#define CMDQ_OP_TLBI_NH_ALL     0x10
> -		#define CMDQ_OP_TLBI_NH_ASID	0x11
> -		#define CMDQ_OP_TLBI_NH_VA	0x12
> -		#define CMDQ_OP_TLBI_NH_VAA	0x13
> -		#define CMDQ_OP_TLBI_EL2_ALL	0x20
> -		#define CMDQ_OP_TLBI_EL2_ASID	0x21
> -		#define CMDQ_OP_TLBI_EL2_VA	0x22
> -		#define CMDQ_OP_TLBI_S12_VMALL	0x28
> -		#define CMDQ_OP_TLBI_S2_IPA	0x2a
> -		#define CMDQ_OP_TLBI_NSNH_ALL	0x30
>  		struct {
>  			u8			num;
>  			u8			scale;
> @@ -559,8 +572,6 @@ struct arm_smmu_cmdq_ent {
>  			u64			addr;
>  		} tlbi;
>  
> -		#define CMDQ_OP_ATC_INV		0x40
> -		#define ATC_INV_SIZE_ALL	52
>  		struct {
>  			u32			sid;
>  			u32			ssid;
> @@ -569,7 +580,6 @@ struct arm_smmu_cmdq_ent {
>  			bool			global;
>  		} atc;
>  
> -		#define CMDQ_OP_PRI_RESP	0x41
>  		struct {
>  			u32			sid;
>  			u32			ssid;
> @@ -577,14 +587,12 @@ struct arm_smmu_cmdq_ent {
>  			enum pri_resp		resp;
>  		} pri;
>  
> -		#define CMDQ_OP_RESUME		0x44
>  		struct {
>  			u32			sid;
>  			u16			stag;
>  			u8			resp;
>  		} resume;
>  
> -		#define CMDQ_OP_CMD_SYNC	0x46
>  		struct {
>  			u64			msiaddr;
>  		} sync;
> -- 
> 2.43.0
> 
