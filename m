Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D224A288C2C
	for <patches@lists.linux.dev>; Tue, 14 Oct 2025 16:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760460140; cv=none; b=OqB2iou0DM+UxxI08+Jgp6WflGx5kCpf10CNK+VFrbP60dPmR2dvhyTq+KyPPEnXFITAkhdODPKVfZ0+HHQ3+0LCfO/L5vAVkc3PMcX3gTKgZuEvCrMOsYi1oKIaFGVpC9zTQFLwrjpL1SNBgiliVHIHBVvhFCr2HO8yCQOGSUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760460140; c=relaxed/simple;
	bh=Qx/eEo2ROVIPmgrj6FFyvxVlP5xP/FaQp3gFsAscr8Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fkyQo95gZGcRPEn/8GKTnHYFYx5YGM4rM/941Ya4Cs/JQPps/Z+hJ2VpsFkwxcMUjW0aCCvNH4Sk5+NyW4xl4CG2uASF0KNtmXd3McFB+u+E9kwurZ137aCon4W+lDUhf7Ze0cYjpM++WkmirfQ1CXAD6bIBIZLbPoECTzLU3Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kwY7M9z6; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kwY7M9z6"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-26808b24a00so8483475ad.1
        for <patches@lists.linux.dev>; Tue, 14 Oct 2025 09:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760460138; x=1761064938; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qx/eEo2ROVIPmgrj6FFyvxVlP5xP/FaQp3gFsAscr8Q=;
        b=kwY7M9z6H2luFRzKPgWFha/G7SScy4DhvgUGf1Loxu/IbKGhl3ETVcQW4amZ6ZXsJ2
         DXOHMe7JLOsOfqHWarTNO1hT4x4UMICbXbcVvxDSAAv3yU1lCFuxsvU0F0f5gEGJuo6O
         ta3crFfVQAb0ikzJig5eqoFLebgfKVbm9ibbX8LRSlN0oFiZnDvPaT/9iQ0OCmDTfVa0
         T/FjperErRGzqJ8qmAZIuL6R7BRRbba1DZJ1hm/Ll8lSYYeRlBNAJCIesoDheD4xB+lh
         dUIAYfHnaPTjttcD5oSjxNV9blpCAmhnNdZwFqAest/HT1TUY2rpUs2YfIYNPKsv3Q2G
         kORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760460138; x=1761064938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qx/eEo2ROVIPmgrj6FFyvxVlP5xP/FaQp3gFsAscr8Q=;
        b=Rhx30Ya0WPV7VWNEf4PHjoC1aGzwQmrJwWLxIubonCcCjsLh/tAon/iSBzC0cMWg8x
         m8AUqo2sLug/nHvoFyxlxssPzOF2UeuClObT0GBtkB/CVuBynrb3d3t9jM+YCJvNS0OM
         WrecAcI7e9NlvZITzrTpSjkwWyAZ4qgose5MJ5yCD4f9U3Anc6sSbQeE9iKyYAKc7ILo
         HFmEo2uA6pfCvULAjM88QXwlu5UUDjj+rc9RFE2utrvhMOShvRNYGZpJ8Lf875Loz3te
         HIHBDsOw9wOBe+0zW963XuYZNT+cOdN5npeTQB40ZACRMuPT2YbLQ6UjxB9tRdhj+v0w
         l2jg==
X-Forwarded-Encrypted: i=1; AJvYcCV4GE5+Na4vDtYcAzMlyiJiCHmRM5SyBrZnTEcWaxO5PXM9+TrHxE1XoTTCtAijLSvSuC6Kwtwh@lists.linux.dev
X-Gm-Message-State: AOJu0YzknEJvdUQ5LJQuqzblMwJ7aPtbKy56wdQw8+AHYn9+kbNSmVVw
	SQBx5nQK8glkI9Zq9B0bGHeILrFTem2vgK29attSAwMHQk/JyyK0vy+WQCDvSp8rVLrEXLrrBKW
	yeG59h9RVoiQSdeEnR56BAAmNi4ijucw=
X-Gm-Gg: ASbGncu4eJI4W4hjklcS2UGelkbD/TfvJqgXl6RsqNQ22XudCsXnS1ySwYbpNu643IB
	4RZbsr6fYEZLnteb2RYA8Mk9g5eLmiYvLP6Xv98359fFGe9luBgou0RTQjOFiDN/dkbhmikJ9C0
	mHgOJn3i99l9HJ2TrJrsJy6jUGZStznfiAgCV6p/BnRGaP9EwS6yaSO+uehrYA70f+3wt5xSYOy
	vcCo/9Dy9uhVQPzrS4goOJiLhhj4daqvhpXWFklBUEeIhzYr6MA5XckDZcdWxYVzLaewi6ambl8
	IQLu1HNrhQH4VitlFpwu1ZLhmzEoG49L8FpL4Lqfbd64
X-Google-Smtp-Source: AGHT+IFm0NocZUOA7deQKev6cTvUimVZbWYXQYPu94G9wpQohGmRSl6mxcEZ0e/f5qO6pZB6kdK7mFOzs9rqiJR2e0I=
X-Received: by 2002:a17:902:ea07:b0:269:85aa:3776 with SMTP id
 d9443c01a7336-2902745664amr187372845ad.11.1760460138023; Tue, 14 Oct 2025
 09:42:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251013001422.1168581-1-ojeda@kernel.org> <aOzET46lagm-p8go@google.com>
 <aO51pV5WSmqnT4rL@yury> <aO54nxGil6a5hLQN@google.com> <aO55B_ishdHO2uiW@yury>
In-Reply-To: <aO55B_ishdHO2uiW@yury>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 14 Oct 2025 18:42:04 +0200
X-Gm-Features: AS18NWBtweXgcaBwWxSZPbyhJpQmvLi4CG8z_VcU2bxMhsLFlMa-fdtcHq67J60
Message-ID: <CANiq72=oiJdA_0SyBCzNmf-XL9DbCN+sOrXmVR2TUhYeuZV29A@mail.gmail.com>
Subject: Re: [PATCH] rust: bitmap: clean Rust 1.92.0 `unused_unsafe` warning
To: Yury Norov <yury.norov@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Burak Emir <bqe@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025 at 6:23=E2=80=AFPM Yury Norov <yury.norov@gmail.com> w=
rote:
>
> OK, will do -rc1

Thanks Yury!

Yeah, these should generally be sent as "fixes" to Linus; otherwise we
will have red CIs.

(I don't add the Fixes tag for this sort of change because the
original code is fine).

Cheers,
Miguel
