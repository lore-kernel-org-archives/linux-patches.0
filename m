Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AEEA55
	for <patches@lists.linux.dev>; Wed,  2 Jul 2025 00:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751415279; cv=none; b=fwK2CtdKWdMgo43hwNJBS2jCLIB5oiyVTOUWhcC3hMSdu2Vw2OyPyb8rNYMzHM/eDf2wRm/8wL4NYySOYbkxtEr5KO6O5qgDz7B0nZxx0xX2wM6ndShsAAoP3+ObN7UFHq00OBClZxrZNfg1s5Qqf0xe7FnbruOPQo9uAUgdJa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751415279; c=relaxed/simple;
	bh=269QJMUMdHzfHuz4jq/gGMWfgE3bohbbwQ/J8DDsB00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MiR40QCNWB7HzQZMTJqmgq3BYp3QwZmDyvXtOY12FHCO6m36PnYVPmkYzQ1oDxMNjVriaq9w842rYuP3bZrEBsTAcbPowIWfdCq82DNUGwGnH/HTqXdjW13llgI0zDg5fdHZQCF6rpWK4CB7C+/EzhrL5FQv7g8s79JnlOse8zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=azta0dWL; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="azta0dWL"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-235e389599fso364485ad.0
        for <patches@lists.linux.dev>; Tue, 01 Jul 2025 17:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751415277; x=1752020077; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yWta2RBHdNOuAiG72RgunT5XM70BX2r3Pve9teJEvWA=;
        b=azta0dWLnTqRjvDyVf3TexWHKvER1FzUs9CeQ7LRK5CniYjVfqKtja4hfUojYE1QZD
         pdfYiQNhqbBMiSLjELs/cbnCqVM4/Dw3NkT7ppfbSSogw9kMmhALX7GHSeQfzhJftsw7
         8SrjL/3mIKDJC/VXfnSWgrZ9Q0jlg2dLln5vqUVoQw20SFhokADFoLIAAEMahKDSnDLJ
         H1WZ0Awd7gPP6kYKcVeCvc/SgMCyyHTRty9NfPEzOdv2tYdwQr4IGDWdEBRuu4YBYrnu
         DUlEdBtjM4OKvbqnDP4V9yM6pqK0AFot/kfRPZAcU8jA3OEY9R0DUYLh0h9uLln98S6w
         Ox0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751415277; x=1752020077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yWta2RBHdNOuAiG72RgunT5XM70BX2r3Pve9teJEvWA=;
        b=Y6L1Xseryf7N0UjprVq3wOwAzfs9YZkheeqME5I+SDC60AgPWv1HuUj7V+HlKEYhBw
         2+S+mnHofcy1u58gb/3R0nX/EWAmBM3LmYOaiqaherpfmAHRIU/Vc6IkU2XH8KFNZRlg
         yNSd8QHOV8mowsKhnVc9wd2P0ms8WLcZSshin4BG68sWH7V+4Fmp6xvU4WAV3ItgdSQf
         JKt4FkbQkXnSJIeyPCWmNe7TQIw+HeyGrjU9A3bliKS/m1kRosUk6o7zJciNXc3JUtqq
         O2RDg62QFhg5ULgD3rjhiRtJsWOGWznH2zkXs/kyGsllwaeNvihD9COKzcogZeGGy6H/
         cHZw==
X-Forwarded-Encrypted: i=1; AJvYcCU2439QVM7v6Zn2LzfWufVTwNL6uarGZ36y8BIqdZxebzqoFfiu0zSoL2xqSgtB26UJcCyULXBB@lists.linux.dev
X-Gm-Message-State: AOJu0YwarbGJvXnXmxdGid4LE06mEjwrf4KbDqMtS6yG9JfI3fcpVLjK
	k0xgxJ9P0kG0IES0PjvFgtGdC1bjspXulHtELc7V/U8q0DZIxKhxNG4j7IZEZUz/aw==
X-Gm-Gg: ASbGnctmaQXpll4+9ClSCeAyRCZnOV6JSGaG8hGBbxmsoV55WTh+/vfK/NSZyvwo7wO
	i5mCPQnd53xRtgbMZD7x+Zw5EZZvyHIW6koWGsTJmsD1+C9hkVgObqhlvu3Wn3/u5K3ZZ+OAWKU
	r0VL9Yye3NDbTjbvqfTBSHWme6D2Z7a6R20yiukhGk/UymM+ZYm725W1vcSp+idZPbnNpg0q6Ul
	LlY7/izyvKt9WktqZ/BYSe9ptfPErrqvIiGaIUvZW4CfilQGGlndmCupqJLFrHthL2MNM1ca99b
	a2MSUT1E12ZSZc07QRSzAEjF+txeW1dZ42on5Um4LhaXdfrBwCJCBRTQ9hX7fnfjrR/D7Y8hFqW
	zLMK29crSyz5clgol/YD/
