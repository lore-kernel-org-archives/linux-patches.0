Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF47536C0B9
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765884; cv=pass; b=TaCVMuPeylDoGp0CtiB6JP9uLyGaYtQxDAURGkpBBadc2/dHUb/bRqV9FRz6SIaA/PozWmrojahEnwcaFkuJ9CQbEY4KmcxFvzcnPHkXnENmtsYAoLiY2vsVq1i43oKtUoM27yfERsP+TaZnyCQ+CpWYG0xw7b3MlQOB+yu1aCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765884; c=relaxed/simple;
	bh=xMcbKpknbNB3wXIMOBId0nSf8GMAY9SSAcNgv5qCF8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MiOooOxwJaZ/JTdtPiThwfabOCGxd4l/xlhCuFAY92gScRmpA32YpDODpGMjrJ8+3VbBMITy+eJM6MFPOBXvXV5HTD/zGH/szH8wZqqi354qoe9lrIAuS/ebJUULZQ+tGmlRmxlqynalZGVq484XvCHwiLt/VEOV0vVNN3vOBqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpQFOUlu; arc=pass smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpQFOUlu"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-5ffe7b6f751so3516157137.2
        for <patches@lists.linux.dev>; Tue, 17 Mar 2026 09:44:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773765882; cv=none;
        d=google.com; s=arc-20240605;
        b=NKR1/rfHZkBVd6pNs3Wxz8+zGXCERCkzrwbxX+D2LIvPeHHWQcfZay/HV7DHOVSr9/
         fTtk5A40+++YIg0yYRKld7MzOHg+vOaIEFLmVJJbsmlDZ7KskGqNJOjwyZbDfFqrEC9Y
         XHSsPrqFFSoNpfanjyI9lvnCAJ85RiPFs6w/Qlw47YvCASSk/9Cx8YCT9I1PIVryNHDd
         GA7hcOKX8qb2x51BqDx+QwUCUE2APt2uPGbcsC5VX3QIAsFTzj0NfVD6CTsoXIyGM6jF
         6kGbjs9gddEOV+m3jgQ6w2NL+i2Ov1J9aCqZ/JjqD/92IPtcb+7j9tBBItR7D3dQ6/2a
         sQhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H/R+aloGVg+DrEMGpfDHhX37OuxXGn9gF9e/LxkmK1o=;
        fh=RXEUVaUNP8QIsCJ29ieLDW0GSZN1s3lcjXu4I+RRq+I=;
        b=WG+I6XGadduCGHTFZZF6D4be8qKihE7ZjO8FtXsvwOFRBrPMrGVOkCZWx5awRiotIx
         M66Ej1dSleUJXeUtwuc6UEu9rI8bQ/8RAEmJ+lxUQNvF/s15b+UHD2oU07nUY5/TYRUE
         tUrLxJqCm9kx1qlsra8UUsn2JCKoztO7o7O42Pv6lkUbUtRx6AyZj/fiseEWpiUPRDm5
         QZQ9BSmnYljjup1uLuQW3Nt0pN/w65J5RdWV6PdlNYzm1C2NKlsVICGNI3zAy16J12hh
         l7vgiAlzT/0q41O/NgIZd8KhZht7QXJsdppQTzbRPeEiiU67uNJ5Xv65nTNLOMkbQ4wC
         YxVQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773765882; x=1774370682; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/R+aloGVg+DrEMGpfDHhX37OuxXGn9gF9e/LxkmK1o=;
        b=mpQFOUluhw+xfDAM6bULvk2VSew//5iSftQChW+lIfOwcGBcmPoaNKlEkSpuvFTaxO
         JC9bKE5zsYxfeCgzzZ3ggl9m/FJPEbKluu71maqHKbOo9ycazBhkYb/rHYJMWhDWpb+a
         Li/LqNjB4iCAPhMDk7NxyHQKS48AXCBDgqVyZH1ERPHxT1zOBrsimNnUDP2dG0+3xdI7
         /pFB45Vsm3XNtwkNAsPaIThxAxSsxUUKBw98h3NDTemfOM8zYz3Fe1HixW4nUWIuKe7z
         /tbBqA7PnQuwrkZEv0+p68T0sdpOsgVu6BmlflzfG9VXLjI0LJE/2ASHwiwq8Rk67N4w
         iGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773765882; x=1774370682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H/R+aloGVg+DrEMGpfDHhX37OuxXGn9gF9e/LxkmK1o=;
        b=bxInc99NKOT86xAi6qauwvUflhY9kE9tOV6vtzM3Qjt8mpWUDbI5Jb7WSxQI6hkg51
         1+Fvg81FDCtvpMFt3AAFnTqcUsBALEGczw+HH+XWw4r045YUp1dPRGkcKoTycfNOScky
         0DuFR3ytBCRkTD9s5spoUbipbuQC+bzEU0OVJhiRKG1bpNq8tFoO5a3ZsProvjnueT98
         E4R+VkbRkAwz6/ktOE0C8RV76j1WkmjxthX8qDtEH7lrPg514MzL/09XuNpredgdh/Un
         kp0mz6eoe01bRfInAHxN5hwp3xo8qJw9XsIItR1o3JSUYFuocDaUza2R1ye29tga23yJ
         R6mg==
X-Forwarded-Encrypted: i=1; AJvYcCW6a7RI+Ay2qkWMnd5GaVKW4VzYKL5FHRAxP2ishHzNr20+BM+2JkRKdv5hTFVJdpGByszse4LT@lists.linux.dev
X-Gm-Message-State: AOJu0YzDFXXyqao7615/qYFIolv37ShreCPyomzox1KbvNDDxsZddNCu
	eopU03SEPKRiWXoIrikTfnxN9Qa6upMu8EK+LCHPUHT7/IGXNyVFop8RS5MOKb/Lsbx42ikskRJ
	MOpnaxYwWdjXZsYA9dLzIm/4OtQHTIm4=
