Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A5825D527
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 10:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762770820; cv=none; b=dlbVSQOreKfAMmIsVEMBW+33PHj+sO3PeQBIBWSyuKkd53xNVAN7tivi3SHbAgoljnaKqNs7Sh7bsEKVycYQ75dDANBA6T3p1Uo8nE+Rah6q319XqgUKRHv75zNDfqxvog5r0yadxtVJkZxV3sA34Erkiiw0FBJ7YivQl4vzDZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762770820; c=relaxed/simple;
	bh=GoL3gN4h5eYU7litgF4qiXRimx4qE9CB8i92qSY1F7w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i1P10yhxZoJOmEYKR8BTV5SS25vMyEl+nhMnxSuOQu8rWjQMR+AsXdGP3JK74Hi21zxCTyTGxcYd5kY53s8RpsTOwbXBwJdjbEQRZ6fBOdaK8c+sz7YgtVX2p1TGtKi0h1H2/OhXME+nmY7m76YSK1YrPP2Gg3dAw0/WhKQf104=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MyzWV7G+; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MyzWV7G+"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6411e349b73so4141320a12.2
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 02:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762770817; x=1763375617; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CCzpwObG7lLSpKChT0Fx+ByLzoerKxd9DaM7EmJ24AM=;
        b=MyzWV7G+GTZBDZlkaiRRVjK1krZjLv9tYjP96XMy/ukDjQ8tBo+J7rJ3mgH2m5Zr3k
         3a9KgdgJXXEhKg2fwrmiUFvsj29qFlNJ76wF7Zxcn7K2Nuq4qfWi64uLsWQLnuYpfFoJ
         cckgZd1ItU78jBGNaivfCl2iwugzPoqnmuLv5H03yaA1TbDqbO2hMmH4M8IX75eMWJ9O
         O+3lTIGxeW1LVU2eR/qFZjnqiGPXy2ZWS8vMTMMlNPkRcRJKjN6LEhbmNTLY+mbKJ2Al
         omjHE5g+gspyHMAlvIiQhHvAKoTTyfEl69nXHLpcxUp84Yqun8h1vKOv9p3wke2qM5q+
         HfsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762770817; x=1763375617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCzpwObG7lLSpKChT0Fx+ByLzoerKxd9DaM7EmJ24AM=;
        b=LTjrVLYD5AX2JY97cd9FXXLdlJQmkVXSUYxTDIAgOinhT87h4bdTHosVW0S7IBKNEt
         oXxruMyAYuXHvrBVilGioE22iB7hJe5tGdFdhd4SE3LhM4P50BeT5Gomw3PJTtTZjMI0
         P4j3lBM5NY+DrLL6E22753ox6/9v4mVZN0aCODySZnw2KZCR3J4lnC3UeXrJCMKZgBh6
         ZTsNfllr6eWIOL9bPZIbQZUPdNTRff0nKU7g1UKE9ejrsdCskHkJfjDDJYZRCWaqGi+s
         p6Alpg0mFhKQItfrKccDIc2yXZnqB0aZ29EbxyfQPScBGzM918SH6ZQQV3tpmd9aoD5z
         difA==
X-Forwarded-Encrypted: i=1; AJvYcCW8/mJE7d6dO5rO0ENWG6uI9Mdb4pEGQcc8clMT5+3rkilxL0h32zaoBi/uZk3K1u+3j5jk6N4m@lists.linux.dev
X-Gm-Message-State: AOJu0YyFu9MwRMkjyrjlHUd/K3QBsmncvaxsEZHditi/i5nSw0MsYa+c
	DbINgWyqlSqQpbwAAXKrXfaUiepnXR5s96Lw5areS2w22aLnJjWOUkrHNt2X3n4w5Bkr8P5rOz0
	U/W1ahGeJTC8Bixx7+w==
X-Google-Smtp-Source: AGHT+IGrQByfI9wokfMWFe7K1Ttk8ewEB37twW8Y2YwoEzQNcIfJcFh4xKKTJ6P4DH7/NHxDz4jf6iOvc30RilE=
X-Received: from ede25.prod.google.com ([2002:a05:6402:20d9:b0:641:3d6a:4b38])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:27d4:b0:640:9eb3:3673 with SMTP id 4fb4d7f45d1cf-6415dbfbd56mr5809440a12.4.1762770816828;
 Mon, 10 Nov 2025 02:33:36 -0800 (PST)
Date: Mon, 10 Nov 2025 10:33:36 +0000
In-Reply-To: <20251110095025.1475896-4-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-4-ojeda@kernel.org>
Message-ID: <aRG_gJu_yZeJWPuo@google.com>
Subject: Re: [PATCH 03/18] rust: kbuild: simplify `--cfg` handling
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

On Mon, Nov 10, 2025 at 10:50:08AM +0100, Miguel Ojeda wrote:
> We need to handle `cfg`s in both `rustc` and `rust-analyzer`, and in
> future commits some of those contain double quotes, which complicates
> things further.
> 
> Thus, instead of removing the `--cfg ` part in the rust-analyzer
> generation script, have the `*-cfgs` variables contain just the actual
> `cfg`, and use that to generate the actual flags in `*-flags`.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

For anyone else reviewing this, here is the relevant part of the
makefile that calls generate_rust_analyzer:

rust-analyzer:
	$(Q)MAKEFLAGS= $(srctree)/scripts/generate_rust_analyzer.py \
		--cfgs='core=$(core-cfgs)' $(core-edition) \
		$(realpath $(srctree)) $(realpath $(objtree)) \
		$(rustc_sysroot) $(RUST_LIB_SRC) $(if $(KBUILD_EXTMOD),$(srcroot)) \
		> rust-project.json
