Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7A6178384
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 06:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731479351; cv=none; b=nuH1Pmb6dpBfmjnhOThwySIqgAlUXw5ohpjhMGlm26cAmufmYm4VNKdQsOCGeszlmwx/WiWkwh+FxgGejpQ/uopEh4a+UpgFpnf+PvbgudMZBeujbsqI655GgRvIcxKusZkmMW7QFiUIugE/MRyZiZzZyiRIlZKvRUT6qM0Aulw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731479351; c=relaxed/simple;
	bh=ryKZ3ZF7sN+kjlkdznbBZ1GozgBjmJSrP4P2jIodaXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aDkefEfaSpnWcald83f+Au+uf3FGEQBbcKnNo/PgQ2IOydVMmzcB7uBXd0G4M45IjfFYvxFGevu1N0PODGTzuAJL0xbldwF0bMpDlmMrvJjlIUSS2eSuIUET1rX8fLAOgZ0CyyAz5iQ4BvBn2ObMKcD5eYJTRPe5aJuD5sxg1ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uRV1X4Gh; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uRV1X4Gh"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539e63c8678so7532927e87.0
        for <patches@lists.linux.dev>; Tue, 12 Nov 2024 22:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731479348; x=1732084148; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9QCU/JLa948seWzRrNmkByaOgxKmnVBehQKimS55YRs=;
        b=uRV1X4GhIhEIqxzTyMdZR6NCwyPfVdZA7MIEfENPEqKL28o/BSqG1bCf2xl+fTjBtx
         NDxVpN04rfc6cVHw+/jiRIR2IeLkfpCTp7m0iebDDSmhY4InRVRMB2kmbBDLrSe2kyrN
         lQaxvSshnejE0LEb/8F6i5n6Eb8afABDRAmeK49SGAhF6aal1I1P6j+TQ/y4Ijx1kyII
         b3MaQMXgUEr5igC8V62uodrfzM66OZfm+K5MmfF0/El/nbWFLwKJEzx48apZMasaGjNm
         pmAscqo1lpRVUzGe5IzO/qWx46Ow2DGw2DJ2rAgF7r7ddsDofElsbggrR0sdHpzVwhQ6
         gXVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731479348; x=1732084148;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9QCU/JLa948seWzRrNmkByaOgxKmnVBehQKimS55YRs=;
        b=BxRxwfqmwaCnpBSEzbwYUPaTdAZ1A3X+vnGGm1fcxz0njGgJbrY7clDmJGuKdfX+On
         U0yQQSS3R7hrCTIF1JSFDbPwmr2L4oiDMUVyWme6SfOVKyEr4Vae0qbAz66Uw7oNRtSO
         jiylGltcsre19jSpnGpd6kJgqlFQcF8i6pg3BJRhDLocn9aKlSNzOk7H4tgb1VmOY1tv
         1se8CYEVRA3KvibmW3Bo9xiulV3fLsCoD66Ztrr3JOEJzsN58rkkln5p4997k/iUdcIl
         v0czuwBvQjB0nuR+rs0lta4qSgyetc0Edv3qrbVHVk/smClwc2WfOGnThFiC0MtBNX68
         r/2A==
X-Forwarded-Encrypted: i=1; AJvYcCU1kQlxN0cpNqcbJfkCdwr7YBm4jKlhjJLkDAhAJWQA99wHAVOY3bF4BPXoR/ITQsXlS/s0+O7f@lists.linux.dev
X-Gm-Message-State: AOJu0YxFykWDg44DTiKxklm/YtBUVjaGpt3wdihni8f9ohhcd2kjG3oY
	RYUxhvzgPqgyhF0G80zt/Gti/6fTraMgkTM0EUTPCij6KhjqNnEnDh4fZ6ysodBVUsBYTA7zA4x
	prgqZEehrGV+mT1SREHy3oGxnf+lMTfks0rhiXQ==
X-Google-Smtp-Source: AGHT+IEEpcf7Vups7lw1NP9O1FTEPXG1XjljcLFymoWHBWMOkn9tB109/qtbls5Dq+XYyRVJ67vPr0ofrW4PZLq41wk=
X-Received: by 2002:a05:6512:281b:b0:536:54fd:275b with SMTP id
 2adb3069b0e04-53d86303095mr9309340e87.54.1731479348058; Tue, 12 Nov 2024
 22:29:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241112182938.GA172989@nvidia.com> <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
 <20241113012359.GB35230@nvidia.com> <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
In-Reply-To: <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 13 Nov 2024 14:28:56 +0800
Message-ID: <CABQgh9F+K67YDYeg4==0dhdjya1YuX6uUttQA8zadWEZyRhNKw@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, acpica-devel@lists.linux.dev, iommu@lists.linux.dev, 
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

Hi, Baolu

On Wed, 13 Nov 2024 at 10:56, Baolu Lu <baolu.lu@linux.intel.com> wrote:
>
> On 11/13/24 09:23, Jason Gunthorpe wrote:
> >> https://github.com/Linaro/linux-kernel-uadk/tree/6.12-wip
> >> https://github.com/Linaro/qemu/tree/6.12-wip
> >>
> >> Still need this hack
> >> https://github.com/Linaro/linux-kernel-uadk/commit/
> >> eaa194d954112cad4da7852e29343e546baf8683
> >>
> >> One is adding iommu_dev_enable/disable_feature IOMMU_DEV_FEAT_SVA,
> >> which you have patchset before.
> > Yes, I have a more complete version of that here someplace. Need some
> > help on vt-d but hope to get that done next cycle.
>
> Can you please elaborate this a bit more? Are you talking about below
> change
>
> +       ret = iommu_dev_enable_feature(idev->dev, IOMMU_DEV_FEAT_SVA);
> +       if (ret)
> +               return ret;
>
> in iommufd_fault_iopf_enable()?
>
> I have no idea about why SVA is affected when enabling iopf.

In drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c,
iommu_dev_enable_feature(IOMMU_DEV_FEAT_SVA) will real call
iopf_queue_add_device,
while iommu_dev_enable_feature(IOPF)  only set flag.

arm_smmu_dev_enable_feature
case IOMMU_DEV_FEAT_SVA:
arm_smmu_master_enable_sva(master)
iopf_queue_add_device(master->smmu->evtq.iopf, dev);

Thanks
