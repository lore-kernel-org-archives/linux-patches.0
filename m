Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D443B340A59
	for <patches@lists.linux.dev>; Thu,  7 May 2026 09:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778145823; cv=none; b=pQSjMPZ19HqAkY5MPNGRw2UOytjaym45zS134RQZRYXv9W4P+oksF5BrePqvZGpTyeAwD+XdVWsBOxjxjbAqQ2pz3dm07cbV3d198Gwrl+divnbEiijxkV3lBGQ2w/HoAvn5Wo6rlRiootbYOlJ4Z6fkhaQ8CorXmn/aO6yvOcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778145823; c=relaxed/simple;
	bh=GYhQXGTJ7e96abjN4ZfwKko3/U++TfK7EJY7LY9hlJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S+K7dkoVWxvZTuZog+vl35e/XNV9IlxZRJ3MHFgsNC3DSSsH6L6eu3033MmiJkE/xEEZ6kRqwD4XuioEUY5sj7rGM2jtCRAVm0YNyRupGKjAdmq/06S8b79dww5GPz6tnT5Um/9q0CBPng27cUklyak1xKkj3dMNMThlSTUrc84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HgD016oN; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HgD016oN"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48d1c670255so78025e9.0
        for <patches@lists.linux.dev>; Thu, 07 May 2026 02:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778145819; x=1778750619; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=13Lh/MJGuQyEFBuGKtOzxhjY59QJuViQArYZ+z8Orn8=;
        b=HgD016oNYtHz2SYdeBoPqv/KuZ3JpCOKzM5CnjoW1c5kMcEmaykXpu5Q0DF4XaTtQ/
         3vovSBPWtwunzjAAgGZmkQf/9x2QkprmKiX4UhTpmnz7w0vPtqqbYXTAaBLwypfzu7vc
         YPt3LGzgUbbsOX6PiRRvQBUulSuIcPbVMIECdMFtBc2+Dr3bin6S3fADtMV6iHvmRYDj
         3XlV0oBmRS3GQ+T/wSfDtbKSjjixsOTOg7mYq6urAVRSAMvKzD9smGW/+nlinZoT0Juz
         J9N0IlYEW/Ivhib8bYgrV+6CHx4vcO2kgOuBZNwLTeOj7Knmo5dY2pQYEeqCM1S5hOtl
         ccyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778145819; x=1778750619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13Lh/MJGuQyEFBuGKtOzxhjY59QJuViQArYZ+z8Orn8=;
        b=cuU3sGRIxzTVOkEYSucpctQqNo7pXo2tTMsVWrkt5succmEG1QjO5R5+wHyboX2Iug
         Ds0oeNHdeZWXoWNzMKhr2pc3WRr2f89IXcHzTACTUO9GMxpOfgIjkCoq4a4sEyBvGL4O
         2Vaid1vGHZIiNtmSGV5d4NTH7gbY2OweQfpXDCdu9J9TM8vCgJ4R9xFQUrfbKi3VzuD7
         y7Tk5DyGvGwpgdOA9ugvOnIYwLpFQ3ltGPbpnrwYZGcS8+jTn0tSo3WlQpuD3qEn/JyA
         n+4HBUUQoi1fIlqIZ8VCbKG7+CuTQjye+J2CT6ZUHIlcj5swn15nJNOdOy2yXmee5bUU
         t3Ug==
X-Forwarded-Encrypted: i=1; AFNElJ/rxSyRWsknRsZT3k3QC+DSfZAryzIaEex9+tBIVdbBXNyia/xODj7lJ1ilhA3u3iq5+V9d7NWb@lists.linux.dev
X-Gm-Message-State: AOJu0YzIxF30Ulcr5wyWnZ9DscuACgs2MgL+e+XRisFHIdyrEjr7K/sS
	Bkw+VMJFOv/VezDMVpQiE/GirV9oJEn/Y2bkc1q25zQr+ef9p9cYv0pWM59g82EIzw==
