Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFA730149E
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 11:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762775047; cv=none; b=DL1djNVkKVg9GV3/1TAV28OJG6kRko7uZZqK15bNmlWwbZOSBlr+4ZgA+x7ESs2jFMvHTyL268Nw9O3QWeXdtctDhqHWIwiDUmuOJysoKT9k1+KhN4w4VNFNi8eq82jmlOxI/Yg5MXV33ZUBTWTXoJ94pN0RefYtR+aXszG7nnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762775047; c=relaxed/simple;
	bh=KHlEJ3ZcFOvOfciC05S5x0Xt1y97nhfIAVEf/vmkfg4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SHd3Od1qDPX55xI7Sc2LaCY5Ixkbz8r/Z+TRN9Ochm6HnIdiKpirjp1sTmWBJTwIAcLiiaPUf1HWaoaAHfFeUGS2Ugv3rMw5miAP5iQrIJqhdqYjXJpbZ17OOEOwbxgmVvv7VrB6gExoQV9SgWTI7EX0fxAfP2JB2hbV0CdlN14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CV3Ac/jG; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CV3Ac/jG"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-475e032d81bso16218295e9.3
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 03:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762775044; x=1763379844; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qjIkKq2mWwIfqO3bEG9TIc4WKN6b5GBEeKQWWDEpLnw=;
        b=CV3Ac/jG9dVUrO1lJihQl9JXgicyhNrYUaYei3E2TYPtUrX08fX4ZJG5WVWsOwOv8U
         fSmRlpx3k+8Nmk/TXujV//yy3TGfqU5JtRpYdA6VP/ePQq4WG2Mjo65xdQjz5vUp+uNV
         xOw0NEWM7AzsS0EIzRSFeOlbvlPhwOhvM2pAKsZOmSE490AibFyClVkPkgbvMkbMW+DY
         L+qiNv4t4V6dfBsjFFclu7RfyLe2ZOrU3wt6WJKZsNq3v484ECJ6smWx9ixpN14GHAEq
         X6o8dNyAnyy8PUw6k3skKGPB+OPsBp49Gc6mbafiQVYhZckwbt6Akq5n6UWAMKgMaicz
         b+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762775044; x=1763379844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qjIkKq2mWwIfqO3bEG9TIc4WKN6b5GBEeKQWWDEpLnw=;
        b=XRQit8PV8mg5qEP9mqtjHqjByXPsEUOQQoPy3LXnfIGUszTJH6sbMTyUA5I7jI/DiT
         89bKvWKaIWuXOFkqYrKoUvYEtpkEyM+4fsPrqxXv03IQ6JSo13NevO5yIVHOvWr9PEdn
         cKihE6ZsHVjCu3QxAzi8RAGpM49th5irI+ebcrGwOlytE5h1EGWN3OlDnsTHNKGc8dnF
         2iWohZNFVtm9oNLkNiL0iQ2FK7Uw+k0b78wrjjYll2yhEQvCjczow4h8oiSQCw1/SPpT
         r48aXs5aN6KExxyVc8pFAIjqSZOzFC+GzG5YyrCXt7ozY2qKZXuwvw/sdzrhqzXQE+Oh
         8seQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmJwMYrvcP8y5opVHEe11Uiu4pH5006XdNT06P43WjxBm7xuE/QIKcEJb3wvK/hsPRkcDMB0n7@lists.linux.dev
X-Gm-Message-State: AOJu0YwO/DMBY0+dneLvqt2DoTZW3gjY8zyRB3jAAAAfjT5UhI9ILdby
	xr/zCzrHZZgz44PSpv8TxhP+7eltdAp7zcu4+bsPCxjcgTr+8G+NctsJcIrVoZ/zk42xD1mvnL2
	9R8alNqAEBuLdTHiJ5g==
X-Google-Smtp-Source: AGHT+IGkuNbhhInDD1ZmUt1/NhCQQS/t6wQ2i+1z9bpocdva95THZTedwTKnj4SLT8o++qExerTsl+FlUO1zVo8=
X-Received: from wmom20.prod.google.com ([2002:a05:600c:4614:b0:477:77a8:8918])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f94:b0:477:639f:2ae3 with SMTP id 5b1f17b1804b1-47773288ba4mr64880965e9.40.1762775044443;
 Mon, 10 Nov 2025 03:44:04 -0800 (PST)
Date: Mon, 10 Nov 2025 11:44:03 +0000
In-Reply-To: <20251110095025.1475896-14-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-14-ojeda@kernel.org>
Message-ID: <aRHQA6FEoxACerIQ@google.com>
Subject: Re: [PATCH 13/18] rust: quote: enable support in kbuild
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

On Mon, Nov 10, 2025 at 10:50:18AM +0100, Miguel Ojeda wrote:
> With all the new files in place and ready from the new crate, enable
> the support for it in the build system.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

> diff --git a/rust/Makefile b/rust/Makefile
> index a614a23023cb..801a8cbf3bdd 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -199,8 +218,8 @@ rustdoc-clean: FORCE
>  quiet_cmd_rustc_test_library = $(RUSTC_OR_CLIPPY_QUIET) TL $<
>        cmd_rustc_test_library = \
>  	OBJTREE=$(abspath $(objtree)) \
> -	$(RUSTC_OR_CLIPPY) $(rust_common_flags) \
> -		@$(objtree)/include/generated/rustc_cfg $(rustc_target_flags) \
> +	$(RUSTC_OR_CLIPPY) $(filter-out $(skip_flags),$(rust_common_flags) $(rustc_target_flags)) \
> +		@$(objtree)/include/generated/rustc_cfg \
>  		--crate-type $(if $(rustc_test_library_proc),proc-macro,rlib) \
>  		--out-dir $(objtree)/$(obj)/test --cfg testlib \
>  		-L$(objtree)/$(obj)/test \

This change seems unrelated?

Alice
