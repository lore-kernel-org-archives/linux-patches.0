Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3B720E3
	for <patches@lists.linux.dev>; Sun, 15 Oct 2023 10:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kQEj4jxv"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-5a7b3d33663so47605747b3.3
        for <patches@lists.linux.dev>; Sun, 15 Oct 2023 03:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697365947; x=1697970747; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gQNEowOiA65pTVrY36QDnfIDvU+PkRiMRLEgKxooNo=;
        b=kQEj4jxvcjh1IbOdZXTWDMrCsWVNZwk4OphfOyeBTQxGkGPGpqrxaKMkdXR9RnUNgd
         1oQXRL8zmwfmmeoIPkJ9Ni6umOywR6J+rtXdCweiTfUg1yEmHmaCmk5874Z3z+q/qNaw
         dxmugQSzyYDuMOyI0h1eyTeG178X5inXGros8IhEtljVl+hbqKh2OKMH86BDSzqe99pS
         oLUa/Pw4mZOV60Cd95dNiVIH4ptR56e1snGn1d2gBOoTCU0UiLqY6E/5HbEEQgrNggLk
         WSP+zd4n5yhvi6AXQ4YZUPtSa4EkUxk32eTM4dGBauMLvjZm8UCQh7/1ZMuT/wRB4FCp
         F9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697365947; x=1697970747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5gQNEowOiA65pTVrY36QDnfIDvU+PkRiMRLEgKxooNo=;
        b=rBoXbK5v3RpXMUfGi/8FP76XebG+7+g1DMVOqJaG+v1dfzqRS2JoFP3EwgDnMz7fQm
         EmqIMFikRmRyRU1nwlL1GFEbTDgzfp5F5ngzTGbTDLkpm3o+8cDNv0KbgFqf0DZCXXNf
         kViMU2oz+fvQlTxGExP5J2wPBJE6waIYS7ikro1R2E1v15pEAasxrOw9R7V0GGoFBuqw
         Q8Q8vb3XU20wS9wKOs1filgN4g6bZ/+2sEegVMI2bmrEA68SpHmp2vccpM5miPWsOLU1
         V8V1WGpuX4Lx8BwW0ZWDeZjD63EIrd6r32FEx3985qxozcclQFZOz3or+0oHxy1ObCT1
         NB1w==
X-Gm-Message-State: AOJu0YzWkV4uXk6A7bi0YCPu5R9Wnopbh1O1czX53zMmz3Xbg7Cv61cQ
	/KUMlKcbH/jthOZN29bh4b/LMmn2P2yUIxbJyqY=
X-Google-Smtp-Source: AGHT+IF+TgDOCsOoo05cN3P+tm6EmoIQc+ZjNPRd9L9fyFgFVozkSRxS5eWrm2Z/dHxzXEsGttaqPf9u4MIVNclH1PQ=
X-Received: by 2002:a05:690c:f0e:b0:5a8:1d0e:ca6 with SMTP id
 dc14-20020a05690c0f0e00b005a81d0e0ca6mr8599898ywb.32.1697365947253; Sun, 15
 Oct 2023 03:32:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231011073204.1069793-1-zyytlz.wz@163.com> <2023101214-trilogy-wildcard-29cb@gregkh>
In-Reply-To: <2023101214-trilogy-wildcard-29cb@gregkh>
From: Zheng Hacker <hackerzheng666@gmail.com>
Date: Sun, 15 Oct 2023 18:32:15 +0800
Message-ID: <CAJedcCyMCOT07=T=DKbYobXWGNXDZ9ccjmdCsdorm2fDoDGmng@mail.gmail.com>
Subject: Re: [RESEND PATCH v2] media: mtk-jpeg: Fix use after free bug due to
 uncanceled work
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Zheng Wang <zyytlz.wz@163.com>, stable@vger.kernel.org, sashal@kernel.org, 
	patches@lists.linux.dev, amergnat@baylibre.com, wenst@chromium.org, 
	angelogioacchino.delregno@collabora.com, hverkuil-cisco@xs4all.nl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2023=E5=B9=B410=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=BA=94 01:23=E5=86=99=E9=81=93=EF=BC=9A

>
> On Wed, Oct 11, 2023 at 03:32:04PM +0800, Zheng Wang wrote:
> > This is a security bug that has been reported to google.
> > It affected all platforms on chrome-os. Please apply this
> > patch to 4.14 4.19 5.4 5.10 and 5.15.
> >
> > [ Upstream commit c677d7ae83141d390d1253abebafa49c962afb52 ]
>
> Did you try to apply this?  The file:
>
> >  drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 1 +
>
> Is not in the kernels you asked for this patch to be applied to.

Sorry I did't check the file. After reviewing the code, I found the
Directory Structure has been changed.
I'll write another patch for them.

Best Regards,
Zheng Wang
>
> How did you test this?
>
> confused,
>
> greg k-h
