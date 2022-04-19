Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFF71364
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 14:55:04 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-e5bdd14b59so8244572fac.11
        for <patches@lists.linux.dev>; Tue, 19 Apr 2022 07:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=XfHepYw+eFDu4Y2GjQzYxqYQe3l3yCNETgfJfWtfEn8=;
        b=mixj2xeVA11NAQnkbsI+dJXBIaa6QQ5iSC6MLy+w2fOxHiEmQgDhlLwEJWHyD9l8J6
         /5E5PxLKpuoi1fB2GFy9Z9ilBSpoWgmZ4TMP6a08rkD++ADh9xVdoQcC8y1RGWp/rlPv
         hzPr+aTqT6BfqZog1Eth/LCpls7qr1CbZFc38=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=XfHepYw+eFDu4Y2GjQzYxqYQe3l3yCNETgfJfWtfEn8=;
        b=JzJSSCcV7G2kXQz6c+HS/CHb+R3E/R/+yDBU9t4P1MrDJJ56OC1bR3IfZwcPPO6cf0
         BP5OlUVv8Od72VL/f+SUjJ48rpATz+qk6FIaasKM8OyCIzPIZDcsamelzT/QrMchP+6Z
         VKhTmx9B1LJU6zhgn4k4ujOk4j1UdhhTB5aONMkUUO793LsOCyBeE9N78se3AjbltnNJ
         WVQZj5BTKtVsu+iJcvZtXJK0i3HPx2knXfUnw5AOBFn0bJC5Btlc0nFE0TiWuLLqHThH
         4p8z48XuxojAlKl+a4KlxCkK/acNZZLJwH1Lc0H/i8Ic6RJG47i6tSaDMGFcfpu76ZSt
         TwsA==
X-Gm-Message-State: AOAM530yEjcuM8QyxxbNBQrthL0xgQnSOtCM966pWpRyjhPT+u1XzozP
	fzW1eYYVaU4iZg5kOnK8St7boTiqigtjXgNxjO9zHw==
X-Google-Smtp-Source: ABdhPJzq4NiF1OxjHN/pxYl61Pc4EGrB6vaPpfW7dATfuy1l83k2YshuDNFMFnJZrwGySdplgTF1XUnOYvYGELVjq3I=
X-Received: by 2002:a05:6870:558e:b0:e1:db7c:26aa with SMTP id
 n14-20020a056870558e00b000e1db7c26aamr6827263oao.63.1650380103245; Tue, 19
 Apr 2022 07:55:03 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 19 Apr 2022 07:55:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Yl4Au/O/am/ZbX9J@chromium.org>
References: <20220419000408.3202635-1-swboyd@chromium.org> <Yl4Au/O/am/ZbX9J@chromium.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 19 Apr 2022 07:55:02 -0700
Message-ID: <CAE-0n507D9W5BFfG2vXqN1cqvnrQKLbLw7YejGb5_kH+7X62sw@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: cros_ec_dev: Only register PCHG device if present
To: Prashant Malani <pmalani@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Tzung-Bi Shih <tzungbi@kernel.org>, 
	Daisuke Nojiri <dnojiri@chromium.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, chrome-platform@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Quoting Prashant Malani (2022-04-18 17:22:19)
> On Apr 18 17:04, Stephen Boyd wrote:
> > +             retval = mfd_add_hotplug_devices(ec->dev,
> > +                                     cros_ec_pchg_cells,
> > +                                     ARRAY_SIZE(cros_ec_pchg_cells));
> > +             if (retval)
> > +                     dev_warn(ec->dev, "failed to add pchg: %d\n",
> > +                              retval);
> Tiny nit: Can this fit in 1 line (100 chars[1])?
>

I'm matching the style of other lines in this file (this is copy
pasta). I'll let the maintainer decide what to do.
