Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCA9217701
	for <patches@lists.linux.dev>; Thu, 19 Dec 2024 08:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734595410; cv=none; b=WPKM2nS/TXqNobeIIApEnQiTzMmuOiIwA9jijOJNlUcmYZr/SdLxtjW79EpEYFMjvb0E4c43k82lqmNL6bcfJilE+L4O7Ii6W1pZfH4LyQh7ZTtrwo8BDWt+/9gG/j1hphEGhPgfTYWh/ngjg1FRQj2hTrpoXXbUuntLu1RarmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734595410; c=relaxed/simple;
	bh=RgfHuGBXae1glgZFL17pBAgm97fYyxc7BJ/AXvBFTbQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=twgko4oqfMCUe4pDNUZlqTpBzehMNzR0lXPZRDW7X2GMjLL6M6PSaVy1NohWKPeO8sTN1jyMnz2dOpwICtX2QrQCSWCqC4MynASPUJXenlAahC6bVLc3Hke8m1WQu0g6AgzZt586pQvltW21vx0muAijeFUXruDanInlQqjNMsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=Tvq/zfdn; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="Tvq/zfdn"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5401d3ea5a1so457477e87.3
        for <patches@lists.linux.dev>; Thu, 19 Dec 2024 00:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1734595407; x=1735200207; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ugXH4+JF66LMJJim+wfATXqMioH1c19K+Z5j5LyswP8=;
        b=Tvq/zfdnwtQ4Idpekh/jM1uNBeKAQsv3zCglvsf6uvZReHvAGVmbAr6nBXK2gkNq2c
         b8hVKAeU9d77W2/iBchZawjN7iVMIW39XJavD0BysDIW+fGbrv42eN+rp+FHoQvXwZzb
         dETvhx/Mj7m3kjCwz4UnSkYZlwBY3RgQ8kkNt57QhccktdwVTcyz/WvUHhaYOYzB8uqv
         4X6/ns6oiZT3vA5R/jyqyF3V7/y/PNquBMxhpVuglSs3qDkhANV3b56ikZ0jiKuzb5jM
         Z4JBfU9OKlplRySSvYwmr1E2DXTYU9yYilFQpRg0OqorSUDrbR//fR/FiPngbMR2wcKT
         bJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734595407; x=1735200207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ugXH4+JF66LMJJim+wfATXqMioH1c19K+Z5j5LyswP8=;
        b=jq99SnmYST1h4glErXjnJfL/N7xCwZj8KRTv7u9pCrPjhtFgT5mgvhzffao012C2Tu
         jh057ITPtX7LlK8o0nHOIzpMXBgtSVQhIcFr/bEsuct/mp+qEBQ2N4JllddYxq9cHOTf
         mS1bxS0ceUSJznIc0CW64BfsPSblCxuxF8k2xlWL/fLxNWw/YeGprmT6DlkEsIh1uv/0
         jP8iXwTQztx72xt02HlDJIcPtC9Bz9/8tbIAv0sqT+TJY5l4b2fdv9PiA165yrdnp1/5
         7fdvkfujSqbbgSh19v2aHafoAWicnrOTuEhrxRKXoXmJ4S9pstF37JorzHwfeJfw7XPN
         d17A==
X-Forwarded-Encrypted: i=1; AJvYcCUVDAZEgRUN9ztCnIYwYgA45cnSsvOf520i2q5YHfxciOpNoh7OofuJqn91bv+i6kXybe6FX5qV@lists.linux.dev
X-Gm-Message-State: AOJu0YwihMbu+T/0YVnDh4gUZgSY57p3gsK57IhnyHVo36VYfqiqv09l
	FgKEEF2w8FqsEzHcyACAihDWOOLc6cd9/1zVjs5gf2ZY0tGLQ82gmnfHQ4odonTwM6wOeLIPyDC
	lro2OWYoSqSKdq2crrb20HnwaN+uCaHeIGm+SwQ==
X-Gm-Gg: ASbGncuBilQvKYUmByseBdcTk3SVYzFQgMOtjMxmkF/Ptx0k9gIsk5/m7jg7uyTuWnM
	WFDF1CedJsGJU6X90dumnJqthrqxSVbv43yhzCmKm5XxTlFfFeKTk3w0VGtGuYcbXskRj9Q==
X-Google-Smtp-Source: AGHT+IFRKO+emIlNQZoyNcMhoAfze1VoczKB32ps+HArJ9oMB44xWoJtMbeHURhGT7AmeGiL5tKkxwjtS5FU/ZOAuic=
X-Received: by 2002:a05:6512:33cf:b0:540:20f5:be77 with SMTP id
 2adb3069b0e04-54220fd29f2mr699782e87.3.1734595406555; Thu, 19 Dec 2024
 00:03:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241218-crypto-qce-sha-fix-clang-cleanup-error-v1-1-7e6c6dcca345@kernel.org>
In-Reply-To: <20241218-crypto-qce-sha-fix-clang-cleanup-error-v1-1-7e6c6dcca345@kernel.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 19 Dec 2024 09:03:15 +0100
Message-ID: <CAMRc=Md19mjs3J+RKTGg--bC+G6yFk5J00wCMohqtt2_O0k=9Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - revert "use __free() for a buffer that's
 always freed"
To: Nathan Chancellor <nathan@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2024 at 9:13=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Commit ce8fd0500b74 ("crypto: qce - use __free() for a buffer that's
> always freed") introduced a buggy use of __free(), which clang
> rightfully points out:
>
>   drivers/crypto/qce/sha.c:365:3: error: cannot jump from this goto state=
ment to its label
>     365 |                 goto err_free_ahash;
>         |                 ^
>   drivers/crypto/qce/sha.c:373:6: note: jump bypasses initialization of v=
ariable with __attribute__((cleanup))
>     373 |         u8 *buf __free(kfree) =3D kzalloc(keylen + QCE_MAX_ALIG=
N_SIZE,
>         |             ^
>
> Jumping over a variable declared with the cleanup attribute does not
> prevent the cleanup function from running; instead, the cleanup function
> is called with an uninitialized value.
>
> Moving the declaration back to the top function with __free() and a NULL
> initialization would resolve the bug but that is really not much
> different from the original code. Since the function is so simple and
> there is no functional reason to use __free() here, just revert the
> original change to resolve the issue.
>
> Fixes: ce8fd0500b74 ("crypto: qce - use __free() for a buffer that's alwa=
ys freed")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Closes: https://lore.kernel.org/CA+G9fYtpAwXa5mUQ5O7vDLK2xN4t-kJoxgUe1ZFR=
T=3DAGqmLSRA@mail.gmail.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Yeah, that was probably overkill but I thought it makes sense if I'm
reworking the driver anyway.

Feel free to kill it.

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