X-Gm-Gg: AeBDiesWi+fiWmggkIXu5C+PbtDTiss59R7Ix3V/cu9AIdiOehVBLVSitqR3jJvcJRa
	HCka6Xbdva0y1Z9AxndGEgpVIse001bvc1dNQRZIgg26FoolFh6peMtfaqbMSi6msv96k+68jlV
	WufXvALFzazlgbIzIQDj3QQr6CrSQDmV1p3vWu/zBVnt/E3J/rYgHGoiy38/gvrZsutJy7LFll2
	mgiBn1TwTcfYWntKwPmrEjsv4x9J+z0fppbJ/oHHBwRQLCN2gEZdCtGeKHILdjif8JSB1yWCc+l
	444L7lcshwMFGGP5JPu460zYzj7m4AqG6vfur1ET1Lk0dzdCWlH2tPLtYXUT2Bf5xTP4a/xg54P
	rYFteEQQuJdIgDvo+o8c9TekCtia4n2hFB130G1cWNVtzlfS265EulS9htQFMsqGgy0/Z2Zemai
	U2tpuWCoqtL01g819GeZZpdcJehhZLDtrST+sW6z/X+e1bqorDDfkpnqRwhFSf4ZhIZUeV5Zcvi
	vWZkQ==
X-Received: by 2002:a05:600c:2284:b0:488:960f:60b8 with SMTP id 5b1f17b1804b1-48e5d64bc85mr781205e9.6.1778145818767;
        Thu, 07 May 2026 02:23:38 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e5314b989sm36568205e9.30.2026.05.07.02.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 02:23:38 -0700 (PDT)
