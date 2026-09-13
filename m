Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5817B32143D
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789312180; cv=pass; b=ZJrcaG+iH9eWBtaEo5kAgXJFqE2B0RrjvVN8JP4YPSTQ6+F1CWoN1nxXzC6nzj2uxtCeFXwCMkYF/0Gt0WaFYVyaATeff7qeOLoZrPli4r4xNOAWiin71m990QRbuZdwsAJUlob+PKsYuJ6QiiO+Z9DjFjp2lm5EtUR7qlEVJXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789312180; c=relaxed/simple;
	bh=6mFuurljPX4icUeSSuxhnmYjx7ggtb2P7Q8jZv2FjKI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VAtAsXeFAEumj2xhgUZFiGUEOSjuOHD1HMcsUWvYIjUYPq8gCb9kDiiLKAsIP49YHP3lFm/VnX6wNmMkNnhnYRMNbQEm+Tofq8XiaBaT9Kqj5x0nhGisSSK1scEeuNULDgubwf5WgvbVPMS9i1UUuUcwdo8sXQTWzga+zGjp8IU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aMrE8Njl; arc=pass smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aMrE8Njl"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-399026951a2so349151a91.2
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 08:09:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789312177; cv=none;
        d=google.com; s=arc-20260327;
        b=ksQIPUd4R86g9du94I+7qk8lpBAE0OY4N4dMn0mbGsyOPLFb39O20c3XgOdhYVwlA4
         3HUszNp23exZCFZslRxwq66Bb4chYo0yuOyNqpF8ztG196gQpxEePmm6OvXJu6XzOn8I
         adkwZcfpAWA6txR9FOO8YHUvOP+jTtdWMGqhi3xEeuevHJmiEbPPjAQTi4AfWSdn2Xp6
         EyfI0k+euMcl8axQnJC7LJt97PRbiijBIOAUKSehhg50BtFQT1aJUDYbifbTFjVGHi0p
         5y85pTuMYXEc371k3ghZlkM2LERPLgvpUjsEuoWUotH9X/7st9H/LcZScAxdskq3UaEc
         TSpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MHdelo62IoLAZ62QrJnv/AKdJJRSQm0JYdG8GL2JCRQ=;
        fh=93GRF9r4TT7wwFxFqC/RmxX2lA8qGBS3C1AVYMJwPoE=;
        b=DJ7XFkuWLLeoB6/svRRnzW23CF/4OdSBXkDCxoLwjSEWeT25lJiKYJeZHNnm3jDQjo
         GEwkE0w4z8zu9PwcfnB3k4pQLIMyOJAm15shArdpABRhtZetqhAk5/ZDGz9cPE69o7N1
         FayriIT8SubUNwsGcutOaLF/1CBjinbjiKiEMJYBtRYlWs946AlxauCRB2B4LRrOxdHu
         bwQuhKOFl37tX44sY4re9E2Jj5Upob8PXVOrYcf3bORuV/eIRVpVhO7CLE6hqCZbBZrw
         wlYHuajwhxGHqrW0UTTbGZ50V+JqWEDjnWH0KDBcfT31aNA01+fsQmeWVcKGuFE1tRO3
         sBug==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789312177; x=1789916977; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MHdelo62IoLAZ62QrJnv/AKdJJRSQm0JYdG8GL2JCRQ=;
        b=aMrE8NjlQOT3OyOPrq9r87coKC8SVkpF5OpTsAeOvbHbhg+WR08jgI6Vnsgx6joPoc
         pHk0pW10FyLkChRQwSoa3TMQPajNWvbidCl9MWGXNgIwYiQWGmi/EpUB7tM8WpIYG1CB
         DHdbqadIF1RvdpXXyL4f1a9aGGE42ehQrQgeyhSP1fzZ4/mcq3S84Pq0y/Bq/hYV6+JS
         CL5cnLgYB/yGJGMk5c32wP7WLIDv52jl758nnA2Ah8v7854A+juaF5EeT4ykfY/iJ5EW
         icmRxOFC6QyeGeWAFQrRdbtVS0JS0zLZcBak3NslHNC0tu9JeKtCesaKtIThfML12b6J
         1X7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789312177; x=1789916977;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MHdelo62IoLAZ62QrJnv/AKdJJRSQm0JYdG8GL2JCRQ=;
        b=GVC7exw2MIwGCXhuD9M55BLRg4gUqlVQdioltgcUCMCJJvHGxLwQGbo8bFlhsJguxZ
         yekcPb4pLiI6dvB/G4aapKIQ0ZMMLvtea6/GCvFI4ioRcVM/6cAPTQ5hsxnoR3Mvci4i
         atsjxnyESRfhig3umLn/AQ7m+eMgX8Csnt7OoQqWmglaB1tGSF3UMEP5ED47Lpfljlaf
         L6gjAY8FQbVmKznx1KEtQNU7lywaRIbk+p87K9bRcgkh0PtOotHdrLLQylNzuzegd5Z/
         5sCkG2Z5ID83Ig7aiRLcXlIwAytpUjJlU/9zTQ1Dy7uKJEwjsB14e6wCzFegF+sP2OrY
         EFMw==
