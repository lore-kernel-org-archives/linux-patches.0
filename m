Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9839B3271E2
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 12:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761741905; cv=none; b=N7cn+O0IWunyTrJBW7T6tvnRlHP9l+ZZRZiUbh3DRMYh07f9/GSUw1BSCRNdJUKZv/F5s5zyj+gHQn1dbYVs2RtcwhmMroEe8QGfStFmRIexmLtkA6G9BC+16T9qXEIlQ3HlV+80L6roUgTXlSwitF7qxocFXrUqgVA1Nlw81UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761741905; c=relaxed/simple;
	bh=Lis8XgSRnA5YJBARphY+01JX7JiGiM3xwyWmHXnsc2M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cJ70VHTk1vVdK+XGcu/J9f4le+1fQaZcGUK9nnntlrPmiq5XSmw0x6F+cPvl+WkVF1ETFBQvCd/nLPETcWtcGj3EdUOELiarMZXX+xzbgJ3oxl8bxup/XKUj07lh/8Z59mS7Vjt5ZisAOTXdI2FLKM2IJ5AB5KOtGJkrIEwmfrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=peAKRf8C; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="peAKRf8C"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4298da9effcso5039524f8f.2
        for <patches@lists.linux.dev>; Wed, 29 Oct 2025 05:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761741902; x=1762346702; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H9cuzKWbb4KNIohtS4TrqwKkjylaSR6bB/ye8dvPygA=;
        b=peAKRf8CpFJoat2arSPdfx4FyY2BMbBs17KmxrFotHJSQrQeVDLxFlM+aOMm7yD1C5
         mxxM3hsIiQ2QMp/YieiX6oxP2JebHRYvn1A4kC1+9RzhiIokfMOQxL2GCLpyXwHZuLHs
         Gi/whfh9jWSe/Anjcb0PjHupNQfcij9Fxs2PQqP68NxCOHTps/9gtcIK01ROxXSfbxzH
         0YGYPwKROzMyA51ZGPNUuD6eSJ2fGmeX8vi43FCFn+asOnpBB1Q791lUbLmRUiMaUrf2
         lZl9+gt6b1gomOrNLOqjSzfWDIsMTgZCOs2EhkcKM187YyQu1exydy67dmwa94ss8biL
         K/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761741902; x=1762346702;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H9cuzKWbb4KNIohtS4TrqwKkjylaSR6bB/ye8dvPygA=;
        b=D72K8ZbB1qvn7P2V6tXKVH53NIUdFLzpJAqgEwv8P/M5wlT2/R3n4yIjRgEB+afl5z
         Y94zHL6mIszkdgm0fKhTmtP+s+0vZdZSuWqAFfNBr2kr6ABhPWMtvVTeuUCR8Of/IP0P
         VXflw/Btu6e+sprUYHOBiCk6zqpr9goa0y3ZOSSnccfWuiYXR+lQ5PJ5qofB/dS9I5QD
         wx81UiL7NDA/s1yXSgpJTLREW9lfKlNzDQPaMIyNyzWFAvi1psKWv7ujV+biHV1I7iEF
         p6CSZuux0jBIkZ2wleMKdlMoIh9KB3lp4ozjalLocpFmgX6SCgndJ6E0sX6Wuwuhvxt5
         C1yA==
X-Forwarded-Encrypted: i=1; AJvYcCXgik8el2spXGI7bXpw5OgwCs0Hjb+XZ/CEEzA8YJgdny06SEbfHT9i1K/Q/U6RqLSLzM95lDIF@lists.linux.dev
X-Gm-Message-State: AOJu0Yyb/qVWjJRSac9xNp5PVS3Mrk4oJWENA2ijPlH/i3THZDRJoszu
	P62heop5YIbslsoKjh0XGlgwZr+qlatt22sMmPd19kcPuxrOyumGjPd5RJyoEKe5YCfDgODVoeb
	+jTUDCb5ApfuIXUjPEg==
X-Google-Smtp-Source: AGHT+IF6tS2K+sHdcmYL2m3Gzf5P+hOD9oht3waH8CGyonRKx29wIX6mnYWr9P3YR2G4rkduuBWQ0BGNCYQ/n6g=
X-Received: from wmbgx3.prod.google.com ([2002:a05:600c:8583:b0:475:dca0:4de3])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:820c:b0:477:e70:592b with SMTP id 5b1f17b1804b1-4771e16e792mr30523355e9.2.1761741902165;
 Wed, 29 Oct 2025 05:45:02 -0700 (PDT)
Date: Wed, 29 Oct 2025 12:45:01 +0000
In-Reply-To: <20251029073344.349341-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251029073344.349341-1-ojeda@kernel.org>
Message-ID: <aQIMTQZK49B1FbTA@google.com>
Subject: Re: [PATCH] rust: condvar: fix broken intra-doc link
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, Oct 29, 2025 at 08:33:44AM +0100, Miguel Ojeda wrote:
> The future move of pin-init to `syn` uncovers the following broken
> intra-doc link:
> 
>     error: unresolved link to `crate::pin_init`
>       --> rust/kernel/sync/condvar.rs:39:40
>        |
>     39 | /// instances is with the [`pin_init`](crate::pin_init!) and [`new_condvar`] macros.
>        |                                        ^^^^^^^^^^^^^^^^ no item named `pin_init` in module `kernel`
>        |
>        = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
>        = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`
> 
> Currently, when rendered, the link points to a literal `crate::pin_init!`
> URL.
> 
> Thus fix it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 129e97be8e28 ("rust: pin-init: fix documentation links")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
