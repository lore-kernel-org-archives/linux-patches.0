Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA26158DD0;
	Tue,  6 Aug 2024 21:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722978894; cv=none; b=BkLWQQk3OqCcDV8kPI/3SAgd/0kkGXlkpSodziGaRU98WG4/22DhR2u31eVHTdSjQmx5xhuGz01fCb2FgKkCKdrhAKA9Q3guS2OILoQUIVe6vDIDCiYqIM+fRcUiRozRxd68x1OW/EZENuuuvMn4ga1m+Xaibrv7Ta5lBrIQMYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722978894; c=relaxed/simple;
	bh=/rh41jvzIxJEsvibJ0CSaL6FFeVsrsO1w8EFTwMPrzo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=addD0IUTuo9/3hXRoUTf7kg6e3+nKnAslDm1hPLgT2c3HJ7YCM4ZZiQ6/QeMMRaPWAGc/sL92AjdC9QnVfA0ItVQEnbDF4aPYaINxBs7/PW/JHnZePWDT4yff8bAQLiFs2Sw5vxtk4Rc60lmwAloXdkDjt/do5IfYcThqulm+wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Aeti/Rn6; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aeti/Rn6"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2cb5b783c15so939724a91.2;
        Tue, 06 Aug 2024 14:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722978893; x=1723583693; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/rh41jvzIxJEsvibJ0CSaL6FFeVsrsO1w8EFTwMPrzo=;
        b=Aeti/Rn6PI4JVvyjcDYmK5eDmx+YbjM39ODGR2L4noqdOLiHY+zkCTgl3W3B1A9/mO
         +pPDnF01zE3Q10hdtC46G8gV6sUdAO25lV7rr2s1Sq4K5HIuk7dpExN39FM5x6YgRgEw
         Sdtd3OKUIKArEPOO/HMny0PNQCuflNutmSdA93bfFMDzMHH5dKzvy68BhLGsvEq5wRoM
         flzjFBwVWgj+hVwlvJrMCCUTboCi6N4k8d//fcbDdBUnpxmVidj/hmXQARnInTtJuFkj
         433y6pvhCeJKeGtSX6gohh1LlmRzg/Gvj/vyHbx4+a+FDsZUx12qQeh1VkRn18E8JPX9
         6iZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722978893; x=1723583693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rh41jvzIxJEsvibJ0CSaL6FFeVsrsO1w8EFTwMPrzo=;
        b=uJWAhrPwPyNNKf4dlRf5h4W+VaZhjnwB1HpmPTl4XnOmgNBkqmAT22mJGp8azdZa5F
         KssjzDaQo0gGFvb91VrIJtFSgYzzLjqeCsSuKBjpAEeDjnAXctzcb9hVexaxv/+4wKTU
         +DOripabTe6tQ7MKqcAjnLZYr4Xlh2hSEgDAD1yQ4ZlMoYFb04nWTQFqSkpSa+2Og5ZT
         LOkclngUofR4KRPDd0vt5aNx0QlNdVmlZFn9OBl2PpzOION9e/Q3+uejUE0hWNwq0HlO
         qWLW/TWctOphRwVDNscMxS2r1l5LsIPlCjhcj+JnNoSrIx6+dTfKs6wYlcJa1geSl71x
         jJaw==
X-Forwarded-Encrypted: i=1; AJvYcCXaAJoV2bE4FDbWv5m3Y4adNosW300FAbt6CKxutTf5fuNtR1vXngyiWAz7a3ILh46zxRcBcd+W3+pJi0HmQ9nfGh58rj1Bp0A6jO3k+OLZvbM1r1CJe9q0BvWIR3A=
X-Gm-Message-State: AOJu0Yy3dJrQhO8EEhbFyu6eMpS47LCtxzCwVsjHbrsHqiXtBY6xtBXA
	ETp7IoNnOuGXqm4LIvJhP5Y1omTN0kxwM0i8DIcjNd5+a37lHQRNum+shRai3d5FktG+fuCjVg6
	a+mv/b2NS/w0SLrEd8kCkbc1NvxE=
X-Google-Smtp-Source: AGHT+IGlaEX4zBGAQOzFZ8UxWiEhKKhxKoVQfNV94CY7VWHsWQgedWZMs370He/eyDvIZ8GBiiPKDdFJ3y5qLobFQko=
X-Received: by 2002:a17:90b:3b8a:b0:2c9:5c63:29f4 with SMTP id
 98e67ed59e1d1-2cff9469450mr19399363a91.25.1722978892680; Tue, 06 Aug 2024
 14:14:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240806150619.192882-1-ojeda@kernel.org> <CALNs47swnK6je1o+LOLUFCDEZJmQmZx8vZ+7MPvUbNKdFr_Q_Q@mail.gmail.com>
In-Reply-To: <CALNs47swnK6je1o+LOLUFCDEZJmQmZx8vZ+7MPvUbNKdFr_Q_Q@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 6 Aug 2024 23:14:40 +0200
Message-ID: <CANiq72mRCOq2xfhNMFg8VNBv9+KqoFp9hd6xe06zb9uyH+YfJg@mail.gmail.com>
Subject: Re: [PATCH] rust: add intrinsics to fix `-Os` builds
To: Trevor Gross <tmgross@umich.edu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 8:30=E2=80=AFPM Trevor Gross <tmgross@umich.edu> wro=
te:
>
> Should this link have the `[1]`?

Yeah, good eyes :)

> Reviewed-by: Trevor Gross <tmgross@umich.edu>
>
> Also submitted a fix upstream https://github.com/rust-lang/rust/pull/1287=
49.

Thanks a lot! Linked in the `core` sublist in issue #2.

Cheers,
Miguel
