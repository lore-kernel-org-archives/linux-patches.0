Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3CD194A6C
	for <patches@lists.linux.dev>; Mon, 14 Apr 2025 11:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744629748; cv=none; b=ijKoIMKipe/Nl58MGeQ3wuDDTbN0CCa+YaItjBHJVwpxFicaac+JlbAEP8OYA3Cfv9xLoZv+AWt0sGZ7k9Hameq6623MiZnyU+ZMnfQ4oElS+MAnhRsWbXbNvyTknr9BXCqWAe6Yz/jcTfCWlf0wZijYJyiJAVhTDdhscXgKBLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744629748; c=relaxed/simple;
	bh=5Fvjkjfat+nJk7Vy80tDWnDp5NpzHStADTmDQuN5aCE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TH90LoqWvA/njyBcIB4OlN52/t3+NAt/WkwRSSJzJxUmJDSmyUp0Kb3z52j2CQi4nM1h8xJ5tJUEi0BUO43toQCdhiKHJg3O7TZE5TB/Gw5p1mewQcF438kshiG69KzjO6AEtNBQI1wfaZWHJ+IMgV2FK5YEY8Zs4u563hNiQUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W9DdGDtA; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W9DdGDtA"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cfe574976so28954415e9.1
        for <patches@lists.linux.dev>; Mon, 14 Apr 2025 04:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744629743; x=1745234543; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rft3EAUTLyhnp7+tWC0d5mWYcohYnVvJHm8W23d6BUU=;
        b=W9DdGDtAq3vM5xaUl6Bu/FJDDtoy9qhIXSWc9LYhmi+RrJDAlXR8J70fld4CbAO4+2
         lpVvRb7v+47xro4P5agrKXDVu5aTO7gTU9pRPHnj2IHnZ38lo6sOYQgYyb/Yu3Cc2ttY
         CMg7a45/pUPcCXr2EC2+BUdK08VA7JWeFV37q8Kw46Uua/4nHti0XrCtKH3+Ixbhq7V+
         EFfR8/bNUa/RU0UPunBGqDNO0F0qU4hZMoGDQz6Nk7eVvxLO+rc1ULKeKZ2OXGsu86n4
         JyrDU3736gu/DuT+gPl2jKT3NKw8FL/nyCcNsChpufEv4QL6L+2iUc6rWIs1IG3Kxd4G
         7+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744629743; x=1745234543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rft3EAUTLyhnp7+tWC0d5mWYcohYnVvJHm8W23d6BUU=;
        b=QsR0EF7/vGn9F+Ws9b+RxD2ek5uDsNiB5StCjIxYDMI83ptta9X0e1qVzht53FtKGz
         R0UOx2t2LRGkFnwdwEDLDenjM0NKPq8rc+Wq3qHqDLWECKs92Bk3SsjMoyeYT2beszg9
         VRoBQIUoNQ0uEHNqhzhEbRcIVgRYtZNgS3grnGdNd5nBr23f5jfH/WHpi+IWdTLObZMQ
         tWukVIQtckCGKSDuBbdBcMEWGKBgxcPZ+EkvILAAhYO7V3vf38I4S6fADYoGBNff60J2
         i0D2m5LM4hvN9+rrcwpq0WgDcXokyrYty3t0S8tVJnORVq27YGvipq7koj6Va8R56lrv
         7Ckw==
X-Forwarded-Encrypted: i=1; AJvYcCUYnBz/+JiDPlVsHMbNh4SUo/Qslnnu2XUJ4imjhXt7cc9kfNXXplc1Qea/HpgUc/9t0kNgvMBo@lists.linux.dev
X-Gm-Message-State: AOJu0YyZuloGddr5iRBRWaGW24z60zYyuNnFGjHsO6wOy4+QXBYEdIKf
	CcDHmNXC5WHjS7IPBHdZvqdGRTQB2zMg47NXktkj9JoQori7aFDBzxtdIvclyZ2XkTgLSTRV13s
	Aj5MJTM5lwvkM0OYMLBnj+UyiwAm7iizWICHf
