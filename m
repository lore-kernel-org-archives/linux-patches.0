Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382DAECC
	for <patches@lists.linux.dev>; Mon, 11 Mar 2024 20:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710189818; cv=none; b=TJ0TsEeZAmjhZ35A4cyeUM1id7s/QpVKF5Z/V7evqY+EcpSp9Apl6HibfUVUS+6oVxNprl8Ufwsc9yujtFzaQNE3Bx2K3B8gOndeVQWMQNEkrILpGq+/KQxcmRWl/wued27DVvMo3AwoBWZhZ3PI2sXdSwzhCgwhYMXcEWQApzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710189818; c=relaxed/simple;
	bh=ffFTjWUwjKJk2wn3H8xQs7+Dr4egWeva9itiCSg0Pds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcUmFmtrw6rv5pEqTk5JyU9CDfJoI8BJCQxs+aSDYw3rsjD6wcfME0rPZPCEDwcD/iV6H9Od5ERe7YgOzJ5lXJi/yvURYFXzzlnRnFdfUBkpzUIaQgClHvQU5mrOgRd2DFiVIxY+U+gQxiQD60tJRO2IQjcUKKV8JoORywuLyRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com; spf=none smtp.mailfrom=osandov.com; dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b=b2Zd1xV1; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osandov.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b="b2Zd1xV1"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5dcc4076c13so3182208a12.0
        for <patches@lists.linux.dev>; Mon, 11 Mar 2024 13:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1710189816; x=1710794616; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSMbt8SBlxm6Ph+X2EK++FswYcdkJc9GASrRfqLnHIA=;
        b=b2Zd1xV1vJN1OmIy18kJdJC21R13+OLSJN+89uqJAoNzo/SBdvcKMSrXLGt4fIF0Nf
         8sRU7FjK1fLCJFNboSCer3M02OS+g16ff3WeDHM7jh5jQWRNqtpc08SyDzcHIvYEB2bn
         WKsnZbC0au2afHvq7e5dO/weR3sl5KunVKpO9bwUZ18yLEwfjgVhrInd9Z/4BUwq82of
         +G8jNrh4UHJT7Peo1ainu3FEBUsy7JEsqL2UwBS5nxt0qe8oJYORLJofKs3SEaSYI9mp
         B4RfCRh/8D/yhVTgp7Rf2FTu5DnWlm4cIcmk1IRu2bMtrGTnJPhEvc1eqVp/vI9/i8Rq
         EQ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710189816; x=1710794616;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZSMbt8SBlxm6Ph+X2EK++FswYcdkJc9GASrRfqLnHIA=;
        b=S+VoKrX6HTYiWzPn6ynBctK8fLKWkoOv2lRgIlETZVbj6MJ1CvtslNdiHSdlhEkoYj
         XrJHDm4A4tl+Zf5iMkdKdQOJfbVwXl7YAYknMIbOy0sGoy6llsXgPlEY2MDiNBCuo798
         daiO0LoqePccuOokN8fX/651gCkMUnT+SQUrvGpupPVjKaVpB+NTu/9GWp/RO5klbxya
         7rmqlv7JMFNxOGErzPL9YL+REb8xb7c5VvoI7dJzkPlor93MF8V8xAHRBhJecNm7Sj6t
         6IYNsvshS9lfO9Jpxy3g1HsFvMqhz4h/ZBeIPmh8yh4OE8GFn/CSsaTWjekkCaU+Yq5w
         8hwg==
X-Forwarded-Encrypted: i=1; AJvYcCUAEqcPqeQQ7keDN9mOsEvxT2jsTkCxiglWDPiy35oK5muuDp8hh7Hq/PWZonAyc7lgcqRm/SFN6mESJEsdr9Bcmz9CdC6pQw==
X-Gm-Message-State: AOJu0Ywp9CetILm7algLhzBSZI9Wek0mouT0VLlrymK0id0Yg3Qv+B18
	b8xQ5jnZaVDwDlEtWCjnRyiLII58LyBgPLPiv9P3wATh03WFX/lcMBlToBbwbXwsFA65hmDtLGE
	C
X-Google-Smtp-Source: AGHT+IFI8S0cvDkzKsHH2FpOY4kyymcvH6/OLB/ZeoDIQrcOe7DhSL5TWGwsYWqI/wA3KH+4d8tiyA==
X-Received: by 2002:a17:90b:124b:b0:29b:a1de:32d9 with SMTP id gx11-20020a17090b124b00b0029ba1de32d9mr10720065pjb.18.1710189816372;
        Mon, 11 Mar 2024 13:43:36 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::7:5177])
        by smtp.gmail.com with ESMTPSA id cv8-20020a17090afd0800b0029bcf62e296sm4100584pjb.42.2024.03.11.13.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 13:43:36 -0700 (PDT)
Date: Mon, 11 Mar 2024 13:43:34 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH for 5.10-stable] x86/paravirt: Fix build due to
 __text_gen_insn() backport
Message-ID: <Ze9s9vIC9S-40kRO@telecaster>
References: <20240227131558.694096204@linuxfoundation.org>
 <20240227131601.488092151@linuxfoundation.org>
 <ZeYXvd1-rVkPGvvW@telecaster>
 <20240305112711.GAZecBj5TMaQDSz6Ym@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305112711.GAZecBj5TMaQDSz6Ym@fat_crate.local>

On Tue, Mar 05, 2024 at 12:27:11PM +0100, Borislav Petkov wrote:
> On Mon, Mar 04, 2024 at 10:49:33AM -0800, Omar Sandoval wrote:
> > v5.10.211 is failing to build with the attached .config with the
> > following error:
> 
> Ok, let's try this:
> 
> ---
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> The Link tag has all the details but basically due to missing upstream
> commits, the header which contains __text_gen_insn() is not in the
> includes in paravirt.c, leading to:
> 
>   arch/x86/kernel/paravirt.c: In function 'paravirt_patch_call':
>   arch/x86/kernel/paravirt.c:65:9: error: implicit declaration of function '__text_gen_insn' \
>   [-Werror=implicit-function-declaration]
>    65 |         __text_gen_insn(insn_buff, CALL_INSN_OPCODE,
>       |         ^~~~~~~~~~~~~~~
> 
> Add the missing include.
> 
> Reported-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Link: https://lore.kernel.org/r/ZeYXvd1-rVkPGvvW@telecaster
> ---
>  arch/x86/kernel/paravirt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index 5bea8d93883a..f0e4ad8595ca 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -31,6 +31,7 @@
>  #include <asm/special_insns.h>
>  #include <asm/tlb.h>
>  #include <asm/io_bitmap.h>
> +#include <asm/text-patching.h>
>  
>  /*
>   * nop stub, which must not clobber anything *including the stack* to
> -- 
> 2.43.0
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

Tested-by: Omar Sandoval <osandov@osandov.com>

Thanks!
