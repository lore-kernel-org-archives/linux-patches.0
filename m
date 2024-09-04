Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC234149DFF
	for <patches@lists.linux.dev>; Wed,  4 Sep 2024 21:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725484555; cv=none; b=eesYAGwRPqR3ZjQqBcsYXS87YRZw7rhoMSdRAYsbWZehCNvmxW+AyPZWvFlMGT8/JZvIgcb+DBz92cwcM/p+f84H2oKtA+TghC8S+7JKkIm48RDKMMG2TutJnNH2bXl4Ke+6wvfE8OoxFT3QHEAYv3VOl1TCRAJiKamRuzjgRkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725484555; c=relaxed/simple;
	bh=4fCflFULU1+SFkIZ9nYfOOgt5VRh5g5+mOSpWCdLiVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FjE16oBvl9rh+zcNaNmrpuRO1DWoq3qahpuRFr6GoxPBfZxy3R1FfGXtxmc4pV+kE2xdjcY6B4ZKzSEvrCC7uF0PeG+cnsbNRP9xS12gqGO3dSgCT0ZJV0vCrtoLjjmX3BpmsjZk5h5ZGU8I0aSg9UhzzWmXcwVePTIJtEoztWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BXgjKH/y; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BXgjKH/y"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2d88a8c66b7so1268a91.1
        for <patches@lists.linux.dev>; Wed, 04 Sep 2024 14:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725484553; x=1726089353; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4fCflFULU1+SFkIZ9nYfOOgt5VRh5g5+mOSpWCdLiVA=;
        b=BXgjKH/yaAbIeBRBBoIXyjxbvy1SUjs3HTgcjQOW6NgdJgw/v5Qo7ITaHuqusD+Dzv
         I7a816NB54BpYPvGvv5GYMio2Xthx15fITfhuIXOp91iXKCsDzAfGnhIKgKcNGxskUMd
         E20640q5LdcJg+6NVPd+ZVCzRpwMXYiVfsrycTz6pfnDRCfqCeobahN7gZbyL6R9oFSO
         c5Sy+5D8eTc79ifcFYffcQhWppYaB/V2Yfv1GT0jeG/hln3dtbi39EpUDbm9PUfVqGrO
         A3Rk5N1CEdKJCKATexaaX5zgXnhZ0JdTZNIPCOK0PzkbnJ0biPOaeRVR71zzbgU1PM9q
         PVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725484553; x=1726089353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4fCflFULU1+SFkIZ9nYfOOgt5VRh5g5+mOSpWCdLiVA=;
        b=CSdZPAUyVB3B5az10bux0vPRNHlrrAHISbeJZUjXiMBrKBEc+3xwwhAN/cFSZxwWEV
         /pBNBYmGVrdbDZ50QMG/wzT3WiccDLoZ8jEjvnVvsGYcpNpPIIJOgqqQGm86L/bZabxr
         Q9S7JbF8mI40Sv6E8Ym50v/ygQ8toM0ySR1zMGtjzMVhQ6lOJIbwwvFXB3HfC6X3wCfR
         FrZQGI8AUNhxXEXJI7TjwLc7YYsDbytIkXuSYs3uBqamX6P+nE/hiK4r3pAxWbbvBqZ8
         3qlcNAi/CPogXXECHucronKEz+G46CD1qVT9IQ5/0qGGUxLu8WPk6zoTnm7jKym6nnxl
         /l2g==
X-Forwarded-Encrypted: i=1; AJvYcCWrGdki3rU/VyQTpdfnGxlzZSWt1e0zTw0bGOYsaIMATmqxm/AhfUndeVokOwv7EWm1YCOFlRp9@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/lMpSrimcoqjm1vTRfAeKjwkZrw3NwomF8/SXQ6+u2Q8RELbL
	+26ziW1DbcpMnOaVfqeLyjA+ukGaSLPde7nzMt7UT+i7Ll7XDcy7R+jHc5THmyReGLMD5KqNVix
	NQGMt50fXw70krK28v5BECG7mtSM=
X-Google-Smtp-Source: AGHT+IFlxv6CPgnp/Wrf38HuLWqVbBunoKGlc8ncr3kHRkQdIkIQT11t5zcA9Eh5DzjZI9I8Fg6EOTfIRZSE4JfoGUQ=
X-Received: by 2002:a17:90b:4f8b:b0:2d8:e7ef:7d23 with SMTP id
 98e67ed59e1d1-2d8e7ef8144mr6231365a91.4.1725484553082; Wed, 04 Sep 2024
 14:15:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240902165535.1101978-1-ojeda@kernel.org>
In-Reply-To: <20240902165535.1101978-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 4 Sep 2024 23:15:38 +0200
Message-ID: <CANiq72ni=sC7Co6W8U-_ikGU0Tf2HvOOoNdHOc7dXLWb1Cuq0A@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] `RUSTC_VERSION` and re-config/re-build support on
 compiler change
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 6:55=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> This series mainly adds support for `CONFIG_RUSTC_VERSION` (which is need=
ed for
> other upcoming series) as well as support for rebuilding the kernel when =
the
> Rust compiler version text changes, plus other secondary improvements.

Applied to `rust-next` -- thanks everyone!

Just to be extra safe, I did not add patch #5 ("kbuild: rust: warn if
the out-of-tree compiler differs from the kernel one") for the moment
to give people more time to look at it, but we can add it later if
nobody shouts.

Cheers,
Miguel
