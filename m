Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A366168F
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 22:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707862746; cv=none; b=rwMHf5+IL0NEIiEwMZMtOS4sZYGTrH5W5oPhG4R0D/UUCNtN/pwh2+f1uXTUJVdUjAE8x/gIRRSoKsqMN7xwZ73Y3uw2Ry/WSC9cLdXpWtpNxtGu4hmg26TMP1p5FgJHy7SV+5qMnZlvaeDoVb1b1W6d46SvhF06bYnr4THUnBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707862746; c=relaxed/simple;
	bh=fupPzFq/mOzPQg49g5zT0ntfs9nXTHiAGCPpCwKSJQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CLKMXs0Ln3boVZAoOa4HqjdP9oBafdFtkdUNF6fTRTQe87URqHcWdcVk4YFTw4ZAh8+ib0BU6gzfxUue8j8jZXJyK004+MWQ68S2x3cgoGsDV5qAUMuTGu3/QjiMhHKmoHt2Ic5QVPl0eSFHW7+HHSRGvaT+dkXqutcH6SvkCwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mwzmgUZU; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mwzmgUZU"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3bd72353d9fso3599871b6e.3
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 14:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707862744; x=1708467544; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NEtsz3nbQBwXPKC2RpUXbyPnr0oHPliF/lmcdhUWxA0=;
        b=mwzmgUZUm7+AePCAZYKRLBpAzP6OMRfHLz1crjABzv8yTsUfACUmpRtQmMA1+w9Azt
         A1tdMXxeKYwFmKjxoJC+jfVKgY0At3KbRw8h6bx4vTokP6ZCG5AuAq7xxoA2enLw6TQK
         GGwiytCyFcfPh8naAGaAjd008SCM/LWy50pDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707862744; x=1708467544;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NEtsz3nbQBwXPKC2RpUXbyPnr0oHPliF/lmcdhUWxA0=;
        b=TZpEKM2kcNETLVNFrvrmFTF5W5KMKgeuJyYT3rh9d4U/g2nwxCwc8W3kyejT5hp8/k
         EoU8ztGP/NcJcfC/EqqVFqkkPINZ9APMmcjKqveYwVyuCA09KFQCCS5TfA8tjoOm7yjL
         2mKRKpgO2gysgSocEgzSkkKXqeXs7xrmcxPrQWNKRzBAQGwRad/I+lzx12uUWlDV0X9S
         ZIP68cwYHbzI3qCQQMRakK3JMS+dMLuJFrUxJZ1IwbZynY9EdXW5BDnVwaWqcaeRH+7x
         FbqTTrNj5bV1Jmg0/bgqC7h1XzvzJTOH9ZKaQ5cf3TQ/UW5NdO9MQn9l/UONHLGwEvsV
         H3hw==
X-Forwarded-Encrypted: i=1; AJvYcCU/ByQKgkyW6vQIBoMo7PEDid2pIc4ilFD5Y8eD/A0rlN0k88ymrf4el1Hjy8HvIECOb1lJ89tdrqlRSERoWk3+jSxG3eq1XA==
X-Gm-Message-State: AOJu0YyA4pQy3OvufpZjUYbpRd7EeGoJFOPd0iDOGG9hbf21Sn+4hKu2
	7N/QdqWPGMB8bijIepj/M9AUG6/hKoEICDsLPFL6vU568EpPIB+SAac/sX160Q==
X-Google-Smtp-Source: AGHT+IHTEQ8wwSveSYvl+t5iWH5jHvKp2JNEd3pVIZ53DZ3GINpiRg01YzM7bjG1Y+XAbeMm+x+wJg==
X-Received: by 2002:a05:6871:3a13:b0:21a:80cd:734a with SMTP id pu19-20020a0568713a1300b0021a80cd734amr874714oac.52.1707862743756;
        Tue, 13 Feb 2024 14:19:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVqeObbu+ItRZ+eJqf1kncpf5EJ3lH1k5WBhURpbH35pDNdgVhmgrUO67MPvRBOssCYpMpuZghAsI3gVHGWXQ4zr5EoG3JEt5HFIFo4MXQb4GLBfeW2Dv2KZ0v5EjBveV4M/WQpFaCz4yzmL+T4uwyZ86MetJ1r1AGxX1kRO6hoPoQRG11vhleH5xqUGld6pFZPXIGLUB1ZGyf2YJVkUL45tEUt82021f7fv6OGKR0LrZh5dLpaZQ/uCXbrNxGplqQbgaVf1wYD2j6RBG8myUgu97IRAqeuJpaSOneq4dc4fblBs6CE8zzvLMFec+AuCgM+CY+hPM0vF5opoCQPMAFIjCdgpVWJbETbd9cjuiq1Y6n0
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id ck25-20020a056a02091900b005d8b89bbf20sm2522310pgb.63.2024.02.13.14.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 14:19:03 -0800 (PST)
Date: Tue, 13 Feb 2024 14:19:02 -0800
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: masahiroy@kernel.org, nicolas@fjasle.eu, ndesaulniers@google.com,
	morbo@google.com, justinstitt@google.com, maskray@google.com,
	linux-kbuild@vger.kernel.org, bpf@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] kbuild: Fix changing ELF file type for output of
 gen_btf for big endian
Message-ID: <202402131418.3DB3FF7@keescook>
References: <20240212-fix-elf-type-btf-vmlinux-bin-o-big-endian-v2-1-22c0a6352069@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240212-fix-elf-type-btf-vmlinux-bin-o-big-endian-v2-1-22c0a6352069@kernel.org>

On Mon, Feb 12, 2024 at 07:05:10PM -0700, Nathan Chancellor wrote:
> Commit 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> changed the ELF type of .btf.vmlinux.bin.o to ET_REL via dd, which works
> fine for little endian platforms:
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
> Fix this by updating the entire 16-bit e_type field rather than just a
> single byte, so that everything works correctly for all platforms and
> linkers.
> 
>    00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF............|
>   -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
>   +00000010  00 01 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |................|
> 
>   Type:                              REL (Relocatable file)
> 
> While in the area, update the comment to mention that binutils 2.35+
> matches LLD's behavior of rejecting an ET_EXEC input, which occurred
> after the comment was added.
> 
> Cc: stable@vger.kernel.org
> Fixes: 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> Link: https://github.com/llvm/llvm-project/pull/75643
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Writing the u16 looks fine to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
