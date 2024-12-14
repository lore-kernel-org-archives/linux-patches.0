Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14603EA69
	for <patches@lists.linux.dev>; Sat, 14 Dec 2024 06:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734158120; cv=none; b=k/uAWKWpSNs0Xx7OrxgpB7NQzf4cKu9h8uMvlG0EzlkaYJMZbk+KY0/wh5X4B06KKynoNFwSK+aUiwBSijcGMjUlc5kgm9P8v0ssRXGz7AO27i+LiNhyxlv1q7Xh2C40eYE7XyBFZxj3s2KDYnorhoGkLWI0YANApo1AC0SlAsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734158120; c=relaxed/simple;
	bh=zFKziE+ipoVbd2wXkCULZt2X9OhiD1E2pZBMKUsBaRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V8mjN1CNWctk1jTVtQtSvPF69y+GrrzqaXdGISBtnbWno4erADIor403v1IdCFb33090Q9wEBxv5hCkpWTdYyTsIQTG4UXvP3aZ0Ri4F4p5c4M+yO+8bvrD8Lli4R0tCirckojKkuPdvCjz0Evw8tj1OmVkOx/BRFlviDW35nco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOTci3w5; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOTci3w5"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2162f968cd7so3578465ad.1
        for <patches@lists.linux.dev>; Fri, 13 Dec 2024 22:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734158118; x=1734762918; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=czn2tePC66dPj1Yi7rQxNU6WF4uHph8JSF5w70bMmx4=;
        b=QOTci3w5KeK5siWcsgN73evu/zrmhhE6BtZgRTo8AqXcx/CKc5QY9Ne8KLLaE88DiW
         0GeShrM/FUei89Vc3a8HPWFgtcHS61qUPtcSfvGymSKssCwC5nWu1YQvCBomZSnxoaZp
         tZb8g1qik3atw0wD1NGSAINhpVCJgU56XLCLtn4+cqOw8EIAZ0gRYSVqu2AI8LEtnTNj
         E457LKuzs3ij+wLbslEugSlS+PuR/kwrXEXGFFM2hn+ZhlrgrPDheI4dbcCtDH5Xj6mp
         D7dvJ16m3lEng2bA/9bcX2rb+jCTYxNYx3ky29A/6BWYpbjRzIaeN82PTWU7WCTcy7ZS
         Aaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734158118; x=1734762918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=czn2tePC66dPj1Yi7rQxNU6WF4uHph8JSF5w70bMmx4=;
        b=fVxKt5pZ5YgkzWVIO/bz72kDVC07INQulV76Xn+XieQQTR3TUtjEazcQeerUjTvxuF
         ZQg+EHhkoO6DB9KlecLEsWGcu6CeHf+c+uYkw/8gw8ycte/WZOO5t8tL5lE61NB/UTow
         2iCp+lBQ18XlrhWiGHgJ8vXcSOib2/lOE5W52vdcEhqteF7xbi9h16is5wWoLInOp/gN
         qGzymTLXImp3eavaJANf37gLKlYqQZZIkDgb8I/0ddz5T/nyu2kltI03Fot0EpCcmfDe
         VqTYN/GPqk7GS9hudblvL/Pc+7nyqhj/jjjEimDWkrNl47sgFnzM/PeRC7p803p9eVuv
         kFkg==
X-Forwarded-Encrypted: i=1; AJvYcCVxrye7akVBootjVc1TCVgBqxNw18jYlC5SOPjeYkpccfFv3oJ/ooVj41d2hm3pRaILFrj26Yad@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7dygiIkHPL4IS14B3jfMAjTIlSBsfLPzl0fya6ldhe0n2Lpfo
	3nR5pr4WUkzAio1Q+HacYKJQ+vCYgEkk86p+qtupuRGBEKKSpSUh4lMpwaCP/q6GfHxu6IRi3Jm
	DN5laoPKm0CzMriMRVgZA8lUhrfo=
X-Gm-Gg: ASbGncv2dVZtScOw5JOOO9n2wAg6h1sim3F7+7pQo7MP0D7s5uvvef4rLR5Ghtgatbq
	OEkssUegwJ7AzEtgyhkLnWVpJUOZ4ogyGkCDzBA==
X-Google-Smtp-Source: AGHT+IH6zwBEOjsZhIdW1ZC/oKRUJnDIyzp5DRFpEUSyWKCG353lhiAS0MKdqsbFxiMXrFEbfuVTq3Go37U1wJDNgKY=
X-Received: by 2002:a17:902:ce8c:b0:215:8d29:af0b with SMTP id
 d9443c01a7336-21892a47c21mr30163265ad.14.1734158118104; Fri, 13 Dec 2024
 22:35:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123180323.255997-1-ojeda@kernel.org> <CANiq72kTX5o2rs=A51keKQiV=6fT0sN+FjWygL4=ddytnNM8Cg@mail.gmail.com>
In-Reply-To: <CANiq72kTX5o2rs=A51keKQiV=6fT0sN+FjWygL4=ddytnNM8Cg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 14 Dec 2024 07:35:06 +0100
Message-ID: <CANiq72kDuaT5082br3PBHmD5xxPpWGD1q-ro_p0DWb+ai4ZywA@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: set `bindgen`'s Rust target version
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Christian Poveda <git@pvdrz.com>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <emilio@crisal.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2024 at 1:09=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> Applied to `rust-fixes` -- thanks!
>
> I added the following note to the commit message and added a small
> sentence to the comment too:
>
>     Starting with `bindgen` 0.71.0 [4], we will be able to set any future
>     Rust version instead, i.e. we will be able to set here our minimum
>     supported Rust version. Christian implemented it [5] after seeing thi=
s
>     patch. Thanks!
>
> I also queued it for stable:
>
>     Cc: stable@vger.kernel.org # needed for 6.12.y; unneeded for
> 6.6.y; do not apply to 6.1.y
>     Fixes: c844fa64a2d4 ("rust: start supporting several `bindgen` versio=
ns")

This is now also needed to support `bindgen` >=3D 0.71.0 and higher
together with `rustc` < 1.82.0, since a week ago `bindgen`'s release
started using `unsafe extern` blocks.

Cheers,
Miguel
