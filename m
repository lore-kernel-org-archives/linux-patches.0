Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC7323D28D
	for <patches@lists.linux.dev>; Wed, 16 Apr 2025 11:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744803845; cv=none; b=E2IrD9jEFsRqv6RybiFu/GepbMWuiJC+1sDnby+q9QzXSEH1DAdkksvReVNC7JfhYBNfWDauBajOlHsL3bbZpsQ5tsfp8lk+fk/OEMWPk8eTUuiA/5nyTNx5svog7Gvf3frrdLUEHKTcNSI387pW7tPNflAkUdFnHN5nhUFXRRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744803845; c=relaxed/simple;
	bh=nzizKzo8Lxv6uOeq/gTFpe0rr/Kc7xMWsK4wkv91jbQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Uk+SXtzHDcAEsZOwqrM66jxCItTtwqXNXC3HJUyDB2+58sKRsRojvGBz7tm+gsLCoTUE+YY/39f4CQ5q4pLerYW+mWgSuL+J9KfDrzRO0Jmp0DRapv9IJkn9BLc8CrgtYzNzSPvT6WRu47RH+mUnEJkJa3WYM/uB6yI9l7pHniY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uI7/sJQ/; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uI7/sJQ/"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d22c304adso2797895e9.0
        for <patches@lists.linux.dev>; Wed, 16 Apr 2025 04:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744803842; x=1745408642; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IF1VZRpImns2dmxjUkl45LwCr5OCxkT/CnkwYELAXFU=;
        b=uI7/sJQ/tGJsDzouzxhvN6dTK9edY/r/IlTwZNePKeE9Qs6Z1bRl86T/hT+xrix3my
         eQEEAfJKHjrHPIFRUAXECC6Hv3obugMsZdYtrUU4dFTOgtOSxd/lera9tYvlnV2KHVz6
         NZ1/43iAOge6sOv5NKoLUpXxiBZwF1ycJl/3WgLnMkAIsljWKzQVZ/EcTO6E74Ybzg6Z
         6MM4wMPsXnSinmBKVxwxP+DBskQrT/Q8yPqG3A/R1ARCnPP1yTmgkYFx6X+2Q9fGz5dB
         wsYgQ3HysQagISnvLe2vDuq815sBsF0pIyEr+0KDPevdCXWM9F7FvgQ6nlpStAiTJC0u
         p7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744803842; x=1745408642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IF1VZRpImns2dmxjUkl45LwCr5OCxkT/CnkwYELAXFU=;
        b=NlM9vdjsWuoEsq87pVZngm3EfHDdJmaGr50usHK4nonenVaR5i/0ps+v2XSRHYdEWn
         V5iRCjcRc1BtJ0lBt1znaJlwXxNtf4MJgKgHwRFGb4zBHxiTfbkxwQtAg5l5HePlPEUo
         +QzGLPbaMtKEQpiNXx5b38CPONgnRP3KVE6gjqPHc8PVZRjsSz054EDBURp4oBtHUvsl
         KsaV3T0AztrsUoWT9T5xgU9dznJuxWOoyv2isF8HQO6NGZGWRsrxc0wKRmsKUtCQKjR8
         ooqYxWU1bxK7nTROL7g0EOAxDeB9TkJuDhpY27uSI5oEqDTyBgsfxJxs/i/Lru5bEbiZ
         m4lg==
X-Forwarded-Encrypted: i=1; AJvYcCVMamFy5/u/iTDu0QbQOag9xmGXwe3SyJWRzMQiBJLO2Rvd0GamBpdyY+3pRKfbWZdwMMfVNeB8@lists.linux.dev
X-Gm-Message-State: AOJu0YwAg1rJpQ6GFwta+MBUg0PtHKfyWIhXJG2xppSlyt5aX+GcvLu/
	HqX5rTYfCFwbK6RP1Pj/9A1B8WUooifVI+rY40Eg1n1M9y7muMoc+Bov3/FDQCHBEZZtn531d8e
	3+2fV8crCZDGatA==
X-Google-Smtp-Source: AGHT+IGALYmOGR2cfumjQH5um+KLKgozzVHSRwGqMvv0DTT4qMGdsYU4qv0QGpbxElwdAz9dDJW4vlVIoSCEgsg=
X-Received: from wmcn28.prod.google.com ([2002:a05:600c:c0dc:b0:43c:fcfd:1ce5])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5986:0:b0:39b:fa24:9523 with SMTP id ffacd0b85a97d-39ee5e9afedmr1224016f8f.7.1744803842192;
 Wed, 16 Apr 2025 04:44:02 -0700 (PDT)
Date: Wed, 16 Apr 2025 11:44:00 +0000
In-Reply-To: <20250416112454.2503872-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416112454.2503872-1-ojeda@kernel.org>
Message-ID: <Z_-YAAzQVT8g4IY0@google.com>
Subject: Re: [PATCH] docs: rust: explain that `///` vs. `//` applies to
 private items too
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="utf-8"

On Wed, Apr 16, 2025 at 01:24:54PM +0200, Miguel Ojeda wrote:
> Sometimes kernel developers use `//` for documenting private items,
> since those do not get rendered at the moment.
> 
> That is reasonable, but the intention behind `///` (and `//!`) vs. `//`
> is to convey the distinction between documentation and other kinds of
> comments, such as implementation details or TODOs.
> 
> It also increases consistency with the public items and thus e.g. allows
> to change visibility of an item with less changed involved.
> 
> It is not just useful for human readers, but also tooling. For instance,
> we may want to eventually generate documentation for private items
> (perhaps as a toggle in the HTML UI). On top of that, `rustdoc` lints
> as usual for those, too, so we may want to do it even if we do not use
> the result.
> 
> Thus document this explicitly.
> 
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Link: https://lore.kernel.org/rust-for-linux/CANiq72n_C7exSOMe5yf-7jKKnhSCv+a9QcD=OE2B_Q2UFBL3Xg@mail.gmail.com/
> Link: https://github.com/Rust-for-Linux/linux/issues/1157
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
