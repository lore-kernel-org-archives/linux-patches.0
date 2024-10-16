Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE433199948
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 07:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729062545; cv=none; b=tr0S6N2h2E7dJCgE2ahfzSBaUjnA054PkMqppQKh94TSmhCpz/DOgUAE/bebDkdT0s/U6E8N17M9Qjh48HGjDiPvMCHL0DeDNHQ4cPJJ53BHtakwF0Uoyj0ptn5ln0jjN3dq0wCb3lVK7nWBZfwC371p+RLIkCzqj3pN90bHWIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729062545; c=relaxed/simple;
	bh=gcnOGBR9KP/UNGr3AkdELOzAOvVCqPN6A1wxZVJU840=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lxY6iP7lojr5uOWN7idfGAQ+fSAhNIM9jbCqKyFFs2x9/vCNjbGx2+SrZfutpa3rJXcCurzcvkZ0Yl4Cv6TFVLmGWerIzGGXzzeCgOHDkMFvFesupWO+dt7IpN6pbTZ8fAw3n4lxis5GX0Qz7EuYNVHp6E4wHDPq/AiH+I1YW3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D5WqmVvk; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D5WqmVvk"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539e13375d3so5100937e87.3
        for <patches@lists.linux.dev>; Wed, 16 Oct 2024 00:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729062542; x=1729667342; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QCm13YryhPmYIK6474p+L4eQPIt7tXj7ERqjZjp8M3A=;
        b=D5WqmVvkJOu40PYFAnyCXNZhywzZqudZ9eo395ZvbELspNyRMU6vZEKG+whqiT56Eg
         pcTscSIcOnzvZmgRCT9MIioFvNKn4ay3rykC/IKidHzb3mJ7dHSWkNI+BoGGDAMmtP2A
         APSpmz6zUhVHDUQWIGtnw081V3srSJPZP4Un5slecoTmRriqcWbJqXKV6qPM65mLNK8C
         auO/LBL+eDNI1h9eAqVGDzAgMi1g9V568FzwMW6Ep25cNzOUhtoC1YeCQf6JR2wrbX80
         gdkc+YaVubAhqIO4pBaSO7Ox0ixy8XIb9cKq9sbveiZJjkftooOnNRHvg0h315ylJkgZ
         lQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729062542; x=1729667342;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QCm13YryhPmYIK6474p+L4eQPIt7tXj7ERqjZjp8M3A=;
        b=lIJ4ylMuuqEKBp+KO1kLgEOAb3OnTaqJAKk9C9Y+fbzPqLkMaLi9nmdxj3pGN3M52/
         3DvDu0QR6P6j5iFVwLvfLUQfyUH80tevDMuRADt126r8BgrUK3OlwmHaaXNfvU09bjhY
         QLQvRwrSxfc5PaiwHh9ITkZ5x7w+VhlrYVL7piRDjUXWAbFDEAIZbax6+Bu1Bry5JNDR
         1LoZQroBKMenOatbA+JkINJ6nQLxYulEaL5KaSJJVsdcMofnGxEIJPTp0pqWJ9W8Ezjo
         GNjrkB4cuZYT2HNECwPO6IxWEaveZfbHYxKXJpLYAI/80YYXgLgrjyqXnM7hcleNdERU
         Mlzg==
X-Forwarded-Encrypted: i=1; AJvYcCXLBLJ4WttHIDcxj3P8Rs3cOqov4NwFhxS1KlQSV3FTUyt2onswlgPaxAsvljCDrUulgDu/fISr@lists.linux.dev
X-Gm-Message-State: AOJu0Yy57quuiXSNWvtuZs3vwl0O/wGw7c8W6P0+o9/tXMrcvzDEa4pw
	JtX6ctH2W1KgKmHChc97RNkj3AcFEosIMMPlAiKHDkipf429mEhUEe6bc1DzkDFEh+TPfe42+D1
	R9XeJodHP+Yu1FezWwwTpj952HIUvT0YaiVRKig==
