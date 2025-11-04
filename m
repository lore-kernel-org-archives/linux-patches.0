Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0901B1C5F10
	for <patches@lists.linux.dev>; Tue,  4 Nov 2025 19:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762284331; cv=none; b=Wo5Ham4uLNdVyuxe4Em/pKyWWQKJt5Z7Jy0a7IgGf0mjwshv3vRF7kOdl0lcqq25UIkeRe40Ci886Kj8HPCRMPezJMpf+u5Jw/M703g6VRtxkF/APR2e8YhY2Jxs1qKLPqYgnF1to3dbuAvALaU6G7OhHDGnQodzmsEZ1AK2Cs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762284331; c=relaxed/simple;
	bh=K4Iyxi52gh1Iw5mMl2HUNeLP4ewV8sTogXEjAzGJ4AY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n6yAAGW8QJdgyhM7pEkFCZTUJr0V8jrEB0esOY/thJrp6dlgisj9lR/d9zBveHAVZAyncJ4MyZaw3FLVpXcJ1ToFa1ir2ZyBwLYteOczk+Vc4zs/ZiBwBzLUUZuvSfhM8X+utaV3GZmaYRKrF3uvn9ef4LQ6sZlTPBkGI5OVBns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBV/ADBu; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBV/ADBu"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-33bb66c96a1so1714426a91.1
        for <patches@lists.linux.dev>; Tue, 04 Nov 2025 11:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762284328; x=1762889128; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5cZx+RW3Kt24V+mQj1nrZgt3YKwbbGOTRzEZ/APfqy8=;
        b=jBV/ADBueDvVPB7Yaf30iE7PsB3wAXzJZqFOG/krjCYKjORGHFK44Ud3VnQA4FnXlq
         v6VKIBP3faAe+lVnhhPl1M2agXB+8BF3f0D1EqTgvgxGFEhKvFLH0Jm0hciSorhunrvU
         TKtZMxEjDiihNYIMHQC29n4GdHpn7lFcuLOy59ViIvpUTOeKgqyiQzZGjgfcKMV+8/68
         k/RuuFL8Rur/x/4ZtPy5drsWEtsWdZWGdqGK3zCE8AVBq5LxI39bnqRdEUpw0G6c8MKj
         tckTjjsa94kKO5v7GBjkDAuS679sz8QE5lIsuNIcTpUMQ1fSb3nuailF3gyFUvVGnj6l
         EBQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762284328; x=1762889128;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5cZx+RW3Kt24V+mQj1nrZgt3YKwbbGOTRzEZ/APfqy8=;
        b=c1Om2rCKONLzzOW2ImATh4takFqWK1jLY+xDvcDDT/J7jZrMHl1125w611GUT09WFT
         BoGN5CxsfirdDccOeTXoutuq/kqDPlMMYsu9NZzOCSyza//OX7fMKIIk4rpcPOivbLuV
         xAY/sxbQ8Cria6/eGwON52l9uwW7k4dggdYvAN4AaX2lJfJ23yCSkuHP1YC8s7MiP6PG
         UuCcJ+578Tw/W8wxb5rskFfU5bJgwvWfv7O8XUsVklFniFP/La1GFA7ENdDdmaA83BbV
         RJP/9sGmSfxD3ltKB2yNDDZ2Rq7pq/MHM0yznDUhAvlOTNqA+G4nNqm9ahKyRRX2z8iE
         6ddQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLSbhN4yP/9XA6LfxIcP7CMzzANxc1P/A05PhxYk1QLi86K2PIOd8Sjonssjdl5J25SVlYtGpn@lists.linux.dev
X-Gm-Message-State: AOJu0YzYEHT5AsN5PljSute0jE6eLyIiDedfNuW4xHWSSxM/ZpCfXt4G
	XbwhNDpBihanFDoz3FzudZupm7S8vGWFE8y4KP0UKeCZRVVWOaYQ8SDMObKWnkb/okET1DT5UpO
	n8chitsjhzSoTba9mC7izt4tsExbYvpI=
X-Gm-Gg: ASbGncsD+c6x3LngHfl9HZ8xQb2WKxcqYEUajQ4l04tCz5Vy7dz/E/SE0gkrLxW97Ga
	yV8JeOfezHW5Q3lGQdFjt1MFs+Aw373fWIJcRxubGbnljp54DWb9Tmui1fBEfUV55i8EX7gIi2i
	DL4lNHo8+2+jI6JgLDPmgdEyK2G9bzcGruLCWupXJ8sSdbyaWG9qvX+Xp9xlmHxQGiCT4t2Ig62
	kPJzy3eSclnqjem2C5G/RcPndN5sT5GarjXj9IrPO7YKs2lKufoh1SAm+wa4jYZZPwcyPqKDphX
	ZnAEdslftccSdJbwj/fu55m2XuPcSnICC+AmLFIaQg88ppQZ6/V3MYb4YB7X7V5QW90IvJcOrnd
	bJEE=
X-Google-Smtp-Source: AGHT+IFWzYsYUL37lFrxSC7sVl0Ij5MeA0lOHpSQOZvdZ7ftbuS95sPOKOarVGGOk6+VoduotS4rq+ThkHUUIHnXHbM=
X-Received: by 2002:a05:6a20:258b:b0:34e:8e9a:c610 with SMTP id
 adf61e73a8af0-34f8630155bmr221747637.6.1762284328313; Tue, 04 Nov 2025
 11:25:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251101094011.1024534-1-ojeda@kernel.org>
In-Reply-To: <20251101094011.1024534-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 4 Nov 2025 20:25:15 +0100
X-Gm-Features: AWmQ_bny94bBmKIB7QhLmeowyrAuyscE1LVW-SgNclTZu6rQpXUrhoj1poxn8j0
Message-ID: <CANiq72kWcptN+hu+gMwN2n8WkXrOku4kCHkSRsMzJmQeiCAJOQ@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: support `-Cjump-tables=n` for Rust 1.93.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Huacai Chen <chenhuacai@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 1, 2025 at 10:40=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Rust 1.93.0 (expected 2026-01-22) is stabilizing `-Zno-jump-tables`
> [1][2] as `-Cjump-tables=3Dn` [3].
>
> Without this change, one would eventually see:
>
>       RUSTC L rust/core.o
>     error: unknown unstable option: `no-jump-tables`
>
> Thus support the upcoming version.
>
> Link: https://github.com/rust-lang/rust/issues/116592 [1]
> Link: https://github.com/rust-lang/rust/pull/105812 [2]
> Link: https://github.com/rust-lang/rust/pull/145974 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

It got stabilized and merged upstream.

Applied to `rust-fixes` -- thanks everyone!

Cheers,
Miguel
