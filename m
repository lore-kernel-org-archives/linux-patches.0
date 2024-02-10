Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6097CF51A
	for <patches@lists.linux.dev>; Sat, 10 Feb 2024 00:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707526144; cv=none; b=XG0iOfW18dqxMPcYF/qaFx59EOwjBBF+GnboTQz0uApWUO7Vv9co69EzhEjyLij5Wh6j42JsMwBH7SMmRSwIeHzREmTgaIrP8CmWbD/sVIiuhYYXdT2PBxNuWXvaxUoIAABviJ0wVDwzxqy4fJeY0oF0GLPU8416htJeb2qhy4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707526144; c=relaxed/simple;
	bh=hrEhIt0za4zXX+4YcZvr59C24AojcEa8uuOYHTznHjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NLVuTmZpkN86ZHZXHaoAY+DkjftMmVpg8MjJDX5Y7SLGVLno7i9OD+Zt7YVlmW1hgCDIZ9ixWKJxyEJtM/Ka5rhSi0j/GDR3QPikw/JqGV9fktUKkCvw9qHGpEswdK6JGP0usyko8kuPF3GTlxbeFq6WF/3RmIzgaf/LPKaLSKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mq6YYoi+; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mq6YYoi+"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d95d67ff45so12438495ad.2
        for <patches@lists.linux.dev>; Fri, 09 Feb 2024 16:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707526141; x=1708130941; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xhIOsBixkq6X+I5UtLFYmEvlA1q4nQi2Uk71zOMtrW4=;
        b=mq6YYoi+o3TStqh54FOQkrzYWdzj4d0rwxao4K/E3KpL7iPS3MKR8outOLq76blZFj
         QR+CbzRsl2PRqSmTyUnlEatjzobybfo2omUUh3KQJKnmgVsN1mZVmbkxQxQVTovVMDeI
         ey9u08hinOwFAuXMXxC/amCbXt/k2J7aDx+5M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707526141; x=1708130941;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xhIOsBixkq6X+I5UtLFYmEvlA1q4nQi2Uk71zOMtrW4=;
        b=mUxxon4+r8R0bn8oldEksNOc/lGLMXFF6+6WG/Ebv800CZb0ZkR6PmDNJ43XtmxzCD
         2BhamRXC+XbYCmxZ3z/SzeqXvegqDIXb6aOIORwRzt/MU/hA02P3NaIsoRwY6f06DFkZ
         E6WweYBw/o4UA+ii4jcZUz8cmBG1Tl5lefBIrchzXA3kMv7clnBLrYGlhefSC82lW6C4
         oP90jaXfIvLAxasmcfzyqkTg347T3zcm22X2l0aWSyUkXUzqJGeb5LikO/w2ZR5Q+Xeo
         8jjhqwYKNo9w7H6Bk9AdC3Q9Y+lpsaV2IP9eDtKSqwxPw+PSeexG+Esh3g7NKJe7ULee
         58uw==
X-Gm-Message-State: AOJu0YwIpMk4NJu6b4q8dMCqf72B1J/SJJsxe3ikRblk2cMdCidQZXlb
	hytWzKqrEqTpt/ULacPk403/9sbw4oDstHK+lw5cjGvg1YIe5PyZC3yDisi6+Q==
X-Google-Smtp-Source: AGHT+IGqFQmp48EV/HeK/ohKlHb7zxUA5fEEZHeG+9UTzYyujZAJTn94wWRhwDxrqBopNav53lCKsg==
X-Received: by 2002:a17:902:ea09:b0:1d9:b8cb:3665 with SMTP id s9-20020a170902ea0900b001d9b8cb3665mr1167619plg.36.1707526140735;
        Fri, 09 Feb 2024 16:49:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVI0SOI2E3VC0AE0of9/MYFRR0yVYQzthkFmv0JW7fA/SJQhhnnI3Nj5OEsNvrtNcdRFhHpOf5u+C3DGYEj7y1QmZKG9DqmJxhSLGKUmKRtiym081eBwXvmlPvnPoRFbYozaBCVcEzpfdzvKL5XsE6na+cvYGSIz8z/iw3GGz5NgMjZyC8x1ylmlUU500p9eC7PsDUz3qdjaUJ4lDemv8WJ00f0xgTx30k9IBXOA4ukuDuItip5wN0tqF2XRRURTeOK4zFlkc/U1xMHtLiGXHCiJxbOfRkGuI6qbhSgFvTKnpkPDxwJIq+B0WYaKEtx/pSF/bhP69oEmAjzAfeoA5ZDA9/FFXosjMJlFihIuYBkey/d
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id h3-20020a170902748300b001d9eef9892asm2062122pll.174.2024.02.09.16.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 16:49:00 -0800 (PST)
Date: Fri, 9 Feb 2024 16:48:59 -0800
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: masahiroy@kernel.org, nicolas@fjasle.eu, ndesaulniers@google.com,
	morbo@google.com, justinstitt@google.com, maskray@google.com,
	linux-kbuild@vger.kernel.org, bpf@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] kbuild: Fix changing ELF file type for output of gen_btf
 for big endian
Message-ID: <202402091648.2B8D95062B@keescook>
References: <20240208-fix-elf-type-btf-vmlinux-bin-o-big-endian-v1-1-cb3112491edc@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208-fix-elf-type-btf-vmlinux-bin-o-big-endian-v1-1-cb3112491edc@kernel.org>

On Thu, Feb 08, 2024 at 01:21:06PM -0700, Nathan Chancellor wrote:
> Commit 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> changed the ELF type of .btf.vmlinux.bin.o from ET_EXEC to ET_REL via
> dd, which works fine for little endian platforms:
> 
>    00000000  7f 45 4c 46 02 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|
>   -00000010  03 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |................|
>   +00000010  01 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |................|
> 
> However, for big endian platforms, it changes the wrong byte, resulting
> in an invalid ELF file type, which ld.lld rejects:
> 
>    00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF............|
>   -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
>   +00000010  01 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
> 
>   Type:                              <unknown>: 103
> 
>   ld.lld: error: .btf.vmlinux.bin.o: unknown file type
> 
> Fix this by using a different seek value for dd when targeting big
> endian, so that the correct byte gets changed and everything works
> correctly for all linkers.
> 
>    00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF............|
>   -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
>   +00000010  00 01 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
> 
>   Type:                              REL (Relocatable file)
> 
> Cc: stable@vger.kernel.org
> Fixes: 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> Link: https://github.com/llvm/llvm-project/pull/75643
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Yeah, looks good to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
