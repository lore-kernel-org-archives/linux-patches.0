Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F19F1AB530
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 18:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727981086; cv=none; b=la+yo9mr3cQT7KT75K9aMEb8et7e9PBCdWWG3JcEzA90ysEnEDQlkoupNuw53XaQ7G6nxc75qA0uoKxl0+XZ9+6CMDHeZ++9pFXIi1GiexsGDbS7DAqnDICilxQmf/kXpvWp3y50U3ZRaSN7M3uUUODAczP5CvtMf/Q/uqFeDZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727981086; c=relaxed/simple;
	bh=Ycb3Cnm6ICTwEhO7rPuXIICGBEt5as3cnbaVCZ21XBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GmOfwPFhEWAid7rQZOPC49jaD37te5Cbiuq6wl+ovUpT76cr7+MRs4l9WTDNeLPx54tq3nPeXKICkpY6thGQwMiWlFdrev8b++b49raCB5jnqdCj2nFC/VoKYVjZqvacLHSF31Aj6aFeiYNIJ+5DLuG8tkJwrkqDJOiFbq4Kwiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dHSljKOj; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dHSljKOj"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-717880daae7so77873b3a.0
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 11:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727981085; x=1728585885; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ycb3Cnm6ICTwEhO7rPuXIICGBEt5as3cnbaVCZ21XBs=;
        b=dHSljKOjf3u2BbSov8fV+AGa3y+DXdv2+tOVGd+Ktu/RXHWp23lRIoIQbn+H1ra7ZE
         NQ1cIbU4AuHgPdyUgJ0uvJ5VJyHeXst7UmOFi1qcJAuM3QGBQso2778xDtoGnztib5gW
         VFzhr7Cuj2tW/9KyGOeMdcZKrtjuFfUPUpk9aIdloqF8oaRp88Ex+Jc1Dvvb5fmIJnTA
         uiBI6t5sIDUgJSD9BJReanrB6BJz2ZD3gEdv6ecMYbBQf2Z876BqZ9sDa/+DhWUB9Kpv
         j+8eJc2vPeVrUEK5nbHtY4+kpOG+ogOSM7RwEANxEyDi7rRlU714W1bWarn8vVgxuJW5
         QKkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727981085; x=1728585885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ycb3Cnm6ICTwEhO7rPuXIICGBEt5as3cnbaVCZ21XBs=;
        b=hLQeAvPlCP+ZwxLpz7SKY1zKBjEva0gVhy1c6l0sV6FjoxnQbNJ0aVaaJZ4kA3j6sF
         ui9PPC75lVibJg/4PjdnNE59fyC6ipr/6WsA7WKyqQJdoj5DuFiGd2DnnzNM7OlqP7cS
         dfFatl5mi4hHWkF1opAUN+al1G2vteKHpJyPXd8mF76IrsHYbh4F8o5izSJpe1LvkS6N
         47ja8ejzXKQbS3NybYmpphGox+qeGC7IIQOvy7Fp5VDINCXQuCwDM5X6xF4aWn12c1Q2
         HvktkIHSdW9F5io4mwfCNNv6JZxtrXfsYN5F1aQe4c/2F3nIOKhPgEddfvRx3a6IRWlV
         6zkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZc3GjKL3IaXt6lj9Li8QV5p259J7+Q/f+RJz5VoiBfAYFpbSqMwS6O8+CZ6/Rj+gtgx6E2vqi@lists.linux.dev
X-Gm-Message-State: AOJu0Yxk4StYXU7o5z3+l84TsIpDkT77uvfCxc1ZFoGAr4VzUu1isE1R
	zSPzHzLiOSVjA5wxmNicD1X9gI4FqxCj0vpHg00SbaqQrkptxh+oRSDI4VQ0yeTJLpfP8h+ppop
	s8HaB4ayIIcbu/eHm/DdpN5yW8pg=
X-Google-Smtp-Source: AGHT+IGDZcv1EGR47N/kbV/QRNk7qllYDnalvMwH5ygy0m438oy36PucEWG5clvW/m3wLDIZr6Xq5L0xpe+GaUrcNhg=
X-Received: by 2002:a05:6a00:4b4e:b0:710:51cd:ed43 with SMTP id
 d2e1a72fcca58-71de23a662dmr57137b3a.1.1727981084725; Thu, 03 Oct 2024
 11:44:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-15-ojeda@kernel.org>
 <CALNs47u+vEO5+v7dS3Zm2QbeOQfp9OdNv_y7G5c_AxqxjppFHg@mail.gmail.com>
In-Reply-To: <CALNs47u+vEO5+v7dS3Zm2QbeOQfp9OdNv_y7G5c_AxqxjppFHg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 3 Oct 2024 20:44:32 +0200
Message-ID: <CANiq72kp2uW-miyjb8pH6Thg6p4++CPnupEOM8PfDF8JgjEypA@mail.gmail.com>
Subject: Re: [PATCH 14/19] rust: provide proper code documentation titles
To: Trevor Gross <tmgross@umich.edu>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 6:56=E2=80=AFAM Trevor Gross <tmgross@umich.edu> wr=
ote:
>
> I think some words got flipped around, should this say something like
> "...a couple private cases we had in case checking..."?

Nice catch, fixed in the version I am will apply -- thanks!

Cheers,
Miguel
