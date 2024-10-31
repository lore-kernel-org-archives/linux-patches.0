Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473C113D8A3
	for <patches@lists.linux.dev>; Thu, 31 Oct 2024 06:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730355687; cv=none; b=hupubWcLnDMyiSt6Sw6TWadPzjw7+WiItQ/JNpo0QVfUEGv+2F+yduasrp82CIeMBh15qQITOx33QvnjnS+pFzsJsgOUzt5H6hb9Ku9qvD0loAVVbQvONkuKve1uYoxEJWi5JSp/mhDVK1ufWzG3fxPFU2oVjYPEzCmUIj1cQ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730355687; c=relaxed/simple;
	bh=XSZ6Hy52turl3LfxnjEUv5hVzdAx9oOcIHfaeoqhMiU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pPwMlwqyTQBOIrYxxsxi9GzEzWXwftIfBO7NGwHYNkj2X4ziBPZDXAJHy9h+Y+WA0W9ceE4A5q8jJkdec07R/EJJ0KzDNlJq4T9dItevJmleMvupi7iqwAFo3VYENQvyFSfYvCTGcDSKFFMUPjlRZT0ByjHGOLGWI/AR5sG/yvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CsQgmdcZ; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CsQgmdcZ"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53b13ea6b78so973450e87.2
        for <patches@lists.linux.dev>; Wed, 30 Oct 2024 23:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730355683; x=1730960483; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uCUVXtHK/IiMB+Oe4BWESMJU8Ob4rgGM97ZCX/sNfKI=;
        b=CsQgmdcZeLh5MzI29uvJbR5QohXaD5b1Ggym0vj5LEw1cZaO7wavaRVNxZK9JFNzLj
         UrsxTibKItB5l5cJ3KKvMFsbuOAOpaWxK4V21Yp23kbicqYM8ZGFs8ynkLyEwKy49gmR
         24qumDlqAkHN59BIQZlirEUhdkz0p4IYTbdL521pgOUFNkoWOJaFL9UvVE276fQN5DHS
         CeYgYAYj+t4hAAXlmKqJH867QWY0rKS2GVxaaFsH3pUu9vozwXtIZhxNNWbgzH1KLQok
         YDwz2zZpeMsROGoM2wcO07t6+wYxcU2xa/B45lW7rEtjTZ5RYzA9gKTtnDfgkffLqcrW
         EwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730355683; x=1730960483;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uCUVXtHK/IiMB+Oe4BWESMJU8Ob4rgGM97ZCX/sNfKI=;
        b=f2XHsUihZId89KLoC2uqAnf89mDfzMMC4pYUHIELuv3NBCc3yBr2b3Qpe1xXc2TR2F
         QYIGVrGC9Y2AJMU08oZHSEjHACggjwO/J5soa39Ilurlmyd7UpB03cNTnD5lxtzxx4bT
         yWdkjPyVOOsgipfG1RGfLfCp4NDu37vVxWk34FpRmuu0e8T8bnQQ2COkkfGCve8iBIU1
         UbDBLLLdvkfZ4BOmUX1MY8BlI5M++EfZM8cEgOkYsHlDI3nbov2nnSlleOrdGQN22G7T
         U4F9sxfXTz3aiFvJFGZyYJOdQKtooLjyxU5Wx1BnKOQhWhTj3U958hsrEM8cL1D7LhTe
         1/BA==
X-Forwarded-Encrypted: i=1; AJvYcCUFCGssm9NNNFVAV08lpTYV6Z+zatrjxe7QdcqML+2fc8oLr8cIKXGjvpqTa1sPresofhCUfJqh@lists.linux.dev
X-Gm-Message-State: AOJu0YwVPObE6PlJPEaJP39g5e/5UXPBEunfnSrLCqkZxW1vbb8e+9LX
	nz4JppgIl+Pu3oMJeXcmugK2QfbZN4CW75rqofuIy7wzTXed7xQWgu1waFA87jrjjVKNy+Z75kr
	EQOTDeNW4/FDH4qyZvk1gEaTVXnzRPFF4Q4CYgw==
