Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952031917C9
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 20:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725569221; cv=none; b=JOArKljbEcS+9IJZ3IFSrpEmr4q9hmtxyRRrSGsbd0hixd4pU1labEczWlHVPqoto3tvO2vs20QbIKQSZLzDQMRLuFfVcoLIFiLj2ANjhPzJuy4WdjFmSkGnwSp7Vt8vFQQZoPhsGmHaMiQDZ1nHAwEPAboAGzuik7aw9y7WycQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725569221; c=relaxed/simple;
	bh=DKH0xshsIJo/ETksdiaF50SA60u4xZglDzBF5StYyLk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f/Er9iRc6anZhW1JC2PR5SpQgWmVNiYJJQtmyG2bkveldfn190oRxYBa/YWjXD9Luikveww8Up7RcaLJT6+NS03P31fvfpSUeEl9dlLGIA28Z/L3fZZa8S0Q57hNf0/J3R5VaQP+KH6pAhVfQgXXjbzusUpQnd4p+lnYtPRDDWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HSKYJf/i; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HSKYJf/i"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-717839f9eb6so139883b3a.3
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 13:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725569220; x=1726174020; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DKH0xshsIJo/ETksdiaF50SA60u4xZglDzBF5StYyLk=;
        b=HSKYJf/ihHAh/ctr74nL/wtqFoRcC8QS3jPkJUWYxaBJ6lmvQzV94onsxwHZ3GUCc/
         qPxo25RHciReK9EgjQY4hWdHhgkPAd52UjlPyo6w3ZaNXvMc/60jDfGFS8+mY7ip/kOu
         CobgcI3gwF06OYG2zt4mDPhrtC71GfcMgrzurfHWQ43znWGFG0Iph9ejaWzubop0RQYU
         o0aXEVDyWdMN87ZKd8ESRfxtOJmBrWjaHGe4c0T9zKpgN/f/cHy7fkoeJSSGqb+roHpX
         S6lvIZHMSXCV1aF+4A0urwNZF7hi1AZbuKYiicH00gmFhsr4nePVHKhtNLPXyhqGdFKq
         ERUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725569220; x=1726174020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DKH0xshsIJo/ETksdiaF50SA60u4xZglDzBF5StYyLk=;
        b=c/OJbMPnb8b8be6z4Z+EGXEqiPilVsXqeBDBEOEmyElnopwa9snsoNvjStIzBoUEOJ
         N1QWPs+f2g6CnEy52B1MxW0rBE0dAjafXJruDYX9JU2AIsaq04BDUzIhiVmj+LMybGDF
         RvwtOLpQFQTphTkPN1lZh/IMq35k9b6M63yfBcitfSh/kLXFAgfmanh7X1JW5plyhZYd
         hXnv3y0tMxPU7zA1dmEnr7+pmecxllOH7dvpCi95p7gsHOCCoj9vXASyq1iGEBOavxcA
         5OEb68q0v/g6dAWMFMBhdT1FlG7INXFaHhE+k0NCQlPHli3P//axjnEEqm0UUiDN7wjL
         PG5A==
X-Forwarded-Encrypted: i=1; AJvYcCUk+kz4Fj2woktfJFw70HUgkv0+ZWdHp0TVQ6r+KjUCYvXM5w9O7S5ZLcWcTMs0zUvK9gwl0+3k@lists.linux.dev
X-Gm-Message-State: AOJu0YxFtiB0s15umPPzZOIRF1pHPP8rMxwkCAKxrxZl5xJhX9X/GdfI
	9xRTj+7srC+YliP/NsEw6jcsCbNOKxROI/OxzApxh0OqjOPOTTCd2dPxk4ucJ3VK16Uhc4HpKeG
	pX27SJYfNsppMwLGar2VCpLgTcLs=
X-Google-Smtp-Source: AGHT+IFzXHgm+VyemU3aVNcQp6kBBtTnENwAdJ1aQ2Sebf5JxvLGKKgceH6BhhcJazgo2Ph4JaNZbZod5wjwomF4Arc=
X-Received: by 2002:a05:6a21:33aa:b0:1c0:f5fa:db13 with SMTP id
 adf61e73a8af0-1cf1d055c8dmr140864637.2.1725569219732; Thu, 05 Sep 2024
 13:46:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240902165535.1101978-1-ojeda@kernel.org> <20240902165535.1101978-2-ojeda@kernel.org>
 <CAK7LNAR5Fz=qf1Srf=RJhGANQZDmiKkuHPeTbqyT+SEwjtDZWQ@mail.gmail.com>
In-Reply-To: <CAK7LNAR5Fz=qf1Srf=RJhGANQZDmiKkuHPeTbqyT+SEwjtDZWQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 5 Sep 2024 22:46:47 +0200
Message-ID: <CANiq72m5EqCO7i5=fXpsETpHjexknvPVBWYcURZquQ12N_om7g@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] kbuild: rust: add `CONFIG_RUSTC_VERSION`
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 3:08=E2=80=AFAM Masahiro Yamada <masahiroy@kernel.or=
g> wrote:
>
> This script does not print the name.
>
> Only the version.

Good catch -- fixed!

Cheers,
Miguel
