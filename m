Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B456C299A9C
	for <patches@lists.linux.dev>; Mon,  7 Jul 2025 12:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751892611; cv=none; b=Mz6xGSzKCYu999B8YF5AUKSGVBW3QGfeLrrPFn2IEj+gpJcHRdyfQu+e62CGgymhtmOSj8KILhRp+RCjwBmMKXVRAFpypDeKWzfjjUKNiE7MuXngRMjWXiNp7QHRfoQQKwPhA+DfZk4LmlipJ+eK87ihk5TFojZYM2pHSnZhQZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751892611; c=relaxed/simple;
	bh=TlGVc2vlqFVb5SNdiOg16XM/hn4x/ChX9J75203gx1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FhValSBxHtjSvFmocSn4AIVkoq8wyFKW8OWwwJktoFG3gExMy+zl4QQ2UVH2hL+f4g5qqmTRQg44DmQ26z1YmDPEuE1zev4Rv09ntNwcw/5M83OlEW9sX75ST0FEWgNxGqXNbZHAz+NtQMQE8j8uzVDmVx3h7kLFBlvIveCtBYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3EpUvES9; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3EpUvES9"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-450ce3a2dd5so27779315e9.3
        for <patches@lists.linux.dev>; Mon, 07 Jul 2025 05:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751892607; x=1752497407; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNdhzW/Y8MjvnDjqqg8r50YbwUFzxxNmO6sjtPUADNk=;
        b=3EpUvES960Rn5dK4l2vDTGs8Kc+yqsUu7q2xzVFKGjJ1LKzwbky8WOqDlYbcocty1c
         Os1Ixy02fhmlxw360IhoN33QjZDwvgWTznEhq76n99FTQAqnK7L8GIoTAuiYEYi/6TEm
         e+U6QDGyS8LQRRj4XJySjoeq21j5BJdeFVA+wV5MveKkBTUlCvoCDl2jQG70YZ99gLKO
         mej2Vfu1Ap2tf67G8mDkewG7ebMafUlJadrd/M8AZRofrr7UdIMqGbFG+KF9tx/K9YPO
         6SI1ky7FhZ62KjYevhZoK7vlst9pjxKwuX/cpS5c0FI+V6+dGbQcsgKbUBviQK+m1yVj
         UocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751892607; x=1752497407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QNdhzW/Y8MjvnDjqqg8r50YbwUFzxxNmO6sjtPUADNk=;
        b=kNdDJOQ8PzGLFlES0qJf2OM9AuxofiUad7qoRLGOa4fUtcZNzujdfuCzAfyfATl3oz
         0dvuXatikrafNEbyyekLeq6LAyYcco/u4B0a2nvbFHvY1LkoSnaed9iQH4rFncTQ4+FF
         y3/+nqkOKi2wGWsTF3XlBaw81DTeZrr31W4FqgWv4ydNDl9ritSMk/eZSnL0Yr8SlEDw
         0dn99X2ygOiO8eZJ29Cls7/xmL+ODw/cuxgRwvc8Az5BJrSv47JOQC4HPitNBrOcocWQ
         gIs1QYJBeGxKtwyBtbnfcNPe9A+qbQZdFDDfDBfOXjE5fUUTK6tBWDvvy4Big+AcZNs+
         S7qA==
X-Forwarded-Encrypted: i=1; AJvYcCXUcxo++PnLWQBZPqbmXJZa3y3FuOAsfcHbMT9gepq/qMYM2OSgLq/npjytuwmhtk1x8gCbsXZL@lists.linux.dev
X-Gm-Message-State: AOJu0YzWdQsmT4XK8Grjf2lexMsUE5jgiqz7w3u+uhHfiPGKxH27BcPA
	dkXIcX/gyUqFHeEmMHZuVGhnhVwD66VOfshpOfE0UP37RZs15Ad8B61dQU/3LmlYPUy2kGTUVk9
	1CtvZ4lS+pkaA61h419rylbHW9lmtiwZ83fBsqhnl
X-Gm-Gg: ASbGncvfDAYouy3kbktxL2T4rXhd3UPldFMbuIQkQHGHxx0TZdOGQoEqP/i9jM7qmmc
	mAFY+bxD09NTDawwMsEg09+kiadMyX3g6AuAGAax/meoKoVN2cy3xzxwqfPNQR+2iKpYzGgHgii
	IAkKoJAug/zwf3J8KBR6WoOkXGSQL3FTa4hfeZegPhVrTcK/ymkrDvHLQOE1/OxacZXRXQtZE=
X-Google-Smtp-Source: AGHT+IHsMXBAD8GA+B5LxiAfDAfLtY6TvZ5FvEHyZmOChFA1YhgQJ0ZWJ5lgZJTqiFSe6ZNS/+jU9jf/Us1OmmZWM4c=
X-Received: by 2002:a05:600c:83c4:b0:450:d04e:22d6 with SMTP id
 5b1f17b1804b1-454b4e6bbdcmr104358265e9.7.1751892606844; Mon, 07 Jul 2025
 05:50:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250701174656.62205-1-ojeda@kernel.org>
In-Reply-To: <20250701174656.62205-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 7 Jul 2025 14:49:54 +0200
X-Gm-Features: Ac12FXzQ5ck03QQHYzFLsSFTLp2hRsyOexA643YmM2tCIERUaEuSJWfO_lmHndc
Message-ID: <CAH5fLghD5eU-YUkq0M4gFK1tXOGHz3Py4m_+xTnYzLxT_ru0xw@mail.gmail.com>
Subject: Re: [PATCH] rust: acpi: remove unneeded cast to clean future Clippy warning
To: Miguel Ojeda <ojeda@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Danilo Krummrich <dakr@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Len Brown <lenb@kernel.org>, 
	linux-acpi@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 1, 2025 at 7:48=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> A future Clippy warning, `clippy::as_underscore`, is getting enabled in
> parallel in the rust-next tree:
>
>     error: using `as _` conversion
>       --> rust/kernel/acpi.rs:25:9
>        |
>     25 |         self.0.driver_data as _
>        |         ^^^^^^^^^^^^^^^^^^^^^^-
>        |                               |
>        |                               help: consider giving the type exp=
licitly: `usize`
>
> The type is already `ulong`, which nowadays is always `usize`, so the
> cast is unneeded. Thus remove it, which in turn will avoid the warning
> in the future.
>
> Other abstractions of device tables do not use a cast here either.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
