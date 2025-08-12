Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7EE2F90F1
	for <patches@lists.linux.dev>; Tue, 12 Aug 2025 19:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755028413; cv=none; b=afEO4o1RRWu1/QRh+F2V9mjs9vKWhA1I2O7iFw0etHwFGm/hJTd+gL78XVL8cnUKMfNoZSSMfiZ2kxruxlbaMBVckV5Dj2g3pMYt5wWhWI2OnJ45T6UJ+E2g/rNWoIyT/urQJPRopSQ/VTYW3FsJfR75n5qI28lXtSmawpaga88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755028413; c=relaxed/simple;
	bh=vhKEJdDCorgUHjle84atTRE7pJ5rUNqpQxJLE0r93UY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mam06iIQYOFq5vfqHGRS4uObX1ZtL6plVbOEbk3uD4C8baBeM8V+LHWkGD/rAuDK0NJ3nrMuZEJy7888uqK8+Hyy1gz7FqRUp6kIsr5Fg9m0A6wvaHDdIFifE4KR7GrFW0Ug9HZ79yWGPsmA7K4BeX1geIEJJVVpBLRPGbSgKQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gpFCqFoZ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gpFCqFoZ"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-242abc28161so9089985ad.1
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 12:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755028411; x=1755633211; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xUy+WBIe8s5eG7yD9G+tniGamA+stC4Ks75UPKA0L7U=;
        b=gpFCqFoZ2heUaM2EmAhz0ebQyMga9wU60rKZXLxpPjPBk4HToOAmd5lUbsawh/n7jB
         jLrIi986NLQt+qL68TfUjklB7YwEpN3o+/iRe+h9pJewfvRAS0mhEZ+2Tt0Ain/WPXTm
         u558slAgTjCY+BdNgB+nchfYDiGwfbn/3b8fvSfQvW30gNgl2exQDY4tBRTuefDvVleE
         MeEHJl3KriElxYIEZWwotS2Am0CVoEi+DwdeMs7QIaEagaMqjNPYUS7fr2Bxa1XnswOS
         EpetRYOnUa/JXjxFEzGP4KBujX8gx6lTgW/3+u/4HxWMh6iFhUkzDyxFJJUI6HUQce3q
         NSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755028411; x=1755633211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xUy+WBIe8s5eG7yD9G+tniGamA+stC4Ks75UPKA0L7U=;
        b=GlAqrWi26mqU0iv6osbwoVPcA87NfkbCXlDJZ/j2Up0dn4oa9kRjN31soF530wWqlq
         bstPzzazxx6ETWd31Z1SV59d59UmgeHf10hFThiKaym2NDRfQ2l1nCFF1OgUswX4B3t2
         8D0RdqqlTCaWdY1VK5eDytVy2awHN4s9HhvBZk5SrJRSKOTV78ZRKJcidgXu8c7EEgVH
         z48DY6n0eFO0SPFrdhoeNgwoGRnPsDfi6oWiDCoSKXvkPTvTHrKvd5Vx/vDzCTHLOzzJ
         /cB/pXjxriRwqZgME7yJK5nuDKjKH6LVHO6mDoVFuzGc3UV7lS9mlgzK5PSHhDy56AF5
         b59g==
X-Forwarded-Encrypted: i=1; AJvYcCUrLc7HXIK1Zq8JAai27tovxu7wyB57RAI7safOr2a5mIrHKvebruavh3HmtgeoL4ixSHL0/ADb@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6sGFL5+2rSNLfjbPfARYEQ8upAfHPdRqhuL/gojhIIEMDBCSx
	HPOnYAjTzsW4e/cdxVp5vkjE0G6NrWk7yTx1lGWGIcj2l8PGqY5frhttv2o0XJF24Mh+a8lkUGX
	0GTWYIhMp1y2h7bbJosGSnI+sLg5Ks6Q=
X-Gm-Gg: ASbGnct1z1q8NAx5AXge6/6+Nc73Hslh7f+oZaqEtRjAJtxPj8yYeOUCb7sU3taJrf9
	WGYKvlEztClOiOMP3oz4X4LYJNvR/XKu6ji/I9kqRGqmPFBJAX6Y6nS2MW8mmVBpoEYE5fBefc0
	9t00g7tM7nCgvQ7bzzxcsD8j5mlnjmnevBDlFXMzEKlSZv7E5yKOKGXVnNS02HAmbYuBQgoYNOH
	v5ggMar
X-Google-Smtp-Source: AGHT+IGJF9vlSl6LtugLF3G5FrHTTGXElXZh3V5XBDYr50G2/qrw0kFxML7ITvym8eH96YpjpZcxBgyhI2RTXm8ZkWs=
X-Received: by 2002:a17:902:c405:b0:242:d237:e20b with SMTP id
 d9443c01a7336-2430d0f9cf4mr3360985ad.4.1755028410985; Tue, 12 Aug 2025
 12:53:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250726133435.2460085-1-ojeda@kernel.org>
In-Reply-To: <20250726133435.2460085-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 12 Aug 2025 21:53:19 +0200
X-Gm-Features: Ac12FXw9PM7CHJhFQfCIPFdA9X2yBdN7wgOVawlhnEq1u63q42B2t16j4ZB72TI
Message-ID: <CANiq72kbsj5nJCZOo_jh8YzsiX8RgOKVAF=x8vDYbFjoCh6mjg@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: clean output before running `rustdoc`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Daniel Almeida <daniel.almeida@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 26, 2025 at 3:34=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `rustdoc` can get confused when generating documentation into a folder
> that contains generated files from other `rustdoc` versions.
>
> For instance, running something like:
>
>     rustup default 1.78.0
>     make LLVM=3D1 rustdoc
>     rustup default 1.88.0
>     make LLVM=3D1 rustdoc
>
> may generate errors like:
>
>     error: couldn't generate documentation: invalid template: last line e=
xpected to start with a comment
>       |
>       =3D note: failed to create or modify "./Documentation/output/rust/r=
ustdoc/src-files.js"
>
> Thus just always clean the output folder before generating the
> documentation -- we are anyway regenerating it every time the `rustdoc`
> target gets called, at least for the time being.
>
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned i=
n older LTSs).
> Reported-by: Daniel Almeida <daniel.almeida@collabora.com>
> Closes: https://rust-for-linux.zulipchat.com/#narrow/channel/288089/topic=
/x/near/527201113
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

Cheers,
Miguel
