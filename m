Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F7E15E81
	for <patches@lists.linux.dev>; Tue, 23 Apr 2024 00:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713833021; cv=none; b=iUms5Z3cKm93Zx94vkDQsmvo36UFNMGh5c8ujz5yKFjioOi6qi2wMa5jKfZpvD15pVsAvOXP4V+B8/djZYmhKsrk9C7sgJ+6Pbr5s2g1GDImJSRlfjqrfjcsp6oJicY2GAb2akhvkt2Xe1HdZhy7jsIDWTRHHna3C67KAWZMnLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713833021; c=relaxed/simple;
	bh=b69z8MKu5WCo7Cd2DA4gTZQA8lpYkKyRqYcx1dxF34w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dYvbwoYRQnSjLO0U/1aK73MPES3CQ7E1UYJbFIsk1wXVuc5nazoMFSDeuKFBBHjRArDwOGmvLb5Nhts86MKZpNA0PLgreerVcAwcoTHRQ9INjhIz3e2SPrWISi5OSvVc2h8tOD5ILqt82w3QswimleS3yWtrF1SViYkNWkac7hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MxXOYSIe; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MxXOYSIe"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6f103b541aeso2291944b3a.3
        for <patches@lists.linux.dev>; Mon, 22 Apr 2024 17:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713833020; x=1714437820; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84vJQPmZeH4flu8huGOV5q9Ft8py+u51GWOsQbHslr0=;
        b=MxXOYSIeQpA5qPh/9wngmFQz+U+oPQAZtbIPeyRE9YVHn5SEeM+7dg9BGucbfjXxT/
         LtBfkwTLMpRk6LAVjLrfPLPnMO98ikOyFw7RRPbq7EtjzjDsaVuoWd5Jxi8aMhx5R7Oi
         umHGLic2Pii6BvdBdogOY5kyEna9PTIL25o2fpwZJ5UE6bK4R81DJvdlqCS9dZo69WUy
         k0FkdiBRZiO2oyR904NICDnsLGKUy9RT5XFnPN6UdSr/kV+Y4ShfraAz61eGay68YJPi
         PCZXTa2/JzkwS2b7sxq5zxecKA1Q2Fjk15Kg/pzOoNgCK7PTWBv4DdFqBB+iI9FAjkMO
         nEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713833020; x=1714437820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=84vJQPmZeH4flu8huGOV5q9Ft8py+u51GWOsQbHslr0=;
        b=DmKnPfxf7m2uFnfCFxbzJQ0altdTQyh3AHDhDNjxsh881/je6/4muWKxGfXUVCmfhD
         Dv7/wDS6G22cwyfY+3iuLlmd3jx6wV/5zzOeN2M+niFBuMm0HbwQZBx+nYpK7cVEeFlg
         41SQjGhz1+sjSPDgi1Ev+NRmbOLWUYKpbW4bh8zjjA03BdwK2eKPZ4XpUyyzCbrZs8Qz
         ixVSh1zRmyJDZwzmXhwfvaciHT0y6Ptz4gG1Ibkyyw+62DyyUt0x62vN50D/th264d8F
         v6tENzMzMdwIxiWERWWDkF/9JvPCh7IWgNfPxNwsCPBdr4aZlOUaAKeVxJYmgTNjpWPg
         snNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrboK8E7W6nrusnf7cfcfe2Cttb4aQuveIG5kwGjemgi7DAKNUoOzfUctuQSAyK+KEvQoDNKe3tlyUeLJYxk9Hft8sP/v2xw==
X-Gm-Message-State: AOJu0YwnMCYFaqzwGiOp78e99m8t07G5Yn921bNdVdNEoaDRzWLGUtkk
	7V/Osc4R1xQfTyW5q1tAMWXF/JsSFJP95QOw41kVMvMgoiBgCW86VIGB04NQl5Bxqw7pGc6bWpx
	dAs4OoYKOhZyS6vw6zqt8dhWz2EC46Q==
X-Google-Smtp-Source: AGHT+IGxeORm1TBskNYFb9Q9UnxlPWh+xAzteXrnLfX4ZhQxPREhBxwkngicmnabL/j5mMF9OrXzpySLTVciO2cdmAw=
X-Received: by 2002:a05:6a20:9f43:b0:1a7:6a90:8820 with SMTP id
 ml3-20020a056a209f4300b001a76a908820mr13612612pzb.4.1713833019802; Mon, 22
 Apr 2024 17:43:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240422091215.526688-1-ojeda@kernel.org>
In-Reply-To: <20240422091215.526688-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 23 Apr 2024 02:42:34 +0200
Message-ID: <CANiq72=xkmSGNCiJOr5+YZhKUVYjMwfBZJVCXbDfdf7qEGBAag@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: remove unneeded `@rustc_cfg` to avoid ICE
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, David Gow <davidgow@google.com>, 
	Brendan Higgins <brendan.higgins@linux.dev>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024 at 11:13=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> When KUnit tests are enabled, under very big kernel configurations
> (e.g. `allyesconfig`), we can trigger a `rustdoc` ICE [1]:
>
>       RUSTDOC TK rust/kernel/lib.rs
>     error: the compiler unexpectedly panicked. this is a bug.
>
> The reason is that this build step has a duplicated `@rustc_cfg` argument=
,
> which contains the kernel configuration, and thus a lot of arguments. The
> factor 2 happens to be enough to reach the ICE.
>
> Thus remove the unneeded `@rustc_cfg`. By doing so, we clean up the
> command and workaround the ICE.
>
> The ICE has been fixed in the upcoming Rust 1.79 [2].
>
> Cc: stable@vger.kernel.org
> Fixes: a66d733da801 ("rust: support running Rust documentation tests as K=
Unit ones")
> Link: https://github.com/rust-lang/rust/issues/122722 [1]
> Link: https://github.com/rust-lang/rust/pull/122840 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` early to start getting some testing in -next.
Please feel free to send tags for this one.

Cheers,
Miguel
