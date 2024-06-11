Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A747F49B
	for <patches@lists.linux.dev>; Tue, 11 Jun 2024 18:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718130476; cv=none; b=PPvAo0exlISJqOUzNtV47kG/is6TQxwExXX7jHmMlbYURO9kW7wI7+2zr/2E5FOH4e8b+EyfvMASJLyRtagPYu97y3/XHAKIT9728uN4xSAOS+qBBGk6C7bdgZy6KBnxBO649F1nvt6O7weDbhenCArEq7WS1ZqbTfCR5WgyY8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718130476; c=relaxed/simple;
	bh=xNv2gtlBfEvUS6Ujo5AA9Bt69CcEG9Nao++wV38Ni2k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V+yTYxzbhF+9aWxQcyeUZ3VQg2A1tSA6aEKXCoU+rtiGOWOzT3krCsZKq4EBw2fAijhyu6bt4uFfpRsvzVtY0Ny56eSxraGB9FIhb9pPxW4EmcBoYK5COHFyofjk+LJBY3vn/6vHi9ZeqpEjftVH7q3Ys4WUmIE8FRGAZNH083I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ExzL5zW3; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ExzL5zW3"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a6e43dad8ecso20601766b.1
        for <patches@lists.linux.dev>; Tue, 11 Jun 2024 11:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718130473; x=1718735273; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kAzQpAsku5HY8+Qmj0ySk3Jtzr0pPw6rPKwko9mzqm8=;
        b=ExzL5zW3/GdYnPiKJFesqPDKTJ8Yxc6kKEnbMMFo2iXHyIZVetOOi+CXelYn7/d6lo
         F8YVOL3xy0PyPZUfTD9bx6CE5BtEwYdOB74has5OKKeXGDfG6AlFlt7cUytzHRmLfabV
         Tp6qIYH7m1OCVnmx8tBqWPGVKnAh7pFIHjnj7Bs/GDOfMicODRlE2VkHFEZoqHdXrmjP
         gjXLqj5kMPcjVh9HiVPg71pYgZhw3AMIUOMG7xX96L1+dwFgOLLFVaS7APExknDAiUUh
         22V1JUF/ST5rd2V6yQCVrUEFPGU8Fi5LGsBEUuduqCCFumyJQNNb7JJyNPfYPmFu2Nk4
         uVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718130473; x=1718735273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kAzQpAsku5HY8+Qmj0ySk3Jtzr0pPw6rPKwko9mzqm8=;
        b=WcIChjiNLNHhKch5lRJvX1OcQ3pFsSkyXgzYO0+uBzB1ewJQFOPWIDhTrvZ6/M90uj
         bzb7wlpYvk0/soHC3+NG2Bk0psiIoz/68OLr3reKq96wc5S48EBEL3x0yTw4Lxs4318+
         FQD+KizU47KaBUrD9rER379fzmAW2XA1CwYPBaOCdz6adQI0ZJK/DAV4a6CTs5XELA4L
         FXfHBDXEJfyW0NmomHqBbR/P5Ikd49vr5k6vfSM4z3WM8NFoDwKotQiiMETJGJsthLWJ
         LSScxateaKPbc0FEEBTG0dKatzN9vOALcAy1oWoMFcqUdR+A4CwyFK32o6BSdYO+wQGH
         LzoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqAzPJrlsrweup4k9Qkk+Le45zRMnXdiUKMvFCAO3bnBYLZYoLyzoZv41EdKQuYdT++bGdRgw2MPuuN+5HBOOLlitXE7aHyA==
X-Gm-Message-State: AOJu0YzhPS/0dD+mSLqnmHmXsVpH3u91+VHt4PkNSRAHOoqWvBxfueLn
	8fEhhJXQYDTgeKYL7HPuMnpyxMfF2t6+yyEJr6x2bP3KmSrsS9PMx2ZalU6IjU8eq4vlg/1bj/o
	Tvl6PpVSeoz43xta1FNEUqKUXHwI=
X-Google-Smtp-Source: AGHT+IF1N64L1BDSLsRfKUWvL7ixtVlnG3jH3MB2N4pKTF0BtAIrRHO8wv2HJFgF1ngUY9+5x7xZaRMS1bHgKA+TTC8=
X-Received: by 2002:a17:906:c210:b0:a68:e681:be2c with SMTP id
 a640c23a62f3a-a6f34cd6b4fmr252203866b.20.1718130472659; Tue, 11 Jun 2024
 11:27:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611-pinctrl-keembay-fix-func-conversion-v1-1-3197f2ded3f7@kernel.org>
In-Reply-To: <20240611-pinctrl-keembay-fix-func-conversion-v1-1-3197f2ded3f7@kernel.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 11 Jun 2024 21:27:16 +0300
Message-ID: <CAHp75VdUR7jYtTCu1jaz4v-XExboyCeWPj+g6U-YU-SD9q44xw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: keembay: Fix func conversion in keembay_build_functions()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>, Linus Walleij <linus.walleij@linaro.org>, 
	linux-gpio@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024 at 9:13=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> A recent refactoring to use the func member in struct function_desc
> missed converting one uses of name in keembay_build_functions(),
> resulting in a build failure:
>
>   drivers/pinctrl/pinctrl-keembay.c: In function 'keembay_build_functions=
':
>   drivers/pinctrl/pinctrl-keembay.c:1630:35: error: 'struct function_desc=
' has no member named 'name'
>    1630 |                         if (!fdesc->name) {
>         |                                   ^~
>
> Perform the same conversion to resolve the build error.

Oh, Keem Bay is ARM-based :-)
Thanks for finding and fixing this issue.
Reviewed-by: Andy Shevchenko <andy@kernel.org>

--=20
With Best Regards,
Andy Shevchenko
