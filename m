Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B6D18C018
	for <patches@lists.linux.dev>; Mon, 25 Nov 2024 09:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732527925; cv=none; b=Q/g2U8Wr/5VagXep56urEDUBhx+5Z5RcltzvSnagb7wmKsaaNNGkGxEZXf+Kd5h87C4gRSZhSe15cJV8gGTZs/JtbdhvD2zMFv8kFc3x8G7V7FqnVfwx9L8yWtRaHNci9KIrFAbkeKeiDpfRoCBB5Bl8BIXjIcZltpwkRqT0hwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732527925; c=relaxed/simple;
	bh=8GWbrppTY2SdRiB8p/3spnrWMuOqZHHKbGVh/ni1TaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PkW6AlSbD6tPVrniOvvfsCqxbC7tlgooEUkJM2zIk6AW3VBky+PZ3gxZuTHysqGK3htGAtlgtdHo9Pxf3XmEyc8XdGNNdF1EtRy388h48gSlU5cnrSuyAiEjKMi5/P0FMxmegH1jubrXiXkt/suBV7vJtcV8WiFPmhCWQVOhAHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mjkC68yp; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mjkC68yp"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4316a44d1bbso38256685e9.3
        for <patches@lists.linux.dev>; Mon, 25 Nov 2024 01:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732527922; x=1733132722; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8GWbrppTY2SdRiB8p/3spnrWMuOqZHHKbGVh/ni1TaU=;
        b=mjkC68ypS/voOMZddJ6l4pxOawOngH/rqprlTahRZ6YegVBpDOqcXHK4apyMvf1tAM
         KWKAoHvDglhdX+noj1JKl7zH/Dih9qcneQ6X/9rGjq+zcTHUl8DVlTL/R95J2m8R646G
         oWygWPE0VJ3bEnf+pIobf3ZodsVDGn4no9I1gUfRhf2BJCt5e7f1NFCKFpa2h0vSlpdK
         boA5FqAka/zWuZ7SxEZmZTRxqaLduC6DFenTwyYeCQyTnUT12wVCz9FrJuMR6EkYNPfZ
         3+BDCxiXFgjDFQBsBEXACVIQqN0eLF/msg6mX0lrFlBolkDMPez+9d9vAau+2hYH+/wU
         MG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732527922; x=1733132722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8GWbrppTY2SdRiB8p/3spnrWMuOqZHHKbGVh/ni1TaU=;
        b=xG+GZh2ZCa9I/O8Vk3vwJawtn+D7Wy+gRPfRw6b846gtx4Lod71Z7oKHQMipjZMcft
         3ButeHJ4zMeilLfUJ5ajCPIcsfpAwlSFBgWXmfMzmCoduEI5pbmRmGygfwemCw6YoUqJ
         xhkfen76n3fpRQAwwRVtvWNyW1vetzKtJaN3+d2eaCABXiO48MGc9DSWYcPD7k5aGr9u
         SVffc6DcCNdUYDY61+HNhPAvFZ4O2OF1ptncnAZueZFk3yLIJxIbRv5ifyBsM16+bWPl
         7h/P2AaOKF7HvEyZJdFvGjy3kk2nr+apkGohdHFj9Y6DObAc/0349BhfhPBZqQlC4RJR
         UyfA==
X-Forwarded-Encrypted: i=1; AJvYcCVB4ecYiPAYW66boShmkH3pZ2aHFT6A5sVL0pCPwx7DxlW/sVvBqK+/d4wPiULIIBJ3YLtdhAdw@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4jbqPPiCcExI1uilt17OhQ7scBAQzXbFhuCSFYDb/j7/CieiN
	yk8VBPmbavhNYIbZFYwCqsmTkKgIK9yIiPZRYVorQ2sSyUIV04Cft8tTRERZRMg6UbLZFaZwOoi
	/2uakJ797X1z0qyBm4sEdy7hhRdqs+yyYGJ8t
X-Gm-Gg: ASbGnctJ4y1426uWMvPW5M9aKFsLH7Kz9ouj+Iv5PDp7RRBem1MsbMZ03ri6k3ZO9hg
	aAWbcETBTJVFwSUpArZK5xLL1XZdqB4+eCm6ulgj0Tn1XXOaMmap1NFxOIJ3+hw==
X-Google-Smtp-Source: AGHT+IGMe//ja59s2KtnkXWASLS4/7cHUSPDFQmfLfQzEv/lOhx3Gg//+rAV5dCcd3lozbWK7n3eI2qxPCsTUq7WPdI=
X-Received: by 2002:a05:600c:4fd1:b0:430:52ec:1e41 with SMTP id
 5b1f17b1804b1-433ce42845fmr110108165e9.17.1732527922183; Mon, 25 Nov 2024
 01:45:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123180323.255997-1-ojeda@kernel.org> <CAH5fLggg5f0KpaObVtZc7WaxHjUqbhCDsn5CwnA5-3df2HEjnw@mail.gmail.com>
 <CANiq72moPEL5s0T3ELEDvWiE6Lz5oZv2hZnziV5A60EP65bkkQ@mail.gmail.com>
In-Reply-To: <CANiq72moPEL5s0T3ELEDvWiE6Lz5oZv2hZnziV5A60EP65bkkQ@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 25 Nov 2024 10:45:09 +0100
Message-ID: <CAH5fLgjEDXHGLf+fAyzZwGtX+sjuCst6P9Eg_eyLjujd2datYw@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: set `bindgen`'s Rust target version
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Christian Poveda <git@pvdrz.com>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <emilio@crisal.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 10:42=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Mon, Nov 25, 2024 at 10:08=E2=80=AFAM Alice Ryhl <aliceryhl@google.com=
> wrote:
> >
> > Just to double-check, the problem is that bindgen currently doesn't
> > get any information about the rustc we're using, so it may generate
> > code invalid on the rustc we are actually using?
>
> Exactly: it doesn't at the moment, but eventually a future release could.
>
> Of course, people using the latest stable `rustc` would likely never
> see an issue. But there may be people e.g. building `bindgen` on their
> own, and thus likely picking the latest version, while using an older
> Rust toolchain from their distribution instead of, say, `rustup`.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

Sounds like this might need a backport to 6.12, to prevent issues
appearing on the LTS in the future?

Alice
