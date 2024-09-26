Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EF9187FF6
	for <patches@lists.linux.dev>; Thu, 26 Sep 2024 21:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727385555; cv=none; b=hyZ8tZtD8jZTetFFE2tl+uwCkJTOJHm7j7E/jhSknQrNUSN3p1HoyttaS5j+U5sJcJN+pnh28rzqEH6pgjwSzCBaXcG9ybRyAshFcAHoMe8tcr92r4hqo7z5FA/QpF+iUsZ6PJTitzalRofWz507mD3vuB671jDWGMgIzj16R/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727385555; c=relaxed/simple;
	bh=YEKHoo43BF79Gz23kSQAk8+dmLPPoq5zevMJhdfoyBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LaCT/7XyKnOMExN1odW21luv8JM7yd0+81CSrXfMStVJV/JO7rkxe/JfXQiv/jARrq36x0HGy30wlY6+y5bHTsrJDDQOeSBJ+KIyCZQIoG3VijFtU4333m63ZPTfMCHsLZgkiHY8UvQAlPa38+hWnOJclCytevwkOQKu+7Y8bgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mzHR5QAH; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mzHR5QAH"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71829963767so191778b3a.1
        for <patches@lists.linux.dev>; Thu, 26 Sep 2024 14:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727385553; x=1727990353; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YEKHoo43BF79Gz23kSQAk8+dmLPPoq5zevMJhdfoyBE=;
        b=mzHR5QAHN4P7oYDxDiHNuAo45wMWPdzJ9U5sFEMM7Yg9ILaQAr+rwgZ5wPcCTQsGTg
         OhgPbuDbuIG2e/shxWPzX5FSf/amKeYggzcNiHfcRhu84SQxMlXcSSL1w2Oa42oWBVXr
         CEzf0RGyMgpLR4NZqwhcNZZueOG3QdhzGm7QKdeUtXPehd7fnCrDH3/lENm5C2U2SntK
         3sxtZwpCyslhqW3xO2nWlF/EiOs5RL5+N1cvJ9hOtIrX59RIiWbiQFRQOf3n+OuTyFJy
         X5eTR7/oivtM9GcsH9FrKPnF9PITxq+50P9rX1G5um3eQ94ceRtyg3FIGQB5g9L014/y
         lJ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727385553; x=1727990353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YEKHoo43BF79Gz23kSQAk8+dmLPPoq5zevMJhdfoyBE=;
        b=WHArHZ5Aw0LPcba1MwnAsE5Y40T/JHzD6smgm3IN8V4rQPYA58SanKvV7+KgJ+I7JQ
         MfHHhGP91V/QLgBptbk8AFW3EpxGDsZy4IsYOjxQOprGIDGoqs6l2r7qbvEAuFL0rv6a
         63ahjsT1nL6zHf8BZbcfP2pDtjT0x86g2lQ/SYmWWeoW9dP0lHJU78MHsmBKlTni8IB6
         MhYRwX7aEmMEw++0XY49gHYS30NSkXuGJyIpv5P6aBvi1P6b2niafs8EKfgBBu4P/o5Y
         2ynWKgT3VnOxtTpUXgttt68d6ElKOK+D5LPJBle8NO+G2T7xngcUXR+zwT/hGiizsrVY
         bRCg==
X-Forwarded-Encrypted: i=1; AJvYcCVJ0h2RS5oyiPSGK4BKUyhhbExWX+BfBe8BJtpw+lNHANiVZa9rj9Q3ulzCOiTE21jY1zxZsrjc@lists.linux.dev
X-Gm-Message-State: AOJu0Yzudz3E2lrkzKu0MJjw+n3gwjYTc736sh+cgv/QolckBXnuH/Wc
	G6gs6+z6S83MuGK/Yw+GswTc9Yc4VzwhcejKptO8ZBVCM0CVHHJS+vU+JEuaTBIYH3TBNUbdY9K
	ImF5fYJGZFscZaDc4Hz52laxhGcE=
X-Google-Smtp-Source: AGHT+IHULP3pU3vUe/QzsEsWGXZyg5HaYhsoOAbzA5msEXfvnbs+cNXkKhwNX7aRIH724eXaazA1vELV1IzArwEqRhI=
X-Received: by 2002:a05:6a00:1407:b0:70d:2c09:45ff with SMTP id
 d2e1a72fcca58-71b2604d429mr749238b3a.4.1727385553106; Thu, 26 Sep 2024
 14:19:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240925141944.277936-1-ojeda@kernel.org>
In-Reply-To: <20240925141944.277936-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 26 Sep 2024 23:18:59 +0200
Message-ID: <CANiq72meNkvahLDAxPUq4suzFY_xUgxEW6vGsWuo9ZzeiNrQJA@mail.gmail.com>
Subject: Re: [PATCH] rust: cfi: fix `patchable-function-entry` starting version
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 4:20=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> The `-Zpatchable-function-entry` flag is available since Rust
> 1.81.0, not Rust 1.80.0, i.e. commit ac7595fdb1ee ("Support for -Z
> patchable-function-entry") in upstream Rust.
>
> Fixes: ca627e636551 ("rust: cfi: add support for CFI_CLANG with Rust")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

Cheers,
Miguel
