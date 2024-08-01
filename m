Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37267189B8E
	for <patches@lists.linux.dev>; Thu,  1 Aug 2024 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722513608; cv=none; b=PMO6u/1o5i0zPMJ/covjWecdDj6KG0x/rmOUz/hq9OJzgpndT2KeC7ag0rf2Otq0ZNwAmEjxmXt/xpGAxZ+ZkaHrw0wrjDk0L5eSAF6HLFbLg3Zzm9BpOju0YIPsWkjsNsCcRWWC+V8RJaZaneSFrjofnReHAOVCDWDMwwUu4nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722513608; c=relaxed/simple;
	bh=3ch82ZGw9itWwM3foqXc9vkSYoQPWEdSIpMsxQEbjX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vD48RzCBbniXfN/mPh7ViKEK8osT7W9x1Viv/LWlR5xMYOgLHMmNMWu5xWxKQI4uGtCzY/AW2syNPyNNdTjoP1YpRG7Q69DFIDAhqZMWNJFYrHGZI7Kgql8OdaF5TKoHkk9YRHvvWv5rMhPNV9/5SugM0aUCcAjBs8/H8+syN0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DO2eXlO7; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DO2eXlO7"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-823227e7572so1289450241.1
        for <patches@lists.linux.dev>; Thu, 01 Aug 2024 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722513605; x=1723118405; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=39/okCXpvEfDdVyBNIEADsyPVsMtXQG7Jd9DbMIJnl8=;
        b=DO2eXlO7bgj0AIYF1h7tObR9C9Tycz/Ljpwpz+4SWNDbmO2bB34o4euqOn09/DBw0S
         UwpROxNnU7Hf4ndVxUY92udpqLc98j2E2aZCFofJaczf3dH1rkxm0fx9O0uiZX9o60Rp
         UxSamLwYDFF9MLsuMlTnNjf1B+FmY6x8Z2Ku73cCgQrzT8qy3DlRVw0r4ygcJShCkW3g
         dFJO4uJomnmTqFvWZEv+jXfjrrFz6BVvUlvWGiykg6cHyPJTgNwgBDedEhuvKZRkU/Qq
         yRDHG/YH86psh83TvdkYMiK98AAx4iu6IkxmclV5IvFK7lQzI0iiySz+mn3EAZR30UG9
         Xgqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722513605; x=1723118405;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=39/okCXpvEfDdVyBNIEADsyPVsMtXQG7Jd9DbMIJnl8=;
        b=KfQSDi5d90T29idlw2xrDf7YxhjRwnldtBPLft7r4kp97vYXni7qbtjBFAERSKMVLo
         mp5lNYv6iQoKF2+xepf/83F0IgJTNYQDOhRt+4R7cqooew7qTiNt1J1Tcgt2T+LJi+Cs
         ETaamA5550g4cJJ4qaWzBZ1KCUzvBW6kroclb9X/Szy+vcad2MDReU0V0lpfsYD7Omwm
         /LQX16CD9uUHuy/RNIwYnRk7DIwtrjRTksC+EqsFSR7al0NMWSJkWX4CfaN2JUIhEQRn
         tBZSsS2iPBbbhp4moQPcoHp5tyhQbTiNu+XhwVffoNs74lwaOnbQnuK0gVUy78k+UhrE
         uboQ==
X-Forwarded-Encrypted: i=1; AJvYcCURAEI4Wic3484T2gGxyZJIFwtKwvJ1xHst4DEmoHqfSg5eY6WtsB95TcklE0XiX8cK/KBgplmXHYaWFM/4zCBAixrB6moTiQ==
X-Gm-Message-State: AOJu0Yz0A9xw/z9VrCgTzsaoz9jGWkdmypdNUH630Aj/h8UaPpRwQwJI
	UOMaq5/u08jH4rPQ018BKHI36dco3gyKDllv9yZAEkqx5zLmdq3zleN6BAsdF9T7bhTCRx/5oqh
	cuKkHLUaeqWYK+Sqf/o/sw/AuZQtCbXkQhMhN8w==
X-Google-Smtp-Source: AGHT+IF/TDUkHDgBItBjFUIVrxnPpACFopWfjdE9RH7NLEAE+ZcE6DNqzAmrrpGzUOTkY/FD0CW07WIZVLL23BzdnyM=
X-Received: by 2002:a1f:e404:0:b0:4f2:ffa6:dbd5 with SMTP id
 71dfb90a1353d-4f89c16eb50mr351810e0c.6.1722513604907; Thu, 01 Aug 2024
 05:00:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240502224703.103150-1-swboyd@chromium.org> <CAE-0n50VDgsg-4QnynvLOzykr3KP5JsnHqeFPA=uRT3EfgL19g@mail.gmail.com>
