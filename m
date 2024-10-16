Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4AA14A4C3
	for <patches@lists.linux.dev>; Wed, 16 Oct 2024 01:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729043826; cv=none; b=GEgH7tAXMTv/swJ42lg7/lAZt6fSpiungZK4b568UmYNdVoqClreRzQX4vpN59V06yfKQeyfyKpj+6vS0kIlHE3Y80tLxZruwuA+aDJgUJ0XgFwxrLYz4AJOmtYOkUICcdVSYBuQsNf4XaYuNbtTB2xVSgn0XSheFjhVC2PiKlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729043826; c=relaxed/simple;
	bh=6btI4iopsKLLKW9bPf4SycRrF9fzH3XxNtDWeivhWT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UNuqo6W4vWE4vCsO7SE5PkmLLebZ2BFg/uhXH/XqYf/uTh2Y2RJUgW3QnsAAQ03P6/bE80Uxy3DivxOSGBiThho2wY8W1GdVo6Yv+f1guT6FMMEkvKbeqVOZmLB9mP3hwkw490L5m91VvBdnPftGx/3zOVdJksaYHBV40m1xpP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mxCc++sR; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mxCc++sR"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5366fd6fdf1so7205328e87.0
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 18:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729043823; x=1729648623; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+FelR6GsDdJRo+uFPqIYovXFoQ6VzTQQEO/rkc9OHfQ=;
        b=mxCc++sRcirU/rq/kNxDlR6NJm5NLMah/2Aie7+I9Vt9hT33osWNpcEdZWjZggq2R7
         tCMwiWG7EqIyO2ppIC3yMecS4LGtytXzLt1E21cWuNG+LgcrFwX18YA0weuqTzf6OkBW
         OzzGAvLBqxcoBBXy+739xetrnNXbRt+FNm/ujjzcfG5UIJpThiCbfoiPuM858YGRdnO3
         3KZEqMxPD2XTeNA2y9NUEXPJZ1U1/XeWWXHH3neb5VsTCRxV6IJE/DSooUyppzHwfuf/
         bi29y1P0gJlKdYT3+dTHYH2Bc/auUIx6zRQbKY5fN4jeoRNq0xe/XvTTslY6uP3E69h8
         eTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729043823; x=1729648623;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+FelR6GsDdJRo+uFPqIYovXFoQ6VzTQQEO/rkc9OHfQ=;
        b=IyXjy3Mlw87M2RPRm8op+hUcidyz1WwWG2MCgcVyV8t+ijgDij6tKkPvp+pbY7H7CW
         hk19bHvFZgEIFY+PslBPbr6oW2WE4bpXOdX1BT/FNMYUc0dk65sfwA7TMuuTnuTz0mxk
         jiSuJQXk/AHxVxsS8IqBrCrrVC/Ca9qwobChiCqHjFWnievRb291RnVz0xvKHMxAH3jy
         H9WAlYfE4ArCBC6rGJgoEe8hZ7UL15c/xUoJa1PzWskSYcSB/icAU/PbOnfzahBxpGNa
         6/6GyvFZZ+avF0rPhMQ7z3j3MQc0v8uyesqv1itvpygD631GdS8FvJih/CVkTtXbu6Pk
         KtKw==
X-Forwarded-Encrypted: i=1; AJvYcCWObEZlKRD2dbHU/0FlhjquG9EJiR+Nh6uXRzNOi9jEIrFuWNiYn4GigbV+0k5eByNY5VMm1Auw@lists.linux.dev
X-Gm-Message-State: AOJu0YzZEoAjOpful/m0tmTf58lNQz6G2umyHnPTHyRywlhe0v30U4Fk
	5DXfMMv2eBTJiumwTP2L2J7vF4HBmgCpb5AcEO/oNWIPyrCpcPnl1ma3eQY5U2RL/MOWhdFTTcz
	pF+zx8dFWgXBNz2Wq2LCBZTBdSn+tVR8g42iYEw==
