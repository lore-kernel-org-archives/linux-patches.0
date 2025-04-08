Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE769267B89
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 11:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113491; cv=none; b=g2VYtLlikqX282qzurpFgTxLH4Tix5uKJIkimNzKMDU9K0Cvs4gJM/rMoihtViZh/TksVo8R+BI+HhNWDkjt1P4awYt/uayM8NjFKnS/nod9XvVH3HXh1uZrTyzOkb5SHzmrwBF4kT2EoigLrbNaU4cXKABwd1pMqWeIP+Z2sy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113491; c=relaxed/simple;
	bh=H8PrH8DhwvVPq9YxP0qvt8ia656YD1J02D0+wxd9KKs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pqvc7LEWwRP9SYPRx8nxlWgr/qGHxmpnplzfYGxS3ZuPGftCEb+fhuz4NJ+OHK68KRg6UePsURP4sVaWDUH2WYShTICj7asFIjhCgEz3DQ/0pyAjInLdDclDiF/bXmXzPneXGbx/PvRUCHGUIG0lOBPMIsmIQfaeqI04dRidZbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2fpNwqmR; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2fpNwqmR"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39c266c2dd5so4755570f8f.3
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 04:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744113488; x=1744718288; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LzDQS9SW/iaYstqoOxPXbXo6eBA2JBDZWGyNq+1mh3A=;
        b=2fpNwqmRqUAwE1iF7SiFbaC9ox27YnbRY0nNJvFxokH8NLwU5lkcROBFSduXLh7WAc
         fsV1avA+GzPT++s2SxOARnBoJibiqM+y1/DSigLHVz3sqk6xWlRgQWcuHfQ2pdoUto97
         /jK6NeXIVLXjfyc74Sp4zfGDby231AmEPNYaN/5NLIrNBShXjXGF0RBZrDE14KEWdhri
         HDUpuV1psCEjXmSX3IiiFmIy2qKa/0Hg2ThynalNYVAJi4LZLgQpMqRGf+M2taRfufYk
         1G3xe/v5j2bAj1eUalDZPJeb01MAc8jLcOZzogYa0De3QFMXAkQ+11TPw5TGiU6k/64a
         X9NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744113488; x=1744718288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LzDQS9SW/iaYstqoOxPXbXo6eBA2JBDZWGyNq+1mh3A=;
        b=i67N+2OcM4uuuYBKnO8hydTd68uwTmel0pui4svKX9Qz0MUvTxJWXYDmCGISNBgv2+
         VafajixW3uhEn4XwwqIdpVWGE3SWEYIfkiBqIygqKHr+XiwXznKyT/eQAFcINX0Bnunq
         72xWfANlQmiI8ppun5dfepAR10hgDKeW0LYTNCwbn5kFOsX/HJwFP31hp22aA5c4uMzQ
         ItFXePKSlwfqe0T0RvAfhpEY5asc5SQ/xOJkxzHALFBNROMcpgauw/zf/jKGAQZZmJVT
         yxJtRge6oQ8+fxdaKYIEXO+PwBdjVUuttesQ6P4iGeC3BSRkfdk/c2k5O4IKlMWADXzS
         u1uQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2u9/mBMFm9x6GjNGKREHxjzFcd7mflDT6ig53ClDmsp7zDClZTAXJYnA64/TxNt2TvBbyyM8u@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1mkIqeyDZeJz1Aqe8rtgiiKV8knQBYgbzy/WoEPEywJZUK6F+
	KyqlQ7fC+bcWfhUJDuG8i1kle5DaBy3j7caopUzxByROU5lkNkl6MNJxu5E3wywFxrjBttRaJeS
	bHH5Jtpw8Vf/M0d5K5jb7+mqS6botR+TZsZoEZ/xS2+f9kT9uxw==
X-Gm-Gg: ASbGncuHJ53PfJNEG2yl3idZZA5FZGaua0ONU7UvrOXECxJyCrnvgahvAhYJXbDN8s0
	kWv8LCLoshaP/jHeGBkiT0Hmb+YurNZRkqmamILue5l1k2VcT2VlYq4yOLj+x4P0wi93eLLfmZ6
	ahi3EuU66jfTZWcPYguhIXIp/gCc3WmwqlnubP6swiHpBBUxGqvtjIStf8
X-Google-Smtp-Source: AGHT+IHR5+3qdcDJjtKctI9kDCAeB4369y/zP0yo1fjwF8QoixOqRlbbyym+GmWvivti/4RxoDhijpZ0LI4xTLRTKZo=
X-Received: by 2002:a05:6000:228a:b0:38d:e584:81ea with SMTP id
 ffacd0b85a97d-39d0de67ca9mr13977845f8f.45.1744113487958; Tue, 08 Apr 2025
 04:58:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104828.499967190@linuxfoundation.org> <20250408104830.890872754@linuxfoundation.org>
In-Reply-To: <20250408104830.890872754@linuxfoundation.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 8 Apr 2025 13:57:56 +0200
X-Gm-Features: ATxdqUGe8bFOZvLuWZ__R6jYo-U_e2Seu4Hh30FmTWVbnXMjq3AfKCGDNREEkCk
Message-ID: <CAH5fLgj6SEKy1-CopXTnaFWK6WFddP+ahccf1_MdabpeCuB87A@mail.gmail.com>
Subject: Re: [PATCH 6.6 089/268] rust: fix signature of rust_fmt_argument
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Tamir Duberstein <tamird@gmail.com>, Petr Mladek <pmladek@suse.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 1:54=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>
> ------------------
>
> From: Alice Ryhl <aliceryhl@google.com>
>
> [ Upstream commit 901b3290bd4dc35e613d13abd03c129e754dd3dd ]
>
> Without this change, the rest of this series will emit the following
> error message:
>
> error[E0308]: `if` and `else` have incompatible types
>   --> <linux>/rust/kernel/print.rs:22:22
>    |
> 21 | #[export]
>    | --------- expected because of this
> 22 | unsafe extern "C" fn rust_fmt_argument(
>    |                      ^^^^^^^^^^^^^^^^^ expected `u8`, found `i8`
>    |
>    =3D note: expected fn item `unsafe extern "C" fn(*mut u8, *mut u8, *mu=
t c_void) -> *mut u8 {bindings::rust_fmt_argument}`
>               found fn item `unsafe extern "C" fn(*mut i8, *mut i8, *cons=
t c_void) -> *mut i8 {print::rust_fmt_argument}`
>
> The error may be different depending on the architecture.
>
> To fix this, change the void pointer argument to use a const pointer,
> and change the imports to use crate::ffi instead of core::ffi for
> integer types.
>
> Fixes: 787983da7718 ("vsprintf: add new `%pA` format specifier")
> Reviewed-by: Tamir Duberstein <tamird@gmail.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> Acked-by: Petr Mladek <pmladek@suse.com>
> Link: https://lore.kernel.org/r/20250303-export-macro-v3-1-41fbad85a27f@g=
oogle.com
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

> -use core::{
> +use crate::{
>      ffi::{c_char, c_void},

I don't think crate::ffi exists on 6.6, so I would think that this
does not compile.

Alice
