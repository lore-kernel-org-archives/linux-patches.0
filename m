Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7072784A22
	for <patches@lists.linux.dev>; Sat, 12 Oct 2024 03:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728702745; cv=none; b=nck3MGO+QUNSKcmx1ecQG9rmoMvmg1RtYLD9qfXdM9YlO0l5EQbySmgeY1zXoQWsmH4tLrUjg5682wCVsEtHiz0ZpMNhiAWIUgwJu1Y0V03je31qrFhG+9LGHCbsYJ4AaYquCOOEK6CXtHESdZMlI4dZQTTGw/u4N6Vmi3oLDZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728702745; c=relaxed/simple;
	bh=ZPl0vRIjZy6Q1TLJkMAfmvzvlUnFAH8cE6wBRsWA6AY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M4sfSN1UlQSpLlbpZhLKYpFotSahGOUTwJfPtg5WPjA1O8F7PC1f3EjkOrlE1nDtMA/ulL7PdBMW3l0XruH/t59BpHH0jVdrZosC0GIdpaaW7Hfv4KWA2G+vXBOUTug9mdqZjL5sqNmlyVNx63caeZ6pIlgnZM/0vjx/PGhuFQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LqTm01F7; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LqTm01F7"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2fad100dd9fso39992221fa.3
        for <patches@lists.linux.dev>; Fri, 11 Oct 2024 20:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728702740; x=1729307540; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=skhRjSsjRWRBkBJSR7ncRA8S1Q1nCZnYe3M18zuYqQk=;
        b=LqTm01F7W4AuYPe9+WnKbXZ4N9xjC/u9Yg7VsNmx6nHWOhB7AN29fXvKf+zNVuZ0Ps
         1OlOtFaIJIsqIuUuG/i1iga892VLWcdfyh8sz/O8/g/HJHlXdxTrhJyi4999aA+wIGKE
         sxcbdw4ICpgCUYD/1XSSVum76BeOSFCpCvMJAXu5uCyMiUHGeMo+ea8Jr6UCgtyLwQ9C
         it8NQdc7nqVgCSHvy49HkItfTaZlwT2GqhtthPGCXnIE//CxhxsvVoFuL4f2RQ4l1Gqn
         4HxJJsFgTAl4JeIWNIsUQLA9vpcJcw+tc3OZowO82W4bqf+H1C78XDL4JAaj7BZk0FUp
         yCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728702740; x=1729307540;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=skhRjSsjRWRBkBJSR7ncRA8S1Q1nCZnYe3M18zuYqQk=;
        b=XAeCK/5G1exApKNQkz/Hon4fASM5wuC7VPWXRLYoe6iPub1HyrSBfOP1k1h7q/BRXu
         pSByKt4OgMW18tprTviffcMDOHEysp8m8MPnDLjszTGhnafpDyGO+VxJhOS0wTlNJOtk
         29IWq0p0qfCdSvClUXXdjQZKeuZdwT+I+UUDWEHWrXKUOBqMop2Br2TAgxx8un7lKt6T
         i+2u/Atgfh0g2GNg0Agx4XQEf4w6zhG+OMlHd5jakhnmqD2daPK/nFhbBmMK6eES+l0N
         Anz5agxX3qr6NdTz1/LRG9hI22NvFCRPNU1CK9Osv9fcfuevIqH3LhfRXCVegnDizhPW
         HOIA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ+gkNJip/uNhclpBk8mrsNktHok3YibQmy7U+icR4VDep4KHIe1sKkx03H9RCH3ECZcuhuJ3h@lists.linux.dev
X-Gm-Message-State: AOJu0YxbT9rJ7NaQ9bvqLuaeeOfUA0wfEWRjLePKMy4JZ28R0SRgNj8t
	OgZIFgjZXyLolPY+5+9ubMm8HNZ+H7zGfzfaeaJU97xi4SIMWOqbG84UzgnyvAUV0MnZArD1Fcw
	8o7vAVSwHES486Rs1YtjCWeC84czksH/sa3F8Ug==
