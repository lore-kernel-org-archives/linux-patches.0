Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C9721B196;
	Thu,  9 Jan 2025 14:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736434320; cv=none; b=AHWDB04Z6tv5mTug3zpbXMRiXhBDPhxM7oLVMdo7gkr+YOb5/c/aKxBpNxzK4P6PvXCkqV/aAxOY8wDC2hGMKkYx5phv3yds2aiqiQ6PFuFbO/k243/REjcKgyJ2+tL6vWMzHBaMv5gA3r8EpoO6WjxZCTmTwIQoWsBQ1+Fjf08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736434320; c=relaxed/simple;
	bh=vGufw494e7AVXh5tSsVjnihLIZW0pgD5E8k9h5gHXP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EdYWaw0gYhkIpf482c4oihmOtyT/+rdbQK+heQBTSN5Kvf6IyQ/wULTtC375UCWVeQVnKyURZLRp4X618O3MQsEC1uj73uBJxtQXmzBCD/fxYiXd4jWj50qJktlsLEvGS3lK35XAi9Lls/vv6YtJtddfDKkbOiIeI6JmSDILcmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iFtU6tFT; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iFtU6tFT"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21634417587so2128695ad.3;
        Thu, 09 Jan 2025 06:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736434319; x=1737039119; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vGufw494e7AVXh5tSsVjnihLIZW0pgD5E8k9h5gHXP0=;
        b=iFtU6tFTnVZuBpW5RraaB3Rp5R4za08Hjd2FfnC0Q3KMD8dDkmro7c5CeZCdxeeDOd
         ZY+fP4tjYgr4BrWkjqMR7YjcyrL9cCK8+IgFj0OZzDVuMGISgnsw5iFfI8wmzzLQeU9S
         K1aLpEyyxImc23GVtJ1HiTaAAAYYUMXh2dzbHDaHEYpcFt5zTeWByaEsJijMDpTlqF1Z
         tpsaKAiQYJo+9LfhPIN0ypJUDo9vlSfS6eCCFn9AaxJiYnMwL7OTPKjOGyqoGhpkC/UV
         wOAL758cFHNNloqYhQ/AaRqaX3Y5CTBGAjX+Fk2ib24/mYY3/F7iCOd/vPY0zseCgqLQ
         Hp5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736434319; x=1737039119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vGufw494e7AVXh5tSsVjnihLIZW0pgD5E8k9h5gHXP0=;
        b=Qlf/zAbIOnM6QGF4FHZNz2abqgcEwEXoXRwwrhzhGmd2biCCOMW8vrWXCABtHQfKKH
         puuZH0fqyK++94bK0ESE9zPQad0W4vlM4BZjzbkeDpaFXY54Z8wKd2C4vvb/r2Y/Trbm
         t/Q2A6oK+0ZDmXqc7wyGXFCOGHUzT7Brcf5WLLpF8eXk6tG7GfFytbhudEcqkbaBmwqg
         MGp26SLtdsGVm+JtuWg3ygCWiNsnIdTkSTVduV5bPp7EJydRdtscNHrk23+tb8OVrqZQ
         xcSsatP9ppPBpyhW4VD6vLtrHnjo+kUf/GQpfZtxcVycNKxg/JTX7q/EzFEWC6LJ5hcd
         zDUA==
X-Forwarded-Encrypted: i=1; AJvYcCWHWixOlAmgSIpsHUv+esucklocCut2hP3LJ5h+CPQ2Utdf/CJj2KJxuRPw7GKcnDB6GBU9@lists.linux.dev, AJvYcCXbBFTO/NqPA2n5Ija0GNkY4OYoNBVoMEqbZw9AGjHxGaPSAyojZV3nczO3PkxjtCykFIst915sXQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YytMA/7rrNGXcX3GnPncLRxnEOsTdTXdgeXtjtAPDV91qIHYmHS
	fNGbzhJcZCh4K3FPDX5yrGz/1k72+ZE7PR3FqlDVQxFX6We7PVO09aRehmROdDT39X6LyoG5JHU
	nUKpQt9xnWf80q+kB8/tH62Ku/QI=
X-Gm-Gg: ASbGnctPmC9PBreuElv4ZDa2qAbiiNdzpfw5yoSD1ONgd3+fe3Xluc4G28Ptop63sUs
	XbvtllOhnYdiCZ7vuk6kUY6/zyZFwPIg1bx/+5g==
X-Google-Smtp-Source: AGHT+IFqNT8q1pSMMob7gWW6dLdc3C5jBhpyogdxQ4jQ4PQacYaeZXz/JaXG5GK+wbEAFynpACiar/4mvaK6X3mkMkE=
X-Received: by 2002:a17:902:e5c2:b0:215:a97a:c6bc with SMTP id
 d9443c01a7336-21a83da2ae3mr39042525ad.0.1736434318601; Thu, 09 Jan 2025
 06:51:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241119185747.862544-1-ojeda@kernel.org>
In-Reply-To: <20241119185747.862544-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 9 Jan 2025 15:51:46 +0100
X-Gm-Features: AbW1kvZR7Xwq8pBqsleSoij5Li9YxDLLzZcWeC8ntsndOTqzMLEhMpAg4Nk5iUQ
Message-ID: <CANiq72n4Fw96hcuqQeorsfH7z4Tb+R1gdf80H_XkD-oA6z5TSA@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: allow Clang-native `RANDSTRUCT` configs
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Aaron Ballman <aaron@aaronballman.com>, 
	Bill Wendling <isanbard@gmail.com>, Cole Nixon <nixontcole@gmail.com>, 
	Connor Kuehl <cipkuehl@gmail.com>, Fangrui Song <i@maskray.me>, James Foster <jafosterja@gmail.com>, 
	Jeff Takahashi <jeffrey.takahashi@gmail.com>, Jordan Cantrell <jordan.cantrell@mail.com>, 
	Matthew Maurer <mmaurer@google.com>, Nikk Forbus <nicholas.forbus@gmail.com>, 
	Qing Zhao <qing.zhao@oracle.com>, Sami Tolvanen <samitolvanen@google.com>, 
	Tim Pugh <nwtpugh@gmail.com>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 7:57=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> So a patch like this one may just work already, at least in some cases.
> But a fair amount of testing is probably needed for this one, so if you
> have a workload and some time, please give it a go!

I may pick this very early next cycle so that we can get some testing
during the -rc's, and just drop it if something breaks for anyone.

But any other testing beforehand would be still very welcome...

Thanks!

Cheers,
Miguel
