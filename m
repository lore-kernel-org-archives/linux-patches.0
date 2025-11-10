Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A46305064
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 10:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762771856; cv=none; b=pClJTqnyifGrzVewTarABWVq9f/kEbscNaBDxpFTTdbefb1XtIjozE51+N1Z7PNTrgtD5+4GdL8Z+ZZxFKkvNMIv4NVU7wkWB9Oen7NgQnRmYe3NMNO2c3OUW1UxX25UClVJHpmf9nJpzNtULxm8NMRllowGDeFVsvdqjoZrm+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762771856; c=relaxed/simple;
	bh=QuvzLQvjJhrJPEv2EiWNZ0BlmMA56gk0ZaiE4mu3nUw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dniiZOloXUS0j3Hj5cjfkOzzFuKsSXr2YJytB9Zo6jMXlXMIbF1CJ7BQ2MYVIT94+HH13gRmr7K/FpI2bRN1GRiTu/aBMhtggO3AnlWfFTQdcswS3Lwu/hF/4tszY6uy/3webv067W7ipkgv9y89rA+21s7avlaYMMxI3XeneJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CkPvBe9c; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CkPvBe9c"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b71043a0e4fso267166666b.2
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 02:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762771852; x=1763376652; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jAehjyaMCP4/3fDkR7/7In2PF2fJ4VvVwolrpLltF9s=;
        b=CkPvBe9ckNZgDGWxTMkg8fA83ydbhvwRcUXJWl/+jhiZL/zCGIqvCyCG7jGCtyMqDo
         TNL6z9GtAHZB0/vpnabWX8C9lrD9kCWTc7/kwH0AdztQ3jXoCuNf+AxdqpEXn3RN7FOW
         WS1/4SvVs/+2WqmcAkQKB+gjYVYJ7Lmz+Q1dCAOmVJuyKo0+97kd3D6A8bFohRnTklyl
         cqNTZuZLFwKTvKdhFYNmqTUrzEiMYhW45n6c8LKcb8mlLZJjmnuXroV/BD0yZuF/bOxG
         WAf5Xy9ZG14hIPpvOHNHQ3Y/lFC3FpMS2eQn5aPY48TWiCDSVO8HUE2MrUJDudVGYKNa
         J7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762771852; x=1763376652;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jAehjyaMCP4/3fDkR7/7In2PF2fJ4VvVwolrpLltF9s=;
        b=enHjFoeC3Kw14vY0QdvYAuoABfVQBrd+7eG1Efp2sb9GHRxcM0VnhCavuofV3HAPkC
         B6op9OUr7sX0pbv5YC+WZyQXQs1q1hNAL+AqotIeAt2IS3GddjUB2mNVwHiXz0s7hxzN
         MDGV8Xas9SXfIWYcyXoPoj1ivUE/y/cj89Yw3MMxwzPZzHYBYjPMRZNiaAHj+VXI/ogv
         rjoL3emg4FhKwc9/H8Uxiezf+9INvO37n2UZfeJdLzVSGOIKL1wFi72dnJACxXys7+jZ
         mwl+ysheFcJ53AJY2aRvEHr9TNh4Rhp+Wwdt1uvDSsDcoxUKPxsqP78P1d2Z5LDPp+ai
         Nw8g==
X-Forwarded-Encrypted: i=1; AJvYcCV2NM6FPZLOzlNdBf2VfbtYVrOhhbRb33QbmGpygWr2l/xn0AjLDrkolCUnlCP83KSq6UHg0/6q@lists.linux.dev
X-Gm-Message-State: AOJu0Yyh5MEAxNcvI9EAlXs8wVOhg12Gj5UMKK2UTd688hjnMEerbQSN
	a47zK2XmXy+qvdEQw+OyB63BgOTL2StHH6F44wZD/NjllYDD0DqIw4DFdB7xKUbTGkgrM5i16fX
	FDS0F/818sUGknMAX9A==
X-Google-Smtp-Source: AGHT+IHAxf8vIQMyFMTQjQQEpwFvS82i11CDs38Q8zhN6iIl6WZ7bHyAX4vTa1PqPqK6uf3c9yj3YRaeI9ccAqo=
X-Received: from ejctl15.prod.google.com ([2002:a17:907:c30f:b0:b71:a2e3:37b8])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1c03:b0:b72:9c81:48ab with SMTP id a640c23a62f3a-b72e050415bmr723371966b.59.1762771851712;
 Mon, 10 Nov 2025 02:50:51 -0800 (PST)
Date: Mon, 10 Nov 2025 10:50:51 +0000
In-Reply-To: <20251110095025.1475896-8-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-8-ojeda@kernel.org>
Message-ID: <aRHDi9phG8iz14SO@google.com>
Subject: Re: [PATCH 07/18] rust: proc-macro2: remove `unicode_ident` dependency
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, Nov 10, 2025 at 10:50:12AM +0100, Miguel Ojeda wrote:
> The `proc-macro2` crate depends on the `unicode-ident` crate to determine
> whether characters have the XID_Start or XID_Continue properties according
> to Unicode Standard Annex #31.
> 
> However, we only need ASCII identifiers in the kernel, thus we can
> simplify the check and remove completely that dependency.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Verified that these match exactly for ascii characters.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
