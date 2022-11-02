Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2F636F
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 00:51:41 +0000 (UTC)
Received: by mail-ej1-f47.google.com with SMTP id 13so41419857ejn.3
        for <patches@lists.linux.dev>; Tue, 01 Nov 2022 17:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eSaSz/Z4qDcGiTl8x7mCllVE7aLOvaKXoGQ851RVNJk=;
        b=AfgzHUqFn7VGV4Kz8Fi8rM1Hwq5OyFKM90jljZgJl17I9Ubqo0jCjbpO4e5kuB579S
         qM6aPojZ5+HAqmj/1DU8AkQMDrQbOCzgHyS007RwUMkW9iE7lGfZ0+aQddSXZZsVixSE
         R/G9WJ8YXjy7TaD2ShD2tdlUyQhK42JfXZ0EA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eSaSz/Z4qDcGiTl8x7mCllVE7aLOvaKXoGQ851RVNJk=;
        b=f7aatutblCVG1tJYWy/HkAwYt5Qk7zlZe4y5tKkVQPex11r7uxwUTo7gdsnuxg8a+U
         t3GERiBiItMnObb23BPc30/G8fIi3+h+UVIWHn3S5mvfUyn8vmuW+2pQeNCz0frYNQj2
         uQBMZGojZauHXnOGNYRVXsOfG48N6wEH8D/Aet3GswF8jsqbNofUBlwmr6Oxo7eB83Us
         /rBByp3mH2eLUkhGpPrq/c9djSftdLs+hfi4nxWmwO1qeq9/hwgJK9v3FKYdaRkGM2nM
         p6g7iz1RlciJzv8rSO0XdWbWvGzAYkpnPYYVZ6RuL+dmPE3d0vcr8M++YSgfehUg8Lj4
         29FQ==
X-Gm-Message-State: ACrzQf1d13cw8lyjPHwz9pB2MFqvs9pT1DZTONvwXorq+edflrLQMxJM
	Lnh/tfjYdNYPOZLKVTzN9Zvjrz/nxWSjLat1
X-Google-Smtp-Source: AMsMyM7s1H7puqilvXLmbksbyR8CYXXZiLWg8aKDUzxwykbsYIh/tpPDturOwYauudm90V+o+klXUA==
X-Received: by 2002:a17:907:a48:b0:7a7:3714:1629 with SMTP id be8-20020a1709070a4800b007a737141629mr19927030ejc.569.1667350299755;
        Tue, 01 Nov 2022 17:51:39 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id 24-20020a508e18000000b00461cdda400esm1697689edw.4.2022.11.01.17.51.39
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 17:51:39 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id 5so9778823wmo.1
        for <patches@lists.linux.dev>; Tue, 01 Nov 2022 17:51:39 -0700 (PDT)
X-Received: by 2002:a1c:4c16:0:b0:3cf:6f1a:9038 with SMTP id
 z22-20020a1c4c16000000b003cf6f1a9038mr10071773wmf.151.1667349915421; Tue, 01
 Nov 2022 17:45:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221101233421.997149-1-swboyd@chromium.org>
In-Reply-To: <20221101233421.997149-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 1 Nov 2022 17:45:03 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XkhtgL_4-cpj-Xi3uH6FAtmWhk5u6sfakXABTnv5eYvw@mail.gmail.com>
Message-ID: <CAD=FV=XkhtgL_4-cpj-Xi3uH6FAtmWhk5u6sfakXABTnv5eYvw@mail.gmail.com>
Subject: Re: [PATCH] clk: qcom: gdsc: Remove direct runtime PM calls
To: Stephen Boyd <swboyd@chromium.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, 
	patches@lists.linux.dev, Andy Gross <agross@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@somainline.org>, 
	linux-arm-msm@vger.kernel.org, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	Johan Hovold <johan+linaro@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, 
	Taniya Das <quic_tdas@quicinc.com>, Satya Priya <quic_c_skakit@quicinc.com>, 
	Matthias Kaehlcke <mka@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Tue, Nov 1, 2022 at 4:34 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> We shouldn't be calling runtime PM APIs from within the genpd
