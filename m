Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14825310652
	for <patches@lists.linux.dev>; Tue, 18 Nov 2025 23:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763507056; cv=none; b=Co67/QEtNREbxGj570AsM8XWx3mj0YXFoSYQGUtzIl+Zx6bz2CNRYPgxylzTMkTmYEweejyTBCQhEk8sis9tP+JmighDPgIlfDfT7ThlXnvlGmgDGLVoCEw8HZxmDDa3MYuBrUXCuTW4mwqM8rkvy4yRLwKkjfXZBA+Fj3srsko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763507056; c=relaxed/simple;
	bh=/ymX6MZbOGP8Rnnx2h10YmGwYTYivcCZihr8XRtlTxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HWcY0ZC+SaX5gYTpgvk+RZ5gPDvhxYZGJCbqUq2NPWDzfZJ4UC/a5bNn6PdfTK3zNpcY0iFF/Uh/QrT2K1v02UOimpyAyy0SmvoW08TMj75FRLpRsJ2+aWlY0RigAa381CUtYM5Up8SDpJkQohyeWjIrnqV+MU3oUiuQESGxQXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GjymGlyE; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GjymGlyE"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-786635a8ce4so50806557b3.2
        for <patches@lists.linux.dev>; Tue, 18 Nov 2025 15:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763507054; x=1764111854; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DpyxSY5WvJi0HmvpcS1llhG6ee+xNYXsAMhYQ5ST4Es=;
        b=GjymGlyEWNUykghkd/pjm67CTKxYTgzABFq2MqLM2akBo8i0HRk6qDa4HWgbPYV/IJ
         bddGMtJ26qXtEGvlNtr5BlZO6zudklExcjuOj6SvN+Zl9n4sPqDhz/xRzWHb5Xj5BuUX
         egh8FU7z7pypJ71TAntRG21vNzDssCYSCa/iJY/yjkDOmnKZveNxhwryeDX2bYSH9Jny
         IRnktsYmwgC9DWMs03t8BT8cIqYfS1QzX/HYIbI2gcTYu7A4Eze4P/gPwQwWCLXoqc2g
         vJJi1NeuMYFqYH+6+7dpYNeNZtuPY66Ym4kuNHtmclCplmleL4honWXLC90BV2s9XLFU
         X9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763507054; x=1764111854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DpyxSY5WvJi0HmvpcS1llhG6ee+xNYXsAMhYQ5ST4Es=;
        b=n2TbZfw7lH3ntr4TMjVA+3D9XLVKqIy8s5nLYBpghZE+vJJjJpbetCtiC7T3ognt7/
         ezv+yj5C8jlopHOpbx6mM+RBub0Xs8kwrFOrsGgEWCBhxK//xD8JsyV3kG0EgpWl41zV
         X4rp82Z+zcG/vNDBjB5DCg1aejNEKjDfLeV5/CgsJLl6bsrZv8a9PZdf7ska1RD6jzSR
         GB6LcH50jazQ1k0wHKVHRn8Mt0uXmfP2nTe2t/2vjYztgJlmlwmZffZEqO2ch4uModVZ
         kJS5QFsFmIxwxvrunOfUuCjhoHUtrGZmR0bP65bvfFGjIVtS1tVRRPOCAfAFjMjmoz38
         7LlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHVT1rFYQBXQ4TeUk6s8Z9C7CH/mKDmEmYJ/fEUSEyc91T7pETYeUA1dTrUyhTzFIY7EGb/F6j@lists.linux.dev
X-Gm-Message-State: AOJu0YywgYJ/KSwx8DtS85t2ScNs23i2qS4stiQJbbQrSkMlJUK3NsOn
	Sccq67+sbqXX2Ycd5yW/C+greAxaupR05vJ5pFKdJ/3Z0delzce16WWBy1C+OL+nDFH/UHnn1yG
	TlroxJ/5ak5oJEiVgIK0YYjszu3qyrz2Ry99qs8KYEg==
X-Gm-Gg: ASbGncv+ZFSpAw1pV7kNfV3hWBlHD2oagqqmt5EmoErzCYyzZ1OUZeg0Ejv+IE5cEMP
	yDy7HvbP6LBwqOJZt8AKZsQQ/q/ovuv2eDeWQf0X6SWLAN+rSgCjA+1qdXSkqj97SN5xxcH3YgE
	lBSG17hk5kTuRq35hKwdbIjF9qEL98yzlzKgLseQEM9j93gW3unvBGIzm+4Rodb7OYhqiaafIlq
	FRHi8w5e0g8onq+JcthiyTBoU+6hUY9jCTbiOuTA2GH0bhqQ8wvFLn8AmhWuRvCzWw6bR4yDgeq
	VG9ZSQ==
X-Google-Smtp-Source: AGHT+IELB+09mf9khX/1UFEnPeAm1lrX0fgELMFuofsGX4R6IFFA6KPF6dwvDM7AxfFurD19MW+eZHnF90lveBd3oI4=
X-Received: by 2002:a05:690e:155c:20b0:641:f5bc:6984 with SMTP id
 956f58d0204a3-641f5bc71d8mr9451804d50.80.1763507053863; Tue, 18 Nov 2025
 15:04:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251112-pinctrl-airoha-fix-an7583-drive-e2-confg-usage-v1-1-d2550d55e988@kernel.org>
In-Reply-To: <20251112-pinctrl-airoha-fix-an7583-drive-e2-confg-usage-v1-1-d2550d55e988@kernel.org>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 19 Nov 2025 00:03:58 +0100
X-Gm-Features: AWmQ_bmTrpDRkDleDNb2XMlOjcgLl6u_OW5kVkCUfJvH2chNj2IWVVvyVcdyP9M
Message-ID: <CACRpkdaFq9PBxvxG2t6xDTN9M-7psvo=VDTCpu_qhvk30zFrMA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: airoha: Fix AIROHA_PINCTRL_CONFS_DRIVE_E2 in an7583_pinctrl_match_data
To: Nathan Chancellor <nathan@kernel.org>
Cc: Christian Marangi <ansuelsmth@gmail.com>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Sean Wang <sean.wang@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	linux-mediatek@lists.infradead.org, linux-gpio@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2025 at 7:44=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:

> Clang warns (or errors with CONFIG_WERROR=3Dy / W=3De):
>
>   pinctrl/mediatek/pinctrl-airoha.c:2064:41: error: variable 'an7583_pinc=
trl_drive_e2_conf' is not needed and will not be emitted [-Werror,-Wunneede=
d-internal-declaration]
>    2064 | static const struct airoha_pinctrl_conf an7583_pinctrl_drive_e2=
_conf[] =3D {
>         |                                         ^~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
>
> Due to a typo, an7583_pinctrl_drive_e2_conf is only used within
> ARRAY_SIZE() (hence no instance of -Wunused-variable), which is
> evaluated at compile time, so it will not be needed in the final object
> file.
>
> Fix the .confs assignment for AIROHA_PINCTRL_CONFS_DRIVE_E2 in
> an7583_pinctrl_match_data to clear up the warning.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2142
> Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs=
")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Patch applied!

Yours,
Linus Walleij
