Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54223A41
	for <patches@lists.linux.dev>; Mon, 18 Apr 2022 19:43:09 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id r8so15861932oib.5
        for <patches@lists.linux.dev>; Mon, 18 Apr 2022 12:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=APMNQ0VOd3gUC3vflkGQPEv7QJLULTgT7Cf+XJq4PlU=;
        b=XIQ67C2JubBiGYT+sCav370KSdQQ0bmY05YMHN0a10iR1OWGIcXTCmayqgBXnTYPQk
         FOwWwAGoUuk33NgFGo8LjQyIIyR+8jFfppCZU5nDw3CvMdgPWzfJsRJKhc8GVY2CRfWa
         pvHjnN+sm1b8cNeSwNOmUffZLIiuAsbhlHf7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=APMNQ0VOd3gUC3vflkGQPEv7QJLULTgT7Cf+XJq4PlU=;
        b=d1v4nMmR7IAd83IZFL5Eu2e34Y5XVX67gQjiMXFlm8dBD1hFGmZJGrXp2MWXyLdDD9
         Is/XTprPLu6mBei3ZOGuD+LO1VrG4Fks22xSgs7tCqpG6m7Qvp5U18J4LXekX8gBKSS8
         XN2pNMgbHmJy6iF+xa0ONz2wHLLKRT4gEtrFv7kO9qmlSwVV7QHAoKarr3L1OyewpCt9
         90VNVbTqwpI2lEeK/967gjNGJIGPf1dJPXzSUX2JEzhtPxL6j0Bq9LFYJNwYloX1pee8
         +k1A+0h43B34Bf5JGr5otwL6MElJnjfOSwm/cbXqWrzej+0q/EWUFgXwvMnSv4wUrXiE
         doGg==
X-Gm-Message-State: AOAM531zchv3J4U+Pb/galToBozdeY4EzAl8zgdr8i5yQe1T6NHr/C5A
	TiEzPB2zbK1RZJ+WzLLeC8dRBK+UPycehLeEJFLlmA==
X-Google-Smtp-Source: ABdhPJxz8/mVSXcDfE357Co4lqCJlK4Bq5DrL7FdoTy7mcDP2lYRYO9puha9GdELIR/9mRNaIG7PKesE2HH4+iorsaA=
X-Received: by 2002:aca:bd41:0:b0:2ec:ff42:814f with SMTP id
 n62-20020acabd41000000b002ecff42814fmr5836497oif.63.1650310988401; Mon, 18
 Apr 2022 12:43:08 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 18 Apr 2022 12:43:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <YlzZr/UElg690/ru@google.com>
References: <20220415003253.1973106-1-swboyd@chromium.org> <20220415003253.1973106-2-swboyd@chromium.org>
 <YlzZr/UElg690/ru@google.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 18 Apr 2022 12:43:07 -0700
Message-ID: <CAE-0n50Kp4PkMqvOR=eAXMYctEv1J_ziRtjKL_mDR_zrS0apzw@mail.gmail.com>
Subject: Re: [PATCH 1/3] platform/chrome: cros_ec_proto: Add peripheral
 charger count API
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Lee Jones <lee.jones@linaro.org>, 
	Daisuke Nojiri <dnojiri@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	chrome-platform@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Quoting Tzung-Bi Shih (2022-04-17 20:23:27)
> On Thu, Apr 14, 2022 at 05:32:51PM -0700, Stephen Boyd wrote:
> > Add a peripheral charger count API similar to the one implemented in the
> > ChromeOS PCHG driver so we can use it to decide whether or not to
> > register the PCHG device in the cros_ec MFD driver.
> >
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Cc: Daisuke Nojiri <dnojiri@chromium.org>
> > Cc: Benson Leung <bleung@chromium.org>
> > Cc: Guenter Roeck <groeck@chromium.org>
> > Cc: <chrome-platform@lists.linux.dev>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>
> With a minor comment about the naming,
> Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>

Cool thanks.

>
> > diff --git a/include/linux/platform_data/cros_ec_proto.h b/include/linux/platform_data/cros_ec_proto.h
> > index df3c78c92ca2..8f5781bc2d7a 100644
> > --- a/include/linux/platform_data/cros_ec_proto.h
> > +++ b/include/linux/platform_data/cros_ec_proto.h
> > @@ -230,6 +230,7 @@ u32 cros_ec_get_host_event(struct cros_ec_device *ec_dev);
> >  bool cros_ec_check_features(struct cros_ec_dev *ec, int feature);
> >
> >  int cros_ec_get_sensor_count(struct cros_ec_dev *ec);
> > +unsigned int cros_ec_pchg_port_count(struct cros_ec_dev *ec);
>
> I wonder if "cros_ec_get_pchg_port_count" would be a better name for the API.

Sure. I left out 'get' even though it's similar to
cros_ec_get_sensor_count() because it seemed redundant. We can't "set"
the port count. Anyway, I don't really care so I'll leave it up to cros
maintainers.
