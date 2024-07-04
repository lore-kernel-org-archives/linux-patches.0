Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9237F1A0721
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 15:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720106566; cv=none; b=ArnN7EYX9G9y2+SCoiElkGB+GBf0wBgD0SvDYLSNGaUFW6ajboQEsLxDdy+l3AO5w+cGrenO5vF7/caSKvwLZS6ZnIbGd3STxzXjqqMIlYZPGlUuEecPLXmicJLF6KipXjn7/rj5gIa420O66j4zmJs3MxGt17M07DITufRCc/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720106566; c=relaxed/simple;
	bh=wFHhVJumckKsysKCIZR45w+PkOdLpxaZi2rmHtCtQr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S6ZH/F59e9bPQbhDKQIporjfD5F0jPB8DWe2WiBZ47B5V2s+Iyl/XgTtTrE6XqSn7bGUveBHvqG9vMzbGpoYHBxseU8+xJ6eH3W9r1TkM/4pKLUE7vNBz00EWpzBQPJngSCUj1O5mq+k4xWkTKMqM/9Jy2bIhuBoWGN04GqHa6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N90hbI9y; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N90hbI9y"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2c97ff39453so560050a91.0
        for <patches@lists.linux.dev>; Thu, 04 Jul 2024 08:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720106565; x=1720711365; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVFK2WSYZ965lLjkevQH4tcohQ9krtqpk0QXLUCUgcA=;
        b=N90hbI9yldQFXghuDtgXxI6+3QFoKGO4/ifvFAOonlImEFxVtntg+tIJYzPWwOY9wa
         gXA7odkGBAOSapvXHDF8w+mpJjZn2PhB7tT6WisuYoK8mKChp0lpDjF/ImgeO45zJdNy
         FA8BRaMiD2TAN+QHoqPjKIaFvaT2wABSSuTM76tcsR4AhrAlyEMtjggqSB2Y2ASyKJN+
         pHahq3seQIJlyncpxiyFyFDuSa/EDfwnk7SX0ak92grpAW/8WBXicV6wFLGkD5ZBC/R5
         aWUdLNmXtLI4D3tFFerThSetUfi7mN/+OOTGvtf4EK2Y9sgU6NsjPVUOoEZiBWB7MM8t
         v6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720106565; x=1720711365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xVFK2WSYZ965lLjkevQH4tcohQ9krtqpk0QXLUCUgcA=;
        b=MQVLLild1PbFSBt1IYcdR7FWHWz2HmyEkcGELAh3hkAtglKBmeocbitKbgsZfEsRZs
         I4L96+ULlQofJs7PbSYx/DMJ6zQ7qHI9pL+7j479nKP00zYsmRvA8IjYsRo5b7EpixCW
         laYbtb/9one6eecafFQhUYnXzKd/z/KKoXzNP9AW6mLhKSDQ+XfSxWglVpjHAhGbMtNA
         4SnoUVXgXl6IiaT90S6Ds/IBcmbiuRjS12dBTYlXSeeYDCXULoLo0g0aodbeY5H0gcTv
         Y6BvxAS4q2mS0amAW534VWw9BMycpPE9n3qT8UIUxvxfiv8dP4YrAVU4b2Tl/Zi/ejP9
         DMaA==
X-Forwarded-Encrypted: i=1; AJvYcCU6sbd9Se+IxEOdMiPklWpk12krBEVlcYzbbp2eW+r3+NJaAVLJ+TQNtFUfeVYF5/n/I3uwgMTCYMUqNU522/Ss+mwH6NyepA==
X-Gm-Message-State: AOJu0YyHBa6PjHOGjOG220wqk7PTSCNeZW0tq3aeKgkoWADG+jcpELsz
	5XnpGOxf88Du5sSK2kE4yGmEQn0xhnMV+d9J0YUzDp6LRu1rGVqFyd0IfgEnF9HpLEKgrOI4Qgo
	PwHLJlDw1Z56J8I9T3Ph8P8OqzcU=
X-Google-Smtp-Source: AGHT+IFfBoeinZVknPJ2qB+zv1AA45Y+rwAXZJ2EypvSPSD3MCuzlu8qe3Z/aXwaSOKHiC9JvGHvi//0bilEXU7z030=
X-Received: by 2002:a17:90a:f2cc:b0:2c9:8f97:d2e7 with SMTP id
 98e67ed59e1d1-2c99c6b91d2mr1536223a91.37.1720106564696; Thu, 04 Jul 2024
 08:22:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <87ed8a8ka3.fsf@metaspace.dk>
In-Reply-To: <87ed8a8ka3.fsf@metaspace.dk>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 4 Jul 2024 17:22:32 +0200
Message-ID: <CANiq72n=dF4Zzpoq9zpQ_Baapy_MXYJh3OHkuDRAySCThCh6Pw@mail.gmail.com>
Subject: Re: [PATCH 06/13] rust: start supporting several compiler versions
To: Andreas Hindborg <nmi@metaspace.dk>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 3, 2024 at 7:20=E2=80=AFPM Andreas Hindborg <nmi@metaspace.dk> =
wrote:
>
> This does not set a max version. Will older versions of the kernel
> always compile with newer releases of `rustc`?

That depends on how many changes Rust introduces around the remaining
unstable features (as well as plain bugs in new versions, like for any
other tool). With the kernel being tested in the Rust pre-merge CI,
hopefully we will reduce those to a minimum.

It is also why we need to keep reducing the unstable features and get
into stable Rust as soon as possible. The Rust project is starting to
support us more here, and they are setting up a project goal for
2024h2 on their side to resolve the biggest blockers for the kernel:

    https://rust-lang.github.io/rust-project-goals/2024h2/rfl_stable.html

Meanwhile, on our side, we can do our best to backport any workarounds
for new versions into supported kernels, i.e. stable and LTSs.

But, at least, this series should already help kernel developers (they
will be able to compile the kernel with Rust enabled using their
distribution) and Linux distributions (they will have more freedom to
pick a Rust toolchain version and avoid having to package another
version just for the kernel).

Cheers,
Miguel