Date: Thu, 7 May 2026 09:23:34 +0000
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
Subject: Re: [PATCH 7/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_ATC_INV
Message-ID: <afxaFjFf2c5R6jAc@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <7-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>

On Fri, May 01, 2026 at 11:29:16AM -0300, Jason Gunthorpe wrote:
> Add a new command make function and convert all the places using
> ATC_INV.
> 
> Split out full invalidation to directly make the cmd instead of
> overloading size=0 to mean full invalidation.

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 59 ++++++++-------------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 27 +++++++---
>  2 files changed, 40 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index f9c25ca9a9e7b8..0cdf0752ff6d62 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -308,14 +308,6 @@ static int arm_smmu_cmdq_build_cmd(struct arm_smmu_cmd *cmd_out,
>  	case CMDQ_OP_TLBI_EL2_ASID:
>  		cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_ASID, ent->tlbi.asid);
>  		break;
> -	case CMDQ_OP_ATC_INV:
> -		cmd[0] |= FIELD_PREP(CMDQ_0_SSV, ent->substream_valid);
> -		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_GLOBAL, ent->atc.global);
> -		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_SSID, ent->atc.ssid);
> -		cmd[0] |= FIELD_PREP(CMDQ_ATC_0_SID, ent->atc.sid);
> -		cmd[1] |= FIELD_PREP(CMDQ_ATC_1_SIZE, ent->atc.size);
> -		cmd[1] |= ent->atc.addr & CMDQ_ATC_1_ADDR_MASK;
> -		break;
>  	case CMDQ_OP_CMD_SYNC:
>  		if (ent->sync.msiaddr) {
>  			cmd[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_IRQ);
> @@ -2371,9 +2363,8 @@ static irqreturn_t arm_smmu_combined_irq_handler(int irq, void *dev)
>  	return IRQ_WAKE_THREAD;
>  }
>  
> -static void
> -arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
> -			struct arm_smmu_cmdq_ent *cmd)
> +static struct arm_smmu_cmd
> +arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
>  {
>  	size_t log2_span;
>  	size_t span_mask;
> @@ -2395,17 +2386,6 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
>  	 * This has the unpleasant side-effect of invalidating all PASID-tagged
>  	 * ATC entries within the address range.
>  	 */
> -	*cmd = (struct arm_smmu_cmdq_ent) {
> -		.opcode			= CMDQ_OP_ATC_INV,
> -		.substream_valid	= (ssid != IOMMU_NO_PASID),
> -		.atc.ssid		= ssid,
> -	};
> -
> -	if (!size) {
> -		cmd->atc.size = ATC_INV_SIZE_ALL;
> -		return;
> -	}
> -
>  	page_start	= iova >> inval_grain_shift;
>  	page_end	= (iova + size - 1) >> inval_grain_shift;
>  
> @@ -2434,24 +2414,25 @@ arm_smmu_atc_inv_to_cmd(int ssid, unsigned long iova, size_t size,
>  
>  	page_start	&= ~span_mask;
>  
> -	cmd->atc.addr	= page_start << inval_grain_shift;
> -	cmd->atc.size	= log2_span;
> +	return arm_smmu_make_cmd_atc_inv(sid, ssid,
> +					 page_start << inval_grain_shift,
> +					 log2_span);
>  }
>  
>  static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
>  				   ioasid_t ssid)
>  {
>  	int i;
> -	struct arm_smmu_cmdq_ent cmd;
> +	struct arm_smmu_cmd cmd;
>  	struct arm_smmu_cmdq_batch cmds;
>  
> -	arm_smmu_atc_inv_to_cmd(ssid, 0, 0, &cmd);
> -
> -	arm_smmu_cmdq_batch_init(master->smmu, &cmds, &cmd);
> -	for (i = 0; i < master->num_streams; i++) {
> -		cmd.atc.sid = master->streams[i].id;
> -		arm_smmu_cmdq_batch_add(master->smmu, &cmds, &cmd);
> -	}
> +	cmd = arm_smmu_make_cmd_atc_inv_all(0, IOMMU_NO_PASID);
> +	arm_smmu_cmdq_batch_init_cmd(master->smmu, &cmds, &cmd);
> +	for (i = 0; i < master->num_streams; i++)
> +		arm_smmu_cmdq_batch_add_cmd(
> +			master->smmu, &cmds,
> +			arm_smmu_make_cmd_atc_inv_all(master->streams[i].id,
> +						      ssid));
>  
>  	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
>  }
> @@ -2650,14 +2631,16 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
>  			arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
>  			break;
>  		case INV_TYPE_ATS:
> -			arm_smmu_atc_inv_to_cmd(cur->ssid, iova, size, &cmd);
> -			cmd.atc.sid = cur->id;
> -			arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
> +			arm_smmu_cmdq_batch_add_cmd(
> +				smmu, &cmds,
> +				arm_smmu_atc_inv_to_cmd(cur->id, cur->ssid,
> +							iova, size));
>  			break;
>  		case INV_TYPE_ATS_FULL:
> -			arm_smmu_atc_inv_to_cmd(IOMMU_NO_PASID, 0, 0, &cmd);
> -			cmd.atc.sid = cur->id;
> -			arm_smmu_cmdq_batch_add(smmu, &cmds, &cmd);
> +			arm_smmu_cmdq_batch_add_cmd(
> +				smmu, &cmds,
> +				arm_smmu_make_cmd_atc_inv_all(cur->id,
> +							      IOMMU_NO_PASID));
>  			break;
>  		default:
>  			WARN_ON_ONCE(1);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 10b3d95d9ee660..194f73cabef5c9 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -552,6 +552,25 @@ static inline struct arm_smmu_cmd arm_smmu_make_cmd_pri_resp(u32 sid, u32 ssid,
>  	return cmd;
>  }
>  
> +static inline struct arm_smmu_cmd arm_smmu_make_cmd_atc_inv(u32 sid, u32 ssid,
> +							    u64 addr, u8 size)
> +{
> +	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_ATC_INV);
> +
> +	cmd.data[0] |= FIELD_PREP(CMDQ_0_SSV, ssid != IOMMU_NO_PASID) |
> +		       FIELD_PREP(CMDQ_ATC_0_SSID, ssid) |
> +		       FIELD_PREP(CMDQ_ATC_0_SID, sid);
> +	cmd.data[1] |= FIELD_PREP(CMDQ_ATC_1_SIZE, size) |
> +		       (addr & CMDQ_ATC_1_ADDR_MASK);
> +	return cmd;
> +}
> +
> +static inline struct arm_smmu_cmd arm_smmu_make_cmd_atc_inv_all(u32 sid,
> +								u32 ssid)
> +{
> +	return arm_smmu_make_cmd_atc_inv(sid, ssid, 0, ATC_INV_SIZE_ALL);
> +}
> +
>  /* Event queue */
>  #define EVTQ_ENT_SZ_SHIFT		5
>  #define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
> @@ -630,14 +649,6 @@ struct arm_smmu_cmdq_ent {
>  			u64			addr;
>  		} tlbi;
>  
> -		struct {
> -			u32			sid;
> -			u32			ssid;
> -			u64			addr;
> -			u8			size;
> -			bool			global;
> -		} atc;
> -
>  		struct {
>  			u64			msiaddr;
>  		} sync;
> -- 
> 2.43.0
> 
