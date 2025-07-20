Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03FD221D80
	for <patches@lists.linux.dev>; Sun, 20 Jul 2025 20:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753042450; cv=none; b=MBwzleg64erXYFqCnNf2eLKd+nrLM+foNuRpyPLqB2xaVAa8w3UGKYyQtpJPJnLKBf+UGGVGKlcKwcNoNwESQVs4wOQUhChdNVe4+4HCiC1GLyWkCEoKjIvnGbIye0S8RhAyYaSTYFa3UIvMQ1OVbBSSNCL/n2orSBhKn7d3eS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753042450; c=relaxed/simple;
	bh=3XqnZ3lQ7EVpBDgAQl7576ulVBufGzapdE6biJkdf1c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pPYxN2Ei4d3xypsOOjOBD8P3bT45QH037djJSCyZuY6miypNi/RSFCgr38dxkYaPhZosVSZU2gn8EYgL8BqvmCldMvAXbHEGQfUd50lrYkvRktkf+se0nuVaRVoAHAbI8lbJkF+iwwlzKQP390fnSRLlRTb74l1+D/2T9TyFEUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TtJJHTny; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TtJJHTny"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-312efc384fcso693525a91.3
        for <patches@lists.linux.dev>; Sun, 20 Jul 2025 13:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753042448; x=1753647248; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3XqnZ3lQ7EVpBDgAQl7576ulVBufGzapdE6biJkdf1c=;
        b=TtJJHTny1jri0QI59TvZDEeXmNa0wbuvys7oAzhsfFBiQaCmxYwyfwOPbOqlfCx8YK
         QJtL2THn9sSZ4KoDabMtdMOBidJfs7HEJSH9mWR6RQFl/DynzIL5ThrXp0/VVrkpGWlT
         0jE0+BqWOFkT00Zq8CCLRn3ocHZkspdaclrbdiWF1YLv1zmqFACVoRj9xv4NpZH4dtYI
         NE6fsn02ssKrC7f8gVd31qn6Bn4E5FkVF6sjQp/Ngm4naSdA4ab5Wl1X+jQrLCcORkHB
         FVZoB7izc5VDoRHBB0GojpvRglQb3iJ/7tQ2dXkhYJS+y76tLfu8GsyMqOG4/Bi00X+H
         ts5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753042448; x=1753647248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3XqnZ3lQ7EVpBDgAQl7576ulVBufGzapdE6biJkdf1c=;
        b=J47Tt3k+hhtw+ETvOxtCXdeoQDAJusvRrzl5aDSyV+RXb+v8zK/z12se7bIqreHx9O
         pFkDI8Nrs99NmBszPF6vpQ6DleiKNs1w+8gmDLzom/oLYthNkS5eqdgbyWmr0P9K0zR9
         7bAtBKYm9xnHF5Xe/ZP2zEWgEEry1/a14L/q9VhsN7NsxRvLIBR8jVVjye4mY/LB/Pt+
         vqP7QV4zvRT1ATMF98k7wSzu4V0QjDYwwFVXj/GfuBJpswZ72amu8LVdP1PndPHSwN/+
         foGefjBAGrM7uRPoazb6NFvt1d9hZKk94SgqbRsCHPToZxjUW5uQ+vjzwFPpcWs0lSVe
         /frw==
X-Forwarded-Encrypted: i=1; AJvYcCU7pF8Ht4sz9cjNP2eOE6Vtya6cL3yMEJVhri3t0Hf8QDQl0GCcfJPU/ZqrQxTedUmOgvuh/1kr@lists.linux.dev
X-Gm-Message-State: AOJu0YxIuJRaiZOF4wREN3DeG3wcD/3d8dlolTLgzGLgJvnUa4TiFIRT
	J2VLKZHKr29lnPJzOueNieGFTdXCTLXXmgm9tV40tTllYQyg4hhIqK55QZUnCd6kg0uz8s4ulMP
	FulwrzKneL8ZPohe0OImgECcKMdGtkOI=
X-Gm-Gg: ASbGncsISa0qXFWktawQmyTkwayA8HiyCumhzZKB6UTYbzNMyHemigmIxDRKemsLBNX
	cBBFp7cK0LveKz3U/paf8csVPKl7WugCqS2ofNj7/M/IATxf5MsMs15XmfXOPYsRPdzmMkPgbfd
	2JbYG3nUy8X7Rz5TDMz0LrEq+PW4DRATIFNx8ajQK2cC2AIrPtNldqfF2JtSTlMzeCzs0Df2xYZ
	h+oHWygMP+2PeIdqQ0=
X-Google-Smtp-Source: AGHT+IGGe7wNplwNP495bHYi0LizOC3vDHJ4gAQzN47ag/wp0xuN+oscFUl41uSFDjxAQY0aFBK4Zcz8LnBJ86GRkyw=
X-Received: by 2002:a17:90b:2fc7:b0:2ff:7970:d2b6 with SMTP id
 98e67ed59e1d1-31c9e77a4f1mr10752184a91.5.1753042448310; Sun, 20 Jul 2025
 13:14:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250719232500.822313-1-ojeda@kernel.org>
In-Reply-To: <20250719232500.822313-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 20 Jul 2025 22:13:56 +0200
X-Gm-Features: Ac12FXxb7ZG69y5dslaoRTvC7tHnGWA-2l9OwqxXbxYjAVnCX9uZ3NKFIYtXaO4
Message-ID: <CANiq72mk8Mp3M5hWSzgskxqWbQLBix_7_Hvqej5OA3RQnr5VbQ@mail.gmail.com>
Subject: Re: [PATCH] rust: list: remove nonexistent generic parameter in link
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 20, 2025 at 1:25=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `ListLinks` does not take a `T` generic parameter, unlike
> `ListLinksSelfPtr`.
>
> Thus fix it, which makes it also consistent with the rest of the links
> in the file.
>
> Fixes: 40c53294596b ("rust: list: add macro for implementing ListItem")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks!

Cheers,
Miguel
