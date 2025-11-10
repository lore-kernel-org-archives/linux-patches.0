Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD9C3093CD
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 11:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762775601; cv=none; b=buT7J4nUEcgktcKikY42WBTqo/zqXJU5ycSiQhSdI38OJK/Zqvr3gLpZgsoC9glTRYSZWHm9ERyHVtsk+h0Bu2AzDk0oEAr9MAiEiu6bzYz481Fuug3uO230kmPUbyo3l/cx5EIqn3rG9Tb7/k1pN9KJPdinxge+6i9G9t1R7Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762775601; c=relaxed/simple;
	bh=EDZJblRFOBVaS7V9swh66M5uzKZEQn6brygnQ0u2oxA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tKKdF4T/BcB8wQ5ZjcpXmzqToUPdNVc6083dkzpeoCRYW4x0U14z/CQvt1xbl4YkVcIeCKBsLz1/5FaqqlAbZI+XEWrIWjt+L1FDqRTZyRyeKBZCYUyDZ9e1IUzE0EPBxXng301Kk9Ooef7YZ6YTaZxmXSCD3UxJWDHa9VC2bdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aDc0aX0Q; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aDc0aX0Q"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42b2c8fb84fso823902f8f.2
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 03:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762775598; x=1763380398; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FEKi6XUPcJTxR8kCttvI9av/95c/Ll+7Tji2AuMb3UQ=;
        b=aDc0aX0Qfb9MgGIlUm9jEDZxrDdSg4xNqAabj78DEpAdM/BGm5z2h/iuIB5fAvrtS7
         k4UZ60qnQEH8vDEUvizv+nslrqz1543N7VFbqoMe/QZMZA2qWP7l6u0mVNE56TJ9eAtn
         RQkumLXKd/e6/AJ7tTnZCInT7SSRGTNu1YYaw+KHrN5MfsIFAgMwOprb3PNS0Dk44BrM
         9tKL0gQiqsexDOSWyXS3EmH/Mns4ERhH/wSt+yHGx++92xSux+22AC3kmyQ2q5YH1a7o
         kgq9LrGTWEroBoubHcgelCto3GaKWV/tvUsSatfve47TB1atXqaysrOo0zfwkGgAyzBn
         o/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762775598; x=1763380398;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FEKi6XUPcJTxR8kCttvI9av/95c/Ll+7Tji2AuMb3UQ=;
        b=GquxKPCV7zwif03b1ipVpsV2340MIibo0x1X3+L1hMkD1dGetDJzVNvL2hBqSiA4CN
         slOaQ92pRQ3WvMssXHE71n6J4O1NRJvG+6uq/e+fYcP+38Ye0M5IcMhyplWWFLIrraDe
         AvRTp6AvL4djB6XRISylmewOecflAtB9uK0xehnDYiLh5ZQu7b/imDtd3GHnhxy406pS
         glslMi69CRscnKp9uDOB5LvDhHToCft+SLIuJXKuvMdSc4S8jUD8T1kEQWsJ4pcKRzc+
         F9xJXVGcW2i0tXsBqhVNEf7Yhd+FWQ1VR1jQHDkpdCCfRL1tiSTtmdWN1OTyokVwhM+G
         tJZA==
X-Forwarded-Encrypted: i=1; AJvYcCVGzbdL8wG51XKs/Pgzle6dDpd3Bq14mRYOD1b4vhmAJbGSqGQiRdIqE4STZ//wntCUUy621a+E@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5eXUSKWuKmL4QYn3p1Bi0BZ3+JiTk0C7txfuSfjhgTECyPSSC
	GvG9tUG76EyHQ6ArKHaL0Q1rYakmQDVzb3QqoFzHejBC61u2MlE49zsXf8uljyvXC3gOUNRnnMl
	/vPi66p8ggyy+0/6NJQ==
X-Google-Smtp-Source: AGHT+IGDXVa4jR2Hvr+m+drHIkFWVJ9kU5jgqj0CSyP25A++0dFEDi+XQZITKlDq83CPddiTCOmKe1l7tbj1AWM=
X-Received: from wrnp5.prod.google.com ([2002:adf:ce05:0:b0:42b:33e5:eba1])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4710:b0:42b:2dfd:534f with SMTP id ffacd0b85a97d-42b2dfd557dmr4843170f8f.34.1762775597658;
 Mon, 10 Nov 2025 03:53:17 -0800 (PST)
Date: Mon, 10 Nov 2025 11:53:16 +0000
In-Reply-To: <20251110113528.1658238-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110113528.1658238-1-ojeda@kernel.org>
Message-ID: <aRHSLChi5HYXW4-9@google.com>
Subject: Re: [PATCH 1/2] rust: allow `unreachable_pub` for doctests
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Rae Moar <raemoar63@gmail.com>, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, Nov 10, 2025 at 12:35:27PM +0100, Miguel Ojeda wrote:
> Examples (i.e. doctests) may want to show public items such as structs,
> thus the `unreachable_pub` warning is not very helpful.
> 
> Thus allow it for all doctests.
> 
> In addition, remove it from the existing `expect`s we have in a couple
> doctests.
> 
> Suggested-by: Alice Ryhl <aliceryhl@google.com>
> Link: https://lore.kernel.org/rust-for-linux/aRG9VjsaCjsvAwUn@google.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

>  rust/kernel/init.rs         | 2 +-
>  rust/kernel/types.rs        | 2 +-
>  scripts/rustdoc_test_gen.rs | 1 +
>  3 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
> index 4949047af8d7..e476d81c1a27 100644
> --- a/rust/kernel/init.rs
> +++ b/rust/kernel/init.rs
> @@ -67,7 +67,7 @@
>  //! ```
>  //!
>  //! ```rust
> -//! # #![expect(unreachable_pub, clippy::disallowed_names)]
> +//! # #![expect(clippy::disallowed_names)]

Maybe we should also allow disallowed_names in doc tests?

Alice