X-Google-Smtp-Source: AGHT+IH0g8oJXVs7VSlsOX60RHCa1G3irMHjbxsPtlD9vjSUFpsj7VgciJ4cq7Us8zzxRnsUwBQyyU+Qscm+a7G3kBw=
X-Received: by 2002:a05:6512:3053:b0:539:a4ef:6765 with SMTP id
 2adb3069b0e04-53b348ba142mr14459958e87.7.1730355683052; Wed, 30 Oct 2024
 23:21:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com> <9-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <9-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Thu, 31 Oct 2024 14:21:11 +0800
Message-ID: <CABQgh9HoGFGDTEqziQt6WrJ7Bm9d-0c259PYsms3nOVEidn5BA@mail.gmail.com>
Subject: Re: [PATCH v4 09/12] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Donald Dutile <ddutile@redhat.com>, 
	Eric Auger <eric.auger@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Jerry Snitselaar <jsnitsel@redhat.com>, 
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, 
	patches@lists.linux.dev, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 31 Oct 2024 at 08:21, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
> as the parent and a user provided STE fragment that defines the CD table
> and related data with addresses translated by the S2 iommu_domain.
>
> The kernel only permits userspace to control certain allowed bits of the
> STE that are safe for user/guest control.
>
> IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> translation, but there is no way of knowing which S1 entries refer to a
> range of S2.
>
> For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
> flush all ASIDs from the VMID after flushing the S2 on any change to the
> S2.
>
> The IOMMU_DOMAIN_NESTED can only be created from inside a VIOMMU as the
> invalidation path relies on the VIOMMU to translate virtual stream ID used
> in the invalidation commands for the CD table and ATS.
>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Reviewed-by: Donald Dutile <ddutile@redhat.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 157 ++++++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  17 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  26 +++
>  include/uapi/linux/iommufd.h                  |  20 +++
>  4 files changed, 219 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> index 60dd9e90759571..0b9fffc5b2f09b 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> @@ -30,7 +30,164 @@ void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
>         return info;
>  }
>
> +static void arm_smmu_make_nested_cd_table_ste(
> +       struct arm_smmu_ste *target, struct arm_smmu_master *master,
> +       struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
> +{
> +       arm_smmu_make_s2_domain_ste(
> +               target, master, nested_domain->vsmmu->s2_parent, ats_enabled);
> +
> +       target->data[0] = cpu_to_le64(STRTAB_STE_0_V |
> +                                     FIELD_PREP(STRTAB_STE_0_CFG,
> +                                                STRTAB_STE_0_CFG_NESTED));
> +       target->data[0] |= nested_domain->ste[0] &
> +                          ~cpu_to_le64(STRTAB_STE_0_CFG);
> +       target->data[1] |= nested_domain->ste[1];
> +}
> +
> +/*
> + * Create a physical STE from the virtual STE that userspace provided when it
> + * created the nested domain. Using the vSTE userspace can request:
> + * - Non-valid STE
> + * - Abort STE
> + * - Bypass STE (install the S2, no CD table)
> + * - CD table STE (install the S2 and the userspace CD table)
> + */
> +static void arm_smmu_make_nested_domain_ste(
> +       struct arm_smmu_ste *target, struct arm_smmu_master *master,
> +       struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
> +{
> +       unsigned int cfg =
> +               FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(nested_domain->ste[0]));
> +
> +       /*
> +        * Userspace can request a non-valid STE through the nesting interface.
> +        * We relay that into an abort physical STE with the intention that
> +        * C_BAD_STE for this SID can be generated to userspace.
> +        */
> +       if (!(nested_domain->ste[0] & cpu_to_le64(STRTAB_STE_0_V)))
> +               cfg = STRTAB_STE_0_CFG_ABORT;
> +
> +       switch (cfg) {
> +       case STRTAB_STE_0_CFG_S1_TRANS:
> +               arm_smmu_make_nested_cd_table_ste(target, master, nested_domain,
> +                                                 ats_enabled);
> +               break;
> +       case STRTAB_STE_0_CFG_BYPASS:
> +               arm_smmu_make_s2_domain_ste(target, master,
> +                                           nested_domain->vsmmu->s2_parent,
> +                                           ats_enabled);
> +               break;
> +       case STRTAB_STE_0_CFG_ABORT:
> +       default:
> +               arm_smmu_make_abort_ste(target);
> +               break;
> +       }
> +}
> +
> +static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
> +                                     struct device *dev)
> +{
> +       struct arm_smmu_nested_domain *nested_domain =
> +               to_smmu_nested_domain(domain);
> +       struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> +       struct arm_smmu_attach_state state = {
> +               .master = master,
> +               .old_domain = iommu_get_domain_for_dev(dev),
> +               .ssid = IOMMU_NO_PASID,
> +               /* Currently invalidation of ATC is not supported */
> +               .disable_ats = true,
> +       };
> +       struct arm_smmu_ste ste;
> +       int ret;
> +
> +       if (nested_domain->vsmmu->smmu != master->smmu)
> +               return -EINVAL;
> +       if (arm_smmu_ssids_in_use(&master->cd_table))
> +               return -EBUSY;
> +
> +       mutex_lock(&arm_smmu_asid_lock);
> +       ret = arm_smmu_attach_prepare(&state, domain);
> +       if (ret) {
> +               mutex_unlock(&arm_smmu_asid_lock);
> +               return ret;
> +       }
> +
> +       arm_smmu_make_nested_domain_ste(&ste, master, nested_domain,
> +                                       state.ats_enabled);
> +       arm_smmu_install_ste_for_dev(master, &ste);
> +       arm_smmu_attach_commit(&state);
> +       mutex_unlock(&arm_smmu_asid_lock);
> +       return 0;
> +}
> +
> +static void arm_smmu_domain_nested_free(struct iommu_domain *domain)
> +{
> +       kfree(to_smmu_nested_domain(domain));
> +}
> +
> +static const struct iommu_domain_ops arm_smmu_nested_ops = {
> +       .attach_dev = arm_smmu_attach_dev_nested,
> +       .free = arm_smmu_domain_nested_free,
> +};
> +
> +static int arm_smmu_validate_vste(struct iommu_hwpt_arm_smmuv3 *arg)
> +{
> +       unsigned int cfg;
> +
> +       if (!(arg->ste[0] & cpu_to_le64(STRTAB_STE_0_V))) {
> +               memset(arg->ste, 0, sizeof(arg->ste));
> +               return 0;
> +       }
> +
> +       /* EIO is reserved for invalid STE data. */
> +       if ((arg->ste[0] & ~STRTAB_STE_0_NESTING_ALLOWED) ||
> +           (arg->ste[1] & ~STRTAB_STE_1_NESTING_ALLOWED))
> +               return -EIO;
> +
> +       cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(arg->ste[0]));
> +       if (cfg != STRTAB_STE_0_CFG_ABORT && cfg != STRTAB_STE_0_CFG_BYPASS &&
> +           cfg != STRTAB_STE_0_CFG_S1_TRANS)
> +               return -EIO;
> +       return 0;
> +}
> +
> +static struct iommu_domain *
> +arm_vsmmu_alloc_domain_nested(struct iommufd_viommu *viommu, u32 flags,
> +                             const struct iommu_user_data *user_data)
> +{
> +       struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
> +       struct arm_smmu_nested_domain *nested_domain;
> +       struct iommu_hwpt_arm_smmuv3 arg;
> +       int ret;
> +
> +       if (flags)
> +               return ERR_PTR(-EOPNOTSUPP);

This check fails when using user page fault, with flags =
IOMMU_HWPT_FAULT_ID_VALID (4)
Strange, the check is not exist in last version?

iommufd_viommu_alloc_hwpt_nested ->
viommu->ops->alloc_domain_nested(viommu, flags, user_data) ->
arm_vsmmu_alloc_domain_nested


Thanks
