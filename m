Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCC622ACFB
	for <patches@lists.linux.dev>; Tue, 10 Jun 2025 11:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749556648; cv=none; b=mYA5/UOMsSALT9rHAps0gEVimLEBnZ2SXdhBnVKgwm39pyfGqubPSwZ+T8NezdcVvcNI7gfDSfAXsgO2HFEaUmnQVxLmB9cYxlqiovSdEZoPCqBXHDo/lsYp8Oprz5bdcZv1H0IeL+BOHx0Nfw/EyVdopJuIsUmW65p8OZKwdu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749556648; c=relaxed/simple;
	bh=MPeqqbg76lu+Wb+e45oYflxMl5SJ7ctjBNdciDd/NSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bTeCw650f9MsxKwNfhgTLk+xkaCJ1Wlr5VrxNmlAn13Py7Jv68atV0aa/ANBvhE6Z3q066e0wspsFQHgIzBvLRhLdyBQ+iAsUvrZiDR6epLLGjPE4SvQeqapm62yhfmBenPChhDgUDKcYPg8YE6yk1Q4gNMFaL3MhNzI5hbPztY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q76rYjFX; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q76rYjFX"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4530921461aso20171105e9.0
        for <patches@lists.linux.dev>; Tue, 10 Jun 2025 04:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749556645; x=1750161445; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m1tPKB3aQq3zXEcMGGtGtVzly+alYokN147Mvu6MtPk=;
        b=q76rYjFXFpk5TwQ/gcbnfMLnpWRTkmctIwNC0PEIFI6hKUxSVyGIclOnr4Ws79YR3J
         kMLZA4W61kv6/wl/XRNUXY6K4gppRB8hkHoroMH4tRo/+J76sCqaaG8sUnYni22BBGMk
         9PP96lLjT5JgFe2OkqCMIvGDPvjFuVQJIwq19fvCW+8v+qubwekLUAUGNsFTEn7JHYfM
         pNQE/VglR6YbiW8sPXM6TPP83pmJCHhncI+Qm2P7gwtSCABm8cXlC3cAt8Y8+nBLsbJj
         W6B0ZyCWTICS7c1MbSCL06fpdpWo/2ULveYqnzKEzbpgqn6dvKzc/k88/1wFf213yfbV
         JUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749556645; x=1750161445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m1tPKB3aQq3zXEcMGGtGtVzly+alYokN147Mvu6MtPk=;
        b=XkyaVuhffWsLnPJbMdqX1ETvDMdwnp34yllC+2mEEUhnzsnN8lf8LMNMQHsIwLgV5t
         skhVqvh3yqNFM9SuJ3DJZXqtsRmw5AFepWxavORvynlG7MPisaJfcbv8M8gJvymusXUC
         uqwDe9BDfxBus049EdF6C92C65ZzIFUppVGV85/SF1X886aIzcAntrO/Va5GuLnNPNIu
         JL4PvxmciCw9Eb3DFmfRaIfj2Ae6RzJ7taEEPwsv0vflria14gtW5bjugrPsmPkc9zof
         2ivrAOVHD3yf7nGrtcaC5twc5u+dAEVaU1tgLiSwnWg8Bsv6gScpyMOV4FZuxtgCmqDU
         gUYA==
X-Forwarded-Encrypted: i=1; AJvYcCVcnR9tKngFcJmDllCjznFOpLiluwYdt82Qm7FKx932iDLdmxgFbXJ17fRTvZ3rpoVIqkuQEZhr@lists.linux.dev
X-Gm-Message-State: AOJu0YwxvY9M0wvoAF9LBo3DseW39gjvrWTA3HCU3/KbmSRlsEYoLLWI
	NoexjZ14y5XJhxpjnMRgKG8QZniGzqr660VfUg0Y8l0e8zy1fLc3mMKeHhMT8eqwn9Y=
X-Gm-Gg: ASbGncvPeXENG2NvpG1aUdcavKN6Y5lU7sPBQEcqK/ll9pAGghE62TNpD/APq/RhU4Z
	lcDctm1om5U0BExYUTqWJrgcEkSzhdk6UFryjcUNOERvzRQlol/tbTYXKUq718wrxh3TEXBmUdd
	XefOGXt71QOAdcM1AvckQlqzb/eRffy+U828sFd+DrVRgTZJ0jUIW38RkMcHZJQI7/JG/Et610o
	3vjPEXO6qpJtygc8UADRe8rJMurhe0/F6C2NW7MxH1DoM9eGXsvyVzkho+jUKWjiIiIXF5GkcAf
	KHFjqjqJnVjHFrKyLey1a4rvf4Ze6ag1jcg5OyT6TAbONi1LVnSbW/7xDHwgi+ER0qQ=
