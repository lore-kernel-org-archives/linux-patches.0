Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C95F2D94A8
	for <patches@lists.linux.dev>; Tue,  4 Nov 2025 23:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762298276; cv=none; b=QL7+MmYBIxrkhe/KWiixBsIjluTNiF5St7Mwai9E2kM/Wt7+FLgqKgAWxuVGNprvO+ivBQInv5aem2qXuPCkvGuHDU+tWAcnWSAoK7/0vIyUdusyeJLcSmJxgam6kJmbMQ3X4030WYCocLRo7B9YqoOCTlwEbtdBFelO9rwqDv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762298276; c=relaxed/simple;
	bh=7fOREhmgPGHni1gljSJExDQiVXEWe4TOmHfhELJedlU=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xf+6TttGsw2uj9PsMXWTklLg4YxQs3VqCcRGxJQDbJdefzE2Kag3FVq9ttAoS9Dd8pmSshYeb7KSnc10SNqa7pzxHtEMXdPceLtiCSyfcRE6N+fSl9A4CbXEaNF1Ix0QmRYHcK0c3vWBA3YpNVCOS4Hj646XRaNYIw8hDZllmYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=ejrqH4Ju; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="ejrqH4Ju"
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B79FA3FE38
	for <patches@lists.linux.dev>; Tue,  4 Nov 2025 23:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1762298261;
	bh=MieDiTn7THEoDLo56I7CJ2MsB1+PBRPE6P2QhMPLZHs=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=ejrqH4JuNNIuxf1SwwwzyzfctN8Q9NeWPR0GliQAdyjnIjM0XWMTirJ17Jq+zp/Yi
	 0/7N1BUimF+Z8vGmarv/pFxaiH5s1ZJeq4GbLM+MCez5L8WpIxRDeHORX1vfS4crA5
	 TeGngRklVoLvZHZEGaDDdP0iFPouS9pxgpeD2cnwdh3h7ETvZLxwW/z83ruZAhOtg+
	 z/0RFlcZMLxomzcKpmbO0NwELLN9ORKjDBHJsReMLlwPQMFWJiml7i9pkqrLCRR2+T
	 2fHv94yf9ySeYkOh4F6z/CCPG2FV8xRCw1mdknlEFJ49tgaB0K7S29z/ce3k9U1iCG
	 80XZ6i17X0SwZ1ZBoepW5HIacUxU303/mdjG0p9Eae13xFULKgrZPeXJUw3FBv4mmr
	 hdA9nkQcIJbZak1Otgz+ZZ07U0yNUHIVKUwDiNnxTxZ+KGTm57z1E4pv6NPKgCfPu2
	 KTrOPx1rndd9Z81lmwoXzF1nuPnw7ZGpkeT9x4Zdmd7s6cVkOG4fOCUvLg1uOO+T7J
	 OXaMpKq/61WGOiZ4exhj7NRIguRQPw3qxqLaNKdII268ihY4PvpERk3RroRlx26f0C
	 OkPLnyPsbvrxLTnspfaJgyZFSAYqfvqyubJuFTATfe85HGPxwphAhBMJAKGapRD7P+
	 cYeYVq2xK+PMMa0YkVwqYe3E=
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-932c07ad3ebso10428789241.0
        for <patches@lists.linux.dev>; Tue, 04 Nov 2025 15:17:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762298260; x=1762903060;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MieDiTn7THEoDLo56I7CJ2MsB1+PBRPE6P2QhMPLZHs=;
        b=iQrPk/Y7o97mD8zq8UaOu2XSBeY0HTiTxhH5zNv2paT+VrPh0RS0VnWJ28BeGY1Dn4
         dBliRdB/z1ijmXXbYtFXfvl5kt7EK/Ty+YEMb0FCPj20wYLmJaCwWThvtJ5z9dCpwfV/
         vgKR12NPsgroVmITwIUQbdcq7JuMJS642yd3I5GxFU6O9tcwx6vQaVYeXuhlRPdY7DXL
         QhJ9LLYq5fLqv52XVDQXZwIhbG5hfFOWVq2F6ZoNX0eEZk0gwgrq1OGgxY8/KGnG/byg
         y8xN3UWFclp3gAA9j7Mj+7eTVlU7SRwbP4JWfjRsHnuBwuVycl26oJF6KkbsqyoNLRwN
         OBVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoAcqK3wmX0hvfYa1DxZpBL3yQqitWsi5i6FVOTyIKPXFUYNSudC/F+rp/Yjb3LRoXwmj/bkn8@lists.linux.dev
