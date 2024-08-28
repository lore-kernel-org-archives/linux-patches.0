Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5284165EE4
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 09:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724837960; cv=none; b=DsGbBrrFSR18RwHNORfSB9n6kNjOBuk34Ouu7Bf1Zo+CglTR5LSHXZKhmVzxNpg/YkGX1cjLRkzEl6l/K1Km36V7RZ5oqrg7qZc5eSeUavkD1MWJe/7HSnsyV5oeOEUdfKWiTA+G9Du0vlLkjwWgdsUC8ltk7VD+dmJQnnVIrS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724837960; c=relaxed/simple;
	bh=tDCMEZY4ROGolIVEcp1aMHDTEMvgP72/upv7zWxS7mQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g1u4T1ThpCS69hZzbY9wYpTSCKk1HIoNVqcj303fApc98DyLv15S6I/q4e+7fi7r8QhFnbG4d2ME73a0VQfgEIWzV8+gkIKGer/Jbr+lR2or2WL/Rm7c3hME0R4TtDhx7UC+A8fGeYz85//XSRkuIMfOLPjk5iZakGkaRKtYIhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kQkxnzDz; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kQkxnzDz"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2d42c59df79so1206129a91.1
        for <patches@lists.linux.dev>; Wed, 28 Aug 2024 02:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724837958; x=1725442758; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CoDr29DOcw9tyA2bqcOEO54uAa1jA+8Cey/HFxrHW7A=;
        b=kQkxnzDzsrPAmasRljcR4W1iqu1Wq5MrQMrXRudRCmEmyI7GyPvqse6EPf6gYczOGO
         uXbs9P4aFODflRZih8rpyDgBWh76pqIm+4h0pTRio3l3Wg+GbKwOF+fRlAu0CW8OHGcO
         Z6DiPAiujdFXHN+9wu4u2dxesLOv0Yp3MBIOVYEA612KUD14IIbKzabV81yv8j1wWzEp
         BvPK2r01uv0HAJkxXtqk9FZJEs9oOotGlgHC8D20Vq4UdSWTtPeTW454c8vdZU3S8bPs
         ftUbC+TKIPum1cV6xEpdhoIdqf/Ld1pimLNGaucVMn8aNfhLuZRPCVuax2xC8ZGtmOdc
         Qw4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724837958; x=1725442758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CoDr29DOcw9tyA2bqcOEO54uAa1jA+8Cey/HFxrHW7A=;
        b=WcZDv5qgYwk10SNtP7NGbubzurNARkgFfClLi4Snr4HOzG77yKiYiPZftGbqLaCqEZ
         xQ9f91xJNYeNzgLaNOu2R7tRYaVMr4i+Yw6f+qVRHPO43ffoU4EptdgzPjYeWMJsb9WD
         nDl8Tgz7mJNI1qw6sEejBdKZkF816o7mk7DN3ChfdZFQZk214ux6HJiPGTpzbv9ZdFOL
         7LrK8jYzdbqWUpWv7YbXq/9h8WroAzbeZl5IC9+90tRsJJz6BqRjcIiya7RV+ZhWE+VR
         VRsBmXktufEt+PBLa0RZf496gKPD1BbOkbyJ3ojSzUZL5nM5NzXPLNehDt/2HNvOfq50
         9O/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWorj1Vx8f4H5T3ejqzTc3HpVEYqGBIKUhyN6ThzEkKVcYDh6YTT/2keBgHF7C26bs8+7ra2CPa@lists.linux.dev
X-Gm-Message-State: AOJu0YyAJr92vhQRdk/OIDIpKHUs3V7INnceunhedu0tt1olok3kSlmX
	9kzerEHX/EkqtV4/+JRdJqZ+uxnlqEjKBs0Eq9xo137zbaL0I6NXaztRa+GROebEWG3CMuO61e4
	gE2q0xczz/LvVW3C3McbphXL3s6QydAGPzHg=
X-Google-Smtp-Source: AGHT+IFGqbbys2cpK3+MtRg5laEkHU+h2N/t6LMPkJRdqiXvqZZmqZSkMJjbM3N1G39PHuAMyiRYP9Yy5ZmWTKiFFoU=
X-Received: by 2002:a05:6a20:9153:b0:1c4:d4e4:d089 with SMTP id
 adf61e73a8af0-1cc89e0cbdbmr11637734637.3.1724837957847; Wed, 28 Aug 2024
 02:39:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827100403.376389-1-ojeda@kernel.org>
In-Reply-To: <20240827100403.376389-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 28 Aug 2024 11:39:05 +0200
Message-ID: <CANiq72nenMJUY3GK0CWUdDzQOXNgdr0zka6yb8nB+_vvCRAF3w@mail.gmail.com>
Subject: Re: [PATCH] rust: allow `stable_features` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 12:04=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Support for several Rust compiler versions started in commit 63b27f4a0074
> ("rust: start supporting several compiler versions"). Since we currently
> need to use a number of unstable features in the kernel, it is a matter
> of time until one gets stabilized and the `stable_features` lint warns.
>
> For instance, the `new_uninit` feature may become stable soon, which
> would give us multiple warnings like the following:
>
>     warning: the feature `new_uninit` has been stable since 1.82.0-dev
>     and no longer requires an attribute to enable
>       --> rust/kernel/lib.rs:17:12
>        |
>     17 | #![feature(new_uninit)]
>        |            ^^^^^^^^^^
>        |
>        =3D note: `#[warn(stable_features)]` on by default
>
> Thus allow the `stable_features` lint to avoid such warnings. This is
> the simplest approach -- we do not have that many cases (and the goal
> is to stop using unstable features anyway) and cleanups can be easily
> done when we decide to update the minimum version.
>
> An alternative would be to conditionally enable them based on the
> compiler version (with the upcoming `RUSTC_VERSION` or maybe with the
> unstable `cfg(version(...))`, but that one apparently will not work for
> the nightly case). However, doing so is more complex and may not work
> well for different nightlies of the same version, unless we do not care
> about older nightlies.
>
> Another alternative is using explicit tests of the feature calling
> `rustc`, but that is also more complex and slower.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

Cheers,
Miguel
