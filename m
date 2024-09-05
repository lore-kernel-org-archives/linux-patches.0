Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FF81946B5
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 07:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523143; cv=none; b=KiYTBmSMRwY1jSh0WLsILKzmf3hxbdLQOkuJUukXxzodz2tUU4lvvzcqo4p1Ip7WNa2PKBxrtJI3aMsA9OLdxXkcRAtZh648MyXFxkMLZZGc6AKygUiw8erVHpf+vi9dJXxoUpqDBG88BGTbfLnW09aEHEQ7FasFykvKVivH4Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523143; c=relaxed/simple;
	bh=S4wg+N7dLtvOvfF5uGJECcWCNVHiuhHmcyXrxkMmoWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kejMU9KIUaaSiPtyxjJrJmHYfqxgtepnNrWsxaqo06pnS8NF2oT2IMQ8oqZi+3liIF8T213fsdg83LjvcDmEsAW3l2gNRVlOCWVuu1fNNO7+i0861zsValRO4SdR78JMMd6J8HaqPFQTFAxjlW61rwLcB/jK1f17BijKHfLhAyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3B1N9bfp; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3B1N9bfp"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-374bfc395a5so246932f8f.0
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 00:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725523140; x=1726127940; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4wg+N7dLtvOvfF5uGJECcWCNVHiuhHmcyXrxkMmoWQ=;
        b=3B1N9bfpFFzchKrliRwe2YJGr3/+jAfjvl5VzzjFumLZthOsPefRKtoojBT2zlzgbx
         ceMVfOrk6U6EW33hzLuKHwmvOW+8Bjtq/n6yKjhjv2fO7un740L6vrfHeN20UsW6i6ga
         Bu2DfdinNKejbNPBwQ918SsUeMqGsv/gylnRRuYw6TCypzYcwkKJT03Ip5kmFB9Gz5W9
         Cmic5366s1h+1/+KBkpVnwUArTuuSsVg1D09Zm/Z3UsG7WtCqBDVLK3oQh/sWqwm0IiI
         o80g8fKP/gwwubbo/ESV5AeV2UufJksdgfo3ArmDujBIsCfethlj1naTwhwV7tCuJjLm
         vjlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725523140; x=1726127940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S4wg+N7dLtvOvfF5uGJECcWCNVHiuhHmcyXrxkMmoWQ=;
        b=PEv2mUX3q44hHdsADn8oTSIM2R/l9x+3fP3zkuHcBfRe46db6xsKygjBAoz08nXcTV
         L3CXOqjjqoVLb7dZY/nsiBGVZXtuvpDJIYZa8H+BdsX0+BJSseXQzPnSMMcD1QTmE8Op
         EFWOGvieGmuphoYq3peflFacUhHlN5ofhDLWnhI/Vtms4O/no17Apvhbv14sWP8NRaDh
         cwFGt8ZPVjCm+OQFayuauOoXl69Nahcpxvd38LgW+F2L82lOdSWUw5sSmba0f+XptwwF
         mLMmqvWuyvGIc5VMocASa9WoKhGCGv2uXPe/0LR8JinwgAGjF5OYFhwqX26rsXKUmLid
         vN7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWiE1J1j/bU9Vcr7qOvblYbuyYDvc1B4PgPM8Awikq911bLgKRU9elLO2gg8m4bCGcS7sIW5WJt@lists.linux.dev
X-Gm-Message-State: AOJu0YxH51tfnAK54hygkqIgRIJ0sJzgrKPLzWts3404JUE1Facb0f2N
	7TQv6U0Il5Tub1kIObHLbzK8OIdcvY7uYVV4///Ziv6KVQhPCqr3kS0elhI0r6aKDKTsyav1+gt
	e3CTKs74dUrlqYLOm2w97jfg0wf1H49B0qlTL
X-Google-Smtp-Source: AGHT+IGtCPMuGPM1tEnxEq9yaB7NNJmDwi3mMPagHojR/JnOLPZuTRsGFLFDq1TA5h0cNWIxOaDOSqYB5CqWwC4WUqE=
X-Received: by 2002:a5d:4a90:0:b0:376:e2f4:5414 with SMTP id
 ffacd0b85a97d-377998aaf1bmr3162540f8f.5.1725523139945; Thu, 05 Sep 2024
 00:58:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-4-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-4-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 09:58:48 +0200
Message-ID: <CAH5fLghNLZWjaABcztD8utC9VbPMUYGNYKjisPdV=vVYVF+H+w@mail.gmail.com>
Subject: Re: [PATCH 03/19] rust: types: avoid repetition in `{As,From}Bytes` impls
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In order to provide `// SAFETY` comments for every `unsafe impl`, we woul=
d
> need to repeat them, which is not very useful and would be harder to read=
.
>
> We could perhaps allow the lint (ideally within a small module), but we
> can take the chance to avoid the repetition of the `impl`s themselves
> too by using a small local macro, like in other places where we have
> had to do this sort of thing.
>
> Thus add the straightforward `impl_{from,as}bytes!` macros and use them
> to implement `FromBytes`.
>
> This, in turn, will allow us in the next patch to place a `// SAFETY`
> comment that defers to the actual invocation of the macro.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
