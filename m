Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C1017DFFD
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 06:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653716; cv=none; b=iUiBKrqWKV6FeH0nRy3aYfLo+B4KChefv7ItEWI2FxBgsHTGo7O4g5fUwg5042kh9JTES1zWI05DQgVaLUpLhIiW7c6Q1rgXM1m94s4HFOs79pL43T/1JhTyUnK6y9woPYwQiNyZITJ1mdGJhOFegy/ZvdQqzVMSM/FFVvKdMYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653716; c=relaxed/simple;
	bh=1CGr0TE3Wg5HzshzjEwit7oZPSSbwmr0PtGQ0w5NFAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=STNOcYkCvgW48jxxMWTeG/tDWOLozuCY+qCcrCg2wortosCRwJyQK9wQOPdCBUS68nTXN162xO8SUXcRZsXAndu+9F79RcnjA/jF+7hTYg+QU28WOPdUq/CPl3lBAF0K7TougeK1kZNR4w+vr7OEp3hUUbheAoVyfBELA61gtzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EDf4dWfb; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EDf4dWfb"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9ec267b879so69764266b.2
        for <patches@lists.linux.dev>; Thu, 14 Nov 2024 22:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731653713; x=1732258513; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OFl3zgdU+gV4a744BMJnAQAV9SIlx8LGcZai2Rux4bA=;
        b=EDf4dWfbN1TbASMOFnrG8cBH4KKZLaTddqRWKjyShhiAEFLbeGrmeuUIGbSALx3kpj
         T/A9yBAVK5gmho6NjYw8dTiHEHu+uF3fWsLi7irtZETxUvX4khlRLL/c3zNA6K29R8zW
         mohzfQ336Fn+eOc8z61aLkTYdEaFHQwQ8FCLGBnemhb1g4rzax85HX4mu/F6PXn3bxa0
         aEvZpedDnIQZ+liTCmPnQfEpNs4OAxhEkiD/3dxQcARf5MyllYfB1Mvb1QTnjI68XNKP
         lb0RBV2Gu1lVVD43iMQkH35kfnP1/g79GUDnsU+ftgYerzr7pBm8H3kj86134w+as2Zn
         n38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731653713; x=1732258513;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OFl3zgdU+gV4a744BMJnAQAV9SIlx8LGcZai2Rux4bA=;
        b=Av0wMdnY41pzeslkCmwUUaFRqB55gHDQKTV//dLf+cG4w+ynv6P8lnic8jIg4n/Lur
         PC3sMFVKlwuL2mq7Y3/rlGbxHwcQWr81soEugEQwJ9NZBwTkKIw7BQRnXDYKw76UL3IN
         ooLUHiiM0ww8qPIeZMVr1JZD20vStnSNcDFqkouvEFcmUt42jbcadFx28Sv8lwSKI4qR
         5+Tnz01F9lWiZlXKSz8IhGRgCFHfd5hfg5uC3m2GCRusMHhp+BbntbypC5/nhzXxD5O8
         J//tca4FETyrcaRq/qpod9IzqogE4N5J3koZSahjoS1Hh1LRP2mn2AKibHdGBgwm/O1Q
         VrYg==
X-Gm-Message-State: AOJu0Ywts/KlnWIHj0gekCFAyM1/5Rh15x2Y89ezO+X0S+tkeeUwTzr9
	HdMNeWLNT9IdJy1UYOGrS43A+dwNX4PHzMFCuKpO7MgnIzoxGu7iNRmLFriqcsU=
X-Google-Smtp-Source: AGHT+IHlujWuxxaiUuPJQSafn7dTcFby74LcLirC+yJyEdIFFzXahlURXC2FA5JkrzC9ma3wuNrbIQ==
X-Received: by 2002:a17:906:d54b:b0:a9a:4f78:b8 with SMTP id a640c23a62f3a-aa4833ec1b5mr97225266b.2.1731653712857;
        Thu, 14 Nov 2024 22:55:12 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:69? ([2a0b:e7c0:0:107::aaaa:69])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf79c1df6bsm1282524a12.83.2024.11.14.22.55.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 22:55:12 -0800 (PST)
