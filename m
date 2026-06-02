Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9542637187F
	for <patches@lists.linux.dev>; Tue,  2 Jun 2026 07:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780385205; cv=none; b=PQzuE27y4Tg/RDJJzOjQT4TLqcrmNlHCUKiCLGZmwHooaN3FEPo2ziuIeHVXCd3iqGQ6lukozCSy2Z1qlI9yvj/DtRX2wBiEQowfH5Dap4HC7rSa0d/MQ6xDFYMCDq3/YdBcLNvs9x6XuBP4zBQlq/eREjUcvceLt0x1n75QuFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780385205; c=relaxed/simple;
	bh=lww/k4S/rDCe2g/lPxK8iJlS1INRNKuBuTnReTHVA3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FxBFLI/zoAiFcOB7ki/sRgwZHcyTGL9sH+AAIpz+79WEu65GOcdaHGJKghyAGeGKzfeu0mXqIGplChggiuXEkmS0NN4BESALB5+sb6jgge1CNkWSqvnrtUT0qFtiXSY6WyWDafjKzsd495K3nvMKRcH6C0XDeVT+DTb9MsPMFDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=MbrZQu0M; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MbrZQu0M"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bec3ffb95dbso317396466b.0
        for <patches@lists.linux.dev>; Tue, 02 Jun 2026 00:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1780385201; x=1780990001; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rIJcYzfKNWvO4LbSTb+KowDs+YJ5wjm9TkOAb/K4D3M=;
        b=MbrZQu0MPLoK0zaLv6t3CVUyc7PdXqbHGHuVc7ex/h+Y3YSP8NCRwUS1Am7XwhSybv
         078OWC7CP3lqvTvUIEq+84FLUS/vUni7o3/I3IrnCQsqYMISSi7SSutkEKo2VGJJLYbI
         9QIAe+HrQLB8Yjp0yzIOepWzVldZwnpbTCTc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780385201; x=1780990001;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rIJcYzfKNWvO4LbSTb+KowDs+YJ5wjm9TkOAb/K4D3M=;
        b=IJUZz+qtnPIwynMWixaFf1blGSVI/PIDmTMpb8DakI+roCz0D8uhv6IM3R86fbOzRP
         qdj9ewqvH+L2EiNgW0H4QGLPc/yPvlrPh3AuwATB3OeNgQo8xy631pZtXfRB5G+0ZHxW
         fWJKMB8APXAMEOJla9/i4eshXgzh8sOFpWvLiC4FBocNkEahDEOSf8A3Db2W9TEipXDd
         Wkmi/qG+w8InlRru4haXnu2S8qUQEKbd1bS033YShRH7IO6OJccUDIlD+XM5hesNkM6U
         sAuWHkMWudAL02kynBmmA0tm5OTInKgnOkxihkG7tL2f/KwIXUh385u1BmuwP3JTu0BO
         qCeQ==
X-Forwarded-Encrypted: i=1; AFNElJ85y0u9mKRxN4ti2u30tUGpGEjnREeNC7hyjpwcUy5113iFD9Qpz75u+DWBC7gv32bza8Dlb8tj@lists.linux.dev
X-Gm-Message-State: AOJu0Yxi6gtccqI+x01S2TDDapluKeyArbyWPJZJtzqYsjl//Q6QLUVh
	wA1S8wsZ5aiEJYuUt5RrfBRN9/SscSGc5yrsbJTYcPg59DYA1Ri03sqJssQXuVITduERJlDRWi9
	g0s/FTg==
X-Gm-Gg: Acq92OFOKWSgUKrDmFoTDpb9pDZFXsmy7cxTqS/JY/ThBoSe0EAghuCeueAQZiUlaZf
	l5Ml8aJrjIzqVKwAU5vDV7ggC8OE/ckxjq1rNdVIYwYfe+GdsG/Enydc4z/dixmeioBV3iqLwML
	jHEzjs9JRuPvIQxcmlfJtLe8K+wuKNgmNtokTWG6qHPivun3qp3KY4H5wgQQPoEKgvxu634fzmi
	YchKDrUQMOUTo6v8NIOFiKjIGw3U6o+A9YrpRLiodr8Z+MT1syPnbNeEtXEJf7hJ5QF4nihgFup
	KXR/yGY4uJMIK06ter9p4ohusJXSiL9trRzOd387MxN/lWb+/ifGU0lc3mBOq99js5nlSVetX8m
	R8fj9HJ8dC+kCfzB8IWYG7E1qjgAU0iP5cQhvgf3C6FCDYHsxu7cH1Nq9Osebj7Ti7FbDYrJ6yx
	ts25j+vpFFbmpLNV6wLrak/fVM5kOpmJkRDxiE961862nHi9voXGbu2UIjQanIkZi6wPZ6y9c=
