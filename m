Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2254F86277
	for <patches@lists.linux.dev>; Tue, 30 Dec 2025 15:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767109827; cv=none; b=GQEvfoVq2fGaWiP9yzzFNqzCr94zce3wgBKwLwYbxvmIbD194kxN0daAWPrJ4M1g3Nm1uyQxgDtZe4MZCm3YdU4kIPA8OPsl7oyqcQdO6H0AxahowSJ9/yCL7wTR+WEFKvHl1rublYSKgG1NxInB4pdxnpbbmgc81bdfWmUzdik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767109827; c=relaxed/simple;
	bh=buNYBa+G8qfLlUvBCR4ZFcvapW46f5DYot+jLhw9HoQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oNyriGz/8bJhDCzxY85HwS+btd4iBoa11fADm2dJbQLXgcxQNDoqsKhF96qxDZz1A884V9Ph8F52krz6hvCm2bAGy1bMXa86iM+yku1d+9XUEc4saF1ZPNu2cVfdXoDGtkHylqwBiUrx6iN0nYQNic9lJSWhuXtrnE03jgu55d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uud/8zHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uud/8zHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF16C19422
	for <patches@lists.linux.dev>; Tue, 30 Dec 2025 15:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767109826;
	bh=buNYBa+G8qfLlUvBCR4ZFcvapW46f5DYot+jLhw9HoQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uud/8zHKAy9vAmWpvkX9rbSTgMdpfHBrh6WLiprE9pI8hXsuIlJvKVSvybs77Fn8Y
	 sUNNKqabH1O3AAdbTpPpjTZKBZ6V0IebRTaOqL2zluNQBKVnI/KyICHqazM4+tq8Al
	 e7KrJX5C2v4quZN/1/fXqONBGLQD9e5pGrZWWuL4E2yUMn9tgr24TnxY0pGE54iQk3
	 FNmaJE5Xh1NVQAEmCs/Ertn7U8sVHeyHuLWOeql2YdFDe2u0OwNx/yZ5U0KPz8j379
	 t4oJxM3x8CAObxRNyV5UERTf1i+gfTxIHvgPsa8R+JAxSfQDAsS9oaFzAQxP4vVDon
	 lgi7CNLA0cyfA==
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7ade456b6abso8217355b3a.3
        for <patches@lists.linux.dev>; Tue, 30 Dec 2025 07:50:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUbpnGM2R6flACR1tKqerljef6D/ZZcpd9tt4SVdfixujD4uJQKkAWnj2C+oEY8xSkE3HFDpBAr@lists.linux.dev
X-Gm-Message-State: AOJu0YykjrGdOvQOrPJrpRaQoGw423PL8V6RrGOjm2yCHCbvW/XtV7UX
	lDkNSQza1LNlHrZ1OZXRCCHGzxQUxlNiaxvH0bj5wdYjfCrybYd9Fo2Rx7Wrh8Bd9oLumMNWqHD
	Z+9wNg903YLOJls4g+KAhrb8OPZeOuw==
X-Google-Smtp-Source: AGHT+IEZjuJ741PMreIHh9uiPP3hb59AwPjPkgs6EZmokmEJmwSPfCMKsbUmse1x0DIpIk+dUrk59qVP/n9gj5/yiuc=
X-Received: by 2002:a05:7022:b906:b0:11b:d4a8:d244 with SMTP id
 a92af1059eb24-121722ab1e3mr21838218c88.16.1767109826287; Tue, 30 Dec 2025
 07:50:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251125-drm-mediatek-hdmi-v2-wifpts-v1-1-a6c7582cf69a@kernel.org>
In-Reply-To: <20251125-drm-mediatek-hdmi-v2-wifpts-v1-1-a6c7582cf69a@kernel.org>
From: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Date: Tue, 30 Dec 2025 15:50:13 +0000
X-Gmail-Original-Message-ID: <CAAOTY_-hGe-yWK-iSXDefEPJN9bc8A_r=kNirBAyHgCPhqoAvw@mail.gmail.com>
X-Gm-Features: AQt7F2ole3Zhplk3q7hyGThFScP9pdJnuSD325W6WxvbLpbbWXRXwbGOdauOQ4Q
Message-ID: <CAAOTY_-hGe-yWK-iSXDefEPJN9bc8A_r=kNirBAyHgCPhqoAvw@mail.gmail.com>
Subject: Re: [PATCH] drm/mediatek: mtk_hdmi_v2: Fix return type of mtk_hdmi_v2_tmds_char_rate_valid()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, CK Hu <ck.hu@mediatek.com>, 
	dri-devel@lists.freedesktop.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Nathan:

Nathan Chancellor <nathan@kernel.org> =E6=96=BC 2025=E5=B9=B411=E6=9C=8825=
=E6=97=A5=E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=8810:14=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> When building with -Wincompatible-function-pointer-types-strict, a
> warning designed to catch kernel control flow integrity (kCFI) issues at
> build time, there is an instance in the new HDMI v2 drm/mediatek code:
>
>   drivers/gpu/drm/mediatek/mtk_hdmi_v2.c:1331:31: error: incompatible fun=
ction pointer types initializing 'enum drm_mode_status (*)(const struct drm=
_bridge *, const struct drm_display_mode *, unsigned long long)' with an ex=
pression of type 'int (const struct drm_bridge *, const struct drm_display_=
mode *, unsigned long long)' [-Werror,-Wincompatible-function-pointer-types=
-strict]
>    1331 |         .hdmi_tmds_char_rate_valid =3D mtk_hdmi_v2_hdmi_tmds_ch=
ar_rate_valid,
>         |                                      ^~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~
>
> While 'int' and 'enum drm_mode_status' are ABI compatible, hence no
> regular warning from -Wincompatible-function-pointer-types, the mismatch
> will trigger a kCFI violation when mtk_hdmi_v2_tmds_char_rate_valid() is
> called indirectly.
>
> Update the return type of mtk_hdmi_v2_tmds_char_rate_valid() to be 'enum
> drm_mode_status' to clear up the warning and kCFI violation.

Applied to mediatek-drm-fixes [1], thanks.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/chunkuang.hu/linux.git/=
log/?h=3Dmediatek-drm-fixes

Regards,
Chun-Kuang.

>
> Fixes: 8d0f79886273 ("drm/mediatek: Introduce HDMI/DDC v2 for MT8195/MT81=
88")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/gpu/drm/mediatek/mtk_hdmi_v2.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c b/drivers/gpu/drm/med=
iatek/mtk_hdmi_v2.c
> index c272e1e74b7d..454b8b93b834 100644
> --- a/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c
> +++ b/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c
> @@ -1120,9 +1120,10 @@ static void mtk_hdmi_v2_hpd_disable(struct drm_bri=
dge *bridge)
>         mtk_hdmi_v2_disable(hdmi);
>  }
>
> -static int mtk_hdmi_v2_hdmi_tmds_char_rate_valid(const struct drm_bridge=
 *bridge,
> -                                                const struct drm_display=
_mode *mode,
> -                                                unsigned long long tmds_=
rate)
> +static enum drm_mode_status
> +mtk_hdmi_v2_hdmi_tmds_char_rate_valid(const struct drm_bridge *bridge,
> +                                     const struct drm_display_mode *mode=
,
> +                                     unsigned long long tmds_rate)
>  {
>         if (mode->clock < MTK_HDMI_V2_CLOCK_MIN)
>                 return MODE_CLOCK_LOW;
>
> ---
> base-commit: a846505a193d7492ad3531e33cacfca31e4bcdd1
> change-id: 20251125-drm-mediatek-hdmi-v2-wifpts-d67b55175609
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
