Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653E720E02E
	for <patches@lists.linux.dev>; Fri, 10 Jan 2025 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736516488; cv=none; b=mOwLnprzEya8nseHEWyFnnv22/tYdKZ1V0jr8vm519BCuBxGtKHgtwDlxbQLNUWDuK0uBAYJ70n3tjpwV+MN7R7cmDNQDZY3WE4WJ8S5WqcacPTI8qAZkKrqoKQjfrfjKIhLimlFXML68wL/zGLtDc95GUXKRQpbm4aFOXQQP+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736516488; c=relaxed/simple;
	bh=rLsiBDuRzSI91oH3ewkZdOirHVSzZJV5sTLfQ1MLkhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QIuEs3MhLnTVPw3P1qpCwvdlSmcKyMNzl/xzeyMWiCwYyHBm3V9fb5lg3VIGsqN0RJ6wuv3ZbOK/rdnYt93m1cWp6MUPIeBAfTtK8hwmJuP/w1XTZS7a7G+uH9c4YOVqrXHajQDq6jyNcJKftcP2ky45GXk+dgk5fgvThYMXih4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=MgY5kLlG; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MgY5kLlG"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-303548a933aso15521431fa.3
        for <patches@lists.linux.dev>; Fri, 10 Jan 2025 05:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736516484; x=1737121284; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21nrw+DQl8aAfRbmhSjgM5wqQRD/uXyhfMT9bpCfuRk=;
        b=MgY5kLlGUNpBEcCKZhLgzANYGm2koGtLb26nRv3VkPf9P1Uglk8Ct13ZK/MUevTv1G
         1qnIKFpR7Qpj6wT/xuxi7Q5u2peJEkiMy2PqhfGSTsNBO00m8jl6nbXhv6eNjUJ3USHv
         dAWllfZBM9iDe/WE+7Oj63yx56AlLYNWj2+do=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736516484; x=1737121284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21nrw+DQl8aAfRbmhSjgM5wqQRD/uXyhfMT9bpCfuRk=;
        b=YcHKjXVuCRa9ymL0/KES7nBE6r9hgjnfZ7VjvQvy+YOG4yEC2tHWPv7Vh2ASD/wgdb
         hfZJRvf1brzO5zScoGLwmCXwGpEudGxsUrJ59BrWSnyWtKd7BiDmvWO24M6V1mRIkjZS
         3PZwNWNvS3iRsLxz+2ubxWDPzRzacYwSaf/AChytNE5R0FG5Gjaq62LcAObu4xt4F6x6
         t8KezNvpGJJ8lc68Hioci08y0V31z4NkG5waXyIdSj8d1VuWL38vjm5Rx7AMip649DNF
         9BjHpFmDhf4+7QAjtER09hSp+K0hYl0G0nS63pGoVnr04i5nuUqLQ0hazkqPJaP/sc5X
         LnrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOUSRrOOTjAq8huZFmJOAQOn/1BZsDGJcIGfMLFFckj6ar+w2p6DoRrjicxs8tyJ+P3dMcSq0u@lists.linux.dev
X-Gm-Message-State: AOJu0YxL7mHKP7ASIjoniASkOIAiQHKd2sNBk/uQNd+OwBBlf+Ystnsm
	EC2BGKVIu7Ri9QHStV2Fj3jipQMxQ3JOOOMWHUqLbkruMjuT8kTk7PA2jD3KY6apC+YmtBP6iAO
	bOez9JGscCGaRqWnGOuRMPl97tAToD6EDhOU=
X-Gm-Gg: ASbGncuzq+greUUdSZvAY8tK2qSDlcLqklJ19/+fMkCHP8jZblTIxJUHwkfHXYfNMY+
	sJOreC3hR7YAoJ39RBEp/SGuU1quI83c1m3GZa1ODkBUzFT49fWCEWnDhEMuNR+Bxsg==
X-Google-Smtp-Source: AGHT+IExmAvDVNgiPCh8+Gdl+mF1fMk2hcafEPAx+QDPMF5Z/s/Q2OBiZQ5NjdYC7wlrpxHXAnLaq0Oc+LOavuCTY1s=
X-Received: by 2002:a2e:be10:0:b0:302:52a8:243 with SMTP id
 38308e7fff4ca-305f45db514mr37175651fa.30.1736516484579; Fri, 10 Jan 2025
 05:41:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250109220655.1677506-1-swboyd@chromium.org> <20250109220655.1677506-2-swboyd@chromium.org>
In-Reply-To: <20250109220655.1677506-2-swboyd@chromium.org>
From: =?UTF-8?Q?=C5=81ukasz_Bartosik?= <ukaszb@chromium.org>
Date: Fri, 10 Jan 2025 14:41:13 +0100
X-Gm-Features: AbW1kvZJL9DPsrHuI32MQGP34PpUUJQSdf9ZEERbLFrN_fDbCSlIpTkraROCRvg
Message-ID: <CALwA+NbpD1cJMna6qLzkGsVvHuvTsGoFDrx=BPdzPXfQEO8jpA@mail.gmail.com>
Subject: Re: [PATCH 1/2] usb: typec: cros-ec-ucsi: Add newlines to printk messages
To: Stephen Boyd <swboyd@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Benson Leung <bleung@chromium.org>, 
	chrome-platform@lists.linux.dev, linux-usb@vger.kernel.org, 
	Pavan Holla <pholla@chromium.org>, Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 11:06=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> These printks need newlines. Add them and convert to dev_err_probe() in
