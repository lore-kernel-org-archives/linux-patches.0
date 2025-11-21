Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D5D25FA2D
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 04:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763699879; cv=none; b=JyVAizhJXZ22NS+pryXwWWFj47vUEVVtxCH2EtQu2cwTRtpmwKkIqEYBLw6vXcxVSQbLhTp+erKer/IBLLhLQjZF4lEDp9Kg1x3SOIdOd1hXtfXAEh1g3uNcTfQxowDVE+TWoPbi2RzvWotKLM+K83QhLCrKl0LiA9sYhB5H0G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763699879; c=relaxed/simple;
	bh=6s8PHWdOSG+1W/WLK0jEINIZHtjaB4NfAJ0TkZr4vkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuL2JmnAMJ1QQbQcNlhEy95tiuFkjS7NI4h23rlC7+watcT6sldiKW6zxB6jGkF0t8dGjRvWOEo+qFKVmtzeRRivyoGuL60D9ARY9zotGeThh0E8c00/elNN8U13mjdkCiwhTumw5GTzwRkE09joRCVlgLNnbMPrJD/98JQU9jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BDjW5G6C; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDjW5G6C"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-340c39ee02dso1401802a91.1
        for <patches@lists.linux.dev>; Thu, 20 Nov 2025 20:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763699877; x=1764304677; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TynGywYl6RyYw3CZDKcyLY9zDRebGixEzoKG3/4NI9s=;
        b=BDjW5G6C4az757CnPP38IjYEDF0vQeF0MwzTa92kp2Ikcc7uG1uKheJAc1HNq925V3
         CpWOVEH+QaPZBFg4IOrvDvG0YMp87dXCInQmzG6itGY0kE1R9ZtW8/wwtyTkOR/c8DMF
         UUBgc9FnB9MlDS+bsFFL8GAIXN+F/dcXM/aO1zDaMdJ7/4weWvoNV3uvVa/smpg3H/U+
         6lk0TEfZ//AgGnio2Yt+s8pmcKH4v9z6R0+kNh8FveTnu4llTal6Ygt6mncYomC1Kd+g
         F8paPBbWZeVvTjAIwel94xv4DxxW78amifiXXPmLu0uigHYzuCQCLnkE+KpHxc7FZbHy
         gRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763699877; x=1764304677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TynGywYl6RyYw3CZDKcyLY9zDRebGixEzoKG3/4NI9s=;
        b=tFQ2dw6qufMWdqjiNFVUzJao2yyPJHkkE0xnDZbpOj5aS/xgLO9BLdmkz5rCl3Q6Qm
         yKPBrvrwZoVs5YbaupI9k78bIvST+0yIE5y96SADMSvk9VXuVAu4wGPMog29MIl6ZvyP
         r9lvv+m+0WaM1jyZ0zDVeb5kJaf9mSZAdxRwjpqr7HuaX0e+w8VzlAi5FTV7MIHRvovi
         SPGPsnSqeIIbcUFTK7DfCa5Pig22Qbl7rcyMSTOoL/BVd09uEHDnRWVA/S5Er/mtaw47
         QGlEmO5gktZnY//U7cUq8joR5/2w3D4fcFv6fP+VHlhVKsyO+7M0RVlEKdiwqLOMzsRE
         oqlw==
X-Forwarded-Encrypted: i=1; AJvYcCUk//AjM3SkvDL3z7Knv8YSp7gANnlraGWzFvQjpDGSrWlU1xMrpK1rcqyhl2Jp5Hcx6t+Gg0le@lists.linux.dev
X-Gm-Message-State: AOJu0YzPoXnt5Osvc+mIPq+7eGpqnepCOuZDmj6AWUDznvqeCKIdqSEx
	vnWHhwtGuA5DuADeagUOk5v6pKRoSKy0XOfMJ5mMiYQvp2+4Fhjrxnik
