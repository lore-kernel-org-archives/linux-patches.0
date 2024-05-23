Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF2012839F
	for <patches@lists.linux.dev>; Thu, 23 May 2024 23:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716505948; cv=none; b=tnOc35zxSumuKSmEe5v6S+5e7pAxPhYVBOCYQ9mDzfEtO6OvC5qIqP0ReUAidLb4Z3IMI76ERmGsBvkDfxraYPhw6rBd/ULl0CRhYRbsXzRGDJUp4GyzkZWM12Lcz1tr0Y8CYfGCZ7vtW19e2GPMwX2z13hSN6jwpLX9QVrxAnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716505948; c=relaxed/simple;
	bh=Pr5fclf/NyQdxEw21anVvy8WtHKkbRAUyx9Gl02m/X8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8G+QMtVd1SDXNX0hRGZfY0uoRtLWz/5t8PMHBoDAkK4amrFRDNAt4h7ZEIiF8zVCRJbPjkbcOgVs87Y6q9znhswvI3ZAY5kLwIjgEXIrW42uIbkisTNq/j6nQR/FBTowYtPtB/AGMZ4eESYpL6N1eyyxHFA5VS0mHPYeSxjtz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=idxf5R5H; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="idxf5R5H"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f333c7e702so17168405ad.3
        for <patches@lists.linux.dev>; Thu, 23 May 2024 16:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1716505946; x=1717110746; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5mMbC5KBXhHkDvBNusLgJck71yWRaMS5suGXHx+nBss=;
        b=idxf5R5HoqhoOhYvQmtlQT1c/Y+SW7XRYOowbtHc/ghdxwZaroPj51l1nP6C0YtiH+
         /Q0UOn2auu/z2y+OvbShDPvCWMczy0YD1zJsmzfRSKTaPlKsvb7xvYrGF9bcOrS5hjTn
         zB8RK9OS0tpQeeYWWJkNIiEqjxVYJaAPFFA8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716505946; x=1717110746;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5mMbC5KBXhHkDvBNusLgJck71yWRaMS5suGXHx+nBss=;
        b=ql60GAhdqotYIYR4XWcC/QTET0Cu1WLIWoBRDgZhWUgIHBfTVjI6V3EG1FhMY6nM1Z
         +wIkLc/XZhB4V2+6hMdv1H0ir08PGlLsDOjklnj1v4rQ5SikUB/Anbw8NSSRabB3NfR1
         QU4sbPAgGVZMrd1h0LPlkXKFMVixJH4kTYqZqakAyNvcZthobGSQmPI9Q+FEx7GLRy6D
         j804gpudF7MLyKMwCfxx0fkJ7juFfsmzLgpJZVjQzByCyJR/MV0J5T4ZGFJryKGGXsgO
         uLv22mqmkeklEEWGI2/C5MUHotme4YFcWz1ntomqoHQacPnOqr9T5/Ya7NlSLYWqAuY8
         6InA==
X-Forwarded-Encrypted: i=1; AJvYcCXbaRaSy0OaP9lnq+wN6Chuj8Mzh0vQPRoaeyXgUAXTCXb1rulNI+gCYULMsu4eyvIeYb94oBxG2QJkQVXhYowr09ANp5S5Bw==
X-Gm-Message-State: AOJu0YzREKpYO7Bu4aBbaQcdUHAZG57biMzvsuo5Tf4OwVohGo6cGYXH
	3U8GNAgsEc/WzBN2HVSZNQuKGgkl7IaIVdcc/ZUOVyqCXRqniYE8j75QM71Xrw==
X-Google-Smtp-Source: AGHT+IFbXrTeUCq7J46GiJ/p3IWwvb8fOgFDb0trMNcBbD+UJjL4KOevqFmzptXng6JsupSTGMLaXg==
X-Received: by 2002:a17:903:1d0:b0:1eb:73c2:6b4a with SMTP id d9443c01a7336-1f4486e5e10mr8167325ad.8.1716505946250;
        Thu, 23 May 2024 16:12:26 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c9b2e88sm1125295ad.253.2024.05.23.16.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 16:12:25 -0700 (PDT)
Date: Thu, 23 May 2024 16:12:25 -0700
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] x86/boot: Address clang -Wimplicit-fallthrough in
 vsprintf()
Message-ID: <202405231603.2E810E3FC@keescook>
References: <20240516-x86-boot-fix-clang-implicit-fallthrough-v1-1-04dc320ca07c@kernel.org>
 <20240517095110.GAZkcojmJQoY_zU-OT@fat_crate.local>
 <20240517151833.GB3660288@thelio-3990X>
 <20240523115734.GAZk8vLgzOzD8Tv9pq@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523115734.GAZk8vLgzOzD8Tv9pq@fat_crate.local>

On Thu, May 23, 2024 at 01:57:34PM +0200, Borislav Petkov wrote:
> On Fri, May 17, 2024 at 08:18:33AM -0700, Nathan Chancellor wrote:
> > There was a patch to make Clang match GCC's behavior a few years ago but
> > I think Kees made a good argument that GCC's behavior leaves potential
> > bugs on the table, so that was not pursued further.
> > 
> > https://reviews.llvm.org/D91895#2417170
> 
> Really? Maybe I'm being dense but I don't see real bugs there... I see
> readability issues. :-)

There isn't a bug _here_, but this is about making the code unambiguous
everywhere in the kernel. We've already done the work to get rid of
all these warnings; this one is newly introduced, so let's get it fixed.

We don't want to have the same flow-control statement reachable from two
different "case"s where the resulting behaviors are different. Otherwise
we can't determine if a "fallthrough" is missing or intentional.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
