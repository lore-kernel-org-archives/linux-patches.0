Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B6E1AB6E7
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725363358; cv=none; b=aN0F8wHbdVPz97Vfyi1vP2E/l9+XnL2gQNMZ47/qt5HPfx8kZBKQsVtWE0sFiSQTwE7hIJE/JYZTOoGzFIy1OFomCqdNlyE2RiNvNeHoEAYg57Dz+0U2qs8WL0nV5kFKz9+rFb+Dx8ViAq+bSPMXIblcO8NLgXtIwbJx2QU0Z+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725363358; c=relaxed/simple;
	bh=bT4RGC2/CI90zsMbK3CXEI/uSpQdMQIiJJS3i73fW+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NKXIhYZZTcSIofCdunM4I4mvr49/ErHFOGL4ZCSVryKWL5ohQnzqeAdlz2zyG+lk5lXFWC2I45AxIu3VL0VSTpTcbsOFb4xGrqJ5vvLCYPhgyNFatYt+KP8nIncudHcr/uZ5bakLBjhJi1JcvQ+6QUL/Mwxp6EIb95q63m7E04o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jc3D9t6U; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jc3D9t6U"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-374c180d123so1563246f8f.3
        for <patches@lists.linux.dev>; Tue, 03 Sep 2024 04:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725363354; x=1725968154; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IEfBb5av8BFTOtupO7uTtvSgIG4RHj+5V1mUmY2oDqg=;
        b=jc3D9t6UjT32NFPqsrwyrF6g3TDRqFbq4jvmMSPrN6yVfW9scYQ7n2j2KQN5GkCmYb
         M3xOofhE5VG+yJ67o/ehTi96y3Z8P6cti06pcH6e+I25a07BM48yLUXdbz1HncL13tW/
         34DGs2gTT9zrFx5T/6v6UqWkA7/+CKH7Z5h9DiZhRU0gGpOE8/1xiG4sR97yJVbYf+mV
         FiFLvXdMFfaj+pTrZZAv4mbkFz11pekBpje+uTgFfvpCJJSsDbKflSRt7rzACLBWWqhU
         29ZiAh4awY+HSGwlVMsdcCxzspdzxqzNhRLek+k9hUMZcOsuN1W5Ilnnk31hgP5y16J0
         D4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725363354; x=1725968154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IEfBb5av8BFTOtupO7uTtvSgIG4RHj+5V1mUmY2oDqg=;
        b=RL63jfT3fk+7J62xGLMxlWv5YrwNowIzrQRNvYkWmI8ntMD2opNkXHrwoFFAL+XUcw
         Da2y2nhqt/TIUVP0rzUO19W9TeWQmkBTFKQuc3ETmv7qsSXF7NGvDUkxDv5VGt/nMS2Z
         KrnPvAQgvbotdtr+jkLa+eHfrnVwTL9lUAwfA6Rn5I20BkTWtARXLRnYRtbzbZZYFBrP
         wkqUpQ59R43+6bR50j3otDvVcnj/j1IKV9AJAieF/bhoc5H1SuT7vuct2BmwyQh0fh2Y
         2o5kheDER1dyuOFCBCCWcRxXXdPzxa0fKDDW19V33SHibnxmb6UIbCaVttfAv1R3Y94p
         Ys0w==
X-Forwarded-Encrypted: i=1; AJvYcCWlXfvrQD4HGbnYxufKwSyWmSa/VXkLXkcKCATzYnmKOj91o/mE+JENI6XCP5dQwhYK6EQxX1aE@lists.linux.dev
X-Gm-Message-State: AOJu0YwaiLBcmeeSDspTMsI7ELAGu5kAew3XhaIHcVnWHJHHuIbgF46a
	8IZVdbewdYcc3Wr8w9Sv+2jxU05mxLF3YIyAVtjxovgL9I/KENDrHCXOxX24bS4OMJY4QuXjWrm
	F1jasChUUm0Ou/+yBAJ/OA95OUQGtNkOrUitQ
X-Google-Smtp-Source: AGHT+IF9EQsoYXne6eLFgLTZXI3J+dUe2SLFltUotHmh01fE8kD9sVslO84tO3FvbvFkH2w8hwfuP0jI+0CAeaHMDUg=
X-Received: by 2002:adf:9bde:0:b0:374:bd05:a074 with SMTP id
 ffacd0b85a97d-374bd05a0cemr5743763f8f.12.1725363353295; Tue, 03 Sep 2024
 04:35:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240902165535.1101978-1-ojeda@kernel.org>
In-Reply-To: <20240902165535.1101978-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 3 Sep 2024 13:35:41 +0200
Message-ID: <CAH5fLghEz-6HtcpD5N8qXHZt8AK-8DUXHKXbHgs0YQ-pTJrTtg@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] `RUSTC_VERSION` and re-config/re-build support on
 compiler change
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
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
>
> v1: https://lore.kernel.org/rust-for-linux/20240808221138.873750-1-ojeda@=
kernel.org/
> v2:
>
>   - Dropped patch #2 "kbuild: rust: make command for `RUSTC_VERSION_TEXT`=
 closer
>     to the `CC` one" (Masahiro, Bj=C3=B6rn).
>
>     In other words, now the `RUSTC_VERSION_TEXT` command is kept as it
>     was, without `LC_ALL=3D1` nor `| head -n1`.
>
>   - Replaced `macros` crate dependency with a comment in the code that `f=
ixdep`
>     will find, since we can do it for that one, unlike `core` (Masahiro,
>     Nicolas).
>
>   - Added patch (here #5) to add a warning when the Rust compiler used to=
 build
>     the kernel differs from the one used to build an out-of-tree module, =
like
>     the C side does (Nicolas).
>
>     If the patch is not wanted, then it can be skipped without much loss,=
 since
>     anyway Rust will fail to compile in that case. However, it would be n=
ice to
>     have to prevent potentially unexpected situations and to clarify the =
errors
>     that `rustc` would emit later. See the commit message for more detail=
s.
>
>   - Rewrapped comment to stay under 80 lines (Nicolas).
>
>   - Picked up a couple tags that could more or less be reasonably taken g=
iven
>     the changes to v2. Re-runs of tests welcome!
>
> Miguel Ojeda (6):
>   kbuild: rust: add `CONFIG_RUSTC_VERSION`
>   kbuild: rust: re-run Kconfig if the version text changes
>   kbuild: rust: rebuild if the version text changes
>   kbuild: rust: replace proc macros dependency on `core.o` with the
>     version text
>   kbuild: rust: warn if the out-of-tree compiler differs from the kernel
>     one
>   docs: rust: include other expressions in conditional compilation
>     section

I re-ran the same tests as for v1.

Tested-by: Alice Ryhl <aliceryhl@google.com>
