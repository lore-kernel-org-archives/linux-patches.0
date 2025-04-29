Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5192C108C;
	Tue, 29 Apr 2025 13:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745934501; cv=none; b=KYwAi96TeaIZ3U3060ORMFmGYML9YbPSZbr4hpX3S5HgB3MZa8cyQsAL9bmFVcgEBmqiNuGWZoqcULkNcUBa6CuYmkOTfcgH3dvSC2LMaxvyjoBmBfZDRmAMNPBV0VIRpQx5+h6G2/wRJM1ybDhwjFrgQkXfsskhRzsGQ5/MgRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745934501; c=relaxed/simple;
	bh=3UTN0yKFCFM1cU9sTmUdoricE1PyGLGZkh5FyiCMzKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AVIxHHfMkvCCM8aPZr672RF2GuJBRA7ox0f+EcUO6l8zsLJ3IsFIc/JBapIpbU6rfQWf9XO4ICwmSH0A3i4FjRXhmUaFeoTfCbkLc2pjyedkv32+ej3kwts1d14fcz8SzezaVe8C2Rib6mpEww5nhCN1CbBV/irydt3XbrI1sKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C40Tjy4t; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C40Tjy4t"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-30363975406so772743a91.0;
        Tue, 29 Apr 2025 06:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745934499; x=1746539299; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3UTN0yKFCFM1cU9sTmUdoricE1PyGLGZkh5FyiCMzKg=;
        b=C40Tjy4tCgu+UlTpEHOh4nW4P5NdhUB9TVojwBpcmcOjZIwXsmMHNivW3FBRgRNgd9
         imJwUh4b0LkmwuY2zALnYox0la84hqlm28Fcrhnl7TPHVb51OAsutKn4at8ZDAS3Ph1R
         YxitbQ8U3PRZbbvOKjDqWbN+QBsLOls0oHlIOzr7zF/WuKTByfmqB3TUub6l4/JuAoBO
         /JZjaVOVjqTdLTOPnjqIocMObJNKLEsCZLT61oxCGGfvdpJwrXjw/94n5ZP5ISbv4meg
         uLoJrI7cSLgOD/a90ydwl2Tk/+8KQeJGtJAIknO7QcG1LvOS/1U3IE8TlTuCZibVxzCw
         pdWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745934499; x=1746539299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3UTN0yKFCFM1cU9sTmUdoricE1PyGLGZkh5FyiCMzKg=;
        b=A6FBYxoM/R7lWJuwry4rZkqK3NEuMv0ywvE0Scp/bZ81ECdE3veIz+LqzzQkpkEVtE
         tPC6g5hQ+JESPZGuuDuD/Qo3zCXi+czpPz06ofyq37ccvnwF6UvjqdIehE4q64VhQjHc
         XheGoiz1Q0QVoG7zlLD8LmuEHp+Q/rM4Smk+OcLDQwhGmpKmBaPcgW6hqMT04YtR1tG1
         dO9ncQXtklDCo7mEk7YA1bZmHKrESUzyvW/VIiifwTxEDV4J3WwNwezksbDqUQHnHST5
         brR1cWdr5VhgRhi02jPJ+zIRohBpQVkxKJ/2Vn8azxUihuyNeWe0w1GHkusknvh2HZ1j
         4dPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvqj816CX6KgSlQ/5z0hF68GEud5F+rgZ+bHPUSfZcC8dWsb4CcOqJtOupzw+OPaP8ySfY@lists.linux.dev, AJvYcCXVMZWyRvIqRcyhFKY54UWl/r4IW5GO+cFvkHWO542N8NKpiER55alnzPKLJoup8YJ+SWTJc+5ajw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyzJdZd+T9fvHXNK9k1pVUN4M3+TDhRjHONNgdgZhUqnuufoIlR
	sp6XV6r3wNk05Bl5YnNW54fRfZ0QJHG5cOzzOgM9+dQI/k1+GYiZIaPB0pEkX8PWlv5/ivxPhI0
	mQUaH2v+cWrmRKD77CIPjNLpH3Zg=
X-Gm-Gg: ASbGncsAQ7UtTEU2L+a+JJ1/mm+M+SepQ+sBRcuRkh4TGEuZXu/iUUDk1RRQUgXs7mb
	nCmSc73A/LGTxcxpUE8xwyCsxTnoMWTQAnw+A54G+00pC4gB4c6vjtRgyveZXwtgPLeyxwA/2aW
	Uj8onlJ4didKHocgYpg1PYbw==
X-Google-Smtp-Source: AGHT+IHApWOCR0pchAwdFsc2rTFZuflIKfyFi5jyVEU4MEU2Xndu6ccMMN3KcANjTu5macF4UxOTh35AersHNTxlTPc=
X-Received: by 2002:a17:90b:1e4b:b0:2ee:f59a:94d3 with SMTP id
 98e67ed59e1d1-309f7c73b88mr8495550a91.0.1745934498742; Tue, 29 Apr 2025
 06:48:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241119185747.862544-1-ojeda@kernel.org> <CANiq72n4Fw96hcuqQeorsfH7z4Tb+R1gdf80H_XkD-oA6z5TSA@mail.gmail.com>
 <PVK5DQh3QRZOFQ4cMasO5h75CnLppaPo_aKbvSjzd0gv-bUIagkLyv1FZG5KvJqSUWnl8qwSmmQdl6BVPEcNKQ==@protonmail.internalid>
 <CANiq72mNJrMMbEcfJMLT4kM-_iviM0AR6oeigCyrb5eMWkn3KQ@mail.gmail.com> <87jz732ihw.fsf@kernel.org>
In-Reply-To: <87jz732ihw.fsf@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 29 Apr 2025 15:48:04 +0200
X-Gm-Features: ATxdqUGH6Kje-6C0vtqC58kT4m1EaQsxwq5IrujrVqv1brWAT_mXpD5oJuR-R3Q
Message-ID: <CANiq72=siqas5D61A1xCFZ20Sb3zdZNhTrtRFtEWDrJtEry_-w@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: allow Clang-native `RANDSTRUCT` configs
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Aaron Ballman <aaron@aaronballman.com>, 
	Bill Wendling <isanbard@gmail.com>, Cole Nixon <nixontcole@gmail.com>, 
	Connor Kuehl <cipkuehl@gmail.com>, Fangrui Song <i@maskray.me>, James Foster <jafosterja@gmail.com>, 
	Jeff Takahashi <jeffrey.takahashi@gmail.com>, Jordan Cantrell <jordan.cantrell@mail.com>, 
	Matthew Maurer <mmaurer@google.com>, Nikk Forbus <nicholas.forbus@gmail.com>, 
	Qing Zhao <qing.zhao@oracle.com>, Sami Tolvanen <samitolvanen@google.com>, 
	Tim Pugh <nwtpugh@gmail.com>, Kees Cook <kees@kernel.org>, Nicolas Schier <n.schier@avm.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2025 at 3:40=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> It is on my list, sorry for not getting to that yet.

No worries at all, and thanks again if you end up having cycles to test it.

(It does not necessarily need to be Andreas, of course, others are
welcome to test too ;)

Cheers,
Miguel