X-Google-Smtp-Source: AGHT+IGHNJy6WCLVvS1v7p2xUs8DBaNAGSH314OUXrO/87SH8h3u7zNrDy2Yj2k60G+29EMeHRdokeLA3B/2m0BY1IA=
X-Received: by 2002:a05:6512:3a91:b0:539:a353:279c with SMTP id
 2adb3069b0e04-53a03f2d542mr1721990e87.28.1729043822707; Tue, 15 Oct 2024
 18:57:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1728491453.git.nicolinc@nvidia.com> <88114b5c725bb3300a9599d3eeebded221a0b1f9.1728491453.git.nicolinc@nvidia.com>
 <CABQgh9Eaj_vy1=sS2Pf7RC7Vy5PopDfwoshECULEU-jK3JF_sQ@mail.gmail.com>
 <Zwn/4m8Ac0xEiJi8@Asurada-Nvidia> <CABQgh9Ft=xxJK-bjS6wCZ5BN4AiKtF9fzdBkevA3x2yb_4O4Kg@mail.gmail.com>
 <CABQgh9HP1M8GAXMwf0ZNn5EpMBAvJU3JLRWcN5H1wfGrqXSe1Q@mail.gmail.com>
 <Zw08z9TOFL57z07O@Asurada-Nvidia> <CABQgh9H-SB7q1v_XtWaO12K7jMMaq8Lj7F4kpDv9sJ5v-F6DZw@mail.gmail.com>
 <Zw3M/h1KYe9MjcZK@Asurada-Nvidia> <Zw64C7bQicoAmAM3@Asurada-Nvidia>
In-Reply-To: <Zw64C7bQicoAmAM3@Asurada-Nvidia>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Wed, 16 Oct 2024 09:56:51 +0800
Message-ID: <CABQgh9Fea006HPwVTAuxk7KGh-7-YbjRhoUttVo_iACjAbr0CQ@mail.gmail.com>
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

On Wed, 16 Oct 2024 at 02:44, Nicolin Chen <nicolinc@nvidia.com> wrote:
>
> On Mon, Oct 14, 2024 at 07:01:40PM -0700, Nicolin Chen wrote:
> > On Tue, Oct 15, 2024 at 09:15:01AM +0800, Zhangfei Gao wrote:
> >
> > > > > iommufd_device_bind
> > > > > iommufd_device_attach
> > > > > iommufd_vdevice_alloc_ioctl
> > > > >
> > > > > iommufd_device_detach
> > > > > iommufd_device_unbind // refcount check fail
> > > > > iommufd_vdevice_destroy ref--
> > > >
> > > > Things should be symmetric. As you suspected, vdevice should be
> > > > destroyed before iommufd_device_detach.
> > >
> > > I am trying based on your for_iommufd_viommu_p2-v3 branch, do you have
> > > this issue?
> > > In checking whether close fd before unbind?
> >
> > Oops, my bad. I will provide a fix.
>
> This should fix the problem:
>
> ---------------------------------------------------------------------
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index 5fd3dd420290..13100cfea29d 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -277,6 +277,11 @@ EXPORT_SYMBOL_NS_GPL(iommufd_ctx_has_group, IOMMUFD);
>   */
>  void iommufd_device_unbind(struct iommufd_device *idev)
>  {
> +       mutex_lock(&idev->igroup->lock);
> +       /* idev->vdev object should be destroyed prior, yet just in case.. */
> +       if (idev->vdev)
> +               iommufd_object_remove(idev->ictx, NULL, idev->vdev->obj.id, 0);
> +       mutex_unlock(&idev->igroup->lock);
>         iommufd_object_destroy_user(idev->ictx, &idev->obj);
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
> ---------------------------------------------------------------------

Not yet
[  574.162112] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000004
[  574.261102] pc : iommufd_object_remove+0x7c/0x278
[  574.265795] lr : iommufd_device_unbind+0x44/0x98
in check

Thanks

>
> Thanks
> Nicolin
