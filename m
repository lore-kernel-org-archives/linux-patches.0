Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35FE24F21
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 18:08:10 +0000 (UTC)
Received: by mail-lf1-f44.google.com with SMTP id j16so29499408lfe.12
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 11:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m6s+mDwTFEybSnfsv9FLfpZxULcbiJ7Ktz0jYPN4zbg=;
        b=oZ190qKXbUdI3pa/TkZ7GnFQDtDHYWG8bjZi1njg37scSepa9KpKnNxCF5ZM/IM+KQ
         Np/CHo9hpZWYYqOyMwWGXHorI5H2uxm7feX7c3TtuTfuYs5myB2q7dizQUWdWBfEbsKE
         fwoSJGuEqhARSqpzkQV8FkHnpWPtOw232JAeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6s+mDwTFEybSnfsv9FLfpZxULcbiJ7Ktz0jYPN4zbg=;
        b=PJf3KuJBciP858pNwoiwmseo4xbZbSkyR/W92po/WLCgAMBQ/gAsUa+c7OXvxIHL/t
         W/5ufYOlOTrRizhmB3gqxpyCr1cgWvUcSgDXf6oIe8drC+d0z960IWhpyqWt/FSPponB
         y1MslpzQPVYafTmrb3MXt9tun0pyETFmWBug/i2Troj5fw0/2MxxYPPzPT0sz8Hmul9l
         S4r/NIeULFr7+qVl2DSUcP6u7+x9yX77Pih2TZwB+5zEY8S3Dy+UQcbErUEYxn0m2OTg
         Q9sfyKvs0M6461vOXZoYQAjK8sDnBlIF7ygC0SslFbef1mNIph0anKQMVZbcScSGntE+
         YpdA==
X-Gm-Message-State: ACrzQf1UvdJSc+b2RS97OvL50stsDMTzrdSXoHKIPmuFt7JVskRDnPZ+
	H6B+lwn2WYbl2wi6CqaQ6ZcapZINL3t0j/EhwDgQiA==
X-Google-Smtp-Source: AMsMyM74PhTMtaDdojPE3Gl+8/j0gbeo2ZUKzdZSx7kiyQHT7FwZ/NQ9JAOxrEN2lb9nIwl2MLZuQl03p4TzbuBym/Y=
X-Received: by 2002:a05:6512:3dac:b0:4a4:8044:9c3 with SMTP id
 k44-20020a0565123dac00b004a4804409c3mr9462216lfv.145.1667412488653; Wed, 02
 Nov 2022 11:08:08 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 2 Nov 2022 11:08:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20221102042933.mdlfknp45ajyrrpn@builder.lan>
References: <20221101233421.997149-1-swboyd@chromium.org> <20221102024927.n5mjyzyqyapveapa@builder.lan>
 <CAE-0n50uVf-xapfX5A_c7XU7gV58HrKBOf5DCUPCcahPrgkU0Q@mail.gmail.com> <20221102042933.mdlfknp45ajyrrpn@builder.lan>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 2 Nov 2022 11:08:08 -0700
Message-ID: <CAE-0n52389Pmp1dxHbtGijK_x+0xGyJ4q4rFRpa6L2KkZHKX5Q@mail.gmail.com>
Subject: Re: [PATCH] clk: qcom: gdsc: Remove direct runtime PM calls
To: Bjorn Andersson <andersson@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, 
	patches@lists.linux.dev, Andy Gross <agross@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@somainline.org>, linux-arm-msm@vger.kernel.org, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Johan Hovold <johan+linaro@kernel.org>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Taniya Das <quic_tdas@quicinc.com>, 
	Satya Priya <quic_c_skakit@quicinc.com>, Douglas Anderson <dianders@chromium.org>, 
	Matthias Kaehlcke <mka@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Bjorn Andersson (2022-11-01 21:29:33)
