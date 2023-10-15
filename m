Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39C12F53
	for <patches@lists.linux.dev>; Sun, 15 Oct 2023 14:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ejxOt9R3"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-27d18475ed4so2750390a91.0
        for <patches@lists.linux.dev>; Sun, 15 Oct 2023 07:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697381628; x=1697986428; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1QeST0PLMb2ZNLVkBlW8NWrl/t5BNJXpDpuJk9M9hV8=;
        b=ejxOt9R3rdJuyDBHXXPKM+hwF2vfMR/U2d+LbkFwS+myoV6Q6WP/ErrLol0Ia7Yd5O
         cNTVNGW04sXVyTbS1w3EaK01b/ZicvqGfypcxDr64GUIlbq6KPcc0z2/2njoWK6fLQnd
         /25viPSOgqppRFQ1Ep07XEyP3eHBqeHJ/ohbX3MiiGMEmSdgFV7Vzois8CQZzq2b1dYj
         Uh7LlCV6Tc6r2opQIzGKYC2nQzqEsDdEyWHqlJEJcPDhF0hKIfdId5AGpPc37PY2Cnp5
         536mAGZduXPs+3N/xXYrTUiPnO0UxGMqy4lvQzEehqRUHNL3sC7bw/OzC5kVk/Cq65jz
         0J4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697381628; x=1697986428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1QeST0PLMb2ZNLVkBlW8NWrl/t5BNJXpDpuJk9M9hV8=;
        b=n8zTr2HJEP6ikSeXZcRGfdrEXHlEow0kcAd6Pr6TM+EDgJ6i2tMDwTGvR59bO3Yp6u
         o4qhWico+oV/gJGv8rIR8+HtczvsEPtn+xpgh8sbJt6wDF+DuqPBvhyLjH3dZ2+/3yPv
         A9D20WYpo1aIbAg2gkNErDxgDQ3Jk++l5aW4wHqiQE0itMwTMvpTI+obCFHRiMcnTh5l
         v8Um2RZoiCvct9Boo3PNTeli9ZFlfspk/2sElNI2Qx1LYaCNrNuCVFOQ2+qQXT5BVd1Q
         CX3ccDuXAJy9fjtZrpym+OSDjd8dGvj/MReiuCMUqjzjsOXEgNGYgXo7Q4HfEwc5AQ/h
         oW9Q==
X-Gm-Message-State: AOJu0YxuV3JqzfBjB3+BMvSLQi1CjVOArfRkyC5u/nVLmiScKCwFQcIV
	bxjx9Qsx87fsCVgI1MNHnthGBweTu7bvzcCdQeI=
X-Google-Smtp-Source: AGHT+IEIOT0a5ybHGwxl+XgCIU2lssNErK/upJACr6wQD7mQA49G4NivoJig5DFqodsMF6FSrRiyq/sFEy1N/LlMrks=
X-Received: by 2002:a17:90a:3f16:b0:274:6839:6a8c with SMTP id
 l22-20020a17090a3f1600b0027468396a8cmr25891511pjc.6.1697381627589; Sun, 15
 Oct 2023 07:53:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231015144242.723743-1-zyytlz.wz@163.com>
In-Reply-To: <20231015144242.723743-1-zyytlz.wz@163.com>
From: Zheng Hacker <hackerzheng666@gmail.com>
Date: Sun, 15 Oct 2023 22:53:35 +0800
Message-ID: <CAJedcCxQbRrOm7gCx95GSxWBG3SOp0bS-ORHWR2n969e9wOViA@mail.gmail.com>
Subject: Re: [PATCH] media: mtk-jpeg: Fix use after free bug due to uncanceled work
To: Zheng Wang <zyytlz.wz@163.com>
Cc: stable@vger.kernel.org, sashal@kernel.org, gregkh@linuxfoundation.org, 
	patches@lists.linux.dev, amergnat@baylibre.com, wenst@chromium.org, 
	angelogioacchino.delregno@collabora.com, hverkuil-cisco@xs4all.nl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch has some mistakes in the typo. Please ignore it.

Zheng Wang <zyytlz.wz@163.com> =E4=BA=8E2023=E5=B9=B410=E6=9C=8815=E6=97=A5=
=E5=91=A8=E6=97=A5 22:44=E5=86=99=E9=81=93=EF=BC=9A
>
> This is a security bug that has been reported to google.
> It affected all platforms on chrome-os. Please apply this
> patch to 5.10.
>
> Due to the directory structure change, the file path to
> be be patched is different from that in upstream.
>
> [ Upstream commit c677d7ae83141d390d1253abebafa49c962afb52 ]
>
> In mtk_jpeg_probe, &jpeg->job_timeout_work is bound with
> mtk_jpeg_job_timeout_work. Then mtk_jpeg_dec_device_run
> and mtk_jpeg_enc_device_run may be called to start the
> work.
>
> If we remove the module which will call mtk_jpeg_remove
> to make cleanup, there may be a unfinished work. The
> possible sequence is as follows, which will cause a
> typical UAF bug.
>
> Fix it by canceling the work before cleanup in the mtk_jpeg_remove
>
> CPU0                  CPU1
>
>                     |mtk_jpeg_job_timeout_work
> mtk_jpeg_remove     |
>   v4l2_m2m_release  |
>     kfree(m2m_dev); |
>                     |
>                     | v4l2_m2m_get_curr_priv
>                     |   m2m_dev->curr_ctx //use
> Fixes: b2f0d2724ba4 ("[media] vcodec: mediatek: Add Mediatek JPEG Decoder=
 Driver")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
> Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
> Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collab=
ora.com>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/me=
dia/platform/mtk-jpeg/mtk_jpeg_core.c
> index ee802fc3bcdf..67c9ca4cfcd2 100644
> --- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> +++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> @@ -1189,6 +1189,7 @@ static int mtk_jpeg_remove(struct platform_device *=
pdev)
>  {
>         struct mtk_jpeg_dev *jpeg =3D platform_get_drvdata(pdev);
>
> +       ancel_delayed_work_sync(&jpeg->job_timeout_work);
>         pm_runtime_disable(&pdev->dev);
>         video_unregister_device(jpeg->dec_vdev);
>         video_device_release(jpeg->dec_vdev);
> --
> 2.25.1
>
