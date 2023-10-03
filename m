Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA33A362
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 00:32:00 +0000 (UTC)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-50573e85ee0so349805e87.3
        for <patches@lists.linux.dev>; Mon, 02 Oct 2023 17:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696293118; x=1696897918; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iO9eQroF7O4wqoRvgq0RaFH1dV9uh3sUuUFRmWyQ7SM=;
        b=TP7eF2Dr2GTKGvXYuXvkmDRRMXAzOZvuFsEkuAsZkZisLxlbeADB7Igs6mGa+iBhgk
         1m7b4wgMUMXQ9YIZQKpxeMnmf3HPlbUYrE+sSKmL3zv6TTeUBtRAAyTLbrt5At25i0aj
         gJKxiSekDvHWJ7KxkfyD2nnRi03KbAbtK/WR4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696293118; x=1696897918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iO9eQroF7O4wqoRvgq0RaFH1dV9uh3sUuUFRmWyQ7SM=;
        b=e6zA9347yIDeITNi6H8CH9RHsuFfbp7w6+gxaFm2u9S4/QBEQ7/LAOj7i9yok8L841
         oNYV1jnSjCf1z+KTshJZ7UPKxQmynrGlCwowo7GrOACa8Yh38BBLUChBD7F9m5b+8rb1
         aVXnc1+77aEzbffgFLVzmyoX7RC9u2lc/1XxU6TBJFBNk42tDwfhwrNzwlu8aZCTn6Tg
         //lYAcTqUtZQ/EOW58g+Thhv65VFlpqkbTopLldsQREtjRge3jsOs70w53qdLZKYIKdt
         vtAi7yj5YR1ZSAH0DY3LnIU4ClPYNwLJhP8HZqyHRighlCWDrEqXomV1K+Ch0QNvGSbB
         Xlsw==
X-Gm-Message-State: AOJu0Yx08FtKYby/KyrOs1QLryUmtrLaAKrriU/gWVrhLXDaNyUkMftx
	wklAUiXZ7aUY7ry8xSrE3ttK0xdKnm+6YYgLcCVFJI0M
X-Google-Smtp-Source: AGHT+IF/m2rmL5jynoyRpJgWWzC13ghmecm4zmbm3AiytJAZ1bTpayuNs3AY+awsYaJByVUm61vL1g==
X-Received: by 2002:a05:6512:ba0:b0:4fd:faa5:64ed with SMTP id b32-20020a0565120ba000b004fdfaa564edmr13942681lfv.11.1696293118372;
        Mon, 02 Oct 2023 17:31:58 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id i2-20020a196d02000000b0050567cdb8ffsm1975543lfc.269.2023.10.02.17.31.57
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 17:31:57 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-50348c54439so1260e87.1
        for <patches@lists.linux.dev>; Mon, 02 Oct 2023 17:31:57 -0700 (PDT)
X-Received: by 2002:a05:6512:3903:b0:504:7b50:ec9a with SMTP id
 a3-20020a056512390300b005047b50ec9amr25948lfu.1.1696293117450; Mon, 02 Oct
 2023 17:31:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231002235407.769399-1-swboyd@chromium.org>
In-Reply-To: <20231002235407.769399-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 2 Oct 2023 17:31:41 -0700
X-Gmail-Original-Message-ID: <CAD=FV=U2dza-rxV=YtcfJwUY-gZw5FrCyn0NahOxvXJW2J2-vg@mail.gmail.com>
Message-ID: <CAD=FV=U2dza-rxV=YtcfJwUY-gZw5FrCyn0NahOxvXJW2J2-vg@mail.gmail.com>
Subject: Re: [PATCH] drm/bridge: ti-sn65dsi86: Associate DSI device lifetime
 with auxiliary device
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Robert Foss <rfoss@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	dri-devel@lists.freedesktop.org, Maxime Ripard <maxime@cerno.tech>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 2, 2023 at 4:54=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> w=
rote:
>
> The kernel produces a warning splat and the DSI device fails to register
> in this driver if the i2c driver probes, populates child auxiliary
> devices, and then somewhere in ti_sn_bridge_probe() a function call
> returns -EPROBE_DEFER. When the auxiliary driver probe defers, the dsi
> device created by devm_mipi_dsi_device_register_full() is left
> registered because the devm managed device used to manage the lifetime
> of the DSI device is the parent i2c device, not the auxiliary device
> that is being probed.
>
> Associate the DSI device created and managed by this driver to the
> lifetime of the auxiliary device, not the i2c device, so that the DSI
> device is removed when the auxiliary driver unbinds. Similarly change
> the device pointer used for dev_err_probe() so the deferred probe errors
> are associated with the auxiliary device instead of the parent i2c
> device so we can narrow down future problems faster.
>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Maxime Ripard <maxime@cerno.tech>
> Fixes: c3b75d4734cb ("drm/bridge: sn65dsi86: Register and attach our DSI =
device at probe")

Even before that commit I think it was using the main "dev" instead of
the auxiliary device's "dev" for some "devm" stuff. I guess the
difference is that it wouldn't mess with probe deferral? Searching
back, I think the first instance of a case that was using "devm_" with
the wrong device was commit 4e5763f03e10 ("drm/bridge: ti-sn65dsi86:
Wrap panel with panel-bridge")? Would it make sense to use that as a
Fixes, you think?

In any case, this looks reasonable to me:

Reviewed-by: Douglas Anderson <dianders@chromium.org>

I'll give it a week and then apply to "-fixes" if everything is quiet.
