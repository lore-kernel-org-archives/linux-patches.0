Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CC210E9
	for <patches@lists.linux.dev>; Tue, 19 Jul 2022 10:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703F2C341CA
	for <patches@lists.linux.dev>; Tue, 19 Jul 2022 10:22:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UUZ50RqS"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 19 Jul 2022 11:22:51 +0100
Resent-Message-ID: <YtaF+zgQUUGpNaVD@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 19 Jul 2022 02:09:58 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=sjY/=XY=gmail.com=zheyuma97@kernel.org>)
	id 1oDbkK-005LGN-Al
	for broonie@sirena.co.uk; Tue, 19 Jul 2022 02:09:58 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id ADEB2616FF
	for <broonie@sirena.co.uk>; Tue, 19 Jul 2022 01:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 09ABFC341CA; Tue, 19 Jul 2022 01:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52B5BC341C0
	for <broonie@kernel.org>; Tue, 19 Jul 2022 01:09:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 52B5BC341C0
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id b10so2402149pjq.5
        for <broonie@kernel.org>; Mon, 18 Jul 2022 18:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3m2jsoZVnCeuFKH83suFaNs1dcI5It+Kf55ap/8RDKU=;
        b=UUZ50RqStV4YXyPHAnYpKBCbXGrkJ6AKnGaXKX2i5Rhte585irqphv6scV1ycYS6yw
         HNk6smdMxkbcMvMJRmQfaS/VXu0TrMzDMr6Lkif5E50tfOCqILntjqKSEzcGLdB8qiWw
         9857mYpxbTM712kSoLi/OpE4lQa3eS+m+rDWavQOQmoU0gg0XAyG+DBfpQrda8fe9XxJ
         G5aW1Wqho19NNYapdHdbtKeS0Cxild/BbolG/MMV4lglN3IaMPPw2Lit7uKKExeVCp9J
         I1f3hUEYEEoEKaNzjh8XvtJAsWZGrk1FsHdGGZVN7/JcQ/txcIwKcxCypaaQYg8tHjg4
         Mmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3m2jsoZVnCeuFKH83suFaNs1dcI5It+Kf55ap/8RDKU=;
        b=7L7NVjRpo49LyLg4Z2RnAg4Qpg7kPajBIgyWMi1dsj61el57TWRY35OtmZ2h87BmsU
         49eInkbhIs/UGYqA7nFe7Wgm72NGucKd+/uuRrl1islKQ7QQ9TdeZYm1XSl7Kckys/Y/
         fJk5JqHbcOC3lv0GOfSl+9c+9KdgTpBDZNeIZSnjMkn5vvzcifj8OWPP8Ehn0TIympKa
         MIXJNHs5HvwpkEZRTHqJJnaqWVSvuc1i2LNJrOjigazzxdb4j/ZOC3YKDXh1IdnT3RaL
         S6EI1JPFjPrwo/aC5PFi1+C+tUdjkdHwgEkqxtEExfH0EnhpkeWB+i7W+LW0Tj+/5NVM
         BTtQ==
X-Gm-Message-State: AJIora+ZX8nwJulz3G6a1/XpudvFQbEJCVfIczCoeum+Tr9YvKRTg7+E
	uIjM3Trv1Rafh79Eeoox5fchndd1HtxD9T9y0jySBUc3erTH
X-Google-Smtp-Source: AGRyM1vVAM2QUvjDPhGUIuFDwjjw2Ev15IPOYZpxjK1pPjQUBds0zuzFP3747SSbPYKf8nk3SkWAa73jPrdInX1v3Ew=
X-Received: by 2002:a17:90a:4809:b0:1f0:59d7:7ee2 with SMTP id
 a9-20020a17090a480900b001f059d77ee2mr35083757pjh.240.1658192992607; Mon, 18
 Jul 2022 18:09:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220718140405.57233-1-broonie@kernel.org>
In-Reply-To: <20220718140405.57233-1-broonie@kernel.org>
From: Zheyu Ma <zheyuma97@gmail.com>
Date: Tue, 19 Jul 2022 09:09:41 +0800
Message-ID: <CAMhUBj=NdAio20DpFJDiWv1LKipC4_YXg0sqHXNWQ2Sm6a156A@mail.gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-deve@alsa-project.org, wtli@nuvoton.com
Content-Type: text/plain; charset="UTF-8"
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=sjY/=XY=gmail.com=zheyuma97@kernel.org
Subject: Re: [PATCH] ASoC: nau8821: Don't unconditionally free interrupt
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: aCFQOQmGVf9j

Hi,

On Mon, Jul 18, 2022 at 10:10 PM Mark Brown <broonie@kernel.org> wrote:
>
> The remove() operation unconditionally frees the interrupt for the device
> but we may not actually have an interrupt so there might be nothing to
> free. Since the interrupt is requested after all other resources we don't
> need the explicit free anyway, unwinding is guaranteed to be safe, so just
> delete the remove() function and let devm take care of things.
>
> Reported-by: Zheyu Ma <zheyuma97@gmail.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  sound/soc/codecs/nau8821.c | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
> index 2600be250a3c..3ce23c20eca9 100644
> --- a/sound/soc/codecs/nau8821.c
> +++ b/sound/soc/codecs/nau8821.c
> @@ -1699,15 +1699,6 @@ static int nau8821_i2c_probe(struct i2c_client *i2c)
>         return ret;
>  }
>
> -static int nau8821_i2c_remove(struct i2c_client *i2c_client)
> -{
> -       struct nau8821 *nau8821 = i2c_get_clientdata(i2c_client);
> -
> -       devm_free_irq(nau8821->dev, nau8821->irq, nau8821);
> -
> -       return 0;
> -}
> -
>  static const struct i2c_device_id nau8821_i2c_ids[] = {
>         { "nau8821", 0 },
>         { }
> @@ -1737,7 +1728,6 @@ static struct i2c_driver nau8821_driver = {
>                 .acpi_match_table = ACPI_PTR(nau8821_acpi_match),
>         },
>         .probe_new = nau8821_i2c_probe,
> -       .remove = nau8821_i2c_remove,
>         .id_table = nau8821_i2c_ids,
>  };
>  module_i2c_driver(nau8821_driver);
> --
> 2.30.2

Thanks for your patch, it works for me :)

Tested-by: Zheyu Ma <zheyuma97@gmail.com>

regards,
Zheyu Ma
