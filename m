Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32F01364
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 14:58:57 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id t67so31529658ybi.2
        for <patches@lists.linux.dev>; Tue, 19 Apr 2022 07:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XG8kQ+XIcj/kxQkqKlX6Of1DGaCLk+DsEI9aRIpWeLs=;
        b=Oy9TvaCS/0qIZZ8t1TL2LJxxehNvhY1VAoqRcmRrlCdVK69gizdMFSGDeZiX0xLCOf
         2KcC7dEOo6dIqoY7Z3aCU/K+5ky2qwleELsn/kkkKEgDhWUXVGKy6Nq3RKuutKo2UkCM
         vP4RFdEK7kzA6azj/1KzhyiPNPwQ1YXsTxuq0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XG8kQ+XIcj/kxQkqKlX6Of1DGaCLk+DsEI9aRIpWeLs=;
        b=rhB3vht6viwz6BPMQc70xb8zWwFM1+QgdjGnd8yzwHEcm+SDqxIcdYtvlWNMAMGHjE
         fIxK49JoLEA0/R0BNy33y89moUR3PSTyLmv/fTlO9FshuyyNH+QSyNCX2vWcJwuOHOhD
         uIkAzEhiLOJnJ1KzfmYKrJfmh6Zgqtlu62tQYNkAu0QTJz2A9+joCy4F4jiii6F9NEYQ
         zwp1/2+c87lLbQEuIWtFhnxOJTHKFGzoJYHV/SLjV5nPbyP3ZWpHLH8Tkild31RZ9Mbm
         /nrxuVheyqqHngj+kBjXfk3P9Gp0IFgEE80b2ynw/1kuzwMvMUsG5zqOn1DfnwWwxUDS
         RSNg==
X-Gm-Message-State: AOAM531lcNfW77h2kBN6mvjc2AIFPLxMRumBgDMv/fpot/1tF0NdsNEk
	Sqz2uVZ/NnXWkUt1HNFbAe1r88cpQOg3EP/QCzekNg==
X-Google-Smtp-Source: ABdhPJyvxzwabX5yi+4hLlFDW7j672aGNtFoJ1IdyVEymCiqxg7DCHw1Bd0ZglILn50oMoTJO2soBbS5WmSx/OFgbVs=
X-Received: by 2002:a25:3258:0:b0:641:d47c:8321 with SMTP id
 y85-20020a253258000000b00641d47c8321mr15399843yby.294.1650380337072; Tue, 19
 Apr 2022 07:58:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220419000408.3202635-1-swboyd@chromium.org> <Yl4Au/O/am/ZbX9J@chromium.org>
 <CAE-0n507D9W5BFfG2vXqN1cqvnrQKLbLw7YejGb5_kH+7X62sw@mail.gmail.com>
In-Reply-To: <CAE-0n507D9W5BFfG2vXqN1cqvnrQKLbLw7YejGb5_kH+7X62sw@mail.gmail.com>
From: Prashant Malani <pmalani@chromium.org>
Date: Tue, 19 Apr 2022 07:58:46 -0700
Message-ID: <CACeCKac83uiwdAf2RWqc9DxEft2+BSBn5Kp5PMR23UGKJyk5KQ@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: cros_ec_dev: Only register PCHG device if present
To: Stephen Boyd <swboyd@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Tzung-Bi Shih <tzungbi@kernel.org>, 
	Daisuke Nojiri <dnojiri@chromium.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, chrome-platform@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 19, 2022 at 7:55 AM Stephen Boyd <swboyd@chromium.org> wrote:
>
> Quoting Prashant Malani (2022-04-18 17:22:19)
> > On Apr 18 17:04, Stephen Boyd wrote:
> > > +             retval = mfd_add_hotplug_devices(ec->dev,
> > > +                                     cros_ec_pchg_cells,
> > > +                                     ARRAY_SIZE(cros_ec_pchg_cells));
> > > +             if (retval)
> > > +                     dev_warn(ec->dev, "failed to add pchg: %d\n",
> > > +                              retval);
> > Tiny nit: Can this fit in 1 line (100 chars[1])?
> >
>
> I'm matching the style of other lines in this file (this is copy
> pasta). I'll let the maintainer decide what to do.

Quite a bit of that code predates the char limit update, but OK.
