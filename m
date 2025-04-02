Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2CE1F09B8
	for <patches@lists.linux.dev>; Wed,  2 Apr 2025 21:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743628179; cv=none; b=LN5mu+K/7nZ/8hR341nCyZHrID6Yv+TabYUJaWrIVk3KZ5w579oYqtdRq/Dp+Mc3vVNl/ta4fVztl7IJVv54vUIa89OtussvKuhL6WgsW1EUBmVPxfVOce42eOo68ML6alKuLj3zU6b8BQy6xqynmKiEZhv460cTdDAgP5jS2Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743628179; c=relaxed/simple;
	bh=pDdg2pUujsuHDByxjg2MMuLuk8ydhxrM9P7TiksmsU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ep4SuLNoIn4a2vbhhNfCTA/FJbdCc5DP12UMw3xkojR1jQG9D7fom6dfaCqZNvuJfk2PlQBgRFoSYaFKKqg8QhPfckHwCfkRjHI7WRs3zqnzEvgUm8LYOK/pcU/w8qg6Z+Qmy6ISYDJ3gBDVS2zOTkwjybQGhiz59bQqEGisMTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jaiOAr0S; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jaiOAr0S"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-30db2c2c609so2017241fa.3
        for <patches@lists.linux.dev>; Wed, 02 Apr 2025 14:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743628176; x=1744232976; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pDdg2pUujsuHDByxjg2MMuLuk8ydhxrM9P7TiksmsU4=;
        b=jaiOAr0S/SxbUmkLBMqr/OjEdywWtg+g1aXJ1ia6tj8u9AJs27maECmWoxHMk1siiA
         VBU77BI/Aw2mqB+SFJUbNxAH/MCmfwrq/7r66h3qMVQreCY+6u3SM/okgOyDvICY2gQQ
         3rqhab5O9nh6sKpHibTyBhMGjRR7gqTlSN6lp0v83Br509hlIp1nEXfGPMFNQInZLoAl
         Q82/w9ZasVQpcybSGjRzVGf9jtIpR4OlLBqjc1K1wp9YKAw0EKlayVpp/WwtBF/pgSTi
         8Izq9f+yFGZFrqK1oW+qet1UR9zFhh6derFlWSQNZwfLMyQs2VciPm6nruGzqyCnYC9O
         /z7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743628176; x=1744232976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pDdg2pUujsuHDByxjg2MMuLuk8ydhxrM9P7TiksmsU4=;
        b=uGJEN/lSRz5usUwgVH/uhTzIOLbecz5AdNNwm1zeJS+FlCxrEYz1mG3ZBFpPUcHXTP
         9EDNcVk4bzGX5XEL7B/fMUEPYQCPKnniOYD9VqZVJ0FhB6uAKG0l4tGt0+FylSaxbBsi
         GMdjTCyk7PWkknNZBjwzr0CE2fRAhIjWrtp3+MeKK4fABt3NtprnB4hyYEHI1uqF24VB
         uTfyUY6KT63GecsrLyRlA4WUHsKxjpqMdgBl2dynxIVbLZTsUhi4Yb8304PX2vY31124
         iBjdBJoUW+lH98HU0HKBh4yaV90nl3x61bzL+Tk3QXzOu3/iUEKgrBrJbBY+sV+aRpbl
         Mxew==
X-Forwarded-Encrypted: i=1; AJvYcCV9c8Z+VOSzP1lazkZOIRBvpys2oHnavI5iGwYK9JJVWaae0JkYKqRAXrx4rErN7w4QmNsWpMlV@lists.linux.dev
X-Gm-Message-State: AOJu0YzP4cahlGsNWwmBC4QRsjW4PgqWPnUmir0K7OonvHYJmeJPljSf
	w2idriVsItjNEwqMtXVCHsmJSzyekomeUVBStX9IzrUjJNGSLFwHWs7781NMnbgii6bQhJjflQ2
	eg1ifWki5ZHcc//LrSKLD926m3VE=
