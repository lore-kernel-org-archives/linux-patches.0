Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4FB232429
	for <patches@lists.linux.dev>; Tue, 14 Jan 2025 23:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895959; cv=none; b=oafGI1qmav8YdD3KPt02l/ABBGbjIqxfkDiqq89FV6Ncdcg+ul/tUq3PVAg2VkrmS5R/lsvI9Ltb859gKMtGdt4HZWaGUZt+1GpUwJlrXB+CnOWFXoaL5Y1DcDOjuMhT/lcPbxG7BfcmX8ju20u+F2VtC8h00nZh6F67WgAsd6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895959; c=relaxed/simple;
	bh=jGONpBpb6F9TljeHsIjaB5ReH725348vqOqeKbCOuPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CiGOojKIeP4LYFHBKfZ+xksGyuizm9r9Byb2tslNV50c+7w5cjqpEsakwa7vSASZpDrfLnkYlIoQJwhFfo9Xn/GCAofaFFfY3Bspnwya6r5fpl3eZdHW24BBJp8afHu+dtOGBI3bOGYtDCeQpoeSwy09mdpwxqP2pqlJY6GjJj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SSf1GvTb; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SSf1GvTb"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2166db59927so10564115ad.0
        for <patches@lists.linux.dev>; Tue, 14 Jan 2025 15:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736895957; x=1737500757; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jGONpBpb6F9TljeHsIjaB5ReH725348vqOqeKbCOuPw=;
        b=SSf1GvTbQ/Vdpi9usZM+GIHIscmuMbz/3HVROl7fBhCpQnTci0Kh5I4a87KJt/H+p+
         hJ2VZKp0zobMVy/rQx8QkMeS9fZXn9FcZj7NaYhgRIe/q/HwNz+aQNaADdL1KDFZT/+Y
         oA+y7l+U8Aj3Kl2YL3/ZP0mT5k3JAgQTMJWMVY02TMkYfyXaqxbI5XBVAx1pd9EN32Mq
         E75gjSMHnUtM1IIGb/RiQZtcg9jWa3gaKNnNtmtn7hRK+ye7JvdbLyAfdeybei+1ytEw
         XFo/ld4LC7whS6EiG1aIkSs6P8xHIh/Tz37d/If60wCxHebyw4gBumfJFiAK7n2C5mxx
         Si0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895957; x=1737500757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jGONpBpb6F9TljeHsIjaB5ReH725348vqOqeKbCOuPw=;
        b=rnIsopmTqN3aGU1JOIcznmDWHeDxWxfl2KOef7ir8FGj/ZGjMfgEaUf8yZBQlQNO5U
         QyBddZL/Y0kugpJqQE73OZ3mOZJwXJ/MwgrIYUruJ6WCFBDrXgQzsbLDDsW/dhn/Wh6l
         Z2Ui+iF89w3ve0cA7HUDGyQGfGEUjy/0RFCJ2SuoIX9fR7G9LoVbU2OehQt+0yaWwY1k
         uWR534ZOrMEaiHnz7pL1lkwvbskD9uARj6cQzcWMt7037XmyepD1gv0ZWqu223hNsbcP
         fK/c+iNrlNEHqnAeQd3S6f5DJfQsDMD7JwDM8FqQhjXgiFMxyhgCDki8yyoyL1nR+fkW
         zT8w==
X-Forwarded-Encrypted: i=1; AJvYcCVjEFg4DYQF82xoG7B4Q5HXKI27s0mn/r7FnB8/uG4JJ3Hjj6gFMcyR62kb1/aTUBeyUO0v3CsR@lists.linux.dev
X-Gm-Message-State: AOJu0YxrAWIJdOeQZSQOpoHp3jxFZErki+0z8FHEHnlPwKeKpL/GNk6U
	Ipuv2hMHLZXHWayZuLzhzKnbSe7l6SXET176xfgVrO+jb4O+I65zdDoy0V9SaxzeKNOxGDgV/KT
	hpXIKyOBe99hpEZRVc0pKzs9u69M=
X-Gm-Gg: ASbGnct29apomxTlFVvb07LxpcUfZH+lf2AzjdTqOSQpco+nAVdMbOE1eFZAjmNitxM
	Sy12Y9sP+dPwqLPqJfdMoP2DcO5yqtlAEeTmoEw==
X-Google-Smtp-Source: AGHT+IFw7qEmnSUSBN15L+/rlki7LwsWRww8bHcfKqUXNQn0Pn9u6VHx1zgibAEJ3jsF9xzVfr5SDELRI8wCRUezTn0=
X-Received: by 2002:a17:902:e5c2:b0:215:a97a:c6bc with SMTP id
 d9443c01a7336-21a83da2ae3mr150920595ad.0.1736895957174; Tue, 14 Jan 2025
 15:05:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org>
In-Reply-To: <20241112184455.855133-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 15 Jan 2025 00:05:45 +0100
X-Gm-Features: AbW1kvafypkAPrC-F6af1-zFvD-4hiQ71FiqfbF1PE_YNJTaf0k1myhzOh-09ko
Message-ID: <CANiq72m+k07miKu=vHfp1-A+nu092R+khau5b95Ugq8M8sksFQ@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, HONG Yifan <elsk@google.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 7:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> To distinguish between the two, introduce this new variable to stand
> out from KBUILD_HOSTLDFLAGS used to link other host progs.

Applied to `rust-next` -- thanks everyone!

Masahiro: if you wanted to pick this up through Kbuild or to give an
Acked-by, please let me know!

Cheers,
Miguel
