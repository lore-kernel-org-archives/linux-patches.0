Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F294B17BB25
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 07:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723708625; cv=none; b=d1r2aizVZQsHfZUbUhLAIrxpBI+b/TFh9/AJly/tFvZ16k8w9tJUXGOBExctSvhEbNiyunFl7JHhH/OojgPY+7m/5l8IAodVzAmg1UYaymailblXYTacKLeIKJIy+/L49CTYFQiPpO0cucH5hAWFUqj4ZH7zlYqpfQqhn7k5p6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723708625; c=relaxed/simple;
	bh=lFaxAIKnjHKxlZBdeFXofarPjUb1JU4bQlq7BQ4PqII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e0sB8JhUcK2iMs28ALFgeXlZoQsCduqE3O0n+Ni9tWLmHIcp8uz6I7cooL2nOdH+5RUC7Kh+gwWgHJAMD+29XOX0pEa2eY7dFsiVOHrLQN5EdTsnVOKS+ZwPIArgRzjfo2vsJa4qBBAWo6zCpnHSDoTq9bhlX8r/aw69i+/ZOiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NVC0+4Be; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NVC0+4Be"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-36bcc168cdaso384907f8f.0
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 00:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723708622; x=1724313422; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uFDgfr18jKgjWjTVFgaR01eg1gTio0cJGxh6b91x9kI=;
        b=NVC0+4BeYEivHHVnTRCAMPAumCWbLWNwfKrEsGeZ7krHQm54PsHZhq5NmCIHsksRGk
         OxvY+M21oxQ7o4AMNY0BKWIim3WyHRmZAQfGCyg8jP56s/0uSXm+TTiC07zOd9xq/hoX
         oGez4yGyZRZGSgMYBks1LQHfsn9RrC3H7iiyXPAPBSp92ngRfGUdbGRew3fNn6XCovyM
         8hwrHODq3/qVImkpO5msdidP+wZRt1f12eAmSQ/mtShEaMNMqlqX7JIR+/nFdRwCBmF7
         Q5a40UDOFtIeTu5ilrvS6t4VtHerali8N0crJ4TAEyS1UHaTNjJSurKi0piS9JQ0oxMf
         XZkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723708622; x=1724313422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uFDgfr18jKgjWjTVFgaR01eg1gTio0cJGxh6b91x9kI=;
        b=TVGzeCUnu6pYB9xiFwEsLWKsGYQq+2/oJKBiGlyDYopzzTsumFQf8MSWuBwiUlZeXg
         F0wjzDg7iDr0julMSqpbDhdl1xA1E6+CB3cYzuw8mWNLFikpdr2LCrXhEvhAy97/2iTk
         5WmkBnw1+I8Kvy9VbXMYYmZtrjrGThw5LS+KvQOxbvCPoPHLi/iCFHsVbZ4cHb10jmg3
         L18Yxf6l37g2Jl0xu5mzcgp3IZQFf0Hn+tcScUln4+18fnqcaePsf/D0xUrJF/e3L11m
         Gi7Zym6DGk3ypCRYdg3aDoi/lOn4P3AaJ4T6t8vt8YdTBbaaqXa33yeMnV4mfeICYVE+
         6NGA==
X-Forwarded-Encrypted: i=1; AJvYcCUtdKevvg+ef29/N9nk8llOWbYV0Hml4T43w6M6JWpPu0TvaBeSEGGwXi9T7XpGSmV7CdnoSG3mjRBQmvkDtJ9y0/uoqU2nAQ==
X-Gm-Message-State: AOJu0Ywol8sec472u0+ELRxicDjrVl8kkyT8dJY3ikpMYgasi5CDU2Kq
	g3G8AY98FBDoatQGsuRhid+0f5jXkDSHNwU/CaBGY7dq4EGA0P2ijXu5o15xC3vspWceZuQMzyv
	5VFQYfaBqpwS8efqFrlLzdbBGTzwct8UpySnS
X-Google-Smtp-Source: AGHT+IF44XjYngCZ8eLUhbWGRFsRASvEhApV5Zb7EnuduDNmFQ2HllL4LplMRCeD/E33eirS9R2OR5QzF4QYcVIzYOc=
X-Received: by 2002:a5d:4985:0:b0:368:4910:8f43 with SMTP id
 ffacd0b85a97d-37177744ee0mr3834274f8f.3.1723708621922; Thu, 15 Aug 2024
 00:57:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240814163722.1550064-1-ojeda@kernel.org>
In-Reply-To: <20240814163722.1550064-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 15 Aug 2024 09:56:49 +0200
Message-ID: <CAH5fLgi1xpuH1KpwSTPkiVsPsQ6YUC1=XhEusf3bXoRVyJefQQ@mail.gmail.com>
Subject: Re: [PATCH] rust: enable bindgen's `--enable-function-attribute-detection`
 flag
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 6:37=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `bindgen` is able to detect certain function attributes and annotate
> functions correspondingly in its output for the Rust side, when the
> `--enable-function-attribute-detection` is passed.
>
> In particular, it is currently able to use `__must_check` in C
> (`#[must_use]` in Rust), which give us a bunch of annotations that are
> nice to have to prevent possible issues in Rust abstractions, e.g.:
>
>      extern "C" {
>     +    #[must_use]
>          pub fn kobject_add(
>              kobj: *mut kobject,
>              parent: *mut kobject,
>              fmt: *const core::ffi::c_char,
>              ...
>          ) -> core::ffi::c_int;
>      }
>
> Apparently, there are edge cases where this can make generation very slow=
,
> which is why it is behind a flag [1], but it does not seem to affect us
> in any major way at the moment.
>
> Link: https://github.com/rust-lang/rust-bindgen/issues/1465 [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72=3Du5Nrz_NW3U3_VqywJk=
D8pECA07q2pFDd1wjtXOWdkAQ@mail.gmail.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Alice Ryhl <aliceryhl@google.com>
