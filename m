Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182401AB52D
	for <patches@lists.linux.dev>; Sun, 11 May 2025 18:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746988127; cv=none; b=kQQOWz5fpUA8qvhyslckyXsvun5iuIJDTP7eOyMXffc/WQ/CEAEY6q8rTZqwtrg+rArHnJcPQim2YioO1o3X+ao1lWPilBGWZRTau+G8bAXWlEHgu5isuvhJ25cQrXVWBMZ5Putx+C5wM6E/iY1ozk3cNznEj/H1kHTAgibnxDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746988127; c=relaxed/simple;
	bh=mem0KBsBp2payG8qdvLsnklmRC11hWKx33t/iTDmQew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bjmc0/MkeshCG3qUKRgLe2TDf1igV/38GM0XMTiRZEnCKKDeUvThbqYdg/iRZT1VeUxmI17oetuW5zqthK8uPIo96OaF1/BC1+RNeIZRxbnoDTZVbWo8oLDpnwe2IeI+qBv/dk+lnIB7HvMZkktIolhxT1ugkyxJX3STxAsQHV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iVlIz75S; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iVlIz75S"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-30c1fe19b07so813886a91.2
        for <patches@lists.linux.dev>; Sun, 11 May 2025 11:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746988125; x=1747592925; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mem0KBsBp2payG8qdvLsnklmRC11hWKx33t/iTDmQew=;
        b=iVlIz75Sy3zc2l6JRPWs1BKdE0KH681yesdonFdo0m6XO2bUDWwEeXzq3rkrD6hztU
         p5A0fodchCqXVIWpJ14rwo1kCyFNJ2lq+8gTeOnK7ZBKoxUsr9RhlcoN5YvBcrC9gZNa
         ZR63WimUBKEhT4W5iGC8qc8z4RIhlb8gofkqREt5LKXjAVuag57u0IN22GIvJ7Gecb+X
         Z1uZd3bSbQF5tL8K+LSvzAJU0RAmGzQqmYoUa4rteZn4pp3qTiJwUIDGCR4ykIzlf3dm
         /a70Ql/TMbdVcblvRnSau2o5gOS24O3s0MgCLTtNS6a03Cm+aY/5hKSdk/Ago/DqXNsd
         zQEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746988125; x=1747592925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mem0KBsBp2payG8qdvLsnklmRC11hWKx33t/iTDmQew=;
        b=M6rUN04cCUmUDg5kYjL+fI5c/bEGLgPJXvUrkpSvgre732PHJaPZeCGu/NVFCVGXTE
         1Mv/XFccfnheG6V2l3dtuSNlYikVjQOPpGddFPAn8xjsIPdgKy5DCqep90Uj7+E7HvYD
         WPWgB63OZExYhoyNtnB3Qj+ALk3IEeAOZP0EO3HIgiersWCPoV1+3wThE+PkY0oA43iu
         tt9Guk7BzFwMn4pIaNo20TppaG5u4YQXDvSf+CAmXUU/wY+7kQWV+wRy4LaEzqXoyGpn
         4hR4HLLUnq8t79C1FMgXeIWHQAKDU3iL/lVFgAfXx+ngp+3xWPzW1tH4X+7skRuHe8Ae
         vbBA==
X-Forwarded-Encrypted: i=1; AJvYcCUkOk6ny87Bg5Gyf9dx7KaF3QNovrvc1mze5jpEugji2xNdxFo2sHcM6pWjgNASsZeLMxYx9ymz@lists.linux.dev
X-Gm-Message-State: AOJu0YxOfSujWG9w+qjthkl9hO7iiF0o2auSjgF+DWzUobqiZMhAkAZI
	jqLE3caucFzOX99V0wlWTvlih0Wo0CKkObxiWY8VgHSZjNCBYKDA7ALpZf0TJRgH7oq8IjxOmk2
	KHrhFcAL0S5lSc7SKoHW02LTDDjw=
X-Gm-Gg: ASbGncuPTn/wmz6q+YTeObLgDYWCcsA4bPFZDL1YTP1nSG4NxyC7p0cXVj7k9uzPfPY
	bBbP78V0PeXVL6U1P1vivfQBffwVY0MyMjdBWoV/Xh5fHf2CW7Efw6IrSyONCtmfmP+L0cNkz1L
	kmSMsFeJW/TlCczEwTQhCzTgXDGAtPZJjz
X-Google-Smtp-Source: AGHT+IGP4rBpL1L/R/JOyAFwAzchMSP5tWZAsxEut1AYIlcEPC9wAlnS/rSd+SYDLqun4ZCvuMoUm6Eds8E0cpqj0Cg=
X-Received: by 2002:a17:903:2352:b0:223:659d:ac66 with SMTP id
 d9443c01a7336-22fc9188697mr63883405ad.12.1746988125325; Sun, 11 May 2025
 11:28:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250511182533.1016163-1-ojeda@kernel.org>
In-Reply-To: <20250511182533.1016163-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 11 May 2025 20:28:33 +0200
X-Gm-Features: AX0GCFtE4MpER3Q2huYH2uKaee300aoT3sSh3P3I6FTNekp-TpF_BMnKM8eGask
Message-ID: <CANiq72=FhkjUPjBVDakzo0SJ7=P+ab2r8Do1jExDaYeVMp-edw@mail.gmail.com>
Subject: Re: [PATCH] rust: devres: fix doctest build under `!CONFIG_PCI`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 11, 2025 at 8:26=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Thus conditionally compile it (which still checks the syntax).

i.e. "...even when disabled)."

Cheers,
Miguel
