Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF162BEFF7
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 10:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750849045; cv=none; b=aPxj0oAI9f4dG0rkOr5yUkFaCye35YUgfisUfrYW+9OibbnbN80PJTvIj8Nvy1mOGISruC5vYSIxmABqej9OO2oxTAoUxhd+texDClYWCOwTjmn87gPsf1P6eZw51Q0OZrcHkcWXoxbIttszB7RyiDUzIBn+SAUvkTFhBJcTHSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750849045; c=relaxed/simple;
	bh=j5qAZXIMtMgb/ECKU2Uwdaq58WXZ4HkEGh1K83eVZ6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n5jJziIXrOFODZGj+A9klPifJ46R83m1bgoN3A1hTaCc5eIj4yad50H/0RgM99t6ndvdPbSygFk0A5FuxVAY1rcketePWQkuiM+xwqSDFh7s2+KF4NmWsi6eDoqVdcTYxIFQyYVDoUYQfOv2Jz7TbnrTPQ6PfOHYq1tVSj4S1XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KkSmfR3R; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KkSmfR3R"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-312efc384fcso909055a91.3
        for <patches@lists.linux.dev>; Wed, 25 Jun 2025 03:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750849043; x=1751453843; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j5qAZXIMtMgb/ECKU2Uwdaq58WXZ4HkEGh1K83eVZ6w=;
        b=KkSmfR3RHhIVn5oLtrDKsgojD4XJElixHs9UmoxV+wuh0OZ5RHQCLDEFegA1fKnkqJ
         QIcvbCBh8Hfg0NWWsVD54+QTstVjG8vt25vpYsv9oJuNFER+7oRk+HNoB+EMFIVhNfE5
         5/zH509uBJ9NYRsfNu9nC+ehiJTeJz5RAvCwJvx40gVhvb+yofL3gOM4T6o0jC1oBkrJ
         HBexNOu8YNF5t5xda+fHRtAvpPDXtincdA56GQqzQihAka6m59wgV/6eVzJYRvVOzBde
         EBANvhZqo5JRx5uCBwayCYFb4xQq4BO5pZa/R9xPxWUJXH2HuN5azPvdAPmCTsBygpEj
         66vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750849043; x=1751453843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j5qAZXIMtMgb/ECKU2Uwdaq58WXZ4HkEGh1K83eVZ6w=;
        b=EFhAsVriyxc+YQzgH6YGzzvqwf+ijCx/UkiMNkt5U8cvEBbo1OnsalIzB3sRaLtM6U
         Zh64UD9pD6ML9x1h7SSyidiUHv9r+zLvPKn46c69sMn5KmsC2ZXK8iFdNI2IsevJ4OuM
         6MrxTTjU7bKMTVgPOIFYmoyIDjxosx9Gx+Gf8uJmAvJO9WQcuVSoTy8cDG+uFt3ekBlA
         WNicSeNiP5eLSaq2xa/KAqwjgi35/LbzEdCsu88vBcNPw/tkaGdBoqoHW8OSty3rzkQz
         wMa0q1h/CsIWqKhk07KSVGX7LNaoi+9R88PMff7K/GKRqb2D3pwvpwE3pRw3tW3lXb/3
         0e1A==
X-Forwarded-Encrypted: i=1; AJvYcCXmtCj46ZLKX6UEwrPclFZrv5HI7TYX7fxHlVnnPZRw0crIv4O8C3euyZ0vI+EdiYlKdzrzwb7f@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7ea2DcrBQopmgKW/wtEfdMpSuYHJ7ki+h3MihFKNzEeE3jC5W
	tF7pxN4o3ogLBfCuacA2YVIvZM1b1MMBdq/deJK6zRjYMuHnutRwsOypog6zrKGa8my9u8KN+u7
	2HqkNoXmTjfrrq07DFXeDXkt23Lp/Ijw=
X-Gm-Gg: ASbGncv3pB4gDmrOm4iDwmqtE4pwBU55dvo+9H6aKk2VGWmsCNwCISH3CX51PRObSCs
	F2lFyxy4vBzphCyShnij3Nc7Fkl4FgjHoMbQI7w7r+QFvkTYRt8Q/VppcHeXj5R/PRX5VPkkPQz
	V3STBqS/tBdWu2TfiC4sA598JBwgk/mc+H2ifF3u4vI7k=
X-Google-Smtp-Source: AGHT+IErU46XdKck+HGczUTulIPf1O1SKnXjMswIe51raivemBqN3njq1W74WFLgBdzuMDiUVqTZmP6A6QXImYDFlQA=
X-Received: by 2002:a17:90b:55c4:b0:310:8d79:dfe4 with SMTP id
 98e67ed59e1d1-315f269c7bfmr1308030a91.4.1750849043446; Wed, 25 Jun 2025
 03:57:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250625101805.645133-1-shankari.ak0208@gmail.com>
 <CANiq72nvnqeeteLvhgf-ZfSQN4M_dKKBB41DuOKoboV5an=1Tw@mail.gmail.com> <CAPRMd3ncagoKUyy=3aEZndDeVpbnrME9G7dc4jM1Vv+ArQJzXw@mail.gmail.com>
In-Reply-To: <CAPRMd3ncagoKUyy=3aEZndDeVpbnrME9G7dc4jM1Vv+ArQJzXw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 25 Jun 2025 12:57:11 +0200
X-Gm-Features: Ac12FXxEop0nZDnRIptwBAv9stUTIo3iHSmekXIZF-XSboPC2Ee1MYeLU6Zkr4o
Message-ID: <CANiq72=gL_2Q7cbi3+VNLqVPaZzOJ+vCg-b3eDPSPtuwtCzWxA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] rust: move ARef and AlwaysRefCounted to sync::aref
To: Shankari Anand <shankari.ak0208@gmail.com>
Cc: rust-for-linux@vger.kernel.org, patches@lists.linux.dev, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2025 at 12:43=E2=80=AFPM Shankari Anand
<shankari.ak0208@gmail.com> wrote:
>
> Adding in the lists.

No, adding them now is not enough -- the patches need to reach the
lists (otherwise I could have done it for you in my previous reply).

In addition, your reply (the one I am replying to) didn't seem to
arrive either, likely because you used HTML.

Also, please include linux-kernel (or did you remove it for some reason?).

> Yes, I rebased the repository to the recent HEAD in the rust-next. There =
was only one conflict (a commit adding a module to sync.rs) where in I had =
to accept the combination. Rest seemed to be fine.

Sounds good. For the next time, please mention it in the changelog,
i.e. that part is more important than the `--base` mention, and avoids
people having to do a range diff etc. to notice what changed.

Thanks!

Cheers,
Miguel
