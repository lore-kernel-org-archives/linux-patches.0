Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD26D26AE8
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 16:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712767081; cv=none; b=DLZv0foueuidAGI7nkyCixM2T2WwK0AtrQQ5zIOInfB5zc18JjZx2RTJGST3itMz1hWVJJDJ2BOXo4LnSG3xIdvrjr5r84zvqy9bydhqt2AppiTS3+xPC9Q2kt8ZInSOKDLmRS/ynUuryZKtu43YSotp7ZZ585JZQwc0/yj6J4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712767081; c=relaxed/simple;
	bh=AMgEGgEF5G11tgF61befRzoOglNuHlyFi5hOiDd6CP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VF3kN5RcIrdIWYstSOfCqK3WNfixLWOabTfqxlwAjsQ+kdGtSEBcezmShl7FSntlZYUA9RUKyJeYutuU2ZgONqbyPkL8p+ayBFF5adFeTSp2k583JsLONX96Ca4LGGSru5iBODIpUfhO5KUDkHy+JzuEUnu6flR91OSLxMbagtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jwQBCSkA; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jwQBCSkA"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e51398cc4eso4568335ad.2
        for <patches@lists.linux.dev>; Wed, 10 Apr 2024 09:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1712767079; x=1713371879; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yjP//Mip90DcNq6QUVZoNBunB0elsCFZjlaQ4MXCgWM=;
        b=jwQBCSkAbXgyCL18Jt5mp3/6azJJ9R2bWEjOBrBMfVH6qYCw1chOcW4Tevegjo6KLP
         kQXsXmJjcfzeWq+bf6mxI0CO+NotOBg8RylwoN3nnRYrmVW5RP9NZaIuwaDvNtHhRuRQ
         bs5IWoAjk0wX1g6EqC99l46uGzRAwk5QJRz3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712767079; x=1713371879;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjP//Mip90DcNq6QUVZoNBunB0elsCFZjlaQ4MXCgWM=;
        b=MugBbhKVFi5mGfRYwBo9K6Du1e6U8D33kWWlLV35AAvbEzQOTFX/rpi/1uLuGgj1Nn
         RngmLgOQ2FTfNGQYq5Roc8q4bwZ53XdrE78hbVTavPxzMAX34doPaURHFDhlVACpRZnz
         sic59yZiZJlmcHzIGEaXRiwhxH4+A7Ne0fkoLokJT+BmHNA8JrKaM/xjlHBqW6G9aVla
         gU2OkDcWc5pCPNENcJk4h0DEbEujsuXJ07XteUbXTigVbsCIlsFinjXpYfZJbRu2p0qC
         rZCYE+0i7kZEmfuaYDafrmoBEGsHhQJY74yChRAZncjRUDSJzCstAXJCFopjAYjOMG3M
         5QbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMvM+LhIRWdA0b60gcaSSUDkg46efowWzrvtQGxw23+VFlXv5QhgjAPyGjLf4wTb6ljyA3/dKwWBQqj4hJDEKVxDTE8pUYGw==
X-Gm-Message-State: AOJu0YzaRDI6Z7xG+fcC5KPfbpMDeDRnT4tCWW2Do6N8EC+wesLpk/2p
	DeIP6lA6l37Azr/8p73w/Alt+6jar9jJiHyFq88wPIybpfxd/Ppgl5z+WWaq7Q==
X-Google-Smtp-Source: AGHT+IGkSiqBENZyju8TbqoPI/qjO3Z9rGbf5Qvvr78dXidWDY70vwNaq6ppkND4mRSc9wHSfUaMow==
X-Received: by 2002:a17:902:eccf:b0:1e3:1542:91e2 with SMTP id a15-20020a170902eccf00b001e3154291e2mr4176100plh.46.1712767079276;
        Wed, 10 Apr 2024 09:37:59 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id l17-20020a170902e2d100b001dddcfca329sm10961121plc.148.2024.04.10.09.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 09:37:58 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:37:58 -0700
From: Kees Cook <keescook@chromium.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Pascal Ernster <git@hardfalcon.net>, Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption
 handling into .head.text
Message-ID: <202404100937.12A8146@keescook>
References: <20240408125317.917032769@linuxfoundation.org>
 <76489f58-6b60-4afd-9585-9f56960f7759@hardfalcon.net>
 <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>
 <25704cce-2d6e-4904-a42d-47c96056459d@hardfalcon.net>
 <CAMj1kXH+xOB3cLHL5XHAxMHeN8oOXYaqdExx2+Tij6vwZwhkiQ@mail.gmail.com>
 <CAMj1kXFQfgAOSdPd1aYW8TDi8mkExK9G4buviysu85YsQaQPdw@mail.gmail.com>
 <3ef518a6-6c9b-42f0-a3e0-22a306185a9a@hardfalcon.net>
 <CAMj1kXE-Yt+zVgZ5Y=jEssrna+pUYAOOEr5cXLiXMkmRqEKwhQ@mail.gmail.com>
 <fb25f7fa-f5f8-4ae6-aaa1-e1fdfd2f47a7@hardfalcon.net>
 <CAMj1kXFMwxFJJvYaTfUYb88a3iL4VFLWoBVdKj1eUH7q5_fOVw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFMwxFJJvYaTfUYb88a3iL4VFLWoBVdKj1eUH7q5_fOVw@mail.gmail.com>

On Wed, Apr 10, 2024 at 06:01:03PM +0200, Ard Biesheuvel wrote:
> Please try this patch
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=e7d24c0aa8e678f41457d1304e2091cac6fd1a2e
> 
> My bad, and apologies for the mixup - I lost track of things and did
> not realize this fix was not in Linus's tree yet when I asked Greg to
> pick up the EFI changes.
> 
> @Kees: can we get this sent to Linus asap please?

Done! :)

https://lore.kernel.org/lkml/202404100935.3D7CAE6@keescook/

-- 
Kees Cook