X-Google-Smtp-Source: AGHT+IEc3HtDZMgD9lYvHKiuP10mQcQTLlMzzROBzl6HIMjJA6RX3+ummOZE0ggSdNv9oAbjQQeiq5tKEojMcR8arwc=
X-Received: by 2002:a05:6512:2248:b0:539:fcba:cc6d with SMTP id
 2adb3069b0e04-539fcbacd7amr3773128e87.42.1729062541873; Wed, 16 Oct 2024
 00:09:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <88114b5c725bb3300a9599d3eeebded221a0b1f9.1728491453.git.nicolinc@nvidia.com>
 <CABQgh9Eaj_vy1=sS2Pf7RC7Vy5PopDfwoshECULEU-jK3JF_sQ@mail.gmail.com>
 <Zwn/4m8Ac0xEiJi8@Asurada-Nvidia> <CABQgh9Ft=xxJK-bjS6wCZ5BN4AiKtF9fzdBkevA3x2yb_4O4Kg@mail.gmail.com>
 <CABQgh9HP1M8GAXMwf0ZNn5EpMBAvJU3JLRWcN5H1wfGrqXSe1Q@mail.gmail.com>
 <Zw08z9TOFL57z07O@Asurada-Nvidia> <CABQgh9H-SB7q1v_XtWaO12K7jMMaq8Lj7F4kpDv9sJ5v-F6DZw@mail.gmail.com>
 <Zw3M/h1KYe9MjcZK@Asurada-Nvidia> <Zw64C7bQicoAmAM3@Asurada-Nvidia>
 <CABQgh9Fea006HPwVTAuxk7KGh-7-YbjRhoUttVo_iACjAbr0CQ@mail.gmail.com> <Zw9ijVgDlvRajsSY@Asurada-Nvidia>
In-Reply-To: <Zw9ijVgDlvRajsSY@Asurada-Nvidia>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 16 Oct 2024 15:08:49 +0800
Message-ID: <CABQgh9GAyGNPz1KNCm3ZT9dtECdGyKU-L_aNnahY8K=RG7AODg@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] iommufd: Introduce IOMMUFD_OBJ_VIOMMU and its
 related struct
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

On Wed, 16 Oct 2024 at 14:52, Nicolin Chen <nicolinc@nvidia.com> wrote:
>
> On Wed, Oct 16, 2024 at 09:56:51AM +0800, Zhangfei Gao wrote:
> > On Wed, 16 Oct 2024 at 02:44, Nicolin Chen <nicolinc@nvidia.com> wrote:
> > >
> > > On Mon, Oct 14, 2024 at 07:01:40PM -0700, Nicolin Chen wrote:
> > > > On Tue, Oct 15, 2024 at 09:15:01AM +0800, Zhangfei Gao wrote:
> > > >
> > > > > > > iommufd_device_bind
> > > > > > > iommufd_device_attach
> > > > > > > iommufd_vdevice_alloc_ioctl
> > > > > > >
> > > > > > > iommufd_device_detach
> > > > > > > iommufd_device_unbind // refcount check fail
> > > > > > > iommufd_vdevice_destroy ref--
> > > > > >
> > > > > > Things should be symmetric. As you suspected, vdevice should be
> > > > > > destroyed before iommufd_device_detach.
> > > > >
> > > > > I am trying based on your for_iommufd_viommu_p2-v3 branch, do you have
> > > > > this issue?
> > > > > In checking whether close fd before unbind?
> > > >
> > > > Oops, my bad. I will provide a fix.
> > >
> > > This should fix the problem:
> > >
> > > ---------------------------------------------------------------------
> > > diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> > > index 5fd3dd420290..13100cfea29d 100644
> > > --- a/drivers/iommu/iommufd/device.c
> > > +++ b/drivers/iommu/iommufd/device.c
> > > @@ -277,6 +277,11 @@ EXPORT_SYMBOL_NS_GPL(iommufd_ctx_has_group, IOMMUFD);
> > >   */
> > >  void iommufd_device_unbind(struct iommufd_device *idev)
> > >  {
> > > +       mutex_lock(&idev->igroup->lock);
> > > +       /* idev->vdev object should be destroyed prior, yet just in case.. */
> > > +       if (idev->vdev)
> > > +               iommufd_object_remove(idev->ictx, NULL, idev->vdev->obj.id, 0);
> > > +       mutex_unlock(&idev->igroup->lock);
> > >         iommufd_object_destroy_user(idev->ictx, &idev->obj);
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
> > > ---------------------------------------------------------------------
> >
> > Not yet
> > [  574.162112] Unable to handle kernel NULL pointer dereference at
> > virtual address 0000000000000004
> > [  574.261102] pc : iommufd_object_remove+0x7c/0x278
> > [  574.265795] lr : iommufd_device_unbind+0x44/0x98
> > in check
>
> Hmm, it's kinda odd it crashes inside iommufd_object_remove().
> Did you happen to change something there?
>
> The added iommufd_object_remove() is equivalent to userspace
> calling the destroy ioctl on the vDEVICE object.
>
Yes, double confirmed, it can solve the issue.
The guest can stop and run again

The Null pointer may be caused by the added debug.

Thanks Nico.

> Nicolin
