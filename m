Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCB617E8F7
	for <patches@lists.linux.dev>; Mon, 25 Nov 2024 09:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732526632; cv=none; b=oC+XDgYj8BVh+5dMjUhPhk6yEdZ4layxvpBUnX+w8IjB2A6dWDen3Y+NG+YE0y2bYNhdGJQkjdAMCEnd3uaCxF8jQbJB2PU3j7YG8+UTmY/C5VAS8xURMvS/T8A1tWe9Tc9EoX33KwZTWchG8QQsmCLrGmUYqjXtkF8iF9MPLAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732526632; c=relaxed/simple;
	bh=qcemhaF6dxBYnXBRHVDjb/MTiKC/YiHKVVAIRb06Rdk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lv/gbpxNuaamr2jGiIunex6/7j/sDXZOsXGyD76TwTl9EXwYeTHhw7ADf31fddfycv9d06CjOWBymeIj37hG16sBmHZ+htwpDeRKE7SgN2K4GGMXQCenP6VARlX4i20itVYtVpN1FBYRMsPMMAqK47z5PWBOeSAGQJ5T+Kq4bN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kgrxukv+; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgrxukv+"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2ea704b1c2bso714572a91.1
        for <patches@lists.linux.dev>; Mon, 25 Nov 2024 01:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732526631; x=1733131431; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcemhaF6dxBYnXBRHVDjb/MTiKC/YiHKVVAIRb06Rdk=;
        b=kgrxukv+Kl8G5yEtKjbRnVZpxoJoGHu9rfCAjCrlIZGvNdfUiNyU6qyFiN65yIOBfH
         rHlO/HY97vJP8L5pTriRbnObw4o62JGdRulm9ZsyK1h9vkDdn34qrIaJfyNCRxsbG0+2
         qjBHZ7Ubpgzpk4JNqQ5Dh9j4btgy+SpjKw3HQEpxuvdlI8p9pMMzKltieRZ4dWQ2FsYe
         zJ99QN2oBhPEdvjrZXda99usZnx2HyjKHvRqFUlIKKjGzmJv92sBe6EX6tourevYoKNC
         GY2ArbK6cI3P/MkKci6N/84H35vGmM54dnz1T8z6VJnV0tp9oBfwjMbCr46164SldZWG
         aSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732526631; x=1733131431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qcemhaF6dxBYnXBRHVDjb/MTiKC/YiHKVVAIRb06Rdk=;
        b=EwtoSmxFSYNwWmQE8Cj29tSvt3R1IUMHoDfWlRkMxk/8wMwQl8HoqWR3FlP+iJa7aT
         tLP/bBKKe6oEZiwfVauvBv44fTtxnS5pidt8HPsgvZ1U6J9ul1qgz5dTSpa5KmRSf79t
         tLXvKAs3hyrwbDq4HwwxOdWwN3BQjVM5tzSl7wxj+slXzBdW+4mEqWq7MuCVnjMyzDIe
         j2jxLWVDHwId0K6HkhgmKXBAY/zwH9EcEzqz57rGzR/rlbwncmMaJHpK/vmJPQAFVzUJ
         zrPykn7wd4Ke4LTE2kMWkXHz2e4DSOV8UnRTS0J3twkeF4BQLhFK6WfDklKDpWWdirGp
         RnDw==
X-Forwarded-Encrypted: i=1; AJvYcCUu98FVcO4pMK4btjP+Bmv6zA1KEZiXkpCA5rlSA5OFJvEV0jkZr+68So1NkJJobTm7dz8fIgf+@lists.linux.dev
X-Gm-Message-State: AOJu0YyFuudXVmECuyVbWzZK989GzoibkcDPa9ybHxCKUmq/PGDpplA2
	YyyLBKPdCox8dx/LNTf5ORiOre6TOsss2k9MsHSXXPvWolmSkcfy0koHrXIjNQleA1Z9qXZ/+5R
	tZxwU7j+XnRndy84fNZ/7KwL5C/0=
X-Gm-Gg: ASbGncuxD9c30CXSVNOVDyz/RAPXpJZ6kIqYV3nSg74n1lWYqRusD8XDvD+9PtPuHPo
	V8K0+XO5RovQ0e5Hl3imTUDacxhvLXIo=
X-Google-Smtp-Source: AGHT+IGOTgELQN8uyP5ueJTT51+ZqKtyOCk3LQ405zrt1L/Z+emvAyfINoiT8DvRuIQBC07HGWjHnB5guv16ACCxbfc=
X-Received: by 2002:a17:90b:1b51:b0:2ea:580f:6c0c with SMTP id
 98e67ed59e1d1-2eb0e024be7mr6689199a91.1.1732526630792; Mon, 25 Nov 2024
 01:23:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123222849.350287-1-ojeda@kernel.org> <20241123222849.350287-2-ojeda@kernel.org>
 <CAH5fLggK_uL0izyDogqdxqp+UEiDbMW555zgS6jk=gw3n07f6A@mail.gmail.com>
In-Reply-To: <CAH5fLggK_uL0izyDogqdxqp+UEiDbMW555zgS6jk=gw3n07f6A@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 25 Nov 2024 10:23:38 +0100
Message-ID: <CANiq72nKgj0n84Q76FSsPSeaupwgEKBT0GQbO8m-KHKZb103gg@mail.gmail.com>
Subject: Re: [PATCH 2/3] rust: kernel: move `build_error` hidden function to
 prevent mistakes
To: Alice Ryhl <aliceryhl@google.com>
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

On Mon, Nov 25, 2024 at 10:14=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> You could also put #![doc(hidden)] at the top of build_assert.rs to
> simplify the lib.rs list. Not sure what is best.

Yeah, not sure. We used outer attributes for the rest of
`doc(hidden)`s, including in the same file, so it is probably best to
keep it consistent, unless we decide to move all to inner ones.

Thanks!

Cheers,
Miguel
