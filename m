Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CFA21CFEF
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 01:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765847665; cv=pass; b=jMBnOvsVYeeF8MIQNLwkCEg3efranwGW7Qp5l7XtNoDyesx2GIr+wcN5oFesuwKv6768VN1WfWDgU9xUK50y9zHDaD6W7a0kB5BreMkQn7lgzYY9eh4Sa4E/d0vBKTscgcileyW0som52qZ8hGmxMm5nfCpn6C846vTAFsfc4c4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765847665; c=relaxed/simple;
	bh=RYQZPJfFMxqkp+1nngNLsMaHBFm6+xCUj4KkP21+dYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LAkqPNPnPn5Ya90J+AlgGvYOdB2OYYWJKhJcs2XzbfEuGELMDSj/3dcqbZs0qNMjmbwpnTVYsOPOQzIv/ox7qH2KfOfaJsAmOBEk4+tKuNnq61quE0CrVsXVkddHYli53Qdxcefk6nlgvsgu1ZGzWzkEwvKEuXo4wn4UCuvvrSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vGUDJtK1; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vGUDJtK1"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ed67a143c5so152331cf.0
        for <patches@lists.linux.dev>; Mon, 15 Dec 2025 17:14:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765847663; cv=none;
        d=google.com; s=arc-20240605;
        b=PMvpsVtfWrjIuFcmZEqXhCOq8qJL7yJk5T2aoN6WHJLXahIsgGgs5Td+H6eXa8aKRW
         G9Chzq0JgIkIKqaNfGoVixADhTOUst6r26D8Yngo5NyfsnWWNId0WJzSDybBBJWhtjIG
         GWUiMyJniQPhxLfqbUl2aR4eTmRmhzRLAqW+nMhxacea2Je9xMM/s1KFPhlqnp8OKAm1
         u5HnqBGN2tMYEnqrYES6NLC1ro4lABQiLiD4qDN0kPvRcMpuxOpKTDxwpzqgKSK5ejBF
         HtQdN1ocwHLbmzZMbIxn4+4GuRJ3ZzQVHMztDesoe0IGMKt0B6smsysIf6EjibPNVzom
         zEPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nNRSgDqjGCHm0cCbv9mH9lJK6eTAVlNyMNzHMF8cYvc=;
        fh=E8k2mefM3FiVXAcDqFJoS98zC0gLAQF+z/fQ4X4wHDs=;
        b=ijbxFeeJm1XaJfF4V+X3mUp8g9UiEaDsP9PBDo1LrENIcYe896KEPvjCajAM95dC28
         oS6Ae5EHLMigjhQZvMgLj8Xo0Y+0sAfYI0kFsz/M/+ixyWUR3XS7TDTuBD2+91HuuSnj
         uJNjsmDs4gdR74cI/3x20+idxvjpRZpoz8hwMeWruHEDzTDY1jOWB6WUNV5xcPcvZVKS
         t8ifEYEhwClvIRgmos8TXOuYZHKM/9R+Thkva1VE8MHo1oaxZMp9c8sLNRhODcG8s6Ob
         34mxZ9RW7CjrUdaHrAQ4M0sQ6IBLsXIMyl2IRHwJTnsXmONOvDv9B8wKk7aANTuMhaYe
         XlDQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765847663; x=1766452463; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nNRSgDqjGCHm0cCbv9mH9lJK6eTAVlNyMNzHMF8cYvc=;
        b=vGUDJtK1txL9KJyBns5NkuVGspY/0B/CNh5zdYrm2Kn88dcQxvi7x3xBWZboBRJbwz
         Cxa3fSZhB8JKowYuE3TJ4xLyrs3/ZHGwiMDurxRbgINqiFKvkC4QdZe0pxFQvbM5idoW
         j/JVzMLN8Sbq0qK2KZtxc/nA1Q9sgLTmywbilvBfUBIUqrKPWcfLGee/5kEXd/4KZLF/
         6CDyxeeQYYhyLgmU55mHI8J2PcyP0XkCybiFAa4rT7ixQKRPzMc4VGI+DI8QjyWfyYcN
         lbXLdjnA4BYZcUqEeRpyEez7xO3IQoCC97qeQuRXb01Wk4m+35t33V4zkSnjgee0s4R+
         HNNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765847663; x=1766452463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nNRSgDqjGCHm0cCbv9mH9lJK6eTAVlNyMNzHMF8cYvc=;
        b=n7YJVGcwQaplEbvgBMtkdQm4SrXg/Nyt96lfG139Ibo5hOpgYaokAABjUWX1BP/wWr
         Jihg2u9/f5FmPUEjY5I26ghf9xEhPMGkK9Mur0JojlBF9geL1DJKqVqiAKu4D1ZszsPH
         V//u98sanJmhPlRviAqdiamUzK+07zW1KgkdZb9/0rrWUGw01SntiYIgP4rRcDfUvp/4
         JN5vHwuaXP9szNI/d/GLehCzwoppzMNFPOk2W+f7eY9AWgQcXEqQg3BW6nfmSJFpDM+C
         fmM7HFBClXMkW5JiQaealziRQpLDEaVRwlZKBGupP9As9bkwfw6NA18vMPP9lW8c2OXC
         iSPw==
