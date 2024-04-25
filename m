Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F7014E2CC
	for <patches@lists.linux.dev>; Thu, 25 Apr 2024 17:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714065325; cv=none; b=YMsT/c30MaHubKLSbGY9SgXJtlcAaxAmWRo8Tk441sn/FBIyvPp4TvsQ/34r8B5UzpavslqsazRst2302SrxQLfd5bDWXHGRrZ/Zmujd+JjD52ZcNiVdyDvnlbxAvqM6V3eI8kEYyzv82evjpT+3hXdiAfwZqHLLPzLXAj9Eckc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714065325; c=relaxed/simple;
	bh=keQGh11L4ASmhAbfLJCprZcvvRwnGddM3OJi+dbRQ/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EYVrEJ4w9ss4snnSZETaq0RNJsweRpER32znle3rL8aLZAdIXJeL7ebSL8b7IlZc+Ft4OUKHUoC+aYlKATBALeuOZYvQeA6cid2gF/VvgDSiHiiyiC75UT558SPNRDFIYicsZm4F2aElzOBm93m9yzCkdKMdC1x4eiTVVN/Baww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jwKSR6sv; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jwKSR6sv"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6ed691fb83eso1096513b3a.1
        for <patches@lists.linux.dev>; Thu, 25 Apr 2024 10:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714065323; x=1714670123; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u1JLCe9OgKQpwj7dtaGJUIZ9L7mQbrj8lQtYz3ctHGE=;
        b=jwKSR6svEgTTr3kZkoFNu4qUlnAc6dzMx+VBQaf8VAxUUiwKYIxQEl3r5mR2JqHGcf
         EJxr4xJK37olgi7RyKNnEkiOP+pifCd6ELyGJLWIz/xxMbUZ+KFTLyvEcpqGMc9XYYIo
         lUsy/zYT2GQvrSceTQoFGmleOzp9GNQFXjg3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714065323; x=1714670123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1JLCe9OgKQpwj7dtaGJUIZ9L7mQbrj8lQtYz3ctHGE=;
        b=i3/DJtsV9gDBlBb0sunI26w75i29Y0UvazfoqCFqZpgRhBMiQvzR8VHZyd/5NBOncr
         vOcHVLH41kDm60hcNEkpYKWbDUlIvmTad4+dopkWYrlVd5JnF7C5LMnMRmJdopfNMdGz
         OZG593pCGbsgKpJlNcqMt4KiSK69mnxj3sdWc3KlC05CV0JqblKGiWoPidC3nqvV7ANi
         3yaZzVfJxHI0oNROHeR7iqizeDFdFRuX3zmEr43YBwxo55w2mVCgbIbsLUWGvyFxOvc0
         m8uHDsk48SHFdnX9D2LVSBdW262TfX27i8bBiKYL3PZm0swHr+d/86gKP+d/G9B6BRof
         nX5g==
X-Forwarded-Encrypted: i=1; AJvYcCW13j8gU9C0ppgrwIUv6IadOeGWdt6EdFbegHcb9Pb+VKvisjHXPoDS5xznZyGmANWyrTJhQOmCjzuTIpoFzPVdq1nPhw/OSw==
X-Gm-Message-State: AOJu0YyzenRwXOVVSBnB59ki9Z8xwmrBzvgnXly4Svsy9AIWrR3wIP8Z
	X8wYo6YI7iwfPDQM5jeXq9kIxcxeU/8g5vaBcisNX5t1em24DDNPJkx7kSLplA==
X-Google-Smtp-Source: AGHT+IHdAL2pUCcpe/Rwp2MmAw3VaSPub4F1WVpc3ytbvH+LpXMd2WcDJZqLoubA0TgHiGRSKS322g==
X-Received: by 2002:a05:6a20:5b12:b0:1a7:aecd:9902 with SMTP id kl18-20020a056a205b1200b001a7aecd9902mr294646pzb.49.1714065323492;
        Thu, 25 Apr 2024 10:15:23 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a7-20020a654187000000b0060013d7c463sm6433305pgq.72.2024.04.25.10.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 10:15:22 -0700 (PDT)
Date: Thu, 25 Apr 2024 10:15:22 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	bcm-kernel-feedback-list@broadcom.com, linux-clk@vger.kernel.org,
	linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, patches@lists.linux.dev,
	llvm@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: bcm: dvp: Assign ->num before accessing ->hws
Message-ID: <202404251015.23D4949BCF@keescook>
References: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-0-e2db3b82d5ef@kernel.org>
 <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-1-e2db3b82d5ef@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-1-e2db3b82d5ef@kernel.org>

On Thu, Apr 25, 2024 at 09:55:51AM -0700, Nathan Chancellor wrote:
> Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
> __counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
> with __counted_by, which informs the bounds sanitizer about the number
> of elements in hws, so that it can warn when hws is accessed out of
> bounds. As noted in that change, the __counted_by member must be
> initialized with the number of elements before the first array access
> happens, otherwise there will be a warning from each access prior to the
> initialization because the number of elements is zero. This occurs in
> clk_dvp_probe() due to ->num being assigned after ->hws has been
> accessed:
> 
>   UBSAN: array-index-out-of-bounds in drivers/clk/bcm/clk-bcm2711-dvp.c:59:2
>   index 0 is out of range for type 'struct clk_hw *[] __counted_by(num)' (aka 'struct clk_hw *[]')
> 
> Move the ->num initialization to before the first access of ->hws, which
> clears up the warning.
> 
> Cc: stable@vger.kernel.org
> Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks for finding this!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