X-Received: by 2002:a17:907:970a:b0:bec:5264:e52d with SMTP id a640c23a62f3a-bec52650b9fmr618123466b.11.1780385200915;
        Tue, 02 Jun 2026 00:26:40 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68ceb844b5esm3072926a12.17.2026.06.02.00.26.38
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 00:26:39 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bef47b1ac01so65247666b.2
        for <patches@lists.linux.dev>; Tue, 02 Jun 2026 00:26:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8QWdjCb/LfwHq6P4+ZwIRVThTwINfkafoDop86y6rLqT+7+JCLKifCn6dn+BE0aVuxUSsawk8c@lists.linux.dev
X-Received: by 2002:a17:907:e143:b0:beb:7b50:3a7e with SMTP id
 a640c23a62f3a-beb7b50621cmr392521666b.45.1780385197985; Tue, 02 Jun 2026
 00:26:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260530160224.570625122@linuxfoundation.org> <20260530160231.873363839@linuxfoundation.org>
 <8cd2c0613f018690cba5ae76c4ab73da05118312.camel@decadent.org.uk>
In-Reply-To: <8cd2c0613f018690cba5ae76c4ab73da05118312.camel@decadent.org.uk>
From: Ricardo Ribalda <ribalda@chromium.org>
Date: Tue, 2 Jun 2026 09:26:25 +0200
X-Gmail-Original-Message-ID: <CANiDSCs7PXPQw=rHrM58766YdagnDyDNh92DEhcfis8TYrW1+A@mail.gmail.com>
X-Gm-Features: AVHnY4JSIWy-WoxOBFubbS8uyyq247CjKAuWnxAQPGSXvXaXvW97nNTsZ779qxM
Message-ID: <CANiDSCs7PXPQw=rHrM58766YdagnDyDNh92DEhcfis8TYrW1+A@mail.gmail.com>
Subject: Re: [PATCH 5.10 263/589] media: uvcvideo: Enable VB2_DMABUF for
 metadata stream
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Hans de Goede <johannes.goede@oss.qualcomm.com>, Hans Verkuil <hverkuil+cisco@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Ben

On Mon, 1 Jun 2026 at 19:37, Ben Hutchings <ben@decadent.org.uk> wrote:
>
> On Sat, 2026-05-30 at 18:02 +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Ricardo Ribalda <ribalda@chromium.org>
> >
> > commit fbac03467e53d8d72e5099c03df26d9adae11416 upstream.
> >
> > The UVC driver has two video streams, one for the frames and another one
> > for the metadata. Both streams share most of the codebase, but only the
> > data stream declares support for DMABUF transfer mode.
> >
> > I have tried the DMABUF transfer mode with CONFIG_DMABUF_HEAPS_SYSTEM
> > and the frames looked correct.
> >
> > This patch announces the support for DMABUF for the metadata stream.
> > This is useful for apps/HALs that only want to support DMABUF.
>
> So this is a feature addition.
>
> And the uvcvideo driver has changed a lot since 5.10 (or even 6.1), so
> unless someone specifically tested that these older versions will also
> work with dmabuf I question whether this is worth the risk.

Just one note: The different transfer modes are implemented by vb2,
not by the driver, so changes in the driver should not affect this
specific change.

I have no specific use case for this change in 5.10. So I am fine if
it is not backported that far. But it should be very low risk (famous
last words)

>
> Ben.
>
> > Cc: stable@vger.kernel.org
> > Fixes: 088ead2552458 ("media: uvcvideo: Add a metadata device node")
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
> > Link: https://patch.msgid.link/20260309-uvc-metadata-dmabuf-v1-1-fc8b87bd29c5@chromium.org
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/media/usb/uvc/uvc_queue.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > --- a/drivers/media/usb/uvc/uvc_queue.c
> > +++ b/drivers/media/usb/uvc/uvc_queue.c
> > @@ -222,7 +222,7 @@ int uvc_queue_init(struct uvc_video_queu
> >       int ret;
> >
> >       queue->queue.type = type;
> > -     queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
> > +     queue->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> >       queue->queue.drv_priv = queue;
> >       queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
> >       queue->queue.mem_ops = &vb2_vmalloc_memops;
> > @@ -235,7 +235,6 @@ int uvc_queue_init(struct uvc_video_queu
> >               queue->queue.ops = &uvc_meta_queue_qops;
> >               break;
> >       default:
> > -             queue->queue.io_modes |= VB2_DMABUF;
> >               queue->queue.ops = &uvc_queue_qops;
> >               break;
> >       }
> >
> >
>
> --
> Ben Hutchings
> The obvious mathematical breakthrough [to break modern encryption]
> would be development of an easy way to factor large prime numbers.
>                                                            - Bill Gates



-- 
Ricardo Ribalda
