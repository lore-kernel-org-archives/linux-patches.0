Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAA619882F
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 09:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529532; cv=none; b=bKYiuGqQ62/ITX/BU52/uFYw/Ci/orEBfGrnk3JpV5r78SYD95uFh2PjMCVOsqH9VMcBPlaHMCocHq1NpkbndTGffrmGku274RJiZRVsC77lhpKw9Td8cLRs445cy6PqS6lJNV9+v98QKgRqi7Nq0RGmcMcDMqKEVRt5xZYxLX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529532; c=relaxed/simple;
	bh=T9uAT6P2XJVZAdZnyx/4GZlbV0cbx0PWvTakz+ui324=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m+Jc888/E0GyuwLc0jJ0eF5ybyVUa3HZM9Ymo8Etin/GWzslJuCkEYqNUtUB5TtVc5wxQNLTrA2vEHs6wjBeej/LyUtX/7C7mqsB0kP8aiNFALE4FLh+HXxcbIkP+gYYqEa81++h4vGBDcZJwMa/kl8eN2clG5b9R0aqK18vQGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fiwlFWrN; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fiwlFWrN"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-26110765976so42063fac.1
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 02:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725529530; x=1726134330; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T9uAT6P2XJVZAdZnyx/4GZlbV0cbx0PWvTakz+ui324=;
        b=fiwlFWrN6zhjzaJznDIX1qj5j9dhJU2ewtxyLBG0fed/XttVguzEVd2+hcgNLBby+R
         Lmc+xEwqgsMNuQ15Q80TXpnWh3iMA/ng+rWE06pDK9/cs6Rwz0zN2ShQTDuvpwyVATkx
         Y5uWF0WSKbfcBFbzMvF3Ll4thTHLt9Qg7SvD/I9zZCLo16IMSx9hwA2h2nCSjh7Yucqw
         WCn7DxF7Ak4ppFdFfwQ0RrVw5/xVdJ+pABS8tgi2hIgITMTAiJ1XvwImasSHFxTTxibQ
         iXDyDid+0pOlF47eWLD7RWWF9pLBfmu2yQcARumTwB+zObrTwukgjHPH94+p7jXr52nZ
         aZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725529530; x=1726134330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T9uAT6P2XJVZAdZnyx/4GZlbV0cbx0PWvTakz+ui324=;
        b=iAPT5nAa3ZNGRAcBTiAdViJKSdQIf7+kqJeTihG5bH0JkICegLbYwJGu7jrFAmBzcz
         oBsCl4cNkYgeegt8f7dysySAanIb55VNzK7NbG3J648kwV3FOiMvMWs9ABWzcNEyKl4i
         bPRHF5cbgWH2PyRm7WYHI3Blxzskamyi6eRK9fXzYThw8oMqR+NRZ1FFtZsO5qksztkY
         e/1QESKUrh5ah7hoJFMATQDTIr7kyfAWxv9Qxjy/fBYsAA3QTNNn4XOrWgt0qPQYmRwa
         EJE7EV8q63XmWhGM5awpsUemNsIdCuxe2KAhLSZVrb4sYOwoL3bQEWc33EC8D7ZSGKeR
         v5xw==
X-Forwarded-Encrypted: i=1; AJvYcCXChtojXX/NLcmyNaqkOeZ279VwN00g63GWuKpnfyoXzqt/ZnmgFwTQV2pn7LmdutGsszbRpJdD@lists.linux.dev
X-Gm-Message-State: AOJu0YydAreQiPzhKWzEeLoz0PtzvNStcBTsvuK0GPsZTIHi/KaJoQlr
	trp5L2ohzbDtbxA2+9O+uPhNhL+JG2lrUrlYvE7S2pbSJQ/SGMh0b5+OHesIhdZM/e70nKoFvEA
	M0Uj+VhtJLitZqSB8+VLpnyWFOp0=
X-Google-Smtp-Source: AGHT+IF4/iqCXFx0YZniYl3ZSu+g9OE3IT6hrjrMVy3pCALICpQGkQrU5kNPgWw9rFg6Yzz1lTOlB0WKywfTKVKf050=
X-Received: by 2002:a05:6871:54a:b0:278:6e3:934c with SMTP id
 586e51a60fabf-27806e3966fmr6728709fac.5.1725529530073; Thu, 05 Sep 2024
 02:45:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-17-ojeda@kernel.org>
 <CAH5fLgg20kDCJfD_6+fTSogOnpqK0x3a6eKaTahgSvdgfFzSEw@mail.gmail.com>
In-Reply-To: <CAH5fLgg20kDCJfD_6+fTSogOnpqK0x3a6eKaTahgSvdgfFzSEw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 5 Sep 2024 11:45:17 +0200
Message-ID: <CANiq72ktnMSfMfGEhN1kO0F+C5O_KsUY1y_eb7ZL+qzzSkg9bw@mail.gmail.com>
Subject: Re: [PATCH 16/19] Documentation: rust: add coding guidelines on lints
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 10:16=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> Wow, does C really not have an easier way to do it?

Yeah, it would be nice to get a similar system in C.

There are targeted attributes that can annotate certain things, like
`[[maybe_unused]]` in C23 (and vendor attributes too like our
`__maybe_unused` macro), so `-Wunused-function` is not really the best
example in that sense -- I will think of a better one (it was nice to
use the same as in the other examples I wrote for `expect` later on,
which is why I used it).

But, as far as I am aware, there is no way to handle lints (and levels
and so on) in a simple and consistent way like Rust does.

Cheers,
Miguel
