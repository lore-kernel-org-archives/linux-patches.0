Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732BA37702
	for <patches@lists.linux.dev>; Mon, 19 Feb 2024 16:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708358634; cv=none; b=taobRvapVNI5rsooFYbIoyLxotJIiFTQUGSMtyDjy3pFygIprMf8tN3PZ3sOOXyympsFmmRvnkAitKV0X8HMSOy+sZqHkC1f0g8I1KLQ5Vg4Sfk8vv6k40eBJ27Tb90/OKp22jb1/tgP5KhS4k1zYs+WfYWxYIBQRLpAOx3lNKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708358634; c=relaxed/simple;
	bh=WmRlSNkA/KdX9XPb6GEYSoKbr9CXuMXKqExqINGkwbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XIp3XZ/PjMOE69MJkuVk9SPqNk11Iy78e5v9Q1gH+Ykcaa3KgcvXLAgZj1+dxlM8hlGSt/Ecw7DS9lStxzbcoyi9PAem6GhCPSsWj146LCL/iLV1aN6YUuapiwy/QIXMj8a3obrizDUdFy6IqHi1IJL7AzziT2TsbRR8Sim9iik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UVs7zsTN; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UVs7zsTN"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-dc6e080c1f0so4013535276.2
        for <patches@lists.linux.dev>; Mon, 19 Feb 2024 08:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708358632; x=1708963432; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmRlSNkA/KdX9XPb6GEYSoKbr9CXuMXKqExqINGkwbc=;
        b=UVs7zsTNyOSw0YYV05MMYbdTuY9kmCTlpGNSbjOrcSs8QzipHAKR9LjFtBU8SNB0Ud
         Gn0qfBB1BN2WQ/sZrpkLTM6NU0VRZwp64Ni1uXVoXCtUEStn/t6DX4XJRXLcZZpD0x60
         Vt8A76qMU/ChQ30kXt8tBa8h2I7aEyyn8wIyPfC2g7YNakQMedbeJugMdQ2EXZDaqaiu
         WW/JvD2b3jBM0ERKWCJhUADHeQMPzJuIuIdWdXVMyUPuc/PQ1ynNeIzs6twvcURiL4Zx
         R6ehgFo3smmdHmYUXIDH+fOjSWV1vhlj0tbUVzyloH1tHghGRmNvSuXMm7i0PXT+uiob
         L4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708358632; x=1708963432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WmRlSNkA/KdX9XPb6GEYSoKbr9CXuMXKqExqINGkwbc=;
        b=D5Psb7ORtz83fNXn8d3pFhltWWIVCQ49h4MEpI+AobvFwPBFr6zyypUI4CyEMqeEL8
         rwStIBfClZ0oNHDAVaFI5ZaUtUJW2hWLX1N57pWyzyCBcAlcJk28t4saqZP/fjlY1q6U
         LTzTqLdhYTYzcGEjAjfHrDkUCy0Lk9celPhilgBA5tpbyo2UNxDfwIR5Mg7/XJF1CDxZ
         ylXL+ijfM++fsNGaPyUQpa7POU3pghk0p2wlBENy4tlrpame/hsTH/2a5gKU/3HpQGr8
         caxY5oADQx8hUDUBK2bg5+NSet3gcsNTz8z+lqoAmr1zYdmW2tQmtBLN+iRFmx5dkwPN
         0ttQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1O2Fdu17+ERmJit10wWXmoorUWSH2k4dzE4lxJCv3vQoDPgabeEXc/rwfxz1Wcs0C81ipHVxBO9weLkuGOzVrDt4Pfzoumw==
X-Gm-Message-State: AOJu0YzuQUpb6AOFRUwpq5sa7LV2CUg+een5UBgaVfz8j2dAtXVQ2QsD
	GTgF9MiCJY+aN+pI6RP7lnPYWF/6jZr54ZNAlsvOUmeibeu0gvE1LOsusehbxxau0ge1LPzSThR
	mj8u7GbhRjVVEGzgZg9ov7Dzqp4Dtt42o
X-Google-Smtp-Source: AGHT+IF1m6Ip0CcBIu/E+D6EL8tZaYd0E7pl/0FJrjViHllCekK5lu/AmUM3Gf4H0Avnm+Z8AE/nVZLC6R42mHnhSWU=
X-Received: by 2002:a25:ac9b:0:b0:dc7:5018:4022 with SMTP id
 x27-20020a25ac9b000000b00dc750184022mr13383631ybi.44.1708358632536; Mon, 19
 Feb 2024 08:03:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217002717.57507-1-ojeda@kernel.org> <87ttm4g462.fsf@metaspace.dk>
In-Reply-To: <87ttm4g462.fsf@metaspace.dk>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 19 Feb 2024 17:03:41 +0100
Message-ID: <CANiq72nbr6qy1otJpdh3FVUN5cUfrkUPYEHJFm_QqfKvYEj-Xw@mail.gmail.com>
Subject: Re: [PATCH] rust: upgrade to Rust 1.77.0
To: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 19, 2024 at 11:06=E2=80=AFAM Andreas Hindborg (Samsung)
<nmi@metaspace.dk> wrote:
>
> I am a little confused about this patch, since 1.77.0 is not released
> yet and the link [1] (currently) points to the release notes for 1.76.

Yeah, the patch is written as it would have been written by the time
it is applied, i.e. see the note after `---`.

So, for instance, the link actually points to the 1.77.0 notes, it is
just that they do not exist yet :)

> Will there be a new version of this patch when 1.77 is released, or do
> we just expect no changes to alloc when the compiler goes from beta to
> release?

There can changes (or not), so it depends on that, i.e. if not, I will
apply this one. If there are non-trivial ones, then I will send a v2.

(There are no changes so far)

Cheers,
Miguel