X-Gm-Gg: ATEYQzw1Vkx6FbAN5ulRnEtwKDWJtO6a6iMIeXC4lFh1KXWKVFFG3NenLC4pEzabPhu
	EIG65o8jcUBZxn3i2q2d4ICl96k0Sf5d0rW0ZOYZCcIutNvwtpNXpTdFdOWARODxD4+PsV3WPjT
	7Pz0qFgQMUl3AuUiPZxO0/TvLZpiQToP/BoAIWBDA7hNC1fH04OKpSgjlvwTO7J6asCa2sma8Og
	pfmRrDDcwcOs/KGgT4nFchcEwPCZh+3uNSbZmOD+euBm1ytNOIvHmUSV3Pts/CyzKmiKqgbBjsg
	KTB9+kYF
X-Received: by 2002:a05:6102:38d1:b0:5ff:d192:ff22 with SMTP id
 ada2fe7eead31-6027d2c1358mr229683137.19.1773765881800; Tue, 17 Mar 2026
 09:44:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260317163006.959177102@linuxfoundation.org> <20260317163008.013706115@linuxfoundation.org>
In-Reply-To: <20260317163008.013706115@linuxfoundation.org>
From: Pengyu Luo <mitltlatltl@gmail.com>
Date: Wed, 18 Mar 2026 00:44:16 +0800
X-Gm-Features: AaiRm524OytN7slxZeciId_g8UhvL034v3qBbAQcxH7-KpElWSyfYcpzgxFm_6I
Message-ID: <CAH2e8h7pAR5M=P=5Lb2ZgfWd=J9fj3yJanVrqmOTgXRmO4Roag@mail.gmail.com>
Subject: Re: [PATCH 6.19 028/378] drm/msm/dsi: fix hdisplay calculation when
 programming dsi registers
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2026 at 12:40=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.19-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Pengyu Luo <mitltlatltl@gmail.com>
>
> [ Upstream commit ac47870fd795549f03d57e0879fc730c79119f4b ]
>
> Recently, the hdisplay calculation is working for 3:1 compressed ratio
> only. If we have a video panel with DSC BPP =3D 8, and BPC =3D 10, we sti=
ll
> use the default bits_per_pclk =3D 24, then we get the wrong hdisplay. We
> can draw the conclusion by cross-comparing the calculation with the
> calculation in dsi_adjust_pclk_for_compression().
>
> Since CMD mode does not use this, we can remove
> !(msm_host->mode_flags & MIPI_DSI_MODE_VIDEO) safely.
>
> Fixes: efcbd6f9cdeb ("drm/msm/dsi: Enable widebus for DSI")
> Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Patchwork: https://patchwork.freedesktop.org/patch/704822/
> Link: https://lore.kernel.org/r/20260214105145.105308-1-mitltlatltl@gmail=
.com
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Hi, Greg. You just told me you dropped it. Please drop this patch for
all stable trees.

Best wishes,
Pengyu

>  drivers/gpu/drm/msm/dsi/dsi_host.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi=
/dsi_host.c
> index e0de545d40775..e8e83ee61eb09 100644
> --- a/drivers/gpu/drm/msm/dsi/dsi_host.c
> +++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
> @@ -993,7 +993,7 @@ static void dsi_timing_setup(struct msm_dsi_host *msm=
_host, bool is_bonded_dsi)
>
>         if (msm_host->dsc) {
>                 struct drm_dsc_config *dsc =3D msm_host->dsc;
> -               u32 bytes_per_pclk;
> +               u32 bits_per_pclk;
>
>                 /* update dsc params with timing params */
>                 if (!dsc || !mode->hdisplay || !mode->vdisplay) {
> @@ -1015,7 +1015,9 @@ static void dsi_timing_setup(struct msm_dsi_host *m=
sm_host, bool is_bonded_dsi)
>
>                 /*
>                  * DPU sends 3 bytes per pclk cycle to DSI. If widebus is
> -                * enabled, bus width is extended to 6 bytes.
> +                * enabled, MDP always sends out 48-bit compressed data p=
er
> +                * pclk and on average, DSI consumes an amount of compres=
sed
> +                * data equivalent to the uncompressed pixel depth per pc=
lk.
>                  *
>                  * Calculate the number of pclks needed to transmit one l=
ine of
>                  * the compressed data.
> @@ -1027,12 +1029,12 @@ static void dsi_timing_setup(struct msm_dsi_host =
*msm_host, bool is_bonded_dsi)
>                  * unused anyway.
>                  */
>                 h_total -=3D hdisplay;
> -               if (wide_bus_enabled && !(msm_host->mode_flags & MIPI_DSI=
_MODE_VIDEO))
> -                       bytes_per_pclk =3D 6;
> +               if (wide_bus_enabled)
> +                       bits_per_pclk =3D mipi_dsi_pixel_format_to_bpp(ms=
m_host->format);
>                 else
> -                       bytes_per_pclk =3D 3;
> +                       bits_per_pclk =3D 24;
>
> -               hdisplay =3D DIV_ROUND_UP(msm_dsc_get_bytes_per_line(msm_=
host->dsc), bytes_per_pclk);
> +               hdisplay =3D DIV_ROUND_UP(msm_dsc_get_bytes_per_line(msm_=
host->dsc) * 8, bits_per_pclk);
>
>                 h_total +=3D hdisplay;
>                 ha_end =3D ha_start + hdisplay;
> --
> 2.51.0
>
>
>
