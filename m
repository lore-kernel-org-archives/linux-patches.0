Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811DB224AF9
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 04:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776140185; cv=pass; b=V0mOl4G7UVRP0A+rPU08WxyrcrQiJSzkulIT3eS1/imx7HaWXBlQ6BDnuusLn32YSTDVtuJClafvtCvUv4uwqdOk3vbK6jSrDTIttc55j6EBQUvbft8fCzKkSsegOg1FkpmLyoVB3+4n5pbZf6Jup/BsCyamG+c/TMXmkm+GcHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776140185; c=relaxed/simple;
	bh=Z5N/rVb+adVyB9rZPmhrqHj2kZpgQYkX0Efp8ZIjmTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QcwKeoXVlnzNAqG8g2FWhil182aB7y98bGtDl8ZWZGujfn5zPJWJdCOc7AmH8ac0KSsFz1XmS/jyjsKY8Ny/BMc+FCC3oTGeRAU7+m02XSCWVIk7lk6GLXawedKVItYRQxRv5vW/PRMBCgudnPWlrPQh7SWRO+wMOY30qhxfQo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T0Amp59C; arc=pass smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T0Amp59C"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-41576c5c01cso3885386fac.3
        for <patches@lists.linux.dev>; Mon, 13 Apr 2026 21:16:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776140182; cv=none;
        d=google.com; s=arc-20240605;
        b=Gh8luENa7OtXYrPFX4uvRKLbtBqSMPMgagXoid/GtjmWk+lH+qvlVcu3GG5ful13O6
         zkr0adN8K9Zs+qyD0EX+2m0PHGK9qT0f4MD0uzKD+YfYpx8Q9WQOD/q680RrsvQeOOjR
         a0tS5xaavW9bsE3Ftfb0Ix8OI+Zxm8BPLiHOIqxRygH9AtRjgE9xu4Rtsg6cghG2faXJ
         +7KIB2rkIOpzo2HzXrMXuhGmBG52X+UALW3/Eoi1T0DIeWbUgkte7PeJcW2BpWTVPdrK
         DwWYGxFEBd8/jk78fk6kwOgphy8SjkpdoNM+W4bQXIzr9snLQ0sHkwVNhc77H5I555tM
         buZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D+WGIUzQXT+3c1N6VUNvjgXRKku5D1uJICQtYt+QceU=;
        fh=7TG11cOcfYZZJO1Ra0gC/D6lFQrRmaZV7FO+u9H0BN0=;
        b=ksGva5bdQMNhLXACdcM1LGd22Mxec7RrP2UGfizgOmNiZke+6yHXSR+RUnRD+4/aiL
         rXcUDVAoZ0csA9nCtjcR1WTKSA9DNyt+juKy++q6hBJxne0xhDZMOZ9xWfjKyqBGUx0z
         54PYFByQXtLunHLCfnyU+a0fBfAespM1PCzIY0MiDbFG1/G9vgK3KJt/WgWzRhROleNj
         JcuzrKdT5eM9Q4VBU3sngiwSynyfoDyUf7hlJBG3wFfDBQmhfDyOk/YjBlY8CNITqfMY
         37pw+88nxR1pHrQHaRKpHdrnt8bc3wKsTI3b5r0MiZa1+yUYyIZZ9pVyzOKZpPDYJDJM
         2FEg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776140182; x=1776744982; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+WGIUzQXT+3c1N6VUNvjgXRKku5D1uJICQtYt+QceU=;
        b=T0Amp59CBN2sMxm5joV4gw9kZLJAt6o5DxToskuHhl6hXabq0xF+9SKKF9ACgUtCae
         GDhNt7anwlswXLI3yel1Tm2dWuiEgN4lFfzOoVmCiFO158Z+As3TlYW/dlDqlIZ4kJAK
         TqvKJ95KVK4R5yx61EZow48P0ormPUhc44BMp+Dv0aSK8HuoTv2ajcVKLyjIVGgB1r9j
         ABQ/DAyfYJSVCjP6QxHzTnSFXpbbCqELj8uLA5G9vaIeZc0FeIK+a0lCQ4ePxdekmX28
         PudhGjkZou5bFm0rmpa55xx1E0cVdx3J8o4zSeGbdD4AflDSG3HzYWh6fPxh7EIPsU84
         qgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776140182; x=1776744982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D+WGIUzQXT+3c1N6VUNvjgXRKku5D1uJICQtYt+QceU=;
        b=jjyQx9uijwGpaco/KfxE6Y3gbVPWZA/iEv93BNBjpjyDFpU/fbG9OQex+5vqbhvwSt
         LCKXPrAQ9/aLhMgbA/pX3tVikj06gxLP8z1c6sF12quEzwgsBe+hkgpxITBxFyjOJz+L
         Hi7lKOfv0ynLdg9yyDyfh93gvgnBcq+vW7cueKjrTVj0MEVejaZtKGbfIH8mdkdnBQGL
         wQAcPfTJ7+zEepwuswko0Xco8F4KfseN/lIkYKqNFKAxJ7Y2hQ705JL3DqmrtE0Cd1k7
         QkWHUJU2kWyYnaXqUVQF85NNEVs+OWgbWpBMTWy8f5qvUASoksX9lKGJHMmWOaoNtnmN
         ssIg==
