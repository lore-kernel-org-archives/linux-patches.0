Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3267633BBCD
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 06:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784701380; cv=pass; b=M3FCxeSsWSPgm7bm3MXUmBneGLPEWmv0rCQT6ZTvZ1FL2Ihg0adf4iWIQr8A8l3Lm4vnK/NjjeyRCpq76cBM0QisXGSIxJjcIuaxDlb8ShcAgEhHqKoXZJTq6MMUrEFOQyQ7EAjvSTsCtqXHZwn0ihTKbgwfF0oXdwBiDyVOuO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784701380; c=relaxed/simple;
	bh=ansZuHv5hUKB28upCGQgfNo4EuvlpKUL8A9OQ6KsPVQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i6ePzCCLTZLafkb56iKa/W8ohmZarmI545WlGfO5uxrGeTm6vN76DiiVHx63lg6iCPtZ5ONOiB/HKGWjqH1F7lGIh4inu8wAleLHDO9mmkoYGuFNLwGAOL80OMKNiQOc4Xano3u1AOcW5DkTL+E3mJ4iqaBvjbVfFICbCWGvN1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FA4tvvUt; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FA4tvvUt"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f6609c657so1927020f8f.2
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 23:22:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784701377; cv=none;
        d=google.com; s=arc-20260327;
        b=dljZ3Fi4UuqF99W6RpIfQhJHHGM6JS84o0ZksHd4wqp2x6eLGKaOGRwbcSWuyVq6H1
         6qRH2oFNmlaXROwq3NCnxsvP7ssiExorG5VjKA9i4snTETUJUOH7kn0of+VQdaOJ6WEB
         PW9LMhTQUWMxfzFkZ9RauNGca2iBISzGLcXJhB98S6lDAlszXB4GLMkeqNu9DBgosk2u
         ND85yE7MyT0O01S+idss+hWHfV3fV4QdDD3UmDn0Hakx2s1JWxmIh/+oHmF4CZRJEjCb
         WtCmEItWiYuGrse2ZYzzx+dOjlNXLssfOnqWKqHvl3UkUqXUqYb2NOb58ZGhEWft7sfh
         kHWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h8ar+PE2tSF9whqkAGYsRk8+en4mtmc6KvMg4bog/9Q=;
        fh=A4gLEl4/Z4e3HXtVvlmr57D70qZ6J4n65Hn4EeflzVw=;
        b=HUO97z0BhZVi40M3NwOkGxIwa0R7q4lG9VDOYxGaLlBF6WZBlPcYKhJB+TZQPr77GR
         z/KYtzZQYSx14WaBMBet3s73ydGNrI/85586dOM84Xs0cg63UC3M1qoRX6j2Y9a/cme9
         CSSdxtNmxxP4BsCMqs3lyvFPovY0mQbAMdui7y1lunfdXyBarlISZDj3oQHbJiwiR+iV
         pUsZajOIeBilz7RDt3Tnk/IDtCNEAlMpwYVnv3/BiLvO/FAi9QS3ntzW3V3JvQmxHgTu
         CTocRdIHtS2eFNSW6h15Tbw6kXomVjqPIr4L/3H6T/ownDONQg0+Gvnyq7DUAuRqm059
         uLUw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784701377; x=1785306177; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h8ar+PE2tSF9whqkAGYsRk8+en4mtmc6KvMg4bog/9Q=;
        b=FA4tvvUtn6s+Il292l1XHPu8aKRMTi/8tigkdcYsgFfojHWzaN07hPapoRdMRHrsNW
         WyhF5BKrjGS+wZq794sLKHmA4jHTUEjy5DodNsaHLFhJ2J8Q41+V+9A7BVr6tgQd7vyk
         9TDkD+pc0vS0FxlidFpK5hOkT63AnsIgxe4QQoNelFhYcPNuhwlTKVbcGvIzX0G9mkNh
         sZWKRYV3CAW5tfptXVsV2aJ9pPrJ+/IR94D32AS8MfDypMeHCXje605wt/z5Sk+qHInZ
         9sZt/giVz0TQVKnqyOR/+FVBeQttEDT6whe4cAdRCST5S9HztKNXfbxPmB6tdkjdbp0o
         9xMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784701377; x=1785306177;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h8ar+PE2tSF9whqkAGYsRk8+en4mtmc6KvMg4bog/9Q=;
        b=j7Hv61QPCC+ifZfNG5MkW9q0z01ZaQ8ColtZiUDqPf2Xm81paR1EzH57gLc+WshzOR
         hQ3ZErNQ/+XmzfzrYou5NYPiqEDqwzf275ut9S3hSg4lPn47noQyRqwNLsR4RQOLVAt9
         5ONsvzt4rSc8gW3kCMF+I5TquHKgz0KOjWOcT4pIDh6xsjJrTjXC+mv9Gs7ElOgjLXlj
         es/FMnBj0yUokQXPdhVWnb98BCAoYSDmlY0RebshAMsFfG/s5qwMk5nH8OHKicgDiHal
         pXhLvejphpTe9t8dGECY+L+ehKgL3L2+XBUacqORnIaTMyVdy/r8HaaLHUj90dxebhN7
         n/mQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro1Rg98MhJrX4z4A+Iwf+2fYghYTytdy4tbK3pcY03eam7gjejaIloIsShBJmvNDqhhuAs2p8Oi@lists.linux.dev