X-Gm-Gg: ASbGncsyK3n5/1Y+l0RHrVD+k0N6pJFUW89Yj8XYSoslA5ZmQOg/IpJT5Y7wCJjod4J
	2LlEHZzo1HLtU/njopaUhkU8AyBMKpCUHjqNCwqARz83i2PZmUEjA+GfMe1kKLAmOMFldagVVLQ
	NGnN0qvjEsS70OKB3BX2aMRFrfV6g8Sw/RLypd8bbB/bqXHnK5XnQ=
X-Google-Smtp-Source: AGHT+IEZZBt3UNC3+TSE5+/gmDD+2unhz/9dXO7/xHNdpPGb0TNqsh6CfuUuMhd+ZdyeJAI6BZseyvWSCutQpwcC5zk=
X-Received: by 2002:a05:6000:2405:b0:39c:1257:feb9 with SMTP id
 ffacd0b85a97d-39eaaed586amr8788733f8f.57.1744629742684; Mon, 14 Apr 2025
 04:22:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408220311.1033475-1-ojeda@kernel.org>
In-Reply-To: <20250408220311.1033475-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 14 Apr 2025 13:22:10 +0200
X-Gm-Features: ATxdqUF9via54VPG5nlOhtSrUPwWIS_mfTXT8g_wST2xwdZg_Zg47Lq68Zxptiw
Message-ID: <CAH5fLgjb3Wxbkzvvy9H6QUYVpxXvkse1rnDmmR3nVHjp6zEx9A@mail.gmail.com>
Subject: Re: [PATCH] rust: kasan/kbuild: fix missing flags on first build
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Matthew Maurer <mmaurer@google.com>, Sami Tolvanen <samitolvanen@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 9, 2025 at 12:03=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> If KASAN is enabled, and one runs in a clean repository e.g.:
>
>     make LLVM=3D1 prepare
>     make LLVM=3D1 prepare
>
> Then the Rust code gets rebuilt, which should not happen.
>
> The reason is some of the LLVM KASAN `rustc` flags are added in the
> second run:
>
>     -Cllvm-args=3D-asan-instrumentation-with-call-threshold=3D10000
>     -Cllvm-args=3D-asan-stack=3D0
>     -Cllvm-args=3D-asan-globals=3D1
>     -Cllvm-args=3D-asan-kernel-mem-intrinsic-prefix=3D1
>
> Further runs do not rebuild Rust because the flags do not change anymore.
>
> Rebuilding like that in the second run is bad, even if this just happens
> with KASAN enabled, but missing flags in the first one is even worse.
>
> The root issue is that we pass, for some architectures and for the moment=
,
> a generated `target.json` file. That file is not ready by the time `rustc=
`
> gets called for the flag test, and thus the flag test fails just because
> the file is not available, e.g.:
>
>     $ ... --target=3D./scripts/target.json ... -Cllvm-args=3D...
>     error: target file "./scripts/target.json" does not exist
>
> There are a few approaches we could take here to solve this. For instance=
,
> we could ensure that every time that the config is rebuilt, we regenerate
> the file and recompute the flags. Or we could use the LLVM version to
> check for these flags, instead of testing the flag (which may have other
> advantages, such as allowing us to detect renames on the LLVM side).
>
> However, it may be easier than that: `rustc` is aware of the `-Cllvm-args=
`
> regardless of the `--target` (e.g. I checked that the list printed
> is the same, plus that I can check for these flags even if I pass
> a completely unrelated target), and thus we can just eliminate the
> dependency completely.
>
> Thus filter out the target.
>
> This does mean that `rustc-option` cannot be used to test a flag that
> requires the right target, but we don't have other users yet, it is a
> minimal change and we want to get rid of custom targets in the future.
>
> We could only filter in the case `target.json` is used, to make it work
> in more cases, but then it would be harder to notice that it may not
> work in a couple architectures.
>
> Cc: Matthew Maurer <mmaurer@google.com>
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Cc: stable@vger.kernel.org
> Fixes: e3117404b411 ("kbuild: rust: Enable KASAN support")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

I've boot-tested Android's KASAN configuration with this patch, and it
continues to work. It also passes Android CI [1].

Tested-by: Alice Ryhl <aliceryhl@google.com>

Alice

[1]: http://r.android.com/3584874
