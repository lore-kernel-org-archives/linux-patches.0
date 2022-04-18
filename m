Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3533D63
	for <patches@lists.linux.dev>; Mon, 18 Apr 2022 23:16:13 +0000 (UTC)
Received: by mail-ot1-f54.google.com with SMTP id v12-20020a9d7d0c000000b006054b51c3d4so3057382otn.8
        for <patches@lists.linux.dev>; Mon, 18 Apr 2022 16:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=vGtdbsSp8b8nLU4Y/i6FQSyOLmQMuRTm5ZwD7/D+i1s=;
        b=jgK3NDmxYiGiXrvwIF9JP5KaHQCBLDysQYQyI0VDu1zPG41/TDrZf2azvwl3r8ZnO4
         nc3RuE5w4R5yBC/EOgvpHOYUE9bq3dqqPe57CspsGXhuZJ0t6oDC6JjostCdHR9+VRV8
         3+Nb0wffjdbfQHiWkCAGCdg9g3UXEXwNt7f5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=vGtdbsSp8b8nLU4Y/i6FQSyOLmQMuRTm5ZwD7/D+i1s=;
        b=W28z68Z4aed9lkaUz1ZTgnEFzzpdkghmmYlGI0isvnL33qedbTwC29IPwLOD8BK/Hu
         /lDGE+W/SwdQkq0XoMtrLlVo/eNxFtlujE/gU3sTwkW7Fq7r/6szECXa/FFxu0R6GUUM
         GWB7kpCxJdi+kUcfnmHjznx9+Q5cu/ynAdwkEBUTsi8TiwI4hw2xOGh2bx8t16w6FfVE
         mu82B8dvmclfXcLONU7/oc+DFgQsUDOWiw5jngZNW3R7w/Cev17rR7lOG5lZAcJOxmNb
         ChoIOI8bsFAo0ym7HqdJWsCnmQ26VLq76EUD4CGgtGYhh697Y2c1DNgqpheIqSVu8nmM
         fUwA==
X-Gm-Message-State: AOAM530ENEQ+9Q4epntxxkeP2StknsuGozWLBftX5DSeK6Oe0wvCG0oL
	VyP6346e9kUR2auUlLlKrCLqDbO83v+JdsMOGOXeOw==
X-Google-Smtp-Source: ABdhPJxsGMjYSfJVeUmnawX6RQY6qfIzj5inCYphSGrgNmplvoLLSpR/QIIy2rU3B3oFFZTNwxXUyug6TCFm36/81tU=
X-Received: by 2002:a9d:20a1:0:b0:5e8:d2b6:f63f with SMTP id
 x30-20020a9d20a1000000b005e8d2b6f63fmr4747770ota.159.1650323772740; Mon, 18
 Apr 2022 16:16:12 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 18 Apr 2022 16:16:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Yl3vd4kfgwJXMs/w@chromium.org>
References: <20220415003253.1973106-1-swboyd@chromium.org> <20220415003253.1973106-2-swboyd@chromium.org>
 <Yl3vd4kfgwJXMs/w@chromium.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Mon, 18 Apr 2022 16:16:12 -0700
Message-ID: <CAE-0n53N1k_b9vWJ84nBdm9sxpYV3o4-FLJQM1HGqEhQsdr19A@mail.gmail.com>
Subject: Re: [PATCH 1/3] platform/chrome: cros_ec_proto: Add peripheral
 charger count API
To: Prashant Malani <pmalani@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Lee Jones <lee.jones@linaro.org>, 
	Daisuke Nojiri <dnojiri@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	chrome-platform@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Quoting Prashant Malani (2022-04-18 16:08:39)
> On Apr 14 17:32, Stephen Boyd wrote:
> > diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
> > index c4caf2e2de82..42269703ca6c 100644
> > --- a/drivers/platform/chrome/cros_ec_proto.c
> > +++ b/drivers/platform/chrome/cros_ec_proto.c
> > @@ -832,6 +832,37 @@ bool cros_ec_check_features(struct cros_ec_dev *ec, int feature)
> >  }
> >  EXPORT_SYMBOL_GPL(cros_ec_check_features);
> >
> > +/**
> > + * cros_ec_pchg_port_count() - Return the number of peripheral charger ports.
> > + * @ec: EC device.
> > + *
> > + * Return: Number of peripheral charger ports, or 0 in case of error.
> > + */
> > +unsigned int cros_ec_pchg_port_count(struct cros_ec_dev *ec)
> > +{
> > +     struct cros_ec_command *msg;
> > +     const struct ec_response_pchg_count *rsp;
> > +     struct cros_ec_device *ec_dev = ec->ec_dev;
> > +     int ret, count = 0;
> > +
> > +     msg = kzalloc(sizeof(*msg) + sizeof(*rsp), GFP_KERNEL);
> > +     if (!msg)
> > +             return 0;
> > +
> > +     msg->command = EC_CMD_PCHG_COUNT + ec->cmd_offset;
> > +     msg->insize = sizeof(*rsp);
> > +
> > +     ret = cros_ec_cmd_xfer_status(ec_dev, msg);
> > +     if (ret >= 0) {
> > +             rsp = (const struct ec_response_pchg_count *)msg->data;
> > +             count = rsp->port_count;
> > +     }
> > +     kfree(msg);
>
> Can we use the wrapper function cros_ec_command() [1] here, which does
> the kzalloc and msg construction?
>

Sure. I take it that I can drop this function entirely then? BTW, why is
that function name the same as a struct name? It confuses my ctags.