X-Google-Smtp-Source: AGHT+IESbkfK9x0RkC/zr+X/5OJJGUEqu4Sl+Zaum+icoDlotDKEsytnJ09AslW1W0e34iL7p8s2SZSLipO7yFwMhZw=
X-Received: by 2002:a05:6512:b85:b0:539:936c:9845 with SMTP id
 2adb3069b0e04-539e571c924mr863040e87.37.1728702740436; Fri, 11 Oct 2024
 20:12:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1728491532.git.nicolinc@nvidia.com> <d714a9d107696194cc63e5f6c2b6bf5877b37f68.1728491532.git.nicolinc@nvidia.com>
In-Reply-To: <d714a9d107696194cc63e5f6c2b6bf5877b37f68.1728491532.git.nicolinc@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Sat, 12 Oct 2024 11:12:09 +0800
Message-ID: <CABQgh9E1rfA8i+x+6VRgyFb41n+n_F6-gqnT-TfqLqVeYaYmew@mail.gmail.com>
Subject: Re: [PATCH v3 14/16] iommu/arm-smmu-v3: Add arm_vsmmu_cache_invalidate
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, will@kernel.org, joro@8bytes.org, 
	suravee.suthikulpanit@amd.com, robin.murphy@arm.com, dwmw2@infradead.org, 
	baolu.lu@linux.intel.com, shuah@kernel.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, eric.auger@redhat.com, 
	jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com, 
	shameerali.kolothum.thodi@huawei.com, smostafa@google.com, yi.l.liu@intel.com, 
	aik@amd.com, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 10 Oct 2024 at 00:44, Nicolin Chen <nicolinc@nvidia.com> wrote:
>
> Implement the vIOMMU's cache_invalidate op for user space to invalidate the
> IOTLB entries, Device ATS and CD entries that are still cached by hardware.
>
> Add struct iommu_viommu_arm_smmuv3_invalidate defining invalidation entries
> that are simply in the native format of a 128-bit TLBI command. Scan those
> commands against the permitted command list and fix their VMID/SID fields.
>
> Co-developed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   5 +
>  include/uapi/linux/iommufd.h                  |  24 ++++
>  .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 131 +++++++++++++++++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |   6 +-
>  4 files changed, 162 insertions(+), 4 deletions(-)
>

> +static int
> +arm_vsmmu_convert_user_cmd(struct arm_vsmmu *vsmmu,
> +                          struct iommu_viommu_arm_smmuv3_invalidate *cmd)
> +{
> +       cmd->cmd[0] = le64_to_cpu(cmd->cmd[0]);
> +       cmd->cmd[1] = le64_to_cpu(cmd->cmd[1]);
> +
> +       switch (cmd->cmd[0] & CMDQ_0_OP) {
> +       case CMDQ_OP_TLBI_NSNH_ALL:
> +               /* Convert to NH_ALL */
> +               cmd->cmd[0] = CMDQ_OP_TLBI_NH_ALL |
> +                             FIELD_PREP(CMDQ_TLBI_0_VMID, vsmmu->vmid);
> +               cmd->cmd[1] = 0;
> +               break;
> +       case CMDQ_OP_TLBI_NH_VA:
> +       case CMDQ_OP_TLBI_NH_VAA:
> +       case CMDQ_OP_TLBI_NH_ALL:
> +       case CMDQ_OP_TLBI_NH_ASID:
> +               cmd->cmd[0] &= ~CMDQ_TLBI_0_VMID;
> +               cmd->cmd[0] |= FIELD_PREP(CMDQ_TLBI_0_VMID, vsmmu->vmid);
> +               break;
> +       case CMDQ_OP_ATC_INV:
> +       case CMDQ_OP_CFGI_CD:
> +       case CMDQ_OP_CFGI_CD_ALL:
> +               u32 sid, vsid = FIELD_GET(CMDQ_CFGI_0_SID, cmd->cmd[0]);

Here got build error

drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c:302:3: error: a
label can only be part of a statement and a declaration is not a
statement
  302 |   u32 sid, vsid = FIELD_GET(CMDQ_CFGI_0_SID, cmd->cmd[0]);
      |   ^~~

Need {} to include.
case CMDQ_OP_CFGI_CD_ALL: {
...
}

Thanks
