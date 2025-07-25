Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9696246BB9
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 12:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753446047; cv=none; b=Tkn+ER1ZbKX3/5aTvc5tp04uJ5nAcc2hUOzEqA4vbdGMSKcysGmRfrImxL2bwqkYUWSOzN45YSFMtLpkCMQfWBWoQjujS8xZwO57ywn7Elr24Xe0nfGIQEbQBzTAfsKzt2zg8d6L0asMfOCwXcurVkZjAo386sab+HFwvPgODzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753446047; c=relaxed/simple;
	bh=1Cp7zc6lqPvU29V2fbv1NcFYqTlUMGp8N+HlDjlY+jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iRtPlAnSj1gaUIpdNIMSbnIc/vfYTJzKEvd3qxGMJrjEunGZF4zbZGsmkzzgoPqzeXT+O9NI6gVzTnSoLuO1VAmINBAdJU/9Ly2L9BcPW+E8I9PfT1VyN24Np1d4FzAS/16+dRo5hkbshoi9VqeKEmA6qBHtieo0CVGHGHOefKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KjluHGpC; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KjluHGpC"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-451d3f72391so20692065e9.3
        for <patches@lists.linux.dev>; Fri, 25 Jul 2025 05:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753446043; x=1754050843; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VA1aVk5ATgGwWP5YvZwY73Pqu6/2aciSmLuZYBAcU5o=;
        b=KjluHGpCHxPFY38JHSP3SCwm/aOfhm/eXHQE4Dg9vrAKhavQ0g1vATxov8N971DlId
         2Ii2xbEu4QtFK1gsMwoVE59pLTURaovwPKgNZPsRSLN9ITYADNKRcTYFvgLwlcPVR6A7
         B9RNgLl/1YS1vKfMmgoW+xN87rX3S2rYKL6N+MX5lol9HXKI5OJiHVopBO+dfA5tiUfP
         Jh0HqhxDpm5shXGzVMBY1yuSFzLltV3ny9NkWIM35V+hkt4xlQO6lzN7QuENgrugJ3jO
         O9RG2MxOfbUV2toZ5WKAREjVAGlcFQOLcWwxU5iXp/8W2xIF0pr4kDoJIRZ4/QFDmmNG
         MZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753446043; x=1754050843;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VA1aVk5ATgGwWP5YvZwY73Pqu6/2aciSmLuZYBAcU5o=;
        b=MajCCpebpj9TiOWqPrUwDSJG+Oac/jKZagt9Ym7zWm2HWARXimg7zIRcFaffGBA3oi
         2tqRRunlU7o2gBkhty6zbccywT7c8HLfnsEw8OFGrWy+WTt9N0vMbRV2o2Y7WO5N28Tl
         uGXd2D5a6N5WXTXRImxBXJ/05o1VrMriDu46z0xy5zFMIusVEKw2xLiC6mKvD+tdXiUL
         V+59MNHTHs+fF1E3pLHPilD/UDOykTKHNekglu82zcLg1A3iP2aY+WSVe0iRa5dPsq8i
         wyZpTa7XRUGwdrTP0Elr8jD4xm35wgUigncyZM5sw+tqyXWbTB2AqIsAdVneqHX4gkPf
         E6Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWFMzbmz60Yd6QoXOaqc18EzmjE/TXquVRf03dYQfhA6nLbdzu22bnEVrgWdOAyBR2YCDyxspPu@lists.linux.dev
X-Gm-Message-State: AOJu0YyEdRuh5/ed9LC5N6XUdVkQRZEFde8sPaEK9vYxRhmwp8zMcUhW
	FFkeq+PPKiTHdf4vUsIJ+769B7UyeezpJXANeZ9plFdbZmh4169Y1ECu
X-Gm-Gg: ASbGncuz1X+k2wuBlm0wChKaAEav2DnGMVV4mVoLYMXnYvO+CV318m2JAyNdFRB9nCu
	K1mG1GBYgXUQ9hYfjpEQD01miz1dSu76RgpXVkh0LX1eMm7TkjFb9QSU30K8oVqzMIq0Zs2/sWY
	OLEy71YJk4O9TCbA0ZkiLD4JDvSdzt98STJPYAc6kCIK5FLdktUhiq/knMSOnomRiVD/p4gSmmU
	+FhXB+uuD3moEhjjF2RweTY9Fc0sQLUZFrxOUYnotfyQsFQgTdNyIemB45lcB1LARmj4DmbC/xk
	kgr2oorc2dCJJEm2VYnyVZmLq+MICouEkAbrHHRC6daizwb9llo8RYxK4nw8VJLZ9imibCanmDl
	BRhwqH0nFQH34fcUcwnqbfH+ytzgkOL+jc+E=
X-Google-Smtp-Source: AGHT+IHSdaknPrqijioY9HDWLiOWQTIycCby2q675AueD5MlPYeEPC0uzrUjYIL3oulhKhqiN6JSTw==
X-Received: by 2002:a05:600c:8b11:b0:456:1d34:97a with SMTP id 5b1f17b1804b1-4587631561fmr18307095e9.9.1753446042665;
        Fri, 25 Jul 2025 05:20:42 -0700 (PDT)
Received: from ?IPV6:2001:871:22a:3587::1ad1? ([2001:871:22a:3587::1ad1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054f686sm51705225e9.14.2025.07.25.05.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 05:20:42 -0700 (PDT)
Message-ID: <5b2951af-517b-4d5c-887f-417f486fd9a2@gmail.com>
Date: Fri, 25 Jul 2025 14:20:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drm: nova-drm: fix 32-bit arm build
To: Miguel Ojeda <ojeda@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Alex Gaynor <alex.gaynor@gmail.com>
Cc: nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20250724165441.2105632-1-ojeda@kernel.org>
Content-Language: en-US, de-DE
From: Christian Schrefl <chrisi.schrefl@gmail.com>
In-Reply-To: <20250724165441.2105632-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Miguel,

On 24.07.25 6:54 PM, Miguel Ojeda wrote:
> In 32-bit arm, the build fails with:
> 
>     error[E0308]: mismatched types
>       --> drivers/gpu/drm/nova/file.rs:42:28
>        |
>     42 |         getparam.set_value(value);
>        |                  --------- ^^^^^ expected `u64`, found `u32`
>        |                  |
>        |                  arguments to this method are incorrect
>        |
>     note: method defined here
>       --> drivers/gpu/drm/nova/uapi.rs:29:12
>        |
>     29 |     pub fn set_value(&self, v: u64) {
>        |            ^^^^^^^^^        ------
>     help: you can convert a `u32` to a `u64`
>        |
>     42 |         getparam.set_value(value.into());
>        |                                 +++++++
> 
> The reason is that `Getparam::set_value` takes a `u64` (from the UAPI),
> but `pci::Device::resource_len()` returns a `resource_size_t`, which is a
> `phys_addr_t`, which may be 32- or 64-bit.
> 
> Thus add an `into()` call to support the 32-bit case, while allowing the
> Clippy lint that complains in the 64-bit case where the type is the same.
> 
> Fixes: cdeaeb9dd762 ("drm: nova-drm: add initial driver skeleton")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> As discussed, it may be best to have a newtype, or at least a function
> to perform this -- here it is the minimal fix nevertheless.

I agree we should at least have a specific conversion function, but for now:

Reviewed-by: Christian Schrefl <chrisi.schrefl@gmail.com>

Cheers Christian


