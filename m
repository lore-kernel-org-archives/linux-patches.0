Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82E81684BE
	for <patches@lists.linux.dev>; Tue, 30 Jul 2024 20:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722371789; cv=none; b=GS5AOxaKRbq1S/GhURY9Mfwo9MrN+xcj09WxJKU6Dn5zArDZcFykhrwsZzAVQkfdknUXIwHQ/DyTEc3Gqo6qfyiVn26299W8VIddF/B+PbcMDgDZno4AOtKVAIpTuxXGfXI14Ou/SfXBY3XJosCC6Kr+Abm0BST6t5lA6SnOZeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722371789; c=relaxed/simple;
	bh=qdHVnfTVo3nO7tmMxskdGFwLlxMv/CAQsC4rHemx2xs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KW9TGHrm4iptkXD2fOVziohoH42y7PpOwvdzAqhi9Y8djpSoqHuuAFlNyDbegslPJEIbE02grmYCDGJVyYhiQpZML0KiipjNR4OZNOYy5zBC81TqtdqlDVJs8sRU9MpQ8WwONbXLwvXtVgCiUL++m7U9w5hio3mpexc+vvH0Wno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DC4xDKB/; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DC4xDKB/"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52efa16aad9so7518639e87.0
        for <patches@lists.linux.dev>; Tue, 30 Jul 2024 13:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722371786; x=1722976586; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4/XjNzJXCdNL6KqxYNrTp89XVp9cZX4iiagSBchs6TI=;
        b=DC4xDKB/9CaFATeOpFyR7qEJ8pOhBKq+4sEpYSA6hIpL/EHiGQ1VXZV8ufl6iltQca
         ae5ZfyoZlAt1CvIgc9qCjEm8ArUPCVPAt/HwjJYljBCbEYt/zoc92FA8J4173mX1wYld
         /8jnRK3qug3mVE38ybW/MThzjK0RO3uowCfFuYNhIcJWtAOd75Xlhu3OJTSKVYsbyTSV
         /i+2zC4mLWA4xVbDWqsNuxsbvX2rYxCTNHNTd4OUAnUWwtxwMMahYVZfAUXSOY6F02n0
         TMOKtjvJonzuPfLXATVcNLlGKklAmDu8JCgVPoaLOmDKnj8HPvnYfcEIhkgiUqw3xSW2
         etyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722371786; x=1722976586;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4/XjNzJXCdNL6KqxYNrTp89XVp9cZX4iiagSBchs6TI=;
        b=Z6oSv4Iv7/dArPwEpLEZm/cDGWraSZbGjBMt0u3qoTSsoFKUyK5tMXN0EzH/s6JWpS
         8G01udasGSeBmlX+e0TAgsDur+cAunbKCrKYTrNXgLGUQpnxSieEBZ+WO8s9avVTdvlM
         /U3MPIK6egg9yQo/6zkMKl3KZSjd69aeuAP9MQd9L+TB28it23KdRNyoi0Ib4bkj5CAA
         km8vtF77uFmH8+Zyd9k7sozTgf5mFQkqUr89Ep5gfszpq/5u5bjKMR34ZXN78axNvlgA
         g9WZgYuqBmGo1Z4HHMgxZJ+Q8kaMbO4t3+N6aTuHnWM7cnURqBurHGoNXyFInvGvqiXr
         8VUg==
X-Forwarded-Encrypted: i=1; AJvYcCW+G+3V9ZgTRiHChRRZwjPDHQ9nzavXV/sct4kEelPRRBtg+/PiMLD0ZRr/K5onEFnxRndaXx6g@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3/gvtJxkqXFKKGThTCFP0Kd8JOElbur67hp444r5Go6TrFwdS
	JRF7w0a3pHAIQWYb0zQh9M5/vb4gwGQW35gvDZ8cF6hdPk5nkwHp
X-Google-Smtp-Source: AGHT+IGjxqEwMyxNk7pArNZMq5rayC8VDXVdhCT5ysxA8xd9d9WxB01PKTakbhgRZbhikgwYVzY5YA==
X-Received: by 2002:a05:6512:340e:b0:530:aeea:27e1 with SMTP id 2adb3069b0e04-530aeea2b52mr407616e87.50.1722371785722;
        Tue, 30 Jul 2024 13:36:25 -0700 (PDT)
Received: from ?IPV6:2001:871:22a:50e2::1ad1? ([2001:871:22a:50e2::1ad1])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac64eb3ab8sm7769941a12.71.2024.07.30.13.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 13:36:25 -0700 (PDT)
Message-ID: <14053c9c-0318-4422-bfa4-739966f8e214@gmail.com>
Date: Tue, 30 Jul 2024 22:36:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] rust: error: allow `useless_conversion` for 32-bit builds
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho
 <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>,
 Russell King <linux@armlinux.org.uk>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl
 <aliceryhl@google.com>, Jamie Cunliffe <Jamie.Cunliffe@arm.com>,
 Sven Van Asbroeck <thesven73@gmail.com>,
 linux-arm-kernel@lists.infradead.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240730155702.1110144-1-ojeda@kernel.org>
Content-Language: en-US
From: Christian Schrefl <chrisi.schrefl@gmail.com>
In-Reply-To: <20240730155702.1110144-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30.07.24 5:57 PM, Miguel Ojeda wrote:
> For the new Rust support for 32-bit arm [1], Clippy warns:
> 
>     error: useless conversion to the same type: `i32`
>        --> rust/kernel/error.rs:139:36
>         |
>     139 |         unsafe { bindings::ERR_PTR(self.0.into()) as *mut _ }
>         |                                    ^^^^^^^^^^^^^ help: consider removing `.into()`: `self.0`
>         |
>         = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#useless_conversion
>         = note: `-D clippy::useless-conversion` implied by `-D warnings`
>         = help: to override `-D warnings` add `#[allow(clippy::useless_conversion)]`
> 
> The `self.0.into()` converts an `c_int` into `ERR_PTR`'s parameter
> which is a `c_long`. Thus, both types are `i32` in 32-bit. Therefore,
> allow it for those architectures.
> 
> Link: https://lore.kernel.org/rust-for-linux/2dbd1491-149d-443c-9802-75786a6a3b73@gmail.com/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/error.rs | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
> index 145f5c397009..6f1587a2524e 100644
> --- a/rust/kernel/error.rs
> +++ b/rust/kernel/error.rs
> @@ -135,8 +135,11 @@ pub(crate) fn to_blk_status(self) -> bindings::blk_status_t {
>      /// Returns the error encoded as a pointer.
>      #[allow(dead_code)]
>      pub(crate) fn to_ptr<T>(self) -> *mut T {
> +        #[cfg_attr(target_pointer_width = "32", allow(clippy::useless_conversion))]
>          // SAFETY: `self.0` is a valid error due to its invariant.
> -        unsafe { bindings::ERR_PTR(self.0.into()) as *mut _ }
> +        unsafe {
> +            bindings::ERR_PTR(self.0.into()) as *mut _
> +        }
>      }
>  
>      /// Returns a string representing the error, if one exists.
> 
> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
Seems good to me.

If I create another version of the arm support I'll include this there, otherwise:

Reviewd-by: Christian Schrefl <chrisi.schrefl@gmail.com>
