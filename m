Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FD6305064
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 11:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762775397; cv=none; b=CVsmqhQgJP7XFtjBxxbAyZ11Fe269OJTRABZmKd/HFSBK0kvR2ynbTETE3FV4AKXS5b5rGzzZ+07Qc7U7jAmoWNvte89ZZqEl7Lmv3i8ohP9Bczeebi9Zi5ZCBsqTFMu30MF7tUUmoyw5VDyGdL8+ub69uiX1y1u8E75alf67UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762775397; c=relaxed/simple;
	bh=NTkuc6uDmedR+Q04RzwdAyOhBfZ76Ug/d7nYzNh4m0g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YB1RWBk4F3XqdQ0nVLrxVa6qKPxiTAcjGsxGDU0BdtGi7vxmANyF1MpdIqXtPWKrg1HmHcTNcTdnaT8A7bA00SzRdypZlA32YP3Pt+ZTFZAqjLc1WPBLt/2C+3am6h3fBJRYUxyRkrAH2o8MW3sCJS4P0nG7YWLDd6mN4/x56SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WqeDWA0J; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WqeDWA0J"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2c8fb84fso822379f8f.2
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 03:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762775394; x=1763380194; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iI7BOd97owyrjUzzXBWgb/eTwB7JOAn2nWeIJhsXI4Y=;
        b=WqeDWA0JzyR6OdI9LfH4D4vju9k34ez4JvMowXqnx943eOXnI1zctHYaF2aWPnVBSl
         p+Ztxl88KjEnHWZK2zUdsQyPA/wMzqN/8EE8DvRxhGhNTUZmQe759Vobeh+2B7S70xjJ
         9rBcc+PB/Cez+TC56976tcu4Y+sHhtPEH37G9QQ+Y433zeoI/6B5CadU/8IYr9+v5cEE
         1xHSlll5twb/Q8xJMNFYMY2NnoBbg55mlKGeq1XSgb64zwteJyZufkpuVxJDnE7a1hUW
         Nbtmo7bluloF/bvLIUHZPU60I/ncJDXCI8GW8ETaV/XGooFXB+SYIrbM/xec/GUxyRf/
         EOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762775394; x=1763380194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iI7BOd97owyrjUzzXBWgb/eTwB7JOAn2nWeIJhsXI4Y=;
        b=F9U6HAnzjyW/s5843fIEaCnKNnxEl325/qmQM6lkKPlm9mD5P5dSFWzIFFzdEIt3Tf
         Nr6Dg1COfyNxA/HsuKz0wAVVGLdtNzfFpwuezqRn//K3f1mnvz92XAqMPIR7OA0YiVd4
         e7EM+GL2rIcqnZAOwafAv1AD5Pi68vrPJbP0dsydWFwRgwI8/RTaKo+RL+ym/128VA6R
         SIw6dXBm3uS0e01/p8UH33YUxv4Rb1IQcoTIISkyww+3Q1UWUxJUGaFpSMJOiQmcBTC7
         2Ap03XGe+cqe9yBoDwbh6zBGRkc1sf55HU11W7VP3stXMrQZQfYhd2kpefBkS20qJbcX
         DBSA==
X-Forwarded-Encrypted: i=1; AJvYcCVipYavXJER2/KjbNzD/DgVN7Z0nzzqMKx+JqNdO3xl8Y2TlCDIkK+lM2ojoiJEox2OWS8pUmZQ@lists.linux.dev
X-Gm-Message-State: AOJu0YzNz0A42+Z7jyEj+z5Y4BD25AtP4NWGpevyJrhtGOlhXsVMeNOI
	cJ3f2QxgX4H8LDDWemD3hhPRMjketitSVOK1FoaRUUMD9jNyBo8iWO3lQmvB8zAWWArntelQgkG
	1C5OMer5Lc7c4vEhP6Q==
X-Google-Smtp-Source: AGHT+IHheI/7is/zs8xoYCCHH9TJVBmfgjIXrYT6nk8rB54oQU3DED9esEnZdNar7cXaooSPlLWXVMMw//Gx3p8=
X-Received: from wrnb8.prod.google.com ([2002:adf:e648:0:b0:42b:33e5:ebb6])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2210:b0:429:d725:4125 with SMTP id ffacd0b85a97d-42b2dc62281mr6378454f8f.54.1762775393891;
 Mon, 10 Nov 2025 03:49:53 -0800 (PST)
Date: Mon, 10 Nov 2025 11:49:53 +0000
In-Reply-To: <20251110095025.1475896-19-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-19-ojeda@kernel.org>
Message-ID: <aRHRYbHIfxMQ77eh@google.com>
Subject: Re: [PATCH 18/18] rust: syn: enable support in kbuild
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

On Mon, Nov 10, 2025 at 10:50:23AM +0100, Miguel Ojeda wrote:
> With all the new files in place and ready from the new crate, enable
> the support for it in the build system.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

>  quiet_cmd_rustc_procmacro = $(RUSTC_OR_CLIPPY_QUIET) P $@
>        cmd_rustc_procmacro = \
>  	$(RUSTC_OR_CLIPPY) $(rust_common_flags) $(rustc_target_flags) \
>  		-Clinker-flavor=gcc -Clinker=$(HOSTCC) \
>  		-Clink-args='$(call escsq,$(KBUILD_PROCMACROLDFLAGS))' \
>  		--emit=dep-info=$(depfile) --emit=link=$@ --extern proc_macro \
> -		--crate-type proc-macro \
> +		--crate-type proc-macro -L$(objtree)/$(obj) \
>  		--crate-name $(patsubst lib%.$(libmacros_extension),%,$(notdir $@)) \
>  		@$(objtree)/include/generated/rustc_cfg $<

This change seems unrelated?

Alice
