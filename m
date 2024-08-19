Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE64208A4
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 07:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724052541; cv=none; b=nO/j+q/yNlyGMRpEGDj1m14zaQwScNs/mzW+tcrkIBGzwsM3BVu7XgoPGQbIXzDfXFpW6bq+zn7oFqlkpB8YVxG9Vg2WEkeL0P9gZG8eZCKqESpx5HIHsUVXNOvWYoPaZToko9CwESvztKScb7Y23GJ0dLeebSD5nZRp7se9n0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724052541; c=relaxed/simple;
	bh=9RpqaSW3EP8+7YSs6+tNYph9FaHPbkC6S+ZfjCCWSvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FD9r7sutkMWVVl9r2UUNfvHNwCRf9jlfVEvRByox8qPMIS9HgLcK/UrPgeB/FeFYLk9StGn3lMk+RiyA0YZAyGtDT0o941eQw/T2Rs4ejspXmivDM+0Tcy1Wv+HGfgj/vyQkXsuk3qPrsZaD+0azsRziNc8UBkb7gG4HtqiS93c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2d+WFGhX; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2d+WFGhX"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3718b5e9c4fso1953016f8f.0
        for <patches@lists.linux.dev>; Mon, 19 Aug 2024 00:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724052537; x=1724657337; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9RpqaSW3EP8+7YSs6+tNYph9FaHPbkC6S+ZfjCCWSvc=;
        b=2d+WFGhXh1GHIauhkNMLg4zw88hhyIvAE5F7iyY9oEpskgIurdZvs/9x7zp6J04UM9
         m2CfjP6xWn85lLbF1EycHUZ+NUEDIeC3UD1kTxXDlbk/iCdEGvOxnoepwovBh3OLiRy4
         a34Ji5kwR/JyiBkJuRKnrkvhtYnQbqSi1xWtWXw8pcAcjIWiYMkxmX4b9zUHVmPkQooX
         x8g8ORBZp7kk3HSRillgOrkTn573wCvF4zuePPVFuPCsQP6xEtci8NSYYarFWSBmNHt6
         op0u8cU5/askpF871sVxvro6t2WiWTX65NvcEHqudi/PuVN//AM40hW06J8jmJYxeIrx
         mvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724052537; x=1724657337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9RpqaSW3EP8+7YSs6+tNYph9FaHPbkC6S+ZfjCCWSvc=;
        b=wSSnVz11icCa3gGnLVVqU2zMKpA6ZvQS65YAfmPZeuO25cUX9VWn0RJeykjHlL2cFR
         zup0WCX6OGDIi87OwWta4T8CvHGMX3vY5OsbZW05NyZmrdHfn0IrNwq+A9OCM1GJzhvO
         zRp9edFl+RbVBqgGBNM8EczbOPs9msvlNJI8CGuoDWzK+CvC57ZnTD5fIYHz9Bb+QxsJ
         PzaFhQ5R8X57y3TD3h0Ywt4Y6fNRh+RdyQUIbQPtdumsSjD/wfvKtZ+H0f7A9HsPNVHW
         NJpgZNJyI9dzi5DdbncWbqMTy826fj405nJwRm8dVxFjR3SzApD/XZf5jjudMCesqPHQ
         tUBA==
X-Forwarded-Encrypted: i=1; AJvYcCWzMCdYPCayZbgP9CSeuUK2rJdV1Dm5nbII4kEB2zr5YhxrAQDYoJlLVrW/55FJWqigBB98kEVtnrvUQkM8hABKzIw//Og04A==
X-Gm-Message-State: AOJu0YwyGN7UQJNs1h5P+v+YR46B6Z+QzHRXYcwnx1inq7b400tjKFhn
	wOmhcLAUEr41i1mrZ90XRFLsrqB6xE0feJKl4V0Q3nkRctTW29jc0lo+PvUHFz/bssDkX2azXBk
	pPWOPsrLTCsoIfBPn2ti6QXWksnh6WlDc9Mkd
X-Google-Smtp-Source: AGHT+IFbDPWP+j/rqNlthxQd7CrAdmAs9wRe0NTha3CeBwITtFOy28z/1Ffe4WKvnY7vqXrMteXUHK3icZnMnT+QQxY=
X-Received: by 2002:a5d:49cf:0:b0:371:8ca4:1b76 with SMTP id
 ffacd0b85a97d-3719465b8fcmr6024363f8f.32.1724052536815; Mon, 19 Aug 2024
 00:28:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240808221138.873750-1-ojeda@kernel.org>
In-Reply-To: <20240808221138.873750-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 19 Aug 2024 09:28:42 +0200
Message-ID: <CAH5fLgh9Moq_9M+zMu300ohK=mPqkLyS6cpQ6An2Q3THCPFjaA@mail.gmail.com>
Subject: Re: [PATCH 0/6] kbuild: rust: add `RUSTC_VERSION` and
 reconfig/rebuild support
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 12:12=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Hi all,
>
> This series introduces `RUSTC_VERSION` support, which is needed for
> several patch series getting upstreamed, and it will be increasingly
> useful as we now support several Rust compiler (and `bindgen`) versions.
> Later on, we will likely introduce other macros, such as
> `rustc-min-version`.
>
> In addition, the series introduces automatic reconfiguration and rebuild
> based on `RUSTC_VERSION_TEXT`, to mimic the C side, which is also good
> to have now that we support several versions.
>
> It is based on top of the current `rust-fixes`, since there are a couple
> pending changes to the version text Kconfig symbols that will be sent to
> Linus soon for an -rc.
>
> Cheers,
> Miguel

I tested this together with Rust Binder. I also ran this patchset
through Android's CI setup to verify that it works in builds with
CONFIG_RUST disabled. It passes both with and without a Rust compiler
available to the build system.

Tested-by: Alice Ryhl <aliceryhl@google.com>

I'm happy to rerun these tests for new versions.

Alice
