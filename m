Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E590B6AD7
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721901241; cv=none; b=aDBz6q+1cX1SO9NrmXqlBBf/YD8QBwkWAqruTqpiKyv+n12hZsPKVT58i9ZFUBU4g8nQeUJpqEDz4IhpxgoOUAiyKpquERGnnPtopzvyZgHDRTtv3DPUHF1alCqNSksTwBhToYBhYd+9ARb3KsslGir8YI3jkT0QEgY6669B9Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721901241; c=relaxed/simple;
	bh=vSW6nap/LLM1u8M4rcd+ljLXNqWVV429u9e9s/OZH8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XPV5VifI0ADEqfPPc1SM+FX31r2juyBmCvail3f7pOQQ7M21A1Dz8SyuEg8X8q3p1ZfgHYkpjWvJRyA+T2Emxn/gryLg+zaJbnCacziRMX3yHGr+sFEFQEnoH6n/I/jPd+14TN2WdJE5vIA1LZ40aEdtAzFzsIOZXIrHQYDHY2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kyiFaJxo; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kyiFaJxo"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-70d138e06e3so622221b3a.2
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 02:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721901239; x=1722506039; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vSW6nap/LLM1u8M4rcd+ljLXNqWVV429u9e9s/OZH8w=;
        b=kyiFaJxodd4hg5ZENCsXq8eiVC0IkIHsW1fE8qOqU2Qwv+aIzCZZp5GguxbadTpNID
         oe+h2SGJ3UMGcjftE6XS6YUwFisyq22u17oRb7ZfuOH+ADCjR4Zn6YRIcABGMYSSowSP
         c6QKVrF7uywVvrypZ84LHkBg99gX0GTVODgdD58T4GBCqNaO/qpCFgI8PqlTqtyiNg+L
         R59efcdHiuSO7oCLpL/Ju+wFSy23DBpv4ddKm42cH+SvIG788gi37FDbYsMcsLRA0jaY
         U9954ND79kSHukove5fj8JYZ68oK+xDQOESj8EIb9XLzIaVoe9OAuc0nyEdSimm9YZYd
         rMyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721901239; x=1722506039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vSW6nap/LLM1u8M4rcd+ljLXNqWVV429u9e9s/OZH8w=;
        b=aLm8HwIk8REGyOjh7wsz5M/LeXer+FH+d+gFYI2Vx0o3/dNkH/pDBZrG14w2jykyUS
         OAniYfqH8lCCPYH5l6MMxXXyidX2hvqGU6uEREgPzeleV7LiEYEy3lAFDCZzroamm56/
         ZnGXW6LjmcvJt0OQHOuaVbByr+X6Yd8CpnsRGFePFdHpnbSaA5OOgVtdQuho45XfqDi7
         0zC9V582Ij9X4c3NARps/8OzSN81kOkMJ57M9SDmLeBtDmTdVfvWQrx6svLlHngy7ozp
         cQ54AdaiaNw0C0l3IVCi4HFLUx2yeOOI2sqqs36N6npVT2KdTv7IiY6iTK6aOBzqntt2
         la1g==
X-Forwarded-Encrypted: i=1; AJvYcCV3vkrnYxEJ8APOBexa8/L6/rnuJGHF1fFOrmYOa/yW/0EY7CnbcriQrhPfcJHob/G+I4JDY15Uh8DqiiRa3+DlbmX2lWB4GQ==
X-Gm-Message-State: AOJu0YxFihC1W9q2klTH+Bsd4Mban5feL5DdopSSm6dwmUhyxHIYNyHI
	QF0GmAjacpc3TaST2D0BnjMtC1Al/p4MusW6Ns+vaYfMd7HAJ/vdo0Fj8FnjylE12GFa7pSQM7N
	nsFxIgmAQIlbSUIXz2NYW+pDMkCE=
X-Google-Smtp-Source: AGHT+IFbiQ1IXRG1NhZZZm4Tze6bWl7R6efpC801avvuhU8GxSoCB2LAvGFLfv5GxuroQt/KFwaKLZvWVx9chw7uKtY=
X-Received: by 2002:a05:6a00:1ac7:b0:705:97b3:4605 with SMTP id
 d2e1a72fcca58-70eae98fd23mr1499310b3a.25.1721901239298; Thu, 25 Jul 2024
 02:53:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240724161501.1319115-1-ojeda@kernel.org> <20240725083836.GE13387@noisy.programming.kicks-ass.net>
In-Reply-To: <20240725083836.GE13387@noisy.programming.kicks-ass.net>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 25 Jul 2024 11:53:47 +0200
Message-ID: <CANiq72nNost2vaCd9Ev5hraFRJvV7ae8aWS0O1q5KGWu1h8yjQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Rust: support `CPU_MITIGATIONS` and enable `objtool`
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Masahiro Yamada <masahiroy@kernel.org>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2024 at 10:38=E2=80=AFAM Peter Zijlstra <peterz@infradead.o=
rg> wrote:
>
> W00t :-)
>
> Aside from a small niggle about maybe doing a helper function for those
> Rust runtime things, I don't see anything objectionable here.
>
> Thanks!

Thanks for taking a look that quick, Peter, I appreciate it.

Happy to move that to a helper.

Cheers,
Miguel