> cros_ucsi_probe() to simplify code.
>
> Cc: Pavan Holla <pholla@chromium.org>
> Cc: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Cc: =C5=81ukasz Bartosik <ukaszb@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: =C5=81ukasz Bartosik <ukaszb@chromium.org>

> ---
>  drivers/usb/typec/ucsi/cros_ec_ucsi.c | 28 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/usb/typec/ucsi/cros_ec_ucsi.c b/drivers/usb/typec/uc=
si/cros_ec_ucsi.c
> index db8324b71ee9..75646a8d55be 100644
> --- a/drivers/usb/typec/ucsi/cros_ec_ucsi.c
> +++ b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
> @@ -58,14 +58,14 @@ static int cros_ucsi_read(struct ucsi *ucsi, unsigned=
 int offset, void *val,
>         int ret;
>
>         if (val_len > MAX_EC_DATA_SIZE) {
> -               dev_err(udata->dev, "Can't read %zu bytes. Too big.", val=
_len);
> +               dev_err(udata->dev, "Can't read %zu bytes. Too big.\n", v=
al_len);
>                 return -EINVAL;
>         }
>
>         ret =3D cros_ec_cmd(udata->ec, 0, EC_CMD_UCSI_PPM_GET,
>                           &req, sizeof(req), val, val_len);
>         if (ret < 0) {
> -               dev_warn(udata->dev, "Failed to send EC message UCSI_PPM_=
GET: error=3D%d", ret);
> +               dev_warn(udata->dev, "Failed to send EC message UCSI_PPM_=
GET: error=3D%d\n", ret);
>                 return ret;
>         }
>         return 0;
> @@ -99,7 +99,7 @@ static int cros_ucsi_async_control(struct ucsi *ucsi, u=
64 cmd)
>         ret =3D cros_ec_cmd(udata->ec, 0, EC_CMD_UCSI_PPM_SET,
>                           req, sizeof(ec_buf), NULL, 0);
>         if (ret < 0) {
> -               dev_warn(udata->dev, "Failed to send EC message UCSI_PPM_=
SET: error=3D%d", ret);
> +               dev_warn(udata->dev, "Failed to send EC message UCSI_PPM_=
SET: error=3D%d\n", ret);
>                 return ret;
>         }
>         return 0;
> @@ -161,7 +161,7 @@ static void cros_ucsi_write_timeout(struct work_struc=
t *work)
>
>         if (cros_ucsi_read(udata->ucsi, UCSI_CCI, &cci, sizeof(cci))) {
>                 dev_err(udata->dev,
> -                       "Reading CCI failed; no write timeout recovery po=
ssible.");
> +                       "Reading CCI failed; no write timeout recovery po=
ssible.\n");
>                 return;
>         }
>
> @@ -173,7 +173,7 @@ static void cros_ucsi_write_timeout(struct work_struc=
t *work)
>                                               msecs_to_jiffies(WRITE_TMO_=
MS));
>                 else
>                         dev_err(udata->dev,
> -                               "PPM unresponsive - too many write timeou=
ts.");
> +                               "PPM unresponsive - too many write timeou=
ts.\n");
>
>                 return;
>         }
> @@ -208,7 +208,7 @@ static int cros_ucsi_event(struct notifier_block *nb,
>         if (!(host_event & PD_EVENT_PPM))
>                 return NOTIFY_OK;
>
> -       dev_dbg(udata->dev, "UCSI notification received");
> +       dev_dbg(udata->dev, "UCSI notification received\n");
>         flush_work(&udata->work);
>         schedule_work(&udata->work);
>
> @@ -237,10 +237,8 @@ static int cros_ucsi_probe(struct platform_device *p=
dev)
>         udata->dev =3D dev;
>
>         udata->ec =3D ec_data->ec_dev;
> -       if (!udata->ec) {
> -               dev_err(dev, "couldn't find parent EC device");
> -               return -ENODEV;
> -       }
> +       if (!udata->ec)
> +               return dev_err_probe(dev, -ENODEV, "couldn't find parent =
EC device\n");
>
>         platform_set_drvdata(pdev, udata);
>
> @@ -249,24 +247,22 @@ static int cros_ucsi_probe(struct platform_device *=
pdev)
>         init_completion(&udata->complete);
>
>         udata->ucsi =3D ucsi_create(dev, &cros_ucsi_ops);
> -       if (IS_ERR(udata->ucsi)) {
> -               dev_err(dev, "failed to allocate UCSI instance");
> -               return PTR_ERR(udata->ucsi);
> -       }
> +       if (IS_ERR(udata->ucsi))
> +               return dev_err_probe(dev, PTR_ERR(udata->ucsi), "failed t=
o allocate UCSI instance\n");
>
>         ucsi_set_drvdata(udata->ucsi, udata);
>
>         udata->nb.notifier_call =3D cros_ucsi_event;
>         ret =3D cros_usbpd_register_notify(&udata->nb);
>         if (ret) {
> -               dev_err(dev, "failed to register notifier: error=3D%d", r=
et);
> +               dev_err_probe(dev, ret, "failed to register notifier\n");
>                 ucsi_destroy(udata->ucsi);
>                 return ret;
>         }
>
>         ret =3D ucsi_register(udata->ucsi);
>         if (ret) {
> -               dev_err(dev, "failed to register UCSI: error=3D%d", ret);
> +               dev_err_probe(dev, ret, "failed to register UCSI\n");
>                 cros_ucsi_destroy(udata);
>                 return ret;
>         }
> --
> https://chromeos.dev
>