X-Forwarded-Encrypted: i=1; AKwUvBwfJP+i73n7hQA3bIyni5xoGj/LO42i/xBhg0j5S9X4CdCSGMPifupH8RVaBRRK0vxGteICLmwF@lists.linux.dev
X-Gm-Message-State: AFuF++mrzsK+Ap5nsDp24JCK46UPj2o7ufyGQclI2zvTo449wpkLP+6s
	lGkjE5fGF3QJ1FJglsmig1nT0mjK+7E03u1lT1fMQw3vw9vIIdDAsAhajQJj1dZ6CkzfWfPAmhW
	b8LmTzVJgoU99DuVKLimONfGHYdGv3sQ=
X-Gm-Gg: AYBFou1JBuSxDJguG3QfVJwls9HVhITg4B5UUtyur1SphqI5ctAPfHp1JvoTEUAxByD
	MO9Zp1QoOf5JdD6Zr3+jZvRIkbCqWvsbjLakAppfnH5jQkIG10uAzO8WNZUF1SWUUIO8TE23rwB
	7uXZonRo44B5rBPnJGyo6DWJk2tSxuUNztMM6+K18ONxMa8E6B542Ujz/8z4lnhxOWhsYwHVBWK
	pJlFBQqS1OlOQGlX/FDBS98IeLbLfP4zBj4UOCvHRwAiVujRXrjvZU4Ps3srnozXEx3NINlWlzw
	EVgX/apqC6rVRhs36FmByt81UiZiRUMDXgiQrd9mCbMCKglgHXNvasnchtMEUrlInuheckC2ZuY
	SYGeqVU21cJ0TSLta/5oD7JfBN4RizXHBnzEvILgm0/Un51PiU/d+2t2VEM5jKTKWPuM4/ivr5l
	uRmD4LvnTZMGe2SPXw59jjzuajx0Z6+fK3gymgEqs4ftaWcM6QX1s=
X-Received: by 2002:a17:90b:5605:b0:390:3936:8760 with SMTP id
 98e67ed59e1d1-39d9b99eb0bmr13862044a91.0.1789312176607; Sun, 13 Sep 2026
 08:09:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260912065516.948645775@linuxfoundation.org> <20260912065531.127040984@linuxfoundation.org>
In-Reply-To: <20260912065531.127040984@linuxfoundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 13 Sep 2026 17:09:23 +0200
X-Gm-Features: AcwNN1W7V8fpp-JOiHk7mjvYf6ZP2l5Wo-7SLaXie7gHW4e_0T_-vGqsRI72fQo
Message-ID: <CANiq72m7L0E7kjJA8hS2mzJSCV6CeFNc_+8jtre0hD953js3jQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 611/798] scripts/tags.sh: Prevent binary files
 appearing in cscope.files
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Sergei Litvin <litvindev@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nicolas Schier <n.schier@fritz.com>, Nicolas Schier <nsc@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 9:59=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Sergei Litvin <litvindev@gmail.com>
>
> [ Upstream commit a9b93c34625a27bed5dc0f80ee2a359ceb955172 ]
>
> When executing the command `make COMPILED_SOURCE=3D1 cscope`, the resulti=
ng
> `cscope.files` file contains filenames with the extensions *.rlib, *.rmet=
a,
> and *.so.
>
> To fix this, modify the regular expression in the `all_compiled_sources()=
`
> function so that only files with the extensions *.h, *.c, *.S, and *.rs a=
re
> accepted.
>
> The issue has been introduced by commit 4f491bb6ea2a ("scripts/tags.sh:
> collect compiled source precisely") which implemented the parsing of
> compiled sources from *.cmd files instead of using the "find" command.
>
> Fixes: 4f491bb6ea2a ("scripts/tags.sh: collect compiled source precisely"=
)
> Signed-off-by: Sergei Litvin <litvindev@gmail.com>
> Acked-by: Miguel Ojeda <ojeda@kernel.org>
> Tested-by: Nicolas Schier <n.schier@fritz.com>
> Reviewed-by: Nicolas Schier <n.schier@fritz.com>
> Link: https://patch.msgid.link/20260714083331.69482-1-litvindev@gmail.com
> [nsc: cleaned-up commit message line breaks and removed cc trailers]
> Signed-off-by: Nicolas Schier <nsc@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Before 6.1 there was no Rust, so in principle this may not be needed
(at least for the `*.rlib`, `*.rmeta` and the Rust `*.so`s from proc
macros), but it shouldn't hurt.

Cheers,
Miguel
