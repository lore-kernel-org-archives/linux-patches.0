Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F97189528
	for <patches@lists.linux.dev>; Mon, 25 Nov 2024 09:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732527184; cv=none; b=TWxTKblJfrSuCqDyJlYHg4nqFDSOsf0nw2XFOvYJJDPlJPrjFIKW/grTJE7qBpDQlXm94jJb8LDYoriBmnjEyCXpwrK4CUhKJxTAXiWO4j12bdsIW+coW8cMpwVnCnhEd1zusbJVyJtHowvdXjeBgyPA6pDyg59hf886BYZLFWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732527184; c=relaxed/simple;
	bh=iJhCiDk4FV6a8jhD1x9FdWaVImExu0N+arblA6KpRYw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HJ8DKy/ITnPed46+7lJ8LQ044W5gxBRtn8swKCcBCpSBiBxk3mQPBa+8sy9jVZJmOWlHW9DDfulQKG0/d8CUwYExy/W3VWg/CqqWYHS827x0W7r8yAriw0iwESoRs4yGvI84V138lUPcu1SSRX8cx5dB0jBT4P7yD7HJUZjcGL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vlXxqe6s; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vlXxqe6s"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4349cc45219so10660245e9.3
        for <patches@lists.linux.dev>; Mon, 25 Nov 2024 01:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732527181; x=1733131981; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJhCiDk4FV6a8jhD1x9FdWaVImExu0N+arblA6KpRYw=;
        b=vlXxqe6s+W/DXETFCvVvKh2zA7nqtE3bmzDbOieivlvRdWSP87oq3qha+Vb4CIpdW8
         HJo+deojBbdcps3zn6YfoWn6NYj5q/74gd2+SJSyrTTXy24IAPfRzLaarNiC+DJjXK9a
         whOXw7S8IFLLTpKBlOS4htLdZzxSe31otoIpshp7TUBmBhTJ2tu09bQblfMeT+oZxRRc
         3sEcXuvFSqKZo1c2qOzTFKvHwsIk0mnIeUmEy/KEb3oXaVLAZWBPJcgP53jgZFlHKQjI
         +iuLdR3HUqIj7IqohNGyT2Sxqlf1axRY1bDz3FJ16eI20SJI8So6BMMqgQpNz1IybMMc
         uzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732527181; x=1733131981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJhCiDk4FV6a8jhD1x9FdWaVImExu0N+arblA6KpRYw=;
        b=t5A5DcsMHsXKitQ81b4XgOvHPcuIwtsrN0pge1RBXAY/oPI+Wf8h4W/bW7QXAY3Yfi
         fcw039p6mMZMPuvru2Xzt+/I4jaCkR8yCbYWZQfdz2WdLYUdKqCfooTRQu+TvqrkYz52
         3/qCP3CfJVw6kyScVRRN1i8e19yC1M+v/4PWdYQTE7Y6KEtHV4Bld9D59ikF+RHeWl5t
         mK6ea/dM3//0XuBrv9Reh/br67rDpGN+yjFMMpUms6JJBbDSVpO/I7hJGqBi4Irg97iu
         oNQe52XmqhhKXOoYyRRsH9VBLzhVkvgNPeVkGz2r0BPtmws8DAamS01fawTpz5ZBPCso
         25ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNkbfUsakIW/eHylPk73toQXpl5AGoZm5RUUDQ2aMQqqdBBC5VulWDHGhCV/GYwom+xUBs9iKV@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9LMo9sRUWp2UDtZlsW6joi/LgnNtdDY0SLQbdlMFOPtz6brMm
	usCD6X2XM2pQb+HfpBeBnR7+B0xMw9u1hXQCw8mrN7mFJfb3jsr0BIqxBiZIoRBkkWHAYMlapLE
	X0McBIPdWxj7IeFCqPmjQE+RVBU006iCRRqtQ
X-Gm-Gg: ASbGnctXDpIenyUj3mC1MSmn8w9xKLI7Xa8ZqyivTp5IleQAqEw+RXeihemjjQx3r4i
	5IF19b3BBtqs8QtmqgyvjIWLNxWadLfBk2q3rS73MhRl7VYIN0twGRZsmsz1YDA==
X-Google-Smtp-Source: AGHT+IHk2ePzXk7rFVIBNN5xp9LHxdFZTmA+UEnsClr0r4H+EBABd5CJ17K9erfSX4yaztpTHbj05WlX4/9ds8MqiC4=
X-Received: by 2002:a5d:6484:0:b0:382:4ab4:b428 with SMTP id
 ffacd0b85a97d-38260b452famr8130184f8f.8.1732527179739; Mon, 25 Nov 2024
 01:32:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123222849.350287-1-ojeda@kernel.org> <20241123222849.350287-2-ojeda@kernel.org>
 <CAH5fLggK_uL0izyDogqdxqp+UEiDbMW555zgS6jk=gw3n07f6A@mail.gmail.com> <CANiq72nKgj0n84Q76FSsPSeaupwgEKBT0GQbO8m-KHKZb103gg@mail.gmail.com>
In-Reply-To: <CANiq72nKgj0n84Q76FSsPSeaupwgEKBT0GQbO8m-KHKZb103gg@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 25 Nov 2024 10:32:47 +0100
Message-ID: <CAH5fLgiUwnNE9fP8SFOBY1OeKDhb8NGPSRjSxQaL5fAYb7nAWQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] rust: kernel: move `build_error` hidden function to
 prevent mistakes
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Trevor Gross <tmgross@umich.edu>, 
	rust-for-linux@vger.kernel.org, netdev@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 10:23=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Mon, Nov 25, 2024 at 10:14=E2=80=AFAM Alice Ryhl <aliceryhl@google.com=
> wrote:
> >
> > You could also put #![doc(hidden)] at the top of build_assert.rs to
> > simplify the lib.rs list. Not sure what is best.
>
> Yeah, not sure. We used outer attributes for the rest of
> `doc(hidden)`s, including in the same file, so it is probably best to
> keep it consistent, unless we decide to move all to inner ones.

It might actually make sense to move all of them, I think. I find that
they make the list difficult to edit.

But feel free to pick whichever one you prefer for this change. My RB
applies with or without it :)

Alice
