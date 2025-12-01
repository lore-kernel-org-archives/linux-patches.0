Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB61813959D
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764606627; cv=none; b=PDn7kifibFOiCtgl5KOV77nLh2E/dDWxBQjkBetkeegQouwggK3OGbwGvPlHau8lSWkiUX2nsu9HDOHWYho/rO9Q2OMdv2Yf64P+ADy9PPoFqUlGDQ3m0VOcYV27N6jiXICHkJcO6OUuv9ptT9yWxu2hbfVTizv4bzsX+4glD5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764606627; c=relaxed/simple;
	bh=zpKbkUkQrhP8Z8G+eZrB42QlKP9ymO5xUUiC1g9Bi/g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J+m4oFT9oYPax9vfGkp4HZysgVM3fm1tZ8sa6kFevEzzYC4s3L7rLeK5eXZMbRV4L139L6o8dnz1Y3v8lD7VbKI+GJXkwmA1atLBv32rUReg+UE9pOAOxpvYUHN8NTrW7hDKgubS0iLYljI0xebYtTsDdHqHcMN0aBEZYYYjsQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zp6Yh4x2; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zp6Yh4x2"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b9a5f4435adso255413a12.3
        for <patches@lists.linux.dev>; Mon, 01 Dec 2025 08:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764606625; x=1765211425; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpKbkUkQrhP8Z8G+eZrB42QlKP9ymO5xUUiC1g9Bi/g=;
        b=Zp6Yh4x2aaVGo45k6TWCBmzqXwROd0T20T1qxzlqMHzVdqasqtKcZ5BGyFawrjKj4L
         IpmQnNv8Rc01buYto6KFYQnpi3mwdjzmrgA55RYDjcgax9aaMke63scg6UXWMHyHXx6T
         7xBwymx5MGfmOKyOzRen4TCrH7pwIMlOa4rV+UJPcqJR3tpvpK8XZbIOsnv6ExiNYzA8
         QDaYrfoC+lyKFWr3AMFtiG1eTktMmOH/SPP/sOPhslBHtSwFcQQsEoC26zoLZmBnOmND
         egbbyHo4DtKNUOmA92WrpvjqxGGSL8d9acw0jSmCa6oOvnbdXSS4i4gd5+N/Cj78tNqT
         JasA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764606625; x=1765211425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zpKbkUkQrhP8Z8G+eZrB42QlKP9ymO5xUUiC1g9Bi/g=;
        b=AZNcF/sxYLKxM9tbZZ1ySmbsyXGN9n2zFvdrt5V0AlxMCLHL8VxS6F3dV2uVYEC4OU
         z8J+JmcrJRoGQeoRT6gUTE5sCVWqw6ipxi6EP5tiF4ZhTLW6MXO+MXNTe86P8VGZ6dXN
         pE2Aezi/iyKtVo/Pu0E9b2TN742R4g2UCEexv7wO93ZLR10NBx/LanHL9uEkKGebylPd
         SiSN1ZhhZUJo+gHnLc161LNsssKM/ImbrO6ws7doaOjpu06zfkEYs/v28ZKBvveTsRYn
         b0zMUOjrMUd045sZY9f1U9CaxIFZ8HI3I/D9icxMTRkDgQaFjWAEzLd2ajw0206047FW
         YTkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXa1CG2gxJ5tIjKcLPO8Ij5gnWzpgoy6u/1PQwTzH/il8Xr6+EuU7x2xlIw0it1skD4j32b7whK@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4RLWRhl7yMpRrbgZs5CoeBhqRnBTlRyP9Myx4YOPF8UyiFjkw
	Qv+XQ1/zeas+EBYJMLpotqVciBfLtn1pbP3R1NsKyRQuGP68h7hPzvK6ePcqinqaLyWJOsiFv8p
	4H+3kBP3Zbk52yOB0/eiqWHk5+cUcKgQ=
X-Gm-Gg: ASbGncufUJZglf72rLIJHYauhXU6dXUv7erxC20ZrustJuxTl8GTtcQk1mWR4F33lbj
	aqLUrCLXC/QPB6dugCPGsQZCHUCoL/xs5dVsHW7GELjzK7sIXRN74v9iUQpIBAbciQKuJLi7bFG
	iCkiSmIFp1VCjtEo7em9jJ4NfWRvY9JK1Vs8P6bDcWRfgdhOdvwW9+JVMTQ+mMQgvV89alMpd8N
	KtRnPj8m2z1GIHgAnfNT7p4RanJwCpW16mkSkyCLeBlX5cLMREXxbJaT6j798G0FtmPx/E12871
	hEZQdUwzLJDDG2MIuzdGJoYJHZDIEMpJ38wULf2sFCxesZKpJgCPSXcLc77pJl//0x5Fxj/oNed
	FdGy0F5WAf+88bQ==
X-Google-Smtp-Source: AGHT+IEf7vOC5mAqU/omo2/IqPWzWyzZXuA9/nGkYTAFHB5XIB3JrboNwDg1L1ZxYoKdJ5V3/dY93SPwNN1ywHBmg28=
X-Received: by 2002:a05:7300:570d:b0:2a4:4862:c97a with SMTP id
 5a478bee46e88-2a718ae7143mr24440001eec.0.1764606624691; Mon, 01 Dec 2025
 08:30:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251201021659.1729308-1-ojeda@kernel.org> <470357d7-5958-4470-a718-25b9c7660565@nvidia.com>
In-Reply-To: <470357d7-5958-4470-a718-25b9c7660565@nvidia.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 1 Dec 2025 17:30:11 +0100
X-Gm-Features: AWmQ_bnMEmfxLG1OVV1esCiKsI9DP3zTI0SclB2p7uTVFkawC9SWtkbSUgpCJPI
Message-ID: <CANiq72ngYj4qRwBUZoaS+aT8uAsjRRvY+i5t+L26GudN_0KVLw@mail.gmail.com>
Subject: Re: `KSYM_NAME_LEN` strikes again
To: John Hubbard <jhubbard@nvidia.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, =?UTF-8?Q?Sergio_Gonz=C3=A1lez_Collado?= <sergio.collado@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 5:57=E2=80=AFAM John Hubbard <jhubbard@nvidia.com> w=
rote:
>
> But if it's actually an option, it seems like a very nice one:
> a durable and long-lasting fix.

Unless something has changed that I am not aware of, it is still an
option and it would avoid us having to play these games.

So if someone has time to implement it, then that would be great.

Cheers,
Miguel
