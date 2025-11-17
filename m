Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A943234572B
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 21:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763413379; cv=none; b=jEC1VSaB9nhccMSR8E/FBLiDPJDZdCLvoHKukp3ig5xd6s8ef6El8xIm+Li62QkdWj0koU1NOCYQ66BlrpDRoHMdbd25OfYM55sHYSPeLADBMnEil2tzXfzf0/Tbi8XKA405mmDvLFyu2creQEouPr2Y2oEwOiDzfb3Pnd5R6CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763413379; c=relaxed/simple;
	bh=Jx+mIImXSNDfgYqmNpofAZfv7KprXxOGtDGrhRPT+Hk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S7PJ1TWYN5TvG7z9RanXg1yzOQod6F8XMovcxhEpDVF4F73h+7VIEXtQde1nlqMd29WAhzVd9gOfHHnxnYc962DqN3U2XpliO4IoYS1LGyIo5q6xRb32Jvx6fctrpMKiF3l+X0+1OdDtPpEz3mQPDt4uEIzBrExhlp0UEqzHxfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxpDHw+1; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxpDHw+1"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-bc144564e07so147627a12.3
        for <patches@lists.linux.dev>; Mon, 17 Nov 2025 13:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763413377; x=1764018177; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jx+mIImXSNDfgYqmNpofAZfv7KprXxOGtDGrhRPT+Hk=;
        b=ZxpDHw+1y+BIVg2Sn2pZscnAaz3VVWd7YMdRASJulISGwZXxyqzWaIybGCT7xG3LmD
         UWD40rsNndZyUR5qSi7JC23wIlGvAQ1or06leD1CvmAkySahf0KXhH/xvVqZtHCe+mQK
         62pbL8SH1GUUP/6VMY5n+JznCFU3PV0BUt8Uyx29ycHHWQsdiyb0WF+6IoKDPG3NHgdD
         cI9IQSW19M7X7IkN0bv7QyeyjxsAuFe6f2Af2du1GGIZGr8RcJa3vXwjbmAUPsBiloCX
         faDjZzfTISUDW6RPLmZ20zzmeuWf1vaV0vcCpnrnvzKfAJFTKSyBZsG12KUdicMwwrin
         blcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763413377; x=1764018177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jx+mIImXSNDfgYqmNpofAZfv7KprXxOGtDGrhRPT+Hk=;
        b=JesMcTP9A3clIedd2lB3VNdTjaUqyhWHN7hUbEC9gtS/uu2stqwEo6PDYm5WsfNlgw
         wjsqXgNM8lRovoBEaqkM2kF7DQmGV6hHBHDZENa4LDp1h66ORBME9ZV5m3+bjvtYnGhR
         +6DgwjhDCxSOR6XJlQLmdPBeo7NKcnOqmfz29R6KCq0YFOfL41vGqXQe6ruuA6PTbfaZ
         2kQB0IqMfYWX2BKO21P32Za2nrUl3Yj/ZtIjPLvNJPsOeRVNrH/w/VQCxEMDKKatz7ui
         NeL3CPZLT3vc5ysCmfYRfLkUzuPsqUag054AXbyQKq7QrCNis5WjnGXlxumx5sIr7xGq
         LhzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLfEbyJglQS1eEFeLNFhavVbFVjY5mSXOXuFTchIjbHsm6YzJdnUhXWad5HEEGh9c8/wfK6PVf@lists.linux.dev
X-Gm-Message-State: AOJu0YwZjsQnlo6KWsDuXDCu1FsCSC+ySRtHeo4zR+ztFm/UY+tMalMQ
	1GaBP5zQpp9P9ZELon3qMLp28C0x97J7eQOIQ7TIUzJBBXXqEBBe8tn+AGhaG3fG7jRxY3svtZI
	ngdcSTgvNebX4CfQjUu37kLE0x/1FwTI=
X-Gm-Gg: ASbGncsgiph4VLmedc5psxPkiRIbYBFlSLW7mXluISWSq69ACOeljPpz0J1SkT97Xjk
	TPuB6g+LD8G66O4nO9dg7rhr9CyjgJCR+oHvh3Etj16HbosoAABvjMLMNFIwvkrZXxHgWQiUqHX
	+UHSWTKWvDLGsaMSG18XmCbuV10GQ9n7NC0dIxJFz/gM4Cz7B3aFov83Fd/EKoXR/l1Hc2PMy6W
	TfYkrlHPRpE8qSNnVwc988O1ZaiZkPk/QMbbsOyyvTzlfHyL6v1j64xhIZLNN+iY1b6BawB+yQa
	5xLdGSDwFcHypr8UfprS4OEmapUpE0xZr6zjPVvSwmBObULhoA0M3voblpOLFdOAxxqfRuw/3Y5
	wPBo=
X-Google-Smtp-Source: AGHT+IEfpg5rcBX3WhvIWQ/UIkVD2lfXwiuAfVldmSreQrz3l7c83vqeEp8kW1iCh0Sg9GCSFOezGN+qgrUI5cjThig=
X-Received: by 2002:a05:7301:19a3:b0:2a4:5129:fe99 with SMTP id
 5a478bee46e88-2a6c9b2447bmr78698eec.2.1763413376824; Mon, 17 Nov 2025
 13:02:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110113528.1658238-1-ojeda@kernel.org>
In-Reply-To: <20251110113528.1658238-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 17 Nov 2025 22:02:42 +0100
X-Gm-Features: AWmQ_bkaYzRIEOl89GTZlEKTMKuZ_To2Yp8qyNl_-3c2oE8WhLT2HaZf1WZMoBI
Message-ID: <CANiq72=n3DGg0gfrVq9+b41Ri6M3efWZxnzqwXkOFRt4ozN3dA@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust: allow `unreachable_pub` for doctests
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Rae Moar <raemoar63@gmail.com>, linux-kselftest@vger.kernel.org, 
	kunit-dev@googlegroups.com, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 12:35=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Examples (i.e. doctests) may want to show public items such as structs,
> thus the `unreachable_pub` warning is not very helpful.
>
> Thus allow it for all doctests.
>
> In addition, remove it from the existing `expect`s we have in a couple
> doctests.
>
> Suggested-by: Alice Ryhl <aliceryhl@google.com>
> Link: https://lore.kernel.org/rust-for-linux/aRG9VjsaCjsvAwUn@google.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied (this one only) to `rust-next` -- thanks everyone!

Cheers,
Miguel
