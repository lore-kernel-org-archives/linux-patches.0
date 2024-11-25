Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FF8190662
	for <patches@lists.linux.dev>; Mon, 25 Nov 2024 09:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732528598; cv=none; b=gu3Lj7foV0DlrqzqDe+pxumcWqHW9RMA3HWd+7c/uGfyC80vj6l8XHb8k0C9C4VIjJqL+jkg3gYfqstPWA9d+XkklJ7pzjmseRGYyjelEYT277YVn2xl8gUtCXhTV0PrZZs0BQgL5Z1fT8z0S5JMZu8Bw4AMVMfwDMsScgifCIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732528598; c=relaxed/simple;
	bh=yYZKNyVxriMi7AV//XVt0PIe+AMXWo5WmgtYsMcdOx0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uURI9XgOi3Y/G0yP0dQPJY2KGQqrKNlx9gIkTF0Q/Edk4Q9iaaXCAqU9p1NoqQGyAHQtxAVrZZ9d+TIFiWmqh2HnjmxbDSf0rxa2YCnVuMroEWmbim+mtt9qflno2o4qXUktKHi7UyLjWBvrssLtowMWRPZk8G/wSZg/Ln6Ce/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mHQivfCD; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mHQivfCD"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ea93311724so654607a91.2
        for <patches@lists.linux.dev>; Mon, 25 Nov 2024 01:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732528596; x=1733133396; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yYZKNyVxriMi7AV//XVt0PIe+AMXWo5WmgtYsMcdOx0=;
        b=mHQivfCDC0pgwqkL74fRhqceb72XydkJFTS3vI+LGdQhETYWvhM1OhKp60lHyhqHlc
         QuIyrDJDIt9t3wUYSriNyEbZ0+er9EyFNQShGhy6n6jXY3Pd0OJ1R2wp42g4yfeOVgcl
         AHtyXwZtgUOXOCdEWA9yINVzbJ0Wu/0mXel1CFH9qL4RRZXG9xcwv8Im8QSx6Q3XFhYs
         JgS1/CLUwr3CbR/LTDeohn432BSxbbLG7wi42teA20vFYXNLBcOToNokKNyebLlhmt02
         /w8oRz3pQjPCcFZfUp+hy7ydtkSOJ6mG+at/OJZj30qGKNg0JRTaYv6rI4SDLqN587QS
         ZPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732528596; x=1733133396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yYZKNyVxriMi7AV//XVt0PIe+AMXWo5WmgtYsMcdOx0=;
        b=iwry/nfo2yjzqaIS49AZhSdbCaPkcFCdaKWstN3hdINGVTLTnxEoD+pG2ZzOTw3kHS
         1QnGfHtwal38c5mLz8Dg1XusuHIkymtKswY+7SozoDOn7cPJy9bOPSihB5E0Xpx9rkel
         UIfhMzVWOYg8Z+kmGtanfKej+7SkEoYYCtqpdotznMB3AW/2A98wjoyhfWrqaajH2i/5
         CBEPNbOC/excuxYYhBtunZgVcMsx7g42lVLgCoyZwORN1RRZzLDtQ3vfqEthg/Y1+p75
         pWBAFgdokMjlk1g9ZlDyGlQpoVqama5+ij3/A9/HTvEcEK4qvC4ySWhlnY+Z+O3fEWvf
         FiZg==
X-Forwarded-Encrypted: i=1; AJvYcCVYgiaTsT9d9ueGgLYBQ4aIPQfHBytlNfTrM1b29mkEtAwO5KB6l1DR7EYZUWGVMGHX3nNOXLIr@lists.linux.dev
X-Gm-Message-State: AOJu0Yxw6ahC34COeWaLN2UQo+0a7s5cIFnfMZaMWEUXpUsVED3Ovajo
	udCmt11lfHlcT9ggTlEqmOq77vHdqnflBfBntWuvQgtcIJynsoq/ZGf1AoaP96fdNO0Mm7hl05c
	m3ZloPchGjhfFm+wkwzJa9R04Yn0=
X-Gm-Gg: ASbGnctEkYkImodNRwhmhFdyLZ15lZ5cdEGO3M+2w0f4NWv/iiQC3ko38a04mY8KOxe
	ahsxnZFLv2qBL366gMQmU0eAgL/DE8hY=
X-Google-Smtp-Source: AGHT+IGaoGwCojAvQSCX3mdAqYlWAsTQexhHed/lggWkPEGb4m+hlgXa8w0huMdKx9oXQMlgU9jzhU5CZCIRge27C4M=
X-Received: by 2002:a17:90b:3c08:b0:2eb:12ee:cf0b with SMTP id
 98e67ed59e1d1-2eb12eecfb3mr6003337a91.1.1732528596262; Mon, 25 Nov 2024
 01:56:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123180323.255997-1-ojeda@kernel.org> <CAH5fLggg5f0KpaObVtZc7WaxHjUqbhCDsn5CwnA5-3df2HEjnw@mail.gmail.com>
 <CANiq72moPEL5s0T3ELEDvWiE6Lz5oZv2hZnziV5A60EP65bkkQ@mail.gmail.com> <CAH5fLgjEDXHGLf+fAyzZwGtX+sjuCst6P9Eg_eyLjujd2datYw@mail.gmail.com>
In-Reply-To: <CAH5fLgjEDXHGLf+fAyzZwGtX+sjuCst6P9Eg_eyLjujd2datYw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 25 Nov 2024 10:56:24 +0100
Message-ID: <CANiq72migNNeceZ95fJ4fKfOimD9hymdisvpqL0imAnjgVyxHw@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: set `bindgen`'s Rust target version
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Christian Poveda <git@pvdrz.com>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <emilio@crisal.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 10:45=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
>
> Sounds like this might need a backport to 6.12, to prevent issues
> appearing on the LTS in the future?

Yeah (I am not sure how likely it will be that someone hits the issue
in an LTS use case, since it requires using a `bindgen` that does not
exist yet, even in `HEAD`, at the same time as an old enough `rustc`,
but it is definitely possible, and life will keep surprising us).

Thanks!

Cheers,
Miguel