X-Gm-Message-State: AOJu0YwpFzNvjApeMklAV+H2XZMX0KP/XhG6vTtMC4lRlPngKnJ+sTmS
	5F0d8ul66zZTx1k8iAHvea6/gMYgPMcq1Z+9esYNizldBZzABnTux0+X/QFl7FBoelmQVIcFtjd
	oLMpvJOgZmoV2hKSogBugfeGjqK6mPAoQBmZ73HVOcfVjcUwHxSfWCat4QetZTOnh9PD9NwDSr6
	f43JPBOZONIThz/iJP0VE8pJ94iLG8tvqEL8o/L2Qp0nWP5hGyJQ==
X-Gm-Gg: ASbGncsrYdfkSRT7qgLkFH8Ih/UePwdDW0dzTaDh82DnxiUI5MI1bURR4o/x4Yd8YaK
	QlTQPmdFD2yF7akcUPlo6obB6dLHBGgMJnoWwN5LBXIohggRW+vXsx5C22f+2bKvPcjFns6U7IP
	lhOm9j1CJbi0pTM5QyC2aEAFldub/f9jvm/XYJiZldth7/zajAJAAWbxgUJAGWZF2tj1rO24gd5
	V6Tm+w0scZnZRPB
X-Received: by 2002:a05:6102:cd4:b0:5db:f615:1821 with SMTP id ada2fe7eead31-5dd88eeef01mr457156137.10.1762298259783;
        Tue, 04 Nov 2025 15:17:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGoHJV28+m0O+BSg3fXLgJ4lIxTta5GR6qyYEyZXdo/8e+k0QHarJS9aGAH8XnODBhuWUXhpivbkMok0TRUXPk=
X-Received: by 2002:a05:6102:cd4:b0:5db:f615:1821 with SMTP id
 ada2fe7eead31-5dd88eeef01mr457147137.10.1762298259304; Tue, 04 Nov 2025
 15:17:39 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 5 Nov 2025 08:17:38 +0900
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 5 Nov 2025 08:17:38 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <1-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
References: <1-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
From: Emil Renner Berthing <emil.renner.berthing@canonical.com>
User-Agent: alot/0.0.0
Date: Wed, 5 Nov 2025 08:17:38 +0900
X-Gm-Features: AWmQ_bk2LB2NgRroD72443NwkSJ3-qzEbig-zU0asUuN_-pMFocKpMUHzSTaoCs
Message-ID: <CAJM55Z8SyipTBG8G2wU2euvJhzcjJDp4B8fjm2Djwoonz8xf-g@mail.gmail.com>
Subject: Re: [PATCH 1/5] iommupt: Add the RISC-V page table format
To: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Tomasz Jeznach <tjeznach@rivosinc.com>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-riscv@lists.infradead.org
Cc: lihangjing@bytedance.com, Xu Lu <luxu.kernel@bytedance.com>, 
	patches@lists.linux.dev, xieyongji@bytedance.com
Content-Type: text/plain; charset="UTF-8"

Quoting Jason Gunthorpe (2025-11-04 20:00:40)
> diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
> index 96f8a6a7d60e10..10b8250659b98b 100644
> --- a/include/linux/generic_pt/common.h
> +++ b/include/linux/generic_pt/common.h
> @@ -151,6 +151,21 @@ enum {
>         PT_FEAT_AMDV1_FORCE_COHERENCE,
>  };
>
> +struct pt_riscv_32 {
> +       struct pt_common common;
> +};
> +
> +struct pt_riscv_64 {
> +       struct pt_common common;
> +};
> +
> +enum {
> +       /*
> +        * Support the 64k contiguous page size following the Svnapot extension.
> +        */
> +       PT_FEAT_RSICV_SVNAPOT_64K = PT_FEAT_FMT_START,

Is RSICV (not RISCV) on purpose?

/Emil
