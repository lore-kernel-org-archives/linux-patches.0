Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875EB6A33F
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 18:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727981046; cv=none; b=FPMt2foRQ/SUnvVIdaWu+/0ZuvxaJGRBL6mWPwSqIUpTmfUER4ZYvRpR1M7Mcmf7tvtrUuNQYJxOkd2z8U6hXfRJ4cDUtxgOAlHp/jn9QiYxK2iyvcAcIC/0kCgX57WenA+4ZjX5ry3l/MrgXahif+y5tQLRwjUXjjolVMTx6cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727981046; c=relaxed/simple;
	bh=AohMEN6//bGwLbMRcFuDo/HMLCFf72VoCIMQubro9Qw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HlPIvKLVmCmbf8t0OEW+CpiVjOAj6ALom56WYTYZzTt3PTVCmzvGRzEay/m0ibdm7iZKeGLbYzOxukX/Rp0MyLDX5+bjzzE/Oq0israHHpAvvunfkrdsAKMXD2S5AvA9uzl6RcEnfJ3ZHBXZOmxD/1hP0nayZYUDU+/Kb3/64PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dBMoBfRN; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBMoBfRN"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7e9cbd25337so154110a12.3
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 11:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727981045; x=1728585845; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BnBEBEIYa5oSJNvztsWVVc0YabLIFyfFtgDbS8eEAAE=;
        b=dBMoBfRNgvRuc5qhskn5bpCoOmvqKy7WNJMQy5vX17kS+SLf7URkOCgDOL0XZ8cb/U
         UZaQcsZPXEv3k7ObOz4ck/o35asfMjLXlWcrxP3DNp7wuhfQlq6bIhkjbjCzQOCBNKuK
         LXrev9/NYz3i78ZT7fq6/GL34k/lZHdlfgCr0Ni7ATLCHLa4O6lY6iySD+HGAp3KnHX1
         odk+3HHj6nM0c9tNs1iNzT0ap8/QN1BaqK02axxGzdjvmUhNBLhzUu4enLugWj1CV1u2
         1k6QPfzZERhoVNDZRyU3cgHmwnIU3g2SewW3MWyC1Dr5KPqe6vbJZ+6pfzP1rQt4yLNB
         zbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727981045; x=1728585845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BnBEBEIYa5oSJNvztsWVVc0YabLIFyfFtgDbS8eEAAE=;
        b=nMxz7WY59nNPaKK+Z1hI6dfyGdpGwpU91xI1Pg/O0m1dToNURebthnidNyrQ7j9T1K
         a4T0xpWdYgf8djkrIN7HzeWgvMXfIfIYQCe8e3LBoif/2UyrFtv/ry0Erxs8WPXYfbp5
         E9hsK5QKamQ6Mc0WVGteQEFcTaozEXqppFrAUCHgcCKY9d7F1gk/mhLSJzcz0B2SJLy2
         MyT3IT4T+3d+oSVwqJU/c+rSOCuGJqmOagcAtEpD5X0zKJq4Bgv15rtgxhb2AHakMyIu
         Hll0x/acEvcJIKc8mGGSllB4nMbvUrDdww0G2o/a33wxPWQn6KUCAuNNG1GXs9S74XqU
         e2Hg==
X-Forwarded-Encrypted: i=1; AJvYcCVJ9wWneB969z1PwwQ9rn50nbnuxKXTLWk08Jzo0JxRiy8sfSDXj3LJIhFQmC6aNqc6kzme8TsY@lists.linux.dev
X-Gm-Message-State: AOJu0Yw89Bfj9z4w/dlsb1RXpWt/8EKpkEA9QAGiSQHX+cF8f1/DnI9Q
	xQDoQNH0PdZB9yLoSOZBiGDtfMz+Va+xgur0Z3ggXWGdzru3J8A2MGwp9SzbAIQ3gYQmF0AimHy
	Y0raKK4J1rs9QJm8c4gyNmJB2HJs=
X-Google-Smtp-Source: AGHT+IGkMX/n88gTuOQgSAEyHpcdoHRMJhqSDTvkr4IaK1p75k5TAFT+NTfKcVsqg5Fe6N2QdRLLvDfUZu6Mjl2Zm9Y=
X-Received: by 2002:a05:6a20:3942:b0:1cf:4fc0:4ad4 with SMTP id
 adf61e73a8af0-1d6dfa3bd54mr164516637.6.1727981044848; Thu, 03 Oct 2024
 11:44:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-13-ojeda@kernel.org>
 <Ztk/rn+wztXYVTtd@gpm.stappers.nl> <20240915001035.5fc4d4a6.gary@garyguo.net>
In-Reply-To: <20240915001035.5fc4d4a6.gary@garyguo.net>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 3 Oct 2024 20:43:52 +0200
Message-ID: <CANiq72k4X2OUBwLZ9BMHCDtfJfkWrLsMm0T6RgE-4J9YOfHvHg@mail.gmail.com>
Subject: Re: [PATCH 12/19] rust: replace `clippy::dbg_macro` with `disallowed_macros`
To: Gary Guo <gary@garyguo.net>
Cc: Geert Stappers <stappers@stappers.nl>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 15, 2024 at 1:10=E2=80=AFAM Gary Guo <gary@garyguo.net> wrote:
>
> `#[]` would apply to the next item/statement, and `#![]` would apply to
> the surrouding scope. In this case there's just a single statement so
> they should be equivalent.
>
> Miguel, is this change from `#[]` to `#![]` intentional?

Yeah, it is intentional -- it is what the last paragraph in the commit
message refers to.

I think this is e.g. https://github.com/rust-lang/rust/issues/87391
and https://github.com/rust-lang/rust-clippy/issues/10355:

    note: the built-in attribute `expect` will be ignored, since it's
applied to the macro invocation `assert_eq`

In addition, `disallowed_macros` also has some false negatives I
noticed back when I started playing with this:
https://github.com/rust-lang/rust-clippy/issues/11431

Cheers,
Miguel