Message-ID: <a01c8667-1de5-4f3e-b15d-cd765238a538@suse.com>
Date: Fri, 15 Nov 2024 07:55:11 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 25/63] kasan: Disable Software Tag-Based KASAN with
 GCC
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>,
 Mark Rutland <mark.rutland@arm.com>,
 syzbot+908886656a02769af987@syzkaller.appspotmail.com,
 Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20241115063725.892410236@linuxfoundation.org>
 <20241115063726.828422420@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jslaby@suse.com>
In-Reply-To: <20241115063726.828422420@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15. 11. 24, 7:37, Greg Kroah-Hartman wrote:
> 6.11-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Will Deacon <will@kernel.org>
> 
> [ Upstream commit 7aed6a2c51ffc97a126e0ea0c270fab7af97ae18 ]

But we have:
   894b00a3350c kasan: Fix Software Tag-Based KASAN with GCC
in 6.11.7.

This 7aed6a2c51f was reverted right after that 894b00a3350c by:
   237ab03e301d Revert "kasan: Disable Software Tag-Based KASAN with GCC"

IMO, drop and blacklist this patch.

> Syzbot reports a KASAN failure early during boot on arm64 when building
> with GCC 12.2.0 and using the Software Tag-Based KASAN mode:
> 
>    | BUG: KASAN: invalid-access in smp_build_mpidr_hash arch/arm64/kernel/setup.c:133 [inline]
>    | BUG: KASAN: invalid-access in setup_arch+0x984/0xd60 arch/arm64/kernel/setup.c:356
>    | Write of size 4 at addr 03ff800086867e00 by task swapper/0
>    | Pointer tag: [03], memory tag: [fe]
> 
> Initial triage indicates that the report is a false positive and a
> thorough investigation of the crash by Mark Rutland revealed the root
> cause to be a bug in GCC:
> 
>    > When GCC is passed `-fsanitize=hwaddress` or
>    > `-fsanitize=kernel-hwaddress` it ignores
>    > `__attribute__((no_sanitize_address))`, and instruments functions
>    > we require are not instrumented.
>    >
>    > [...]
>    >
>    > All versions [of GCC] I tried were broken, from 11.3.0 to 14.2.0
>    > inclusive.
>    >
>    > I think we have to disable KASAN_SW_TAGS with GCC until this is
>    > fixed
> 
> Disable Software Tag-Based KASAN when building with GCC by making
> CC_HAS_KASAN_SW_TAGS depend on !CC_IS_GCC.
> 
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Reported-by: syzbot+908886656a02769af987@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/000000000000f362e80620e27859@google.com
> Link: https://lore.kernel.org/r/ZvFGwKfoC4yVjN_X@J2N7QTR9R3
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=218854
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Link: https://lore.kernel.org/r/20241014161100.18034-1-will@kernel.org
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   lib/Kconfig.kasan | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
> index 98016e137b7f0..233ab20969242 100644
> --- a/lib/Kconfig.kasan
> +++ b/lib/Kconfig.kasan
> @@ -22,8 +22,11 @@ config ARCH_DISABLE_KASAN_INLINE
>   config CC_HAS_KASAN_GENERIC
>   	def_bool $(cc-option, -fsanitize=kernel-address)
>   
> +# GCC appears to ignore no_sanitize_address when -fsanitize=kernel-hwaddress
> +# is passed. See https://bugzilla.kernel.org/show_bug.cgi?id=218854 (and
> +# the linked LKML thread) for more details.
>   config CC_HAS_KASAN_SW_TAGS
> -	def_bool $(cc-option, -fsanitize=kernel-hwaddress)
> +	def_bool !CC_IS_GCC && $(cc-option, -fsanitize=kernel-hwaddress)
>   
>   # This option is only required for software KASAN modes.
>   # Old GCC versions do not have proper support for no_sanitize_address.
> @@ -98,7 +101,7 @@ config KASAN_SW_TAGS
>   	help
>   	  Enables Software Tag-Based KASAN.
>   
> -	  Requires GCC 11+ or Clang.
> +	  Requires Clang.
>   
>   	  Supported only on arm64 CPUs and relies on Top Byte Ignore.
>   


-- 
js
suse labs
