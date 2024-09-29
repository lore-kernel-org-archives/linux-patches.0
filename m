Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105896A332
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 05:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727586667; cv=none; b=p6od4vFZjncVjRyWnApPZvAZkyHsy1I9RlLwF1tkgsErFl6a44TGo6xRsAUjZB5pEheq/MrBcL2qf0Z2cbCE+PHjjSBCA1wDq/rQQPhDYqp4+/cqMpXZDOqhJzLNYozBBCy/Hgb8xnBTmR/Dp/ItlhUoZV3xeBAQQTYZhsoDWb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727586667; c=relaxed/simple;
	bh=RuRZYVvei28eDcQ036NK5OQHIXSS5Y8RpN9am0sKM4c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HpJGx2rPvah+MLCG3u3OutNR3UJ+qTK0eGWPd0zpW8klx2puFNUCgksdTr4kZLatm7sutNO6CZoQmIHH31NaM0w1KTZu/TzVn8MWcmO40MOD6JbURmMgC6Wind1CCfX+BdZKTy+Og1F/9KAYg58pWkmna/DIDXFKAcL10bveevk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=R9QnFunJ; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="R9QnFunJ"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6ddfdeed0c9so26736397b3.2
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 22:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727586665; x=1728191465; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RuRZYVvei28eDcQ036NK5OQHIXSS5Y8RpN9am0sKM4c=;
        b=R9QnFunJIzmDMTwC4XoWiEBW84pgYoKVHZAdh6aLaL4zn6uTz1wXs7w0NbPVtaodD8
         pGBrOmxjeC66R9oNCFz9+/exh578bypswt6Fut45UrrgdQekBV6CyEsFYaxtb001VMS2
         yG5yPBJ2QGCRXL6iLQPzoMmxDil4guESvfwqKgT4BvLKUqL+Yip7/gqXXSIl/gFiVkmV
         Df28bhHp+9IghlFVVaOVnFOsuGNi7+BeiXSK5MdoKq2qE1p41iUngjO2xM7ylN6mxtpk
         RFYLl634ydhMfJkTxyQwlTYbk+84ldoXSOGMA3n1J31Tic32ibhYARSWnkOyo8zFWu2i
         d43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727586665; x=1728191465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RuRZYVvei28eDcQ036NK5OQHIXSS5Y8RpN9am0sKM4c=;
        b=iH8TFBAd72d7fCD6wl5o2yG5ul36P7iVj5ZFkMLPUsw4V9BHI0yttPFzYro5nHkRpZ
         y5kF3pndqrcj04CBlzP6v7KL4EmSUJprtRwvd0LIhqTAGkRzYsydoDmkl8CfarkhCEOe
         L3nu38XXSf2I7U45PmGfWM1hdJiwBE31rhS7HcM2MwTv3NgTM0AAULkBJRYOYmfHeUJ2
         i3cRJJ3/SCFZWmG1hajrUFzlkkpanN86Gxd1DYmfdgtVPBTzpJcXJpxY7Gx6kbBmOmXO
         yiJ0b8ht0+ne+l6xPjH6pymDtDcxOxOAthWz53UCCelS2OEg85rki3aAoqbN6qzvcarQ
         d0NQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQWMWLnhScSJFi7IMtuWMceoRb4Oz9GLVnjvh905ErqDae6XnEn4tYKMnsXgEahQYofF8X4fWy@lists.linux.dev
X-Gm-Message-State: AOJu0YyE08njbHaujHTD9iU+YRFdQF/idb/UG2NWQQO3BoIhjNqQ1Dmi
	qXo92U2L9SS9pU4TWuILW2NR5Yx4mluDhyjd8V/7eFrIACBjLQfmbeCRlN/P9J9sRt4K5AG7tWv
	JkX1DP9WauPOhNqIRVu/dPUOo31roLWIwBU03ROvXZvkXJlQ5IxNajQ==
X-Google-Smtp-Source: AGHT+IEbuPLIS0r0UAYXOL55sJ7MsrTfAySS4mECInBKGc5OhJ5B2QgDR/M498wdGIiCmNjzbtv73pF/ogEFQj1XJkw=
X-Received: by 2002:a05:690c:26c5:b0:6b4:e3ca:3a76 with SMTP id
 00721157ae682-6e247571063mr46680857b3.19.1727586665054; Sat, 28 Sep 2024
 22:11:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-19-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-19-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 01:10:54 -0400
Message-ID: <CALNs47vPzH7CSjRh=jW0xNTh9=oajUs4SAkTE2OHLd5M2e065A@mail.gmail.com>
Subject: Re: [PATCH 18/19] Documentation: rust: discuss `#[expect(...)]` in
 the guidelines
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Discuss `#[expect(...)]` in the Lints sections of the coding guidelines
> document, which is an upcoming feature in Rust 1.81.0, and explain that
> it is generally to be preferred over `allow` unless there is a reason
> not to use it (e.g. conditional compilation being involved).
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Would it be good to mention that a reason can be specified with
`reason =3D "..."`? I don't think we use this anywhere yet.