In-Reply-To: <CAE-0n50VDgsg-4QnynvLOzykr3KP5JsnHqeFPA=uRT3EfgL19g@mail.gmail.com>
From: Amit Pundir <amit.pundir@linaro.org>
Date: Thu, 1 Aug 2024 17:29:28 +0530
Message-ID: <CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com>
Subject: Re: [PATCH] clk: qcom: Park shared RCGs upon registration
To: Stephen Boyd <swboyd@chromium.org>
Cc: Bjorn Andersson <andersson@kernel.org>, Michael Turquette <mturquette@baylibre.com>, 
	Stephen Boyd <sboyd@kernel.org>, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-msm@vger.kernel.org, 
	Laura Nao <laura.nao@collabora.com>, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	Douglas Anderson <dianders@chromium.org>, Taniya Das <quic_tdas@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Hi Stephen,

On Tue, 9 Jul 2024 at 00:03, Stephen Boyd <swboyd@chromium.org> wrote:
>
> Quoting Stephen Boyd (2024-05-02 15:47:02)
> > There's two problems with shared RCGs.
> >
> > The first problem is that they incorrectly report the parent after
> > commit 703db1f5da1e ("clk: qcom: rcg2: Cache CFG register updates for
> > parked RCGs"). That's because the cached CFG register value needs to be
> > populated when the clk is registered. clk_rcg2_shared_enable() writes
> > the cached CFG register value 'parked_cfg'. This value is initially zero
> > due to static initializers. If a driver calls clk_enable() before
> > setting a rate or parent, it will set the parent to '0' which is
> > (almost?) always XO, and may not reflect the parent at registration. In
> > the worst case, this switches the RCG from sourcing a fast PLL to the
> > slow crystal speed.
> >
> > The second problem is that the force enable bit isn't cleared. The force
> > enable bit is only used during parking and unparking of shared RCGs.
> > Otherwise it shouldn't be set because it keeps the RCG enabled even when
> > all the branches on the output of the RCG are disabled (the hardware has
> > a feedback mechanism so that any child branches keep the RCG enabled
> > when the branch enable bit is set). This problem wastes power if the clk
> > is unused, and is harmful in the case that the clk framework disables
> > the parent of the force enabled RCG. In the latter case, the GDSC the
> > shared RCG is associated with will get wedged if the RCG's source clk is
> > disabled and the GDSC tries to enable the RCG to do "housekeeping" while
> > powering on.
> >
> > Both of these problems combined with incorrect runtime PM usage in the
> > display driver lead to a black screen on Qualcomm sc7180 Trogdor
> > chromebooks. What happens is that the bootloader leaves the
> > 'disp_cc_mdss_rot_clk' enabled and the 'disp_cc_mdss_rot_clk_src' force
> > enabled and parented to 'disp_cc_pll0'. The mdss driver probes and
> > runtime suspends, disabling the mdss_gdsc which uses the
> > 'disp_cc_mdss_rot_clk_src' for "housekeeping". The
> > 'disp_cc_mdss_rot_clk' is disabled during late init because the clk is
> > unused, but the parent 'disp_cc_mdss_rot_clk_src' is still force enabled
> > because the force enable bit was never cleared. Then 'disp_cc_pll0' is
> > disabled because it is also unused. That's because the clk framework
> > believes the parent of the RCG is XO when it isn't. A child device of
> > the mdss device (e.g. DSI) runtime resumes mdss which powers on the
> > mdss_gdsc. This wedges the GDSC because 'disp_cc_mdss_rot_clk_src' is
> > parented to 'disp_cc_pll0' and that PLL is off. With the GDSC wedged,
> > mdss_runtime_resume() tries to enable 'disp_cc_mdss_mdp_clk' but it
> > can't because the GDSC has wedged all the clks associated with the GDSC
> > causing clks to stay stuck off.
> >
> > This leads to the following warning seen at boot and a black screen
> > because the display driver fails to probe.
> >
> >  disp_cc_mdss_mdp_clk status stuck at 'off'
> >  WARNING: CPU: 1 PID: 81 at drivers/clk/qcom/clk-branch.c:87 clk_branch_toggle+0x114/0x168
> >  Modules linked in:
> >  CPU: 1 PID: 81 Comm: kworker/u16:4 Not tainted 6.7.0-g0dd3ee311255 #1 f5757d475795053fd2ad52247a070cd50dd046f2
> >  Hardware name: Google Lazor (rev1 - 2) with LTE (DT)
> >  Workqueue: events_unbound deferred_probe_work_func
> >  pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> >  pc : clk_branch_toggle+0x114/0x168
> >  lr : clk_branch_toggle+0x110/0x168
> >  sp : ffffffc08084b670
> >  pmr_save: 00000060
> >  x29: ffffffc08084b680 x28: ffffff808006de00 x27: 0000000000000001
> >  x26: ffffff8080dbd4f4 x25: 0000000000000000 x24: 0000000000000000
> >  x23: 0000000000000000 x22: ffffffd838461198 x21: ffffffd838007997
> >  x20: ffffffd837541d5c x19: 0000000000000001 x18: 0000000000000004
> >  x17: 0000000000000000 x16: 0000000000000010 x15: ffffffd837070fac
> >  x14: 0000000000000003 x13: 0000000000000004 x12: 0000000000000001
> >  x11: c0000000ffffdfff x10: ffffffd838347aa0 x9 : 08dadf92e516c000
> >  x8 : 08dadf92e516c000 x7 : 0000000000000000 x6 : 0000000000000027
> >  x5 : ffffffd8385a61f2 x4 : 0000000000000000 x3 : ffffffc08084b398
> >  x2 : ffffffc08084b3a0 x1 : 00000000ffffdfff x0 : 00000000fffffff0
> >  Call trace:
> >   clk_branch_toggle+0x114/0x168
> >   clk_branch2_enable+0x24/0x30
> >   clk_core_enable+0x5c/0x1c8
> >   clk_enable+0x38/0x58
> >   clk_bulk_enable+0x40/0xb0
> >   mdss_runtime_resume+0x68/0x258
> >   pm_generic_runtime_resume+0x30/0x44
> >   __genpd_runtime_resume+0x30/0x80
> >   genpd_runtime_resume+0x124/0x214
> >   __rpm_callback+0x7c/0x15c
> >   rpm_callback+0x30/0x88
> >   rpm_resume+0x390/0x4d8
> >   rpm_resume+0x43c/0x4d8
> >   __pm_runtime_resume+0x54/0x98
> >   __device_attach+0xe0/0x170
> >   device_initial_probe+0x1c/0x28
> >   bus_probe_device+0x48/0xa4
> >   device_add+0x52c/0x6fc
> >   mipi_dsi_device_register_full+0x104/0x1a8
> >   devm_mipi_dsi_device_register_full+0x28/0x78
> >   ti_sn_bridge_probe+0x1dc/0x2bc
> >   auxiliary_bus_probe+0x4c/0x94
> >   really_probe+0xf8/0x270
> >   __driver_probe_device+0xa8/0x130
> >   driver_probe_device+0x44/0x104
> >   __device_attach_driver+0xa4/0xcc
> >   bus_for_each_drv+0x94/0xe8
> >   __device_attach+0xf8/0x170
> >   device_initial_probe+0x1c/0x28
> >   bus_probe_device+0x48/0xa4
> >   deferred_probe_work_func+0x9c/0xd8
> >
> > Fix these problems by parking shared RCGs at boot. This will properly
> > initialize the parked_cfg struct member so that the parent is reported
> > properly and ensure that the clk won't get stuck on or off because the
> > RCG is parented to the safe source (XO).
> >
> > Fixes: 703db1f5da1e ("clk: qcom: rcg2: Cache CFG register updates for parked RCGs")
> > Reported-by: Stephen Boyd <sboyd@kernel.org>
> > Closes: https://lore.kernel.org/r/1290a5a0f7f584fcce722eeb2a1fd898.sboyd@kernel.org
> > Closes: https://issuetracker.google.com/319956935
> > Reported-by: Laura Nao <laura.nao@collabora.com>
> > Closes: https://lore.kernel.org/r/20231218091806.7155-1-laura.nao@collabora.com
> > Cc: Bjorn Andersson <andersson@kernel.org>
> > Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > Cc: Douglas Anderson <dianders@chromium.org>
> > Cc: Taniya Das <quic_tdas@quicinc.com>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
>
> Applied to clk-next
>

This patch caused a few deferred probes on sm8550-hdk breaking the
audio codec and usb-c host mode support. This breakage is not 100%
reproducible but can be fairly easily reproduced though.
I have attached the relevant logs and defconfig here
https://bugs.linaro.org/show_bug.cgi?id=6053 for reference. Let me
know if you need more information or if I can assist you in testing a
debug patch to diagnose it further.

Regards,
Amit Pundir