X-Gm-Message-State: AOJu0YxpOt9W44o/0MENJAUdLa1V7/ww9Vqv/VMaJaVlhMMWEgmv25FI
	XAyl+VxMZanrwBiZPOMOC23JyKZVOgRbTQdIcCXaI7zcT61buPeY4kFFTQtRgdH+53NdOKW+pV1
	mmDHC5hZClCQ9bBSCldBfCh6uvCDgjoUZwl/xH3xo
X-Gm-Gg: AR+sD11T3VgYSN2c1yrVjKa+vl/f5HK/YSKDvK5rbNy/SNKEkv1y+vTJi3savsNPZWC
	fvzY5RmdTTOUycDBWKmY2epqRxk840SXC0STT3ktahoycHnFsE3IGMWPGpEcMqJ+Q94I81dl8/D
	3rxDlDNrPJGiQ7E3V9iTpjhtLzdNk6HVQ5P9nnSYFfygfS3TWpjEMQevIHWJ5+40MFs8FXe/hOH
	3+ghpzd9zffr2JtU9GKcjrBgFmtY4ksBy2i2UiOY1RP3DyZqx/Shl3GOK0pnV8Z9noAbnGXeTPu
	po0UsTKAyitE70Pv
X-Received: by 2002:a05:6000:41dc:b0:474:d7a5:4b6d with SMTP id
 ffacd0b85a97d-47f6230d16cmr25728475f8f.21.1784701376894; Tue, 21 Jul 2026
 23:22:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260721152441.786066624@linuxfoundation.org> <20260721152443.212105076@linuxfoundation.org>
In-Reply-To: <20260721152443.212105076@linuxfoundation.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 22 Jul 2026 08:22:43 +0200
X-Gm-Features: AUfX_myz5AVwlhMfAKqIhVYYjJxuDVlz6T3kotV2RykCrJ12L1ODYU1rEHzqql0
Message-ID: <CAH5fLgh=6eOcsUpBODZmyhQnZ0eqDfY12MkmA20w2JmgxJ3wiQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 0063/1266] rust: Kbuild: set frame-pointer llvm module
 flag for CONFIG_FRAME_POINTER
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Miguel Ojeda <ojeda@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2026 at 10:13=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Alice Ryhl <aliceryhl@google.com>
>
> commit 191f49f1e38b1c10eb44b0f967c6175c884ef7db upstream.
>
> Due to a rustc bug, the -Cforce-frame-pointers=3Dy flag only emits the
> frame-pointer annotation for functions, but not for the module. This
> means that functions generated by the LLVM backend such as
> 'asan.module_ctor' do not receive the frame-pointer annotation.
>
> This is likely to lead to broken backtraces and may also cause issues
> with ftrace if these features are used with functions generated by the
> LLVM backend.
>
> Thus, use -Zllvm_module_flag to work around this rustc bug if using a
> rustc without the fix.
>
> [ The fix [1] has landed for Rust 1.98.0 (expected release on
>   2026-08-20). - Miguel ]
>
> Cc: stable@vger.kernel.org # 6.12.y and later (flag not available in pinn=
ed Rust in older LTSs).
> Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")
> Link: https://github.com/rust-lang/rust/pull/156980 [1]
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> Link: https://patch.msgid.link/20260616-frame-ptr-fix-v1-1-dc6b29a631d9@g=
oogle.com
> [ - Adjusted Cc: stable@ as discussed.
>   - Added comment with link to the PR, similar to what we did in commit
>     ac35b5580ace ("rust: arm64: set uwtable llvm module flag for
>     CONFIG_UNWIND_TABLES").
>     - Miguel ]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  Makefile |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/Makefile
> +++ b/Makefile
> @@ -857,6 +857,9 @@ KBUILD_RUSTFLAGS +=3D $(KBUILD_RUSTFLAGS-y
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS  +=3D -fno-omit-frame-pointer -fno-optimize-sibling-calls
>  KBUILD_RUSTFLAGS +=3D -Cforce-frame-pointers=3Dy
> +# Work around rustc bug on compilers without
> +# https://github.com/rust-lang/rust/pull/156980.
> +KBUILD_RUSTFLAGS +=3D $(if $(call rustc-min-version,109800),,-Zllvm_modu=
le_flag=3Dframe-pointer:u32:2:max)

We shouldn't backport this to 6.6 because -Zllvm_module_flag does not
exist on the rustc version used by the 6.6. kernel.

Alice