> On Tue, Nov 01, 2022 at 08:29:20PM -0700, Stephen Boyd wrote:
> > Quoting Bjorn Andersson (2022-11-01 19:49:27)
> > >
> > > It's correct that adding the GDSCs as subdomains for the device's
> > > parent-domain will ensure that enabling a GDSC will propagate up and
> > > turn on the (typically) rpmhpd resource.
> > >
> > > But the purpose for the explicit calls was to ensure that the clock
> > > controller itself is accessible. It's been a while since I looked at
> > > this, but iirc letting MMCX to turn off would cause the register access
> > > during dispcc probing to fail - similar to how
> > > clk_pm_runtime_get()/put() ensures the clock registers are accessible.
> >
> > The dispcc and videocc on sm8250 don't use pm_clk APIs. They do use
> > pm_runtime APIs during probe (i.e. pm_runtime_resume_and_get()). That
> > will enable the MMCX domain and keep it on.
>
> There's a corresponding pm_runtime_put() at the end of
> disp_cc_sm8250_probe(), so this vote should be released.

Correct.

>
> While registering clocks, the framework will clk_pm_runtime_get()/put()
> while accessing registers. The argument that was given when introducing
> the calls in the probe was the same, covering the direct regmap
> accesses...
>
> And I guess it avoids flipping the genpd on/off for each resource being
> accessed.

I don't think the genpd framework accesses anything when a genpd is
registered. The clock controller is pm_runtime_resume_and_get() during
the time the gdscs are registered with genpd, so there isn't any more
need to get the runtime PM state of the clock controller during this
time. The PM runtime put comes after qcom_cc_probe(). We should be good.

>
> > Then when the GDSCs are
> > registered it will create genpds for each GDSC and make them subdomains
> > of the 'dev->pm_domain' genpd for MMCX. If the GDSCs are enabled at
> > probe time they will increment the count on MMCX to put the count into
> > sync between MMCX and the GDSC provided.
> >
>
> This does not fit my argument; if the purpose is for pm_runtime to
> provide access to the registers (and the subdomain ensuring that the
> GDSC is powered), we should have a pm_runtime_put() after each operation
> (analog to clk_pm_runtime_put()).

I believe registration/probe of the GDSCs is covered, the device is
runtime resumed there. After that I'm not 100% positive, but with the
GDSC as a subdomain of the clock controller's domain it will at least
turn on MMCX before trying to enable the GDSC.

>
> > The clk framework also has runtime PM calls throughout the code to make
> > sure the device is runtime resumed when it is accessed. Maybe the
> > problem is if probe defers and enough runtime puts are called to runtime
> > suspend the device thus disabling MMCX?
>
> Iirc the problem at hand was really that without any other votes for
> MMCX, the register accesses during probe, gdsc and reset registration
> would access registers without power.

Makes sense. The runtime PM get call for the clock controller in the
probe will keep MMCX enabled.

>
> > Can MMCX really ever be disabled
> > or does disabling it act as a one way disable where you can never enable
> > it again?
> >
>
> I've not seen any indications of that.
>
> Only the side effect that if you set_performance_state() MMCX lower than
> required during continuous splash the whole SoC get hosed.

I see. That sounds different.

>
> > Or maybe this is the problem where not all constraints are determined
> > yet but we're letting runtime PM put calls from the dispcc device shut
> > down the entire multimedia subsystem while other devices that are within
> > the same domain haven't probed and been able to sync their state but
> > they're actively accessing the bus (i.e. continuous splash screen). I
> > could see this problem being avoided by the pm_runtime_get() call in
> > gdsc registration keeping MMCX on forever because there isn't a matching
> > put anywhere.
> >
>
> This implementation predates 41fff779d794 ("clk: qcom: gdsc: Bump parent
> usage count when GDSC is found enabled"), so no this was not introduced
> to hide the issue of
> yet-to-be-probed-devices-not-voting-for-their-resources.
>
> This problem has been avoided by tying rpmhpd to sync_state and
> requiring that people boot their systems with pd_ignore_unused.

Heh ok.
