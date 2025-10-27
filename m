Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACF72FF679
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577432; cv=none; b=PHiOMUDREIIogZ52Nmwn1Pyb8Itj2IPKLlUSTwtHaMZ3/A8oU9We55ThC23Yt0VrZHDyAflgdTRQq3nw8Mysnr0zptUJL7pHns2Gk+DutfHREI/sf/bwiWAYifZpIlplwHGjSuDggJRBBpie4wHAG8GlHVTsjqjWaw+VPNuEx/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577432; c=relaxed/simple;
	bh=DApS4hcsGD3zyYGWIsdcOdWVaOZg+1nVqfikxiXnXSk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uirCYDTxK8KpY9nxdsKXbl/1tYl1/cyZj10FuDm14dnaCG8jJDIEWI/NnzlPvabahetXfp1xHvC4VCHriw1S7IY5IWdjbvb1pYtmOpV1RSuJKJdMF0fOXhMRivbr/L3CSHFIzNy5i+tU4XeRFq+kwT3f70pVRm48qjtOcE32Jmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HvKAo1ad; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HvKAo1ad"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-26987b80720so8366825ad.2
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 08:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761577430; x=1762182230; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DApS4hcsGD3zyYGWIsdcOdWVaOZg+1nVqfikxiXnXSk=;
        b=HvKAo1ad7TFIM9wDg3HYeunuIqwaaEQfFsaUnESgudf0dbkAyBoP6tds8buPIaDF7Z
         GQ84EJH7CARZ8h359FsFikurS9b5UewsOSudEWxP6F+M0L9Tn7gc7l7zaoBikjHxyTr1
         gihmzTbDZE3HiZiemkCAzIjDWNHfnz5tMXTl59sp1I4q/uu8/wgsNDpFmRxO4kWAxuet
         652qBDBJ54AIO2J1QIg0fDz0L2nAku8VBPdQ7Bnfem4SFVWfFGqw0mLGlk/U9QbWkdZk
         Ze/CoGEYPXGlVceY9FAxQ432RxFRY7vEuGOouFTgLjc6BjdGJzuLuMCSiPjM7KVuBGUN
         FYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761577431; x=1762182231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DApS4hcsGD3zyYGWIsdcOdWVaOZg+1nVqfikxiXnXSk=;
        b=Ufr+DkyufYNducdd58yQwkwCnWWISB3dhh+8gQFpEaKbJxLmcaaUfw/lVS/lBe1OpO
         ucNDOSoU8rhKIe6QfHicsMVZW/ws62gJf1GDgBWKRsZtWcHRL8raHbIaEbo736uze+tB
         ozJLpCwrHOTmmnDNb6mqGBIaCvZX2XJmjlw+Icd3dd4XZ1Hpf4Rhf8lf9W2JJuPpIjTn
         gQwysbMSC0PWu4CYMRzui/jWjAXYjnt/8Q1vllEXY9lvvda9byAuQx6oiyoCzy+5rc3t
         I408MrZXgGaMBH/eAtp9hDO4s9RIMQQKjreRSnnIazzm8z4BTug2fPFzXc7yjkpmZtCV
         EzCw==
X-Forwarded-Encrypted: i=1; AJvYcCUgCi6bEemExk6WdpvwxRbTIoBhtSmedkjAIt0B3Mn1eOW1mvlM397ZUeeTzceFmHYjKO2JXZcB@lists.linux.dev
X-Gm-Message-State: AOJu0YxC8FU5v3lYS1DNoCB2Fav5uqKtB2OGLtAqe6tLwFn6eKLaG2cc
	hA1o0TNDKCzM4du9hpnXSXYG8EKdOgzyGKN7G+R/Sc3NejCYmF/BGRV7Hxs6JRXrlGjbXsQAdcQ
	ajz+WlYXKOShmBHWtVCGWN+bKN1Cfkh0=
X-Gm-Gg: ASbGnctjbHxOFdY/Ih0ZxqP9U9cQwEvcmkid/Atq6sxddoP9OI6p95+Qoci0WKvfJAp
	LzM9/nfoPCD7RDmvLu7k8pXH35N0uUlRee7gI2uLC+rXmLi8vFttugrYo1BJzRK27E5+i7G8IFW
	5JiDSbsPatsfgecMrfe4kN1fjuNsIwQfQkN+Y8An2h4YXJoaAOzy54GIx8/vSS64eo3kfG+bLvr
	zdq2cZlBc6azao3Ry5fH9C/um7ExgVN/DeyeAzYlXCotvbLpie4HcR1+3CpXNTwat+1uBzenOCt
	TidYcSwsprSUkloNZh27TSse/+oGN/xjFtfu0IVIBsVKk84sx253fjJbPpwDFOI1jcHwKxS9CnP
	JyWI=
X-Google-Smtp-Source: AGHT+IHZ0l03J1yw11Ees0ZvURyj2fdVG9g7KrsSHbaLFL6bHoHKGgLcoCtIOomRh9t9yoDHMruQdA66vlTUVakQCeM=
X-Received: by 2002:a17:903:15c7:b0:272:2bf1:6a1f with SMTP id
 d9443c01a7336-294cb38dad8mr1426145ad.4.1761577430243; Mon, 27 Oct 2025
 08:03:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251016231350.1418501-1-ojeda@kernel.org> <2025101758-mystified-prideful-8016@gregkh>
 <CANiq72nXw4+HesrgNqJjTy6Ji=pVqUMzx7GDO+6U9VYWezTt6Q@mail.gmail.com>
In-Reply-To: <CANiq72nXw4+HesrgNqJjTy6Ji=pVqUMzx7GDO+6U9VYWezTt6Q@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 27 Oct 2025 16:03:37 +0100
X-Gm-Features: AWmQ_bn7EsgCH1WfjYQWlmM5ETWJvrKP7qcsX_xSwmLv67g4Qr7Fxq14134xbNs
Message-ID: <CANiq72kn9HZy2kYaGHM9yj2nR+SAQ=J=Oh8k2doPFMDCRy1wBA@mail.gmail.com>
Subject: Re: [PATCH] rust: usb: fix formatting
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, linux-usb@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 19, 2025 at 8:59=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> They landed in mainline, so Linus' tree is again `rustfmt`-clean.

Pinging about this one so that it is not forgotten. It is the only
missing thing so that linux-next is clean again like Linus'.

Thanks!

Cheers,
Miguel
