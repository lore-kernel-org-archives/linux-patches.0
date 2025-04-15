Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B778D28468C
	for <patches@lists.linux.dev>; Tue, 15 Apr 2025 09:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744709250; cv=none; b=crAo0wTcu/u3uqb0JhBbV83JU/bafm7dtz+CzQ8buf9GOQgw6kptuqjBCweF10xbOL7DbtfdmrkkXQVAvFXhw4ugTzz/wASHyc2QJV2V/yRykENE+yrj+DeUt7m+HKd9AcFPQxEcbr5oSeD2UjoSHCCLxhfJhWKWvuMZs9gF6uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744709250; c=relaxed/simple;
	bh=ACQuDtLySJGUDdPySwcX9laZ30nm6+nLm5qXV88Hr4g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r0jTZa25ipGI4YO913b1eyBvYEi8eRlDFMT7bHuSSPAcyP+i6PznfnGB9U8tRq8ev4kFDueO2u3Qp8mgQvj4rMwspGcGFfjWDQ96FDErPdsk6lv4xbwudWoxsz+tS9eX95i81szAgoObh1biopvH4NQuDJF/06xoQHOGgwcI8A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=16rGEwUR; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="16rGEwUR"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43ea256f039so40667375e9.0
        for <patches@lists.linux.dev>; Tue, 15 Apr 2025 02:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744709246; x=1745314046; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xNqTolRYwEdQ0xZi5RcJyGoxOrWsQ0mEIGkr1N9o2c4=;
        b=16rGEwURFa1FMORlXoO31B4wPDTdAJJBuTYkZwrS1Wpn3H08cvGmY5+vzzDB5EPbSf
         wtZOvgQTvdKyFC/vCd1x7EeuHTtNaqkUbA7Cu/AMoqT42dO96+uMy7e8rUnXaFevgyIA
         jS1xfZQbwbA7jE/j+rTlfNyWgnvCzaPvM9Cxj+WZse494PH/r9Lewf1y6Fa8tWT93B6h
         fyYzYtLwHdn8Jr/yURH7ZRWQYW37bmQFbpwqnBu+2S01JHxO//LkYf2PzOKUaok5K4Xq
         PtIgyFC9gRkZcazCDagAyjYEo4gW8GDhaEilfuX+/LMO3N7S8mZo6vj4k70qIDvW9Eg3
         40SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744709246; x=1745314046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xNqTolRYwEdQ0xZi5RcJyGoxOrWsQ0mEIGkr1N9o2c4=;
        b=Z7pqjititL3BZ9+jPJNM1EiZ3Ef73iUzH75IupaDC5o5E5UtNt49V9Hm1pVcur94BM
         RN4QwBr2Dxag8yNO3I7Kp790LnrgheoJBkuOstqdQEett7RsLUEKw+7pdhorRCrLPWQb
         gyABzSpCDHBGxuSI6/CdznyGXlqet+qTY2fhOFaQajFfSYoqzQ8HbOSReTozpju0O84f
         79iosOXUoBmFX5uzSgkk4cEo8fu9oI69q0kmzOfDISiALxdNVyxkJRevnEL+Tq3u1tqk
         pHTVBiLPW/ENj2sw896dX0AtF8R8GCQRI+kKdqNfcZF5E3TpzH55IHi4pAMeaX+uL6Zu
         li/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWwUVkXQ5CVLcqdGCUMpff/pmcVCCZsz8/D7HU/2aw3fSgLnt0ods5RJShc8wMMgDMIOJ+SKZlV@lists.linux.dev
X-Gm-Message-State: AOJu0YxYK4ZEnPTUyPMwXsWbHv8iKOSif/RU6FWU+viQS5tEUDeJVR3h
	E9s4U3FuDuMVg/oEsuOcTxT5bd+eAI41chyIt5qC0acPI82jpNolmCnghZLcBIA9T9zPZLO6XdE
	C8KnmRrEn2p3nJQ==
X-Google-Smtp-Source: AGHT+IGNOnYD9JWXHsjrfEKTxmUhjAQDAgXAWdeq5XqvcbzsPrWDx2ckJ/DQU+m/oiKaf2kSydGbCqfW3XxRxAo=
X-Received: from wmbz6.prod.google.com ([2002:a05:600c:c086:b0:43d:4ba5:b5d6])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b86:b0:43d:db5:7b21 with SMTP id 5b1f17b1804b1-43f3a9b4865mr111301865e9.28.1744709246233;
 Tue, 15 Apr 2025 02:27:26 -0700 (PDT)
Date: Tue, 15 Apr 2025 09:27:24 +0000
In-Reply-To: <20250414171241.2126137-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250414171241.2126137-1-ojeda@kernel.org>
Message-ID: <Z_4mfK2MK2xclvbW@google.com>
Subject: Re: [PATCH] rust: kbuild: use `pound` to support GNU Make < 4.3
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, Apr 14, 2025 at 07:12:41PM +0200, Miguel Ojeda wrote:
> GNU Make 4.3 changed the behavior of `#` inside commands in commit
> c6966b323811 ("[SV 20513] Un-escaped # are not comments in function
> invocations"):
> 
>     * WARNING: Backward-incompatibility!
>       Number signs (#) appearing inside a macro reference or function invocation
>       no longer introduce comments and should not be escaped with backslashes:
>       thus a call such as:
>         foo := $(shell echo '#')
>       is legal.  Previously the number sign needed to be escaped, for example:
>         foo := $(shell echo '\#')
>       Now this latter will resolve to "\#".  If you want to write makefiles
>       portable to both versions, assign the number sign to a variable:
>         H := \#
>         foo := $(shell echo '$H')
>       This was claimed to be fixed in 3.81, but wasn't, for some reason.
>       To detect this change search for 'nocomment' in the .FEATURES variable.
> 
> Unlike other commits in the kernel about this issue, such as commit
> 633174a7046e ("lib/raid6/test/Makefile: Use $(pound) instead of \#
> for Make 4.3"), that fixed the issue for newer GNU Makes, in our case
> it was the opposite, i.e. we need to fix it for the older ones: someone
> building with e.g. 4.2.1 gets the following error:
> 
>     scripts/Makefile.compiler:81: *** unterminated call to function 'call': missing ')'.  Stop.
> 
> Thus use the existing variable to fix it.
> 
> Reported-by: moyi geek
> Closes: https://rust-for-linux.zulipchat.com/#narrow/channel/291565/topic/x/near/512001985
> Cc: stable@vger.kernel.org
> Fixes: e72a076c620f ("kbuild: fix issues with rustc-option")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
