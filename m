Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165233208
	for <patches@lists.linux.dev>; Wed, 11 May 2022 22:04:13 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-ed9a75c453so4485643fac.11
        for <patches@lists.linux.dev>; Wed, 11 May 2022 15:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=36iz89P09ojYrmbM5f1H/QsMT0+rmWkuU11oOzTk+Ho=;
        b=e1Tq7sW4VPNVTH04wWKgTBIYHtwcLCkVzIBe8Z3juTk4EnXptXqkLVO6IC764LIGqK
         QGrBAh5GOJdMXMylCB2rPsbo7E06IkKoN9lEerUhcn+6bnGvmdt6JWLDWv39N/2B31Ee
         ifot5DzM5pkuOvvFdNQxrtyfAC5Hjy9XNexUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=36iz89P09ojYrmbM5f1H/QsMT0+rmWkuU11oOzTk+Ho=;
        b=hg6RbGf8u9OMlmGTWACudKbYVb6mk9+ZEXjfQwfeidWfCeF+5ryS85EmABqjl0u2Sx
         mSOIBqEQogHLHC8ANO2J9hyOgjIKxaOElsHQzYqmnb5ilY0Ae8kczIqc+gFkd9zCC9DK
         11Jf2x9CyZYjnZnVCypV6OzOxkMzQ6ASRyFfla5uOu/5td5eLNrRTq+SvOwO4ewI1rFv
         UPBakQiA1/Sqq6vEX3qRWi6IIUYZyTuIO42Aj96JiLEXHOFPbmZAKFsB3ufFSMVlLGuZ
         zpGglF3JHVLWegP2vxov5PjaYEhXVFh/plZAHtcmD2NfJIfsWr1D8BMIOqJdm/1UkkKs
         4VOw==
X-Gm-Message-State: AOAM531u3R6yvwmyOQrv5y/8sf6IfnE7vDAwHCuU/I+F58EL656IVHzD
	rwPs0/wMq3GL+nR6ePZm44Pzn2TjY7gnJjsNQjbVnQ==
X-Google-Smtp-Source: ABdhPJzw3oVKCKyN2EqwMU4CV86X7Qc6lhRr4OE1Ty+q7OzIPM+vgj64ZYEKlp7szGeXEs42G0fteoQQhBd08816Sp0=
X-Received: by 2002:a05:6870:558e:b0:e1:db7c:26aa with SMTP id
 n14-20020a056870558e00b000e1db7c26aamr3966022oao.63.1652306653122; Wed, 11
 May 2022 15:04:13 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 11 May 2022 15:04:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAE-0n517iAS9KSdunMX18LpqDrQ4ac-yRCZq82j-XdExaGjCXA@mail.gmail.com>
References: <20220412194505.614002-1-swboyd@chromium.org> <YnKvoh+h07at8b65@builder.lan>
 <CAE-0n517iAS9KSdunMX18LpqDrQ4ac-yRCZq82j-XdExaGjCXA@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 11 May 2022 15:04:12 -0700
Message-ID: <CAE-0n53eXiz74iCHHQaC-eDFkuui9Y1xXvuqd2g0UnrwbYhZTg@mail.gmail.com>
Subject: Re: [PATCH] clk: qcom: rpmh: Set wake/sleep state for BCM clks
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, patches@lists.linux.dev, 
	Alex Elder <elder@linaro.org>, Taniya Das <quic_tdas@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Quoting Stephen Boyd (2022-05-06 16:24:15)
> Quoting Bjorn Andersson (2022-05-04 09:53:54)
> > On Tue 12 Apr 14:45 CDT 2022, Stephen Boyd wrote:
> >
> > > Set the wake and sleep state for BCM clks here, not just the active
> > > state, as the active only state is dropped when CPUs go to deep idle.
> > > This ensures the clk is always on when the driver thinks it is on.
> > >
> > > This was found by inspection, and could very well be incorrect if the
> > > RPMh hardware copies over the active only state to the sleep and wake
> > > states.
> > >
> >
> > Taking another look at this patch and now it makes perfect sense to me.
> > Sorry for not grasping the problem earlier.
> >
> > Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> >
> >
> > Will you take this in fixes, or do you want me to pick it for 5.19?
> >
>
> I'm waiting for Taniya to reply. For all I know this has no effect
> because there's some sort of copy/paste from one state to another. Until
> then it doesn't seem like we should do anything.

Taniya told me that if there's no sleep or wake state set then active
state remains even when the subsystem is in sleep. Not exactly
copy/paste but at least it is consistent. We need a comment here so this
doesn't come up again.
