Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884239468
	for <patches@lists.linux.dev>; Wed, 13 Dec 2023 15:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WYDbvbO4"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a22f59c6ae6so135420166b.1
        for <patches@lists.linux.dev>; Wed, 13 Dec 2023 07:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1702480626; x=1703085426; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IFRmR5aw7jYs0R06huL/PXrkIxEyHWBggBrJG8pw4QE=;
        b=WYDbvbO4eLYmrcp9Zki/Pm5sRwk13fAL43kLwbErkdSfZ/Nw6Zpar6ydI1K7KEco6Q
         YcZj8of/fldvgQ/J95JClPNpVsf47kZJPKcYxW6Je8idjOSYVD4d307e1zxNX7eI6RXr
         cKlg8QeMwW8x4HYrT8Q71HDB+nKGhfmCXTZuI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702480626; x=1703085426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IFRmR5aw7jYs0R06huL/PXrkIxEyHWBggBrJG8pw4QE=;
        b=EKLfp0Is4Lw46STxy2iM7wg2iDf6AuRG8p0W1a2Tr5ipQlJZbkWPqBRA7Mn+jD9Q1v
         RwOrqgv85oE8/oKe/esIeZmq9DjIOEYFWV18a2DMgWBOUXy47FgC4P73j0Xb+pMu/jzf
         7UZwGsj6wL8Wvg9n1sFNIA4W+kAnIA0hJihPwqkFMBRruQty1hiEhY9gfHnrnQXd6ubr
         kCnAXiYo3Muy5BPAc8lj1DKLesmXqJL8PA0X73GA7FcwKlfFm5H91G2LGm3+OiwbDwQk
         bNk4oOoFEl+iBc6qoVWcGKq4eZ0aMmoJ+nROxZ9w4QM7yCtyzWTXEGJ4IqOLTZ6qrIId
         0LcQ==
X-Gm-Message-State: AOJu0YyqQnThIT7JRxWHYcYJMaLCt+5k9Z5IDZTJqdCkuESgULQ+hUL6
	v8j+ax5ycVVKip5o6IHRPxYaNWe4LpEdB3tV7y7RrA==
X-Google-Smtp-Source: AGHT+IEkxtzezJvVvi6yWSTRS8xCLtP8m4y2bxtILoPfPWhXhVdrD7p9pu5FM+akHzzIxSWWbky4+w==
X-Received: by 2002:a17:907:72d1:b0:a19:d40a:d214 with SMTP id du17-20020a17090772d100b00a19d40ad214mr2710780ejc.224.1702480625887;
        Wed, 13 Dec 2023 07:17:05 -0800 (PST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id tk7-20020a170907c28700b00a1d1ebc2206sm7933007ejc.72.2023.12.13.07.17.05
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 07:17:05 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40c3963f9fcso52855e9.1
        for <patches@lists.linux.dev>; Wed, 13 Dec 2023 07:17:05 -0800 (PST)
X-Received: by 2002:a05:600c:3648:b0:3f7:3e85:36a with SMTP id
 y8-20020a05600c364800b003f73e85036amr401838wmq.7.1702480624929; Wed, 13 Dec
 2023 07:17:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231211182036.606660304@linuxfoundation.org> <ZXi9wyS7vjGyUWU8@duo.ucw.cz>
 <a6af01bf-7785-4531-8514-8e5eb09e207e@roeck-us.net> <ZXliuTqyO_IjlIz7@amd.ucw.cz>
 <2023121342-wanted-overarch-84a7@gregkh>
In-Reply-To: <2023121342-wanted-overarch-84a7@gregkh>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 13 Dec 2023 07:16:52 -0800
X-Gmail-Original-Message-ID: <CAD=FV=WK52EjYh0nn8e0PEvY5ovUOn9rymnY09B7SQNgUXymPw@mail.gmail.com>
Message-ID: <CAD=FV=WK52EjYh0nn8e0PEvY5ovUOn9rymnY09B7SQNgUXymPw@mail.gmail.com>
Subject: Re: RTL8152_INACCESSIBLE was Re: [PATCH 6.1 000/194] 6.1.68-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavel Machek <pavel@denx.de>, Guenter Roeck <linux@roeck-us.net>, grundler@chromium.org, 
	davem@davemloft.net, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 13, 2023 at 12:50=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 13, 2023 at 08:52:25AM +0100, Pavel Machek wrote:
> > Hi!
> >
> > > > > This is the start of the stable review cycle for the 6.1.68 relea=
se.
> > > > > There are 194 patches in this series, all will be posted as a res=
ponse
> > > > > to this one.  If anyone has any issues with these being applied, =
please
> > > > > let me know.
> > > >
> > > >
> > > > > Douglas Anderson <dianders@chromium.org>
> > > > >      r8152: Add RTL8152_INACCESSIBLE to r8153_aldps_en()
> > > > >
> > > > > Douglas Anderson <dianders@chromium.org>
> > > > >      r8152: Add RTL8152_INACCESSIBLE to r8153_pre_firmware_1()
> > > > >
> > > > > Douglas Anderson <dianders@chromium.org>
> > > > >      r8152: Add RTL8152_INACCESSIBLE to r8156b_wait_loading_flash=
()
> > > > >
> > > > > Douglas Anderson <dianders@chromium.org>
> > > > >      r8152: Add RTL8152_INACCESSIBLE checks to more loops
> > > > >
> > > > > Douglas Anderson <dianders@chromium.org>
> > > > >      r8152: Rename RTL8152_UNPLUG to RTL8152_INACCESSIBLE
> > > >
> > > > Central patch that actually fixes something is:
> > > >
> > > > commit d9962b0d42029bcb40fe3c38bce06d1870fa4df4
> > > > Author: Douglas Anderson <dianders@chromium.org>
> > > > Date:   Fri Oct 20 14:06:59 2023 -0700
> > > >
> > > >      r8152: Block future register access if register access fails
> > > >
> > > > ...but we don't have that in 6.1. So we should not need the rest,
> > > > either.
> > > >
> > >
> > > Also, the missing patch is fixed subsequently by another patch, so it=
 can not
> > > be added on its own.
> >
> > For the record I'm trying to advocate "drop all patches listed as they
> > don't fix the bug", not "add more", as this does not meet stable
> > criteria.
>
> But the original commit here does say it fixes a bug, see the text of
> the commits listed above.  So perhaps someone got this all wrong when
> they wrote the original commits that got merged into 6.7-rc?  Otherwise
> this seems like they are sane to keep for now, unless the original
> author says they should be dropped, or someone who can test this driver
> says something went wrong.

Right. The patches that "add RTL8152_INACCESSIBLE" to more loops are
bugfixes, but they're not terribly important ones to backport. While
they technically make sense even on older kernels and could
conceivably make the older kernels unload the r8152 driver a little
faster when a device is unplugged, it's not a big deal. On the first
version of the recent patches I didn't even add a "Fixes" tag for them
but I was asked to during the review process.

The "add RTL8152_INACCESSIBLE" patches become more important with
commit d9962b0d4202 ("r8152: Block future register access if register
access fails"). Once you have that it's possible to end up in the
"INACCESSIBLE" situation in response to normal (ish) error handling
and thus you want it to be faster.

Based on our experience in ChromeOS, commit d9962b0d4202 ("r8152:
Block future register access if register access fails") is a pretty
important fix and I would say it should be backported to stable.
Certainly we've backported it to our kernels in ChromeOS. In our case
we made things easier on ourselves by backporting pretty much all
patches to the r8152 driver.

-Doug
