Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FCC2D0C79
	for <patches@lists.linux.dev>; Tue,  4 Nov 2025 19:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762284235; cv=none; b=UijiOQfotN9V8Aphhe2CqfAb9LbIN9o3OsbvwnNQ79mIFvNS1VGJiJT2wdJw5SBMdMwlJ3uaWZN7OGb15I9e0OXMZHMKc0EB1gbTWaimNp7NTOqob83BHZWPnaw7RRiXWknlgkUEFSpwG5p9yhUvOj8PwudJcvu/byOschC0T00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762284235; c=relaxed/simple;
	bh=NqeaPpBSzYADuuHCmtIk20h3DrnAs8JxaBG6a4X0D3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iIGnkpgC5zsb1TtuPKeFAMwR8hhmQicBhgT+nGI3J4vJkLFy2Gy5lIsNdOn3h43DV2ULFHJ22soxJu0fFwUzHn/lOXzLHzr/XLxu1J28EI9oapms/n38Ln1jxvMBCXLJcbsK1xwPUuV2uoHZefWTJaGcx9dQUgN0hpnGlYnFh/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l0yIZLCB; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l0yIZLCB"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-29627a41299so450785ad.3
        for <patches@lists.linux.dev>; Tue, 04 Nov 2025 11:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762284233; x=1762889033; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqeaPpBSzYADuuHCmtIk20h3DrnAs8JxaBG6a4X0D3A=;
        b=l0yIZLCB5GSvQ3cZxOlXy/wgl84aH4WvlrLSG1Kv/JvHVKA1dBABIM+tD6myEUxwuP
         CPpiZ7pMiztsX8WuDL2RSWdjaWevgQsSLsffluaf9TFNf8Z99qfjn3b9Qa1sIP59Zx64
         EjIUfDo7DJqisUGFG5FicdzxSlhFzcdhbAaaXhwQyn1b4ZVlycpf3cdKidni9Tjly/vu
         MDsiOuNijc7vgR84UM3EcJ4fLMndhs2IdGkpHHjV+TtyeXAPUJc/bZC8xNh+LsFz2ZxM
         XxWK3N4hbTEqd+WIkxxPG0WILOPrRXMiBsbnkLils8Ji1iiF41cFCCF4dhigoIu/pS8W
         MuaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762284233; x=1762889033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NqeaPpBSzYADuuHCmtIk20h3DrnAs8JxaBG6a4X0D3A=;
        b=berel7KY+PcMxNHkTUsy9OtE7VP5n60/7BUcD9ZkF7Twks/59wPSyTjTA9eiR77Gg8
         Yuy9IrykyB4KK7bVZdA0UCa4r9v25yoBaLvAVdg4Q5DVwVmmlWuGCvZ2bkHX+qe9ra7/
         YuTQ4tOKusgCumq+LPeWU7Ez6CkIolSMjt35VzlzcMe03fixxjAoidGW2K3SU95YidS4
         Qca0GmRIqwSp/aYeJfNBx8VziirvX2b3wO3P2zPQIn9sbErig4xZneyrInVcYGSIVqtv
         MYShf28LjSf6Ft7YdkjhBfHkzlSJTscuvARjgTLLbBY6xzAdUkNeGl1+nrQnoAVXDrSL
         JZmg==
X-Forwarded-Encrypted: i=1; AJvYcCVnL04N3mMFYvp+ROigKjnvK0mrSCrzRMyPry5NX2dH4zXLWhEU0RpA+i8qRVzJ0oTk+2C5B562@lists.linux.dev
X-Gm-Message-State: AOJu0YyKFiuWR2+9aX3MLObPsibHX2gubgB/PYBpJtwkDElt3yWqWs/p
	tloMgjr55r4MrMyIK6aldwW+XpwJqI0tRNmWsy76cPZP6tkZpA9k9uYvR+Ukme159MQzd9LI2Jd
	r47yg3ELsKOx4+kJqfYvGre00t4nxiMg=
X-Gm-Gg: ASbGncuO0Atsr8/cqudjjPkXUyBQ3tpu6WOtsYBpapz28zDVswdNuKDp/4mPv/lvlYl
	Hm4OUhyXtk4/xcO4Dj1fY2DFmhwt+e+NgbM8cwqt0BM3Tzhb2FVicQ29bSosZlVOz42CF7asuQg
	n/eAVOrDH5VshlCdC5JN2rzkQXurrnBDZGtFV4sYH10nGnae/6CtvoLov/LDOtA88h6a3OVCqYw
	AWPiKHkdI3AfzGFm1aLfdnO7c+YAgEL3NmSCL6+G6gicCHUUwtaCZ1qPnzmaR9pUI4Htjg5SAww
	oRg2L2FNZNu6Wu7fex3166lVIYYqKuvOp0PMg0gjiXhbFNAZw6SaSLTUuAN1zK6L6TzhH3A8xFZ
	AFLw=
X-Google-Smtp-Source: AGHT+IHCk1/j2mBDXkX8+o2FTVWoribYQUy9xTzp1hxavAo8lRskxPigDirMoCigmuiFNy0hYHQN44kMGg808wTtLgk=
X-Received: by 2002:a17:903:2448:b0:277:c230:bfca with SMTP id
 d9443c01a7336-2962ad3d590mr4530815ad.4.1762284233160; Tue, 04 Nov 2025
 11:23:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251012224645.1148411-1-ojeda@kernel.org>
In-Reply-To: <20251012224645.1148411-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 4 Nov 2025 20:23:40 +0100
X-Gm-Features: AWmQ_bmVIeG-cW8V3oOiaFedybQztgT0tJXqDde7XoeN52zMMEb3dKuMzzPon1s
Message-ID: <CANiq72nHV+HoHFs_wS7B4D0s4vihPLoCKu7AaAAv2AhCN0d23g@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: quick-start: add Debian 13 (Trixie)
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 12:46=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Debian 13 (released 2025-08-09) packages Rust 1.85.0 [1], which is recent
> enough to build Linux.
>
> Thus document it.
>
> In fact, we are planning to propose that the minimum supported Rust
> version in Linux follows Debian Stable releases, with Debian 13 being
> the first one we upgrade to, i.e. Rust 1.85.
>
> Link: https://www.debian.org/News/2025/20250809 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
