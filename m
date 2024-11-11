Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAB11AB6CD
	for <patches@lists.linux.dev>; Mon, 11 Nov 2024 20:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731355209; cv=none; b=W2GEnfHkSH0ebGQVf3GpQw6YhM4j6DsgtVeK0dmLjk4XoB//o5kab7KPwv2G40ML6mVR3BPw4GzD6mSAIUP7/fJ5Uk0Mgs8I2qq44T5Y34YEx0qjiLB9VRr7+jSW/mOhnNTamzrsc435nGwOswqwNF0WXpWPUf/C6al2E8ehB2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731355209; c=relaxed/simple;
	bh=WiOrNDG1WD7oZEY0fUAmYsOz30tIJ03LDcgV3v4oLu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JUQ82H5d3UpyEgNiLk+dObKgfiIBi2cxw9TL2E8YTgNYA1eASjyU+nZzuyhqSga1SxlbTsiyUMg5O5AB8DzFiKHlzQxWEQF0g8s0hHFr/EY2jAXh7lULHOtuDjx3qCCKSOqPx5wAfF0PKnUtwvXwHV7MPNKn1c+aymU5fp5G+kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nLIibMPh; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLIibMPh"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2e5b1aaad96so614592a91.0
        for <patches@lists.linux.dev>; Mon, 11 Nov 2024 12:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731355207; x=1731960007; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vcFeO/WZBic4QahIcKveKriqrYB+4GqvXPKrBYwpRHM=;
        b=nLIibMPhftRPBJnlV3kC3U4Sqa0LgJoLn26Fxxa//uGcqPPBlncxxfPZwlmdLwSXza
         BYrfeNhoClcOhusMezwTZ8jFkN/dVCJA1T16p4eBP8Sajmgrb5OU3R1ozW1xRu6aeFs9
         xbR6HWdGhpfZXytp9pSLUrsR/Ix1KVpGeyNF4XDqb0Bp5Wcj03snhixhwJcyAY7AS/6r
         WgsOzxx61stmU/iq5+x+tyQXAhazOCxgHnksqAxW9+jBL4Y1MZcOM/DzqT0RgZpJG3lQ
         iahOGPbj4iqWPvNMrhZehGflsqBW28FnAE0RrQPGU4JrakGY2CAcfvcr6Yv6DCA5Uxw6
         qvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731355207; x=1731960007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vcFeO/WZBic4QahIcKveKriqrYB+4GqvXPKrBYwpRHM=;
        b=L5VrQWbiuq0jf0JloJOIyMY4X5xmzM6SoWmIfKdS6XqP9xTD3JhUNONfrXsoaRQgfV
         g5lrV7fJAP2h0M24VT2qMw2WlFv0Ai+dsWIXZVCEN8mxgLKhRKBT3lAKmEXlkeobD/V1
         jdTWH2VJL29yKX7F84m6058iz+HT18mHlzuylS8o7cjt2IskzPSx2pO5OQYh1zKQ8xWm
         5EMkT5S1TzBYvBXVPU6Qpf8c9DiPQs/WE3/QdXPJzhVGQI22Q9LxvdcvKffUwLW1aGRl
         EprzfPSo+MbPoXCWetORempUqycgevhTS/dpi4tPvGl9g5PHm9RhRe5rwO9qYDf8XgXQ
         +qsQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9+U1cdrb7C8J5nf7tpqsdUkhptGo6w1guMqhgWC52Lrv2Uhhz7bIx+0OoD6RZIAoHbGtcrr2I@lists.linux.dev
X-Gm-Message-State: AOJu0YwZjdRDV0cSpNnJ9G/JEd6aqosy6cAU1jw/UphAzu9OXQ72UE4N
	0It4sNKXkPc610pRx8sgCqKRJZqI+USwxQGqvGScCnrzpnnvWj/rrji0FJ0qP5a+1ieZtaJVdsV
	zjZNwUjOAW/igRuvxRv/GHIo/54/DOHBL
X-Google-Smtp-Source: AGHT+IHCla+3aT64d/PQpp3F34xwPPb0N3eP3FUnIcHUDvmJpi47dsbyQVEnutOGTkU/YrE5VMyCX4YDA0KOHFn+YwM=
X-Received: by 2002:a17:90b:4d0d:b0:2e2:9026:8bee with SMTP id
 98e67ed59e1d1-2e9b16aa2e8mr7616013a91.9.1731355207362; Mon, 11 Nov 2024
 12:00:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241109165520.1461400-1-ojeda@kernel.org>
In-Reply-To: <20241109165520.1461400-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 11 Nov 2024 20:59:55 +0100
Message-ID: <CANiq72m_jUUo1ELwyn8qqXUDNxvCfPbv0NVRAxuAyjzU8o02ow@mail.gmail.com>
Subject: Re: [PATCH RESEND] samples: rust: fix `rust_print` build making it a
 combined module
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	patches@lists.linux.dev, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 9, 2024 at 5:55=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
>  obj-$(CONFIG_SAMPLE_RUST_MINIMAL)              +=3D rust_minimal.o
> -obj-$(CONFIG_SAMPLE_RUST_PRINT)                        +=3D rust_print.o=
 rust_print_events.o
> +obj-$(CONFIG_SAMPLE_RUST_PRINT)                        +=3D rust-print.o
> +
> +rust-print-y :=3D rust_print.o rust_print_events.o

Steven: if you have not applied this one yet (I think you didn't), I
think it would be best to rename the main source file instead of the
module name, since we already have users and a couple other places we
should rename.

I am sending v2 in case you can pick that one instead.

Cheers,
Miguel