X-Gm-Gg: ASbGncsqtKYCOEfuv+8ip99Gnf7hp01EBe24myp9SxM0VT7oWLo8bqcsfAgRL4Y6s2K
	O4z5WReQ/a5wZ720tXMWxgeTvr+a8rxv1ZevMUhPcRXwIPFVpF7Xp2V501LadwXg6mragaJiPw4
	nJxNXbFgYca+AUZGKyoKfmONXnPoWPv9vxHMQGSb6+2A==
X-Google-Smtp-Source: AGHT+IElNaah8ZmJP3TMXN4F2GDMv6Ww8Z37dhvkzK+TjpR8HD1UlkHAgeiXaBGrv90H564RXc8F3aY70RS/85mde+I=
X-Received: by 2002:a05:651c:554:b0:30b:f274:d1e2 with SMTP id
 38308e7fff4ca-30eeccf60e9mr31325291fa.1.1743628175418; Wed, 02 Apr 2025
 14:09:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250401221205.52381-1-ojeda@kernel.org> <D8VPGBN60E61.1Z48FQW6TL3A@proton.me>
 <CANiq72mdvnHvWbVNQbiXSRxd1xrF+A=v0RdJO74xeY3HyhRmcg@mail.gmail.com>
 <CAJ-ks9nAAcoJoFF+qNPbhsM32kOh9u+LGYUwFN_n9qqudB6YhA@mail.gmail.com>
 <CANiq72k36Tvwbzkg6nRdxB8VNRHLf8QzLeCXZq7sEPewccsWNw@mail.gmail.com>
 <CAJ-ks9nfEg=sdn_-q+xOc+k9mU0pdMuumwRb76LXzE3RcOtg6w@mail.gmail.com> <CANiq72mERwbmXYq-pi=WUAZ_VYGcBVS7tzH4P5zSUVCMcL4-CQ@mail.gmail.com>
In-Reply-To: <CANiq72mERwbmXYq-pi=WUAZ_VYGcBVS7tzH4P5zSUVCMcL4-CQ@mail.gmail.com>
From: Tamir Duberstein <tamird@gmail.com>
Date: Wed, 2 Apr 2025 17:08:58 -0400
X-Gm-Features: AQ5f1JqXiOgjgjbHiCZGQl5CAfHUvDvozUzbxrFGGJDQOEgolwWGp0Hhm3b85BE
Message-ID: <CAJ-ks9kJiCGAkzW9M6q-62kcyvwBea5Zt2EoeeY0T3aN7jK+ng@mail.gmail.com>
Subject: Re: [PATCH] rust: clean Rust 1.86.0 new `clippy::needless_continue` cases
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Benno Lossin <benno.lossin@proton.me>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 4:29=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Wed, Apr 2, 2025 at 6:41=E2=80=AFPM Tamir Duberstein <tamird@gmail.com=
> wrote:
> >
> > The counterfactual is hard to prove - you don't know what true
> > positives the lint would catch. In my opinion disabling lints is
> > risking throwing the baby out with the bathwater.
>
> It is true that it is not easy to know what we will exactly lose right
> now (apart from what it claims in the docs and its examples), but one
> can easily test enabling it in a couple cycles and we would have some
> data from kernel code.
>
> To be clear, disabling now does not mean forever -- we can reevaluate
> with that data and possible improvements to the lint that happened
> meanwhile (sometimes they get improved or split due to feedback).

My experience in industrial settings is that this happens very rarely.

> By the way, the lint is in "pedantic" in Clippy and disabled by
> default -- so we are "only" disabling w.r.t. what we do nowadays.

> In any case, my main concern is cost: we already require a lot from
> Rust kernel developers, typically more than in C, and while one goal
> of the project is trying to see how far we can go on being strict
> about things like lints, I worry we may overdo it at times.

=F0=9F=91=8D

I don't have any new information to inject into this debate. It's a
judgement call.