X-Gm-Gg: ASbGncvhD94Jlr6D3r+AXmCbXTcFtZmfFJQmHi0MBQoLL4dFk7CpyJpK0wno8RENNVz
	cVhc72jyRwUc3tw4zdyE9gSjqzOAdFVNVD21v4unONCqwnW9kerG058Mkdhxt1KEhvpw6TGNN8u
	XzvE3mTLRmO1x9Xhd1PDRI42kUVV+Pg5/4Twlo+GNKVIhzfqCVypN/+6Vs3PG+hR2eCYs7xLC3M
	RWl+yqOVgOFk0ls3Cil9qORWEGV0iIQVu1mipFaC+VVZYINS+WVHyDvgqmxc5VSpjY6LpYmkvIi
	HpdmNujaNImbWmNtVgi83wERF9G5iteUhtt142Sa2gnftlGXr/5dREduCLCabgrwJ/3E4FAK1j0
	uibNmVbInDzffYaa7Pkz178kIlaaJpnbl8Xaumnn6ghVEAGO0IJroMg53ZDwFHWgvJvqWcnsTlY
	7scpaStxBeJdVkVdfEtjxNeg==
X-Google-Smtp-Source: AGHT+IFpy8aEMiz+rI49VLVFHENbF/NAOcnRM7T5COE/u2FbKYQ0ITBcar491x6jUidWBixZMc+Z+Q==
X-Received: by 2002:a17:90b:48c4:b0:33b:c9b6:1cd with SMTP id 98e67ed59e1d1-34733f163c7mr1355810a91.19.1763699877463;
        Thu, 20 Nov 2025 20:37:57 -0800 (PST)
Received: from localhost.localdomain ([104.28.217.215])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34726696cd4sm4150711a91.4.2025.11.20.20.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 20:37:56 -0800 (PST)
From: Jesung Yang <y.j3ms.n@gmail.com>
To: gary@garyguo.net,
	ojeda@kernel.org
Cc: a.hindborg@kernel.org,
	alex.gaynor@gmail.com,
	aliceryhl@google.com,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	dakr@kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lossin@kernel.org,
	nathan@kernel.org,
	nicolas@fjasle.eu,
	patches@lists.linux.dev,
	rust-for-linux@vger.kernel.org,
	tmgross@umich.edu
Subject: Re: [PATCH 00/18] `syn` support
Date: Fri, 21 Nov 2025 04:37:47 +0000
Message-ID: <20251121043750.298843-1-y.j3ms.n@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110135927.05d83da2@eugeo>
References: <20251110135927.05d83da2@eugeo>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Gary Guo <gary@garyguo.net> wrote:
> I can build with these patches and I've verified that libmacros can
> indeed reference types within `syn`, so also

Hi,

I've been trying to apply this patch on the current rust-next HEAD
494de8f67b1e ("rust: sync: replace kernel::c_str! with C-Strings") and
test it, since I need this series for my future patch revision.

Unfortunately, when I make the following change:

    diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
    index 793f712dbf7c..084633b517be 100644
    --- a/rust/macros/lib.rs
    +++ b/rust/macros/lib.rs
    @@ -444,3 +444,14 @@ pub fn paste(input: TokenStream) -> TokenStream {
    pub fn kunit_tests(attr: TokenStream, ts: TokenStream) -> TokenStream {
        kunit::kunit_tests(attr, ts)
    }
    +
    +use syn::{
    +    parse_macro_input,
    +    DeriveInput, //
    +};
    +
    +#[proc_macro_attribute]
    +pub fn dummy(input: TokenStream) -> TokenStream {
    +    let input = parse_macro_input!(input as DeriveInput);
    +    todo!()
    +}

It fails to compile:

    error[E0432]: unresolved import `syn`
       --> rust/macros/lib.rs:448:5
        |
    448 | use syn::{
        |     ^^^ use of unresolved module or unlinked crate `syn`
        |
        = help: you might be missing a crate named `syn`

    error: aborting due to 1 previous error

It appears that the vendored crates are indeed compiled; I can see some
build artifacts like `rust/libsyn.rlib`, `libquote.rlib`, etc.

For reference, here's the sequence of commands I ran to compile the
kernel:

    make LLVM=1 ARCH=arm64 rustavailable
    make LLVM=1 ARCH=arm64 defconfig
    scripts/config --enable CONFIG_RUST
    scripts/config --enable CONFIG_SAMPLES
    scripts/config --enable CONFIG_SAMPLES_RUST
    scripts/config --module CONFIG_SAMPLE_RUST_MINIMAL
    scripts/config --enable CONFIG_KUNIT
    scripts/config --enable CONFIG_RUST_KERNEL_DOCTESTS
    make LLVM=1 ARCH=arm64 olddefconfig
    make LLVM=1 ARCH=arm64 CLIPPY=1 -j8

I'd appreciate any guidance on steps I might be missing. Thanks in
advance!

Best Regards,
Jesung