> enable/disable path for a couple reasons.
>
> First, this causes an AA lockdep splat because genpd can call into genpd
> code again while holding the genpd lock.
>
> WARNING: possible recursive locking detected
> 5.19.0-rc2-lockdep+ #7 Not tainted
> --------------------------------------------
> kworker/2:1/49 is trying to acquire lock:
> ffffffeea0370788 (&genpd->mlock){+.+.}-{3:3}, at: genpd_lock_mtx+0x24/0x30
>
> but task is already holding lock:
> ffffffeea03710a8 (&genpd->mlock){+.+.}-{3:3}, at: genpd_lock_mtx+0x24/0x30
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&genpd->mlock);
>   lock(&genpd->mlock);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 3 locks held by kworker/2:1/49:
>  #0: 74ffff80811a5748 ((wq_completion)pm){+.+.}-{0:0}, at: process_one_work+0x320/0x5fc
>  #1: ffffffc008537cf8 ((work_completion)(&genpd->power_off_work)){+.+.}-{0:0}, at: process_one_work+0x354/0x5fc
>  #2: ffffffeea03710a8 (&genpd->mlock){+.+.}-{3:3}, at: genpd_lock_mtx+0x24/0x30
>
> stack backtrace:
> CPU: 2 PID: 49 Comm: kworker/2:1 Not tainted 5.19.0-rc2-lockdep+ #7
> Hardware name: Google Lazor (rev3 - 8) with KB Backlight (DT)
> Workqueue: pm genpd_power_off_work_fn
> Call trace:
>  dump_backtrace+0x1a0/0x200
>  show_stack+0x24/0x30
>  dump_stack_lvl+0x7c/0xa0
>  dump_stack+0x18/0x44
>  __lock_acquire+0xb38/0x3634
>  lock_acquire+0x180/0x2d4
>  __mutex_lock_common+0x118/0xe30
>  mutex_lock_nested+0x70/0x7c
>  genpd_lock_mtx+0x24/0x30
>  genpd_runtime_suspend+0x2f0/0x414
>  __rpm_callback+0xdc/0x1b8
>  rpm_callback+0x4c/0xcc
>  rpm_suspend+0x21c/0x5f0
>  rpm_idle+0x17c/0x1e0
>  __pm_runtime_idle+0x78/0xcc
>  gdsc_disable+0x24c/0x26c
>  _genpd_power_off+0xd4/0x1c4
>  genpd_power_off+0x2d8/0x41c
>  genpd_power_off_work_fn+0x60/0x94
>  process_one_work+0x398/0x5fc
>  worker_thread+0x42c/0x6c4
>  kthread+0x194/0x1b4
>  ret_from_fork+0x10/0x20
>
> Second, this confuses runtime PM on CoachZ for the camera devices by
> causing the camera clock controller's runtime PM usage_count to go
> negative after resuming from suspend. This is because runtime PM is
> being used on the clock controller while runtime PM is disabled for the
> device.
>
> The reason for the negative count is because a GDSC is represented as a
> genpd and each genpd that is attached to a device is resumed during the
> noirq phase of system wide suspend/resume (see the noirq suspend ops
> assignment in pm_genpd_init() for more details). The camera GDSCs are
> attached to camera devices with the 'power-domains' property in DT.
> Every device has runtime PM disabled in the late system suspend phase
> via __device_suspend_late(). Runtime PM is not usable until runtime PM
> is enabled in device_resume_early(). The noirq phases run after the
> 'late' and before the 'early' phase of suspend/resume. When the genpds
> are resumed in genpd_resume_noirq(), we call down into gdsc_enable()
> that calls pm_runtime_resume_and_get() and that returns -EACCES to
> indicate failure to resume because runtime PM is disabled for all
> devices.
>
> Upon closer inspection, calling runtime PM APIs like this in the GDSC
> driver doesn't make sense. It was intended to make sure the GDSC for the
> clock controller providing other GDSCs was enabled, specifically the
> MMCX GDSC for the display clk controller on SM8250 (sm8250-dispcc), so
> that GDSC register accesses succeeded. That will already happen because
> we make the 'dev->pm_domain' a parent domain of each GDSC we register in
> gdsc_register() via pm_genpd_add_subdomain(). When any of these GDSCs
> are accessed, we'll enable the parent domain (in this specific case
> MMCX).
>
> We also remove any getting of runtime PM during registration, because
> when a genpd is registered it increments the count on the parent if the
> genpd itself is already enabled. And finally, the runtime PM state of
> the clk controller registering the GDSC shouldn't matter to the
> subdomain setup. Therefore we always assign 'dev' unconditionally so
> when GDSCs are removed we properly unlink the GDSC from the clk
> controller's pm_domain.
>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Johan Hovold <johan+linaro@kernel.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Cc: Satya Priya <quic_c_skakit@quicinc.com>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Reported-by: Stephen Boyd <swboyd@chromium.org>
> Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/clk/qcom/gdsc.c | 64 ++++++-----------------------------------
>  1 file changed, 8 insertions(+), 56 deletions(-)

One small nit is that the kernel doc for "@dev" in "struct gdsc" is
incorrect after your patch. It still says this even though we're not
using it for pm_runtime calls anymore:

 * @dev: the device holding the GDSC, used for pm_runtime calls

Other than that, this seems OK to me. I don't feel like I have a lot
of good intuition around PM Clocks and genpd and all the topics talked
about here, but I tried to look at the diff from before all the
"recent" patches to "drivers/clk/qcom/gdsc.c" till the state after
your patch. In other words the combined diff of these 4 patches:

clk: qcom: gdsc: Remove direct runtime PM calls
clk: qcom: gdsc: add missing error handling
clk: qcom: gdsc: Bump parent usage count when GDSC is found enabled
clk: qcom: gdsc: enable optional power domain support

That basically shows a combined change that does two things:

a) Adds error handling if pm_genpd_init() returns an error.

b) Says that if "scs[i]->parent" wasn't provided that we can imply a
parent from "dev->pm_domain".

That seems to make sense, but one thing I'm wondering about for "b)"
is how you know that "dev->pm_domain" can be safely upcast to a genpd.
In other words, I'm hesitant about the "pd_to_genpd(dev->pm_domain)"
call. I'll assume that "dev->pm_domain" isn't 100% guaranteed to be a
genpd or else (presumably) we would have stored a genpd. Is there
something about the "dev" that's passed in with "struct gdsc_desc"
that gives the stronger guarantee about this being a genpd?


In any case, I will note that this seems to make the hang that I
described [1] go away. I never totally dug into why the patch was
tickling it, but I'm happy for now that it's back to not reproducing.
:-)


[1] https://lore.kernel.org/r/20220922154354.2486595-1-dianders@chromium.org


-Doug
