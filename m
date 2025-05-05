Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95CA1F5617
	for <patches@lists.linux.dev>; Mon,  5 May 2025 09:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746437038; cv=none; b=eBKeQ50b3g/pDsiSUTQwmC9vBq9eyxKNdU9uD/hmlIeCjPNneS0Eh1m7JOn/zlCOXLRgjV0PFZcjB2fOl7/FtcFhbAzq1mb42RXpwR/yRYNIZOYhfgRUMU6m715/YhbDAPQX195/B/jxsurijG6pbdjweLEuE/IcOC722R/P1qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746437038; c=relaxed/simple;
	bh=2xxpj+2ReE48KbP5KJ11PgdY9Ly28L5Z4eGb6xFarec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ac6cuu6qswRAA/6U5B+JDuMnjjPGVYBERov0k/KW8ajolzZh2jkM+tBtzZzAlpu/nn7kSRItvilACpQ2jz2bobLIprTbdCcoScqDas2nZ91qHcbve2Dap9VX3X2KhdqlvcUpyu06IZa07Fq6ctr1TnJH1ZfgKTZ6MMh7dxcDHKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b32T+7Ba; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b32T+7Ba"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cf44b66f7so22863685e9.1
        for <patches@lists.linux.dev>; Mon, 05 May 2025 02:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746437035; x=1747041835; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UNKpSETC3aRoWs26slbmPYaRhZWnx/HOj+OMKwfNopA=;
        b=b32T+7Bayv5RmebM4WPJf4wgMhuK9reo4nmYvLViaddj8d0bBvXWFjNgbPiAyuWfyv
         JhyqEdrZ3WmjU+MHlSEymlDQIc0ed3xkj4ypvrv2xzigI0gz9F9lUvUQrpKypu1aGlWW
         3SCRtHjmy6IKYseT5LfRYdtAp760U5SSG0zNkrCDWP5joEg+BHMyUuFHL27UhuvHlobP
         W4nI42fTUJdgp4lifXyMFCThX8686e7eBc9HAljKFINTIN5bbDCGXo9LIFF6wIcivciU
         CSgS0wsInkL4FwVb0Wk3kSM4A4T++OBz2KD5VEKVEd4XJjT48ZvrWln0Cjh/kY9LmFaU
         L3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746437035; x=1747041835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UNKpSETC3aRoWs26slbmPYaRhZWnx/HOj+OMKwfNopA=;
        b=HEX5xY/LYXsL70/7+ETwgTsOLH29WZvyvzY0vsXiZUap/gLAYWTx/cyYTDVWQUG1eA
         zDxJ83m0bfV+z2vnFc4f1jU4wZ9N6QZ83cWpEahJwGRWECQdjeRibHyh3It4wMh8MgDt
         adFdFWwT3ZO4st9BAyoTlGMQDr9MSGLpA/DPtuqogXpxZrrnL+VBZYmailaD86H1MWcD
         zgsN/rarVMBgG4t+wQ71TshKmQZAnIponSJBtKcukbTjB5c5AckXSRCnLCE83sp2jYDX
         hNKQxEDZ+Fn0HC3NcIC4ZxY/3bkSGRMxITIhvfP2ogggYEKajoYILIDHBxSZjdAjxE89
         LhKA==
X-Forwarded-Encrypted: i=1; AJvYcCVwAyPunGsWlNgt+++NncW+MFsw9icvF6d81r1xeN4YS9xcyrKcFMoz8ECpolj3H1dqQeVRSeMR@lists.linux.dev
X-Gm-Message-State: AOJu0YxLGP2m0oP8e5JewlKmGeQl/wvRXqI6aNbfrWpsbdpBNywkHW5x
	lY2K6rCDI0bwblpRtfHGjXNhK+JVVjjffMCP60HRSSgXDIDVJ5eGlQfcM5LrAP+k2AZKAgMtaE6
	IOclfwoQuW9o56w==
X-Google-Smtp-Source: AGHT+IHD25Gl0hnIcuOchqaJj6jrQJy3Tcy1tSunT6kxPFMJLsXGIsx+DEdSlsV661NRNl3V8hAe7ZryPPG14R4=
X-Received: from wmbhh12.prod.google.com ([2002:a05:600c:530c:b0:441:b3fe:b95a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3548:b0:43c:e7ae:4bcf with SMTP id 5b1f17b1804b1-441c1c70782mr68477705e9.0.1746437035142;
 Mon, 05 May 2025 02:23:55 -0700 (PDT)
Date: Mon, 5 May 2025 09:23:53 +0000
In-Reply-To: <20250502140237.1659624-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250502140237.1659624-1-ojeda@kernel.org>
Message-ID: <aBiDqQxAzTC4N-n-@google.com>
Subject: Re: [PATCH 0/5] Rust beta (1.87) and nightly (1.88) lint cleanups
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Fri, May 02, 2025 at 04:02:32PM +0200, Miguel Ojeda wrote:
> Now that Rust 1.87.0 is close to release, clean up the new lints that appeared.
> 
> It may be that one of the patches is not needed by the time it releases, but
> I prefer to not wait much longer since I would like to land this for -rc6 so
> that it is clean for release.
> 
> In addition, clean some nightly (1.88.0) ones too.
> 
> Miguel Ojeda (5):
>   objtool/rust: add one more `noreturn` Rust function for Rust 1.87.0
>   rust: clean Rust 1.87.0's `clippy::ptr_eq` lints
>   rust: clean Rust 1.88.0's `unnecessary_transmutes` lint
>   rust: clean Rust 1.88.0's warning about `clippy::disallowed_macros`
>     configuration
>   rust: clean Rust 1.88.0's `clippy::uninlined_format_args` lint

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
