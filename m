Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8B916F85B
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 12:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719923281; cv=none; b=UbD1FAVbbX4r2A5AuoTbHTiTi9gLX0p36XihTl5ulFWmTfc8xRAdbtqZmA0nIESCQGHcEe3MBJMMyX+ClsyfQK7oRLTk5hOmF1cAUYITI/WZrkQAE/AuEiMDRGrJr7tIf6Q7PUtUPuIjoZxtCCYHBtijN6H4L2/fcJD7fHd7pvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719923281; c=relaxed/simple;
	bh=1v5lOVUChevQP+N2QZWisjCxH7AUTxAWh+Bnio2PItY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cD7bo20eeyhcXh2Zgmkym5lY/8K8Re5s22y1+HRHTfWDIeJuj5pf0XJYfilwFy7AN8K6VohwG/3cjesFLAtMjBShnygZEJs7eeoQSIpq9uc1CCi7nWDHG1APkbNlCIY25HTSaMAiGqp8ug8rg2P91GcjQZUS4ERGFv5fjFb37pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cwM9n6RZ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cwM9n6RZ"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-425814992aeso14378465e9.1
        for <patches@lists.linux.dev>; Tue, 02 Jul 2024 05:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719923278; x=1720528078; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1v5lOVUChevQP+N2QZWisjCxH7AUTxAWh+Bnio2PItY=;
        b=cwM9n6RZCfMKUMeSAGuMIfM6g2MrD+5qrEsKj6ez3e+6xSG55/uJrmPRcxPZaEEx5q
         HhmGr5DOePXOMzn2cbJW9qk1lr/bBwWnaeBAdwXjABAL2BbF2sS6Pg3ZVWx2r7Jz3IW7
         xmudmWEIG4QGXWLqV712F25nVe2lLx/MMgXyquDTidDLgVeficb6/JmmsLktc9PIFJtQ
         qfva1h+ouXv7xoCrD5Is6lj1LowJ6DIr+nM/C0UCSlG0pBmb8ovOH4nY9bPWpLs/M4P4
         oGkF4DbNNr5NQQREy/mZ8mDUansSqmjUY/imRjiiu/9sG/W2+/RYVsjbqOyHuD0CS7I7
         bgfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719923278; x=1720528078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1v5lOVUChevQP+N2QZWisjCxH7AUTxAWh+Bnio2PItY=;
        b=E+DtbALG9eKeKgNBk8qTxKa44F4+KDBrzZ/y4JbqepJpkOfNlQ3iEG1B/bZb7wFAOI
         QsKJdLHP6/X0LKwsKjECHh/rPn6aQA4d/vILkPu3MjXuLTWUEQPE+mmlcLohiL9ihYBe
         biDmzJwmWqldfFlvgTRxmwHT0iKDZRoW4Z+NzPt7QwXqsPedWL7QRduAt8GjZo7CLuj9
         ZsZY4EhWK6v/KAXLT8yNoZqzBtTIqKDiaeUHGypwb1kmtbRpkz5Z5+jUdunzKEJqIbh3
         SGcWWsCplA84+pbdc2rlpXbC5fg4dU/5YjPAraxvObKmq2HxVWKETVL+apJV7bxN+Nzi
         /qRA==
X-Forwarded-Encrypted: i=1; AJvYcCVEaxuA7UVPoeGNYNpJcMb/02J/sFyWZdjsDJty9VzC+bjbKql4Oi1r28VQzN4dV6CqL9S7LtTvNpjZumQuTyqeXaJA4GRYHw==
X-Gm-Message-State: AOJu0Yxwut1hGsbIbU+ABPJE6omJ5KkqXX8dFDmGDOZvfiw196vGwt16
	8TM4R/jfGGcy11otxcrusop54Id7GdLOvSuebdBTFk4GT6m2ywD1Rt0fTTy0fcpVC0b4LbNppzp
	5fJIFGydSASctEDvYrGhX/8TKZntvONvVgU8L
X-Google-Smtp-Source: AGHT+IF4qZD52kZRJjBUJxyc2yqwkhHDch0UUTYE9b5JxPadLBBqquNx7emNw9zg4DSnlg0OkbPdmI7A1w5xcyHHBrU=
X-Received: by 2002:a05:6000:1045:b0:367:13a:5276 with SMTP id
 ffacd0b85a97d-367756ad617mr5683027f8f.20.1719923277752; Tue, 02 Jul 2024
 05:27:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240701183625.665574-1-ojeda@kernel.org> <20240701183625.665574-3-ojeda@kernel.org>
 <ap7u5hpgfdzYgTkobIleYc0uolBIsAVbq56CwMJG6k4x57wXeEtu4fpLpgSOvQtbJHvB6D0J1wlBaqDV-xt2owlVejhfABUv_ivILyJ2J9o=@protonmail.com>
 <CANiq72kMaPm2OsGb3o0VUtdoMhSUoo8QEsCFzVjYFtCThvNJ1w@mail.gmail.com>
In-Reply-To: <CANiq72kMaPm2OsGb3o0VUtdoMhSUoo8QEsCFzVjYFtCThvNJ1w@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 2 Jul 2024 14:27:45 +0200
Message-ID: <CAH5fLgiApXtur45Uz+o+xOTX4qqFAf6LnB+Csz2-0CGmJue40g@mail.gmail.com>
Subject: Re: [PATCH 02/13] rust: init: simplify from `map_err` to `inspect_err`
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Andreas Hindborg <a.hindborg@samsung.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 1, 2024 at 11:58=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Mon, Jul 1, 2024 at 10:05=E2=80=AFPM Bj=C3=B6rn Roy Baron
> <bjorn3_gh@protonmail.com> wrote:
> >
> > The formatting here is a bit weird. I would have expected the ) ending =
the inspect_err call to be placed on a new line given that the unsafe block=
 isn't placed on the same line as the start of the inspect_err call either.=
 This seems to be a case where rustfmt mostly gives up on formatting. If I =
deindent the comment and unsafe block rustfmt will keep it that way and if =
I add a trailing space to the inspect_err line it will keep it and emit an =
error that it left behind trailing whitespace. Maybe add a block around the=
 comment and unsafe block to make rustfmt work again?
>
> Benno: any preference here? Or even open coding it.

I would open code it with an `if res.is_err() { drop }`. Using inspect
for a side effect other than printing seems weird to me.

Alice