X-Forwarded-Encrypted: i=1; AJvYcCUK9wrSWefTAe5flnqyWXgFm3vgOgo7OGn0qUEFCJuN1g9MsSPqg9ogwPd2UK26x1hyAXtAiH0E@lists.linux.dev
X-Gm-Message-State: AOJu0YwNoseNoC7KnA3a7JVMCiGLuve93aMr2azjO1HievL5ztY9+9VR
	qOvejWrvXOwQ5tTA7Z0RZmQsFUICU2eQYpumh/dnrFp5q54S/nKq3l2BCjBmGqKlaSGEmrfWPWp
	UdYb8NmkP2OuDZpIuSjmKgHIitqvYJeCtY75VJefO
X-Gm-Gg: AY/fxX78sfa68kRcBiq665qYOLcbP7pvR6QRHBzB0UNeS/J/LKk2ft9ub2uOLOUZhpp
	tyoUiD6CyudvQmQ3kPZhQjIg1BvqR3sMbmOBEoAGwDy9iFVxQseZKa/uK7IdWFOPtzl9vH+QEmT
	VzIYxiu/ASENEHmcsmNjnDeq51Pc8ylin8EtF2M6F8+5sNtr27hWLDS09JvOD5eYUfv/veX7iai
	EuXUPijnoKrVGHp4+0FfqS4E7y4CBSyqzcQGobpFXcVFm/pwH70GfI14KSjxyp/HPVg2GWB43p6
	IBnFUt3dWM4SiA/MtcHN85UNWA==
X-Google-Smtp-Source: AGHT+IHDK9Nx0ZJG9GA2+hWOGyWZ73qxIXF4H8RaWSuD2ofLYKrM3Tu07Foy0ZrKHXYTXOo9Ba7m6bZ0z05T+81FVJI=
X-Received: by 2002:a05:622a:8a:b0:4f1:9c3f:2845 with SMTP id
 d75a77b69052e-4f347f93f08mr1579311cf.9.1765847662514; Mon, 15 Dec 2025
 17:14:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1765834788.git.nicolinc@nvidia.com> <cb38f91526596f4efd0cd1cffa50b4c1b334f7a4.1765834788.git.nicolinc@nvidia.com>
In-Reply-To: <cb38f91526596f4efd0cd1cffa50b4c1b334f7a4.1765834788.git.nicolinc@nvidia.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Mon, 15 Dec 2025 17:14:10 -0800
X-Gm-Features: AQt7F2pGryc6oZ72KleXBeas9fEej802hxD59J2edZO4aLe2-OI0GRs2t7Q1jUY
Message-ID: <CAAywjhSzKM_bEm_VbPZFffY9sR3-p==gbVppSL+555D1kPg_3Q@mail.gmail.com>
Subject: Re: [PATCH v8 1/5] iommu: Lock group->mutex in iommu_deferred_attach()
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, afael@kernel.org, 
	lenb@kernel.org, bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, 
	kevin.tian@intel.com, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev, 
	pjaroszynski@nvidia.com, vsethi@nvidia.com, helgaas@kernel.org, 
	etzhao1900@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 1:42=E2=80=AFPM Nicolin Chen <nicolinc@nvidia.com> =
wrote:
>
> The iommu_deferred_attach() function invokes __iommu_attach_device(), but
> doesn't hold the group->mutex like other __iommu_attach_device() callers.
>
> Though there is no pratical bug being triggered so far, it would be bette=
r
> to apply the same locking to this __iommu_attach_device(), since the IOMM=
U
> drivers nowaday are more aware of the group->mutex -- some of them use th=
e
> iommu_group_mutex_assert() function that could be potentially in the path
> of an attach_dev callback function invoked by the __iommu_attach_device()=
.
>
> Worth mentioning that the iommu_deferred_attach() will soon need to check
> group->resetting_domain that must be locked also.
>
> Thus, grab the mutex to guard __iommu_attach_device() like other callers.
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommu.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 2ca990dfbb88..170e522b5bda 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2185,10 +2185,17 @@ EXPORT_SYMBOL_GPL(iommu_attach_device);
>
>  int iommu_deferred_attach(struct device *dev, struct iommu_domain *domai=
n)
>  {
> -       if (dev->iommu && dev->iommu->attach_deferred)
> -               return __iommu_attach_device(domain, dev, NULL);
> +       /*
> +        * This is called on the dma mapping fast path so avoid locking. =
This is
> +        * racy, but we have an expectation that the driver will setup it=
s DMAs
> +        * inside probe while being single threaded to avoid racing.
> +        */
> +       if (!dev->iommu || !dev->iommu->attach_deferred)
> +               return 0;
>
> -       return 0;
> +       guard(mutex)(&dev->iommu_group->mutex);
> +
> +       return __iommu_attach_device(domain, dev, NULL);
>  }
>
>  void iommu_detach_device(struct iommu_domain *domain, struct device *dev=
)
> --
> 2.43.0
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
