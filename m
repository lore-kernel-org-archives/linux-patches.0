Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2671C3BEB
	for <patches@lists.linux.dev>; Sat, 19 Jul 2025 22:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752963391; cv=none; b=XGz9rnxhypC5SWHf0JaMGhjFDU8RL2sbXAJXYGKYpFNoHMgL/6SFMgL12EVWtkBzkEPH+90zivGWOt0hh3oXagQUB5ygyyZR1updc0JMZdC04o04XN5qCqOIBwgWWL2XIKHCNbrnOQHnfjF1rKFkUVju0HDo6Q80f3kQ0QupPgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752963391; c=relaxed/simple;
	bh=NpkpzpedYY4EMfcvwrKPMwxu3YU5wekHKDu3bm/eEJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hHs9nCqsEBlnLKKgvUmjKbHTRaAz80iDdBPiZKaAfULQiBCOcvIEvrRorcr8T+CEjP9s/3dejfjF73CFkPXCh89xXufNOUXqprQENAWOtZX1y2KEPmHMku0KPi+DeLBmAPVK6CeWCpeMjw5XyPitE5zZBIeLhK2X3yPKAkB74RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BUdsq88f; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUdsq88f"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-312f53d0609so675786a91.1
        for <patches@lists.linux.dev>; Sat, 19 Jul 2025 15:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752963389; x=1753568189; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NpkpzpedYY4EMfcvwrKPMwxu3YU5wekHKDu3bm/eEJU=;
        b=BUdsq88fRexs0uHZx3n0eaQitfpXWNJ3zvipVVdFL8i9FjjKFCZIBFIsPPLdj0JQwx
         a33mlvySBrtYf5GATKb9O2BiEUDPtHBAmLFTUMQWt1/nrjcHaVhCGiLKhttgienzhC7m
         nVysrwdOUiuMvvFE/CDlON32NVeIR/UuaA+1lTUq1DOBJYp4CjQqO1HtK/y6bWu1e9q8
         vgc/RZVms2TTSrS/5FgcSmFrue9xdd/1XPUVFa0oc7JpH+QFD+JkTSWm3FxzAot3Eq6a
         +0sbzfLWnhOdj+5p0GSDX6i7/MqidO+Zvmu/sWCCeg1NZjVl+h9V7vSzMRSA+xeZ/JXP
         l9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752963389; x=1753568189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NpkpzpedYY4EMfcvwrKPMwxu3YU5wekHKDu3bm/eEJU=;
        b=ZukfNPkiI4EKQSN1r6lqnEkon6wBi0FS97bxT/334iyblkEpwoiZrRg7gGcueq6Vuz
         olfQs2B4ch0VYpdkGxvyZwU85wf6M0kSWD/gO6INu2kpIUx1/J6ttPsv1v2u9L6DV+lK
         luhbuNULO1yYxbf0yR2nOBVF+WPEKng4JcbhbJGcWgVj1w73KmY/Ot8/hnOMuU2NJ/0g
         xB0/bciNIVnQg4MQxzb7UNnsnzLfRERCEKXkkms+qcVk7vsRwU6Whvty9D6FEa9DMelX
         G87JMIrC0VpomXWLvks4wWBcRE4g3uiUrxFMD7HFpkYm4Pd1pY3RxkCs99U6odpWeW84
         3dog==
X-Forwarded-Encrypted: i=1; AJvYcCUtrGQXulXqD2GBqozma9ijx+cRQrGYaOS88CoXmn4ivmDyj7xysdvr7TayTfRw0LdtRCtNaArP@lists.linux.dev
X-Gm-Message-State: AOJu0YzxlKosSRLa7ORYlih8Pqjxkx+RKxFCmakcliBcoQEwQEtpFp9k
	4C4MktaL/WJDhHE6Kb0SUXbCMzSt+hyPk8Ax8m/zyQj+5yFEqWS3Ghwf+sfW0sbPdfeEYERE4j+
	oU34fuMZHqH06h6H/WB2tcv7yOpdQNGg=
X-Gm-Gg: ASbGncs3BwiTb9Kh/PfLKEC1q77ZWTOwwFpe3p3rVhm9UCEkbqlXFM6T6uJd53/9WrV
	mQDcUINw3QJ+QLLh2lxJmIBlxibBlTqltaht0/Q5+k4wwESTWhjgMzcryWIyavOnkxEiRqRCRqX
	YypXFgCfx+apfmuOJcJ0el0ftwFLUeVSjjZ8YLF5chUIeqUk+KFZVnvbY+vkW1GchIcinPjZf6F
	p3f3In6
X-Google-Smtp-Source: AGHT+IH6BKo2lnSTjkKm7n7x884y5POek1ffq9Xc270brisl+upX+noMOrw7jbWwO/I56s4/GJsH0QZB9o1iIRnlP48=
X-Received: by 2002:a17:90b:1348:b0:313:f9fc:7214 with SMTP id
 98e67ed59e1d1-31c9e6ec8c7mr9435742a91.1.1752963388984; Sat, 19 Jul 2025
 15:16:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250719183649.596051-1-ojeda@kernel.org>
In-Reply-To: <20250719183649.596051-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 20 Jul 2025 00:16:16 +0200
X-Gm-Features: Ac12FXwbHDJLi_zasTuQDMfRLkeGyZbrsVlDTOxOdBX5LYNwt4g6FSLKRrHf9Oo
Message-ID: <CANiq72=6HE=wz3M1fqAKAUyypSKZXMe7vFXTyYNWSf_0+ysC4Q@mail.gmail.com>
Subject: Re: [PATCH] rust: list: undo unintended replacement of method name
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2025 at 8:37=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> When we renamed `Opaque::raw_get` to `cast_into`, there was one
> replacement that was not supposed to be there.
>
> It does not cause an issue so far because it is inside a macro rule (the
> `ListLinksSelfPtr` one) that is unused so far. However, it will start
> to be used soon.
>
> Thus fix it now.
>
> Fixes: 64fb810bce03 ("rust: types: rename Opaque::raw_get to cast_into")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
