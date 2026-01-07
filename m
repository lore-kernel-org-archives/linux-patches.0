Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FACDDC5
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 00:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767744293; cv=none; b=PiZv4OGJrE9LBaGsUCpouxpFGn4tATv26pVkQOlgx1rzs5kUh/J7uMGuxQtXAForO4cyd6gl/w5rmpmgYqBFQdRRGo9c46mkOhOr4SNw5CQBx/6yqt0rbLKGMvHt9v6kgPqbsSXXMXU4G2cDv/AvZnTwQ4dQap0K/ol2FK1plhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767744293; c=relaxed/simple;
	bh=8qJPx+kC5MLS3XV6h2sWuTOwf1eMrgy6GAS9eEFlKx0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e93E4CGnqe/y1MCLAMy/6nnD5wKWKGHGVhPxv8yJ/uSIOkqFpyaJNhh+oXjlaBdAPxnhSCAor6X+K6hXvmZS+OI88nOBArLBCjNnNeBbFJk35Ddt2tCujCed6dBJdgYce0r0QFtfv3K17F/X5McuR+acRfoWFwFMlMZfhJwO6yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=H73TEBMm; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="H73TEBMm"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59b30275e69so1190604e87.1
        for <patches@lists.linux.dev>; Tue, 06 Jan 2026 16:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767744290; x=1768349090; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HKyvUh+QhrMURKxvdZgbCSxanf920aeudQdpSlc4NpA=;
        b=H73TEBMmQuwFHUoiAc+P9+m5Qyfe3T+tkw4fVEIhXKfo8ni5VYk0Dz6jHDudYF/wr6
         ItZeHCP0txx5s/TXBliTjAYrTZ+1ca05X9mo9FPsfPZXgz6OLJdMdnyCqvMkuUCCwyAg
         dFT8dVqDOFbvU0VAWeI1hPlyGYVOsrowpgkY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767744290; x=1768349090;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HKyvUh+QhrMURKxvdZgbCSxanf920aeudQdpSlc4NpA=;
        b=Axu5VADfjLSm0RXzDkAaWytY8ivtseXbLXzhYabA9Zl/XCrnvAP2eAaHR9yFk/jhTL
         zCUz6spE/oXRRutA/8fLogA5VsjJsS6gTbFGgjceBcQ+tw2CFwhuoXZj83BkhRrXftP8
         0XGlSumJmnIhO2gGyUN9UoYv3W9lsYZDV6OelqUlDSip9Yie4QpsbAJatTfAirTminEK
         G4KdTT5kWGRKjkRpUV2jaSj/PJ5KqRhw8W9cVNilL2yS9q+FwJwidxS4XVPH5Sg0gQac
         h951gNIsrKfbsiAfH3trJ2cYtlT6wrSEviuDQUNshubwy7lBANasCYw4uYk0/XEN8vlB
         azUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVthCKFmoIRrGbLmY1oKmEInan4At3YE383LJjE+TRdze4VrskD+5rGsqlFtLf8KXUaPJ6pMewO@lists.linux.dev
X-Gm-Message-State: AOJu0YyYJbwI9v0KU+Pyk8L9R9evgINUh2ADsgRXwlRniY22GKCudDqp
	v/IfA4gXTY1v61plux29ICE0DkYCr493LaXQOlY/Bq4Qh+c7Rn75iU70P2s7P8vKZfZc37MpQv7
	Et9nTTQhxulvxIOAwdzm5bsIaiNwurQUjLfS1Eps=
X-Gm-Gg: AY/fxX7KMWs6hnGgOHG8GNty/ObAIuSZLe/q4DLPYgSmo343kMOXEiGLHDv2g8EQXW7
	dNawjTvzeztFC90U/Ezlr06R4b4bPXdW74su1U4FMePp9rJG2kWgZ+CIb8OZqIEkzBGnvTy5Fp6
	0V/Q8pUGO2wOrbVRFdi1MTuzwaXhoYjJf8302AezwFJCdNjb7/8i+/Y6r6emddfijGW1g4dlas3
	sCe60Ef+88M09r1BvYdm0ZyyrqgpS0pIL9lRpg+XNDqFmTkRwOroHufdYs09Ka6j9k=
X-Google-Smtp-Source: AGHT+IFQdy/+2J9uOSYpxLDewV04a9J0eyKjqcf1U3V7EFffmr/5C+V3f6woXruTS5TnVHp7er13+RW98nO287n4HrI=
X-Received: by 2002:a05:6512:3dac:b0:598:e8b7:665d with SMTP id
 2adb3069b0e04-59b6ef0698bmr282600e87.3.1767744290137; Tue, 06 Jan 2026
 16:04:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260106170451.332875001@linuxfoundation.org> <20260106170509.599329945@linuxfoundation.org>
In-Reply-To: <20260106170509.599329945@linuxfoundation.org>
From: =?UTF-8?Q?=C5=81ukasz_Bartosik?= <ukaszb@chromium.org>
Date: Wed, 7 Jan 2026 01:04:37 +0100
X-Gm-Features: AQt7F2oZgW6rINda_2dA-YwksISTYezoZCKXSbhdQxy3iradySpgB4CCqOninEU
Message-ID: <CALwA+NZCSz26m96R0gjKP7=O3Z_kWmnt82SiaqvOukR9vFxv2A@mail.gmail.com>
Subject: Re: [PATCH 6.12 493/567] xhci: dbgtty: fix device unregister: fixup
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	stable <stable@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 6, 2026 at 6:43=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.12-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: =C5=81ukasz Bartosik <ukaszb@chromium.org>
>
> [ Upstream commit 74098cc06e753d3ffd8398b040a3a1dfb65260c0 ]
>
> This fixup replaces tty_vhangup() call with call to
> tty_port_tty_vhangup(). Both calls hangup tty device
> synchronously however tty_port_tty_vhangup() increases
> reference count during the hangup operation using
> scoped_guard(tty_port_tty).
>
> Cc: stable <stable@kernel.org>
> Fixes: 1f73b8b56cf3 ("xhci: dbgtty: fix device unregister")
> Signed-off-by: =C5=81ukasz Bartosik <ukaszb@chromium.org>
> Link: https://patch.msgid.link/20251127111644.3161386-1-ukaszb@google.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/usb/host/xhci-dbgtty.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/usb/host/xhci-dbgtty.c
> +++ b/drivers/usb/host/xhci-dbgtty.c
> @@ -522,7 +522,7 @@ static void xhci_dbc_tty_unregister_devi
>          * Hang up the TTY. This wakes up any blocked
>          * writers and causes subsequent writes to fail.
>          */
> -       tty_vhangup(port->port.tty);
> +       tty_port_tty_vhangup(&port->port);

The function tty_port_tty_vhangup does not exist in the 6.12 kernel.
It was added later.

I sent updated patch
https://lore.kernel.org/stable/20260106235820.2995848-1-ukaszb@chromium.org=
/T/#mb46d870145474d04aaabeccc76aaf949b34bbf86

Thanks,
=C5=81ukasz

>
>         tty_unregister_device(dbc_tty_driver, port->minor);
>         xhci_dbc_tty_exit_port(port);
>
>