X-Google-Smtp-Source: AGHT+IFRutpWq3mI++c2ze5et8BoMgRFXoiM8t3JTvOFFmUsflzqRA3Ic1DXBWG2cyZjgDJOcU/CWg==
X-Received: by 2002:a5d:584c:0:b0:3a3:648e:1b74 with SMTP id ffacd0b85a97d-3a53188a8admr13108602f8f.6.1749556645169;
        Tue, 10 Jun 2025 04:57:25 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45307c78489sm89779445e9.4.2025.06.10.04.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 04:57:24 -0700 (PDT)
Date: Tue, 10 Jun 2025 14:57:19 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-staging@lists.linux.dev, llvm@lists.linux.dev,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723bs: Avoid memset() in aes_cipher() and
 aes_decipher()
Message-ID: <aEgdn1U9j1ubbfWT@stanley.mountain>
References: <20250609-rtl8723bs-fix-clang-arm64-wflt-v1-1-e2accba43def@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609-rtl8723bs-fix-clang-arm64-wflt-v1-1-e2accba43def@kernel.org>

On Mon, Jun 09, 2025 at 02:13:14PM -0700, Nathan Chancellor wrote:
> After commit 6f110a5e4f99 ("Disable SLUB_TINY for build testing"), which
> causes CONFIG_KASAN to be enabled in allmodconfig again, arm64
> allmodconfig builds with older versions of clang (15 through 17) show an
> instance of -Wframe-larger-than (which breaks the build with
> CONFIG_WERROR=y):
> 
>   drivers/staging/rtl8723bs/core/rtw_security.c:1287:5: error: stack frame size (2208) exceeds limit (2048) in 'rtw_aes_decrypt' [-Werror,-Wframe-larger-than]
>    1287 | u32 rtw_aes_decrypt(struct adapter *padapter, u8 *precvframe)
>         |     ^
> 
> This comes from aes_decipher() being inlined in rtw_aes_decrypt().
> Running the same build with CONFIG_FRAME_WARN=128 shows aes_cipher()
> also uses a decent amount of stack, just under the limit of 2048:
> 
>   drivers/staging/rtl8723bs/core/rtw_security.c:864:19: warning: stack frame size (1952) exceeds limit (128) in 'aes_cipher' [-Wframe-larger-than]
>     864 | static signed int aes_cipher(u8 *key, uint      hdrlen,
>         |                   ^
> 
> -Rpass-analysis=stack-frame-layout only shows one large structure on the
> stack, which is the ctx variable inlined from aes128k128d(). A good
> number of the other variables come from the additional checks of
> fortified string routines, which are present in memset(), which both
> aes_cipher() and aes_decipher() use to initialize some temporary
> buffers. In this case, since the size is known at compile time, these
> additional checks should not result in any code generation changes but
> allmodconfig has several sanitizers enabled, which may make it harder
> for the compiler to eliminate the compile time checks and the variables
> that come about from them.
> 
> The memset() calls are just initializing these buffers to zero, so use
> '= {}' instead, which is used all over the kernel and does the exact
> same thing as memset() without the fortify checks, which drops the stack
> usage of these functions by a few hundred kilobytes.
> 
>   drivers/staging/rtl8723bs/core/rtw_security.c:864:19: warning: stack frame size (1584) exceeds limit (128) in 'aes_cipher' [-Wframe-larger-than]
>     864 | static signed int aes_cipher(u8 *key, uint      hdrlen,
>         |                   ^
>   drivers/staging/rtl8723bs/core/rtw_security.c:1271:5: warning: stack frame size (1456) exceeds limit (128) in 'rtw_aes_decrypt' [-Wframe-larger-than]
>    1271 | u32 rtw_aes_decrypt(struct adapter *padapter, u8 *precvframe)
>         |     ^
> 
> Cc: stable@vger.kernel.org
> Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Yep.  I recently re-reviewed this because someone wrote a blog which said
that compilers were implementing it incorrectly and we need to use
memset().  However they misunderstood the rules and their tests were
flawed.  Using "= {}" is safe.

Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>

regards,
dan carpenter