X-Google-Smtp-Source: AGHT+IGvJMG8/hp+2Ct3jUaU9SAz7W5inwlVAS3AX7hVe0NTLM1n/six7+4FqNJbQ+qt9+fMTBDOTg==
X-Received: by 2002:a17:902:f70b:b0:234:bca7:2934 with SMTP id d9443c01a7336-23c5fef098cmr4092395ad.6.1751415277107;
        Tue, 01 Jul 2025 17:14:37 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3b7986sm121732375ad.164.2025.07.01.17.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 17:14:36 -0700 (PDT)
Date: Wed, 2 Jul 2025 00:14:28 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com
Subject: Re: [PATCH v7 27/28] iommu/tegra241-cmdqv: Add user-space use support
Message-ID: <aGR55PUBnwb8qT8U@google.com>
References: <cover.1750966133.git.nicolinc@nvidia.com>
 <539ee2ec112162abdba511574e2205a77b425059.1750966133.git.nicolinc@nvidia.com>
 <aGQGm1-i4M75b9Qp@google.com>
 <aGQ6KCI9OZEwHdxS@Asurada-Nvidia>
 <aGQ_F7Qx3scbbA-J@google.com>
 <aGRDtYRXFLoT+PrI@Asurada-Nvidia>
 <aGRIctg4T6cQECx4@google.com>
 <aGRcPSwaJkTeUrMx@Asurada-Nvidia>
 <aGRmaOORg-YDfncY@google.com>
 <aGRozoIDIlgl9H9x@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGRozoIDIlgl9H9x@Asurada-Nvidia>

On Tue, Jul 01, 2025 at 04:01:34PM -0700, Nicolin Chen wrote:
> On Tue, Jul 01, 2025 at 10:51:20PM +0000, Pranjal Shrivastava wrote:
> > On Tue, Jul 01, 2025 at 03:07:57PM -0700, Nicolin Chen wrote:
> > > On Tue, Jul 01, 2025 at 08:43:30PM +0000, Pranjal Shrivastava wrote:
> > > > On Tue, Jul 01, 2025 at 01:23:17PM -0700, Nicolin Chen wrote:
> > > > > Or perhaps calling them "non-accelerated commands" would be nicer.
> > > > 
> > > > Uhh okay, so there'll be a separate driver in the VM issuing invalidation
> > > > commands directly to the CMDQV thus we don't see any of it's part here?
> > > 
> > > That's how it works. VM must run a guest-level VCMDQ driver that
> > > separates accelerated and non-accelerated commands as it already
> > > does:
> > > 
> > >     accelerated commands => VCMDQ (HW)
> > > non-accelerated commands => SMMU CMDQ (SW) =iommufd=> SMMU CMDQ (HW)
> > > 
> > 
> > Right exactly what got me confused. I was assuming the same CMDQV driver
> > would run in the Guest kernel but seems like there's another driver for
> > the Guest that's not in tree yet or maybe is a purely user-space thing?
> 
> It's the same tegra241-cmdqv.c in the kernel, which is already
> a part of mainline Linux. Both host and guest run the same copy
> of software. The host kernel just has the user VINTF part (via
> iommufd) additional to what the guest already has.
> 
> > And the weird part was that "invalidation" commands are accelerated but
> > we use the .cache_invalidate viommu op for `non-invalidation` commands.
> > But I guess what you meant there could be non-accelerated invalidation 
> > commands (maybe something stage 2 TLBIs?) which would go through the 
> > .cache_invalidate op, right?
> 
> I am talking about this:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c?h=v6.16-rc4#n305
> 
> Those commands returned "false" will be issued to smmu->cmdq in a
> guest VM, which will be trapped by VMM as a standard SMMU nesting
> and will be further forwarded via iommufd to the host kernel that
> will invoke this cache_invalidate op in the arm-smmu-v3 driver.
> 
> Those commands returned "true" will be issued to vcmdq->cmdq that
> is HW-accelerated queue (setup by VMM via iommufd's hw_queue/mmap).


Right, this brings me back to my original understanding, the arm-smmu-v3
driver checks for "supported commands" and figures out which queue shall
they be issued to.. now there are commands which are "non-invalidation"
commands which are non-acclerated like CMD_PRI_RESP, which would be
issued through the trap => .cache_invalidate path. 

Thus, coming back to the two initial points:

1) Issuing "non-invalidation" commands through .cache_invalidate could
   be confusing, I'm not asking to change the op name here, but if we
   plan to label it, let's label them as "Trapped commands" OR
   "non-accelerated" commands as you suggested.

2) The "FIXME" confusion: The comment in arm_vsmmu_cache_invalidate
   mentions we'd like to "fix" the issuing of commands through the main
   cmdq and instead like to group by "type", if that "type" is the queue
   type (which I assume it is because IOMMU_TYPE has to be arm-smmu-v3),
   what do we plan to do differently there, given that the op is only
   for trapped commands *have* to go through the main CMDQ?

   If we were planning to do something based on the queue type, I was
   hoping for it to be addressed in this series as we've introduced the
   Tegra CMDQ type. 

That's all I wanted to say, sorry for if this was confusing.

> 
> Nicolin

Thanks,
Praan