X-Forwarded-Encrypted: i=1; AFNElJ81nEw5xsZFJ+RMeKYrX+Wd/zUeocwkFlc4PmI4jdKjXYkiIpHYV0VJcuY+O+oBz+2y4adJ4uid@lists.linux.dev
X-Gm-Message-State: AOJu0YzkTzkLYy/ySQ4qfJBxrlBD0y5xW6CK0y7JGmdSIvagXSHMaJTE
	+m0AmDI3iQxpEtzFt+hlLH8fU3x4TPE6yW8R0g0PgOuchT7WjOHhXCySHc5sA88jTlw38Wlma0E
	l1xM9ChvfyYNhvFRkoY57OLOJjj29I/o=
X-Gm-Gg: AeBDiev/LSOhpavFRL625tMmhUx36x1P+IFfBhzuD20+iN/JF5yKOdbDDOjRuugRC4I
	hrSj55CCKVdEFUq+5qolm/IIJS0jG5bdqHJVoFk9dJuHWwTcMk3AwW4N/SCWqx5uyiysBsVswR9
	QbllQviUaHXel+xVaG1HYBRVIaj82GXao1QTF0xAMawKIQhEsnEFD9Z+sq6Sap88klZJEHbZ3wq
	ZYz/FqDUd4im6D39OP3AGHppHffzFsXe1d2PY1l2PQlxW/s8uLUAkiSD+HN0QRLy/d1f/GY6YUo
	HlS7fWxZ/xRZ6aFJzPwZ5G7+ZkJOMj/+PerfWmz4vtl/CItdB8c2x/sj5ktGGdMeZLYwTTM68QU
	nR2WY+8zHGqHrYIsPEEgYJ+tdokRY
X-Received: by 2002:a05:6870:176c:b0:417:c695:869c with SMTP id
 586e51a60fabf-423e10e1dd7mr9347428fac.27.1776140182198; Mon, 13 Apr 2026
 21:16:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260413155819.042779211@linuxfoundation.org> <20260413155819.436681483@linuxfoundation.org>
In-Reply-To: <20260413155819.436681483@linuxfoundation.org>
From: Gui-Dong Han <hanguidong02@gmail.com>
Date: Tue, 14 Apr 2026 12:16:11 +0800
X-Gm-Features: AQROBzBsLhmYDz5qIxKlxZ6uXmJyhFkiJOcxWp4HE7uRjHVOHfWvJSMxJ2kmQUE
Message-ID: <CALbr=LaxfRiP8totK7_K_ErH8EbYcBxTTZ5dYaXZeo2UCVNSMQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 010/491] bus: fsl-mc: fix use-after-free in driver_override_show()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Ioana Ciornei <ioana.ciornei@nxp.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Sasha Levin <sashal@kernel.org>, pchelkin@ispras.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 14, 2026 at 12:43=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.

This patch still needs its prerequisite commit 5688f212e98a ("fsl-mc:
Use driver_set_override() instead of open-coding") [1] to be queued
for the 5.10.y and 5.15.y trees.

Without it, driver_override_store() doesn't hold device_lock(), which
means the race remains and can actually trigger a double free. Fedor
and I previously sent reminders about this missing dependency here
[2][3].

Commit 5688f212e98a applies and builds cleanly on both 5.10.y and
5.15.y. Could you please queue it as well?

Thanks.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D5688f212e98a
[2] https://lore.kernel.org/stable/CALbr=3DLY8Shn1Mk2CBu5sCwNeR=3DJn7BndH+q=
vAZGGqWMNoJQePA@mail.gmail.com/
[3] https://lore.kernel.org/stable/20260214220547-5519e7b20a4919ddd81d97c3-=
pchelkin@ispras/

>
> ------------------
>
> From: Gui-Dong Han <hanguidong02@gmail.com>
>
> [ Upstream commit 148891e95014b5dc5878acefa57f1940c281c431 ]
>
> The driver_override_show() function reads the driver_override string
> without holding the device_lock. However, driver_override_store() uses
> driver_set_override(), which modifies and frees the string while holding
> the device_lock.
>
> This can result in a concurrent use-after-free if the string is freed
> by the store function while being read by the show function.
>
> Fix this by holding the device_lock around the read operation.
>
> Fixes: 1f86a00c1159 ("bus/fsl-mc: add support for 'driver_override' in th=
e mc-bus")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Link: https://lore.kernel.org/r/20251202174438.12658-1-hanguidong02@gmail=
.com
> Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/bus/fsl-mc/fsl-mc-bus.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-=
bus.c
> index 8f7448da9258d..49eaf5bddd5ad 100644
> --- a/drivers/bus/fsl-mc/fsl-mc-bus.c
> +++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
> @@ -194,8 +194,12 @@ static ssize_t driver_override_show(struct device *d=
ev,
>                                     struct device_attribute *attr, char *=
buf)
>  {
>         struct fsl_mc_device *mc_dev =3D to_fsl_mc_device(dev);
> +       ssize_t len;
>
> -       return sysfs_emit(buf, "%s\n", mc_dev->driver_override);
> +       device_lock(dev);
> +       len =3D sysfs_emit(buf, "%s\n", mc_dev->driver_override);
> +       device_unlock(dev);
> +       return len;
>  }
>  static DEVICE_ATTR_RW(driver_override);
>
> --
> 2.51.0
>
>
>
