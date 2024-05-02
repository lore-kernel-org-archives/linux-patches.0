Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B26DDA1
	for <patches@lists.linux.dev>; Thu,  2 May 2024 23:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692054; cv=none; b=MkHOvi8T0ezoqQXWUbzAY5CTkNNLGa4OVGxvbf2iPCRnSJvmaagkKipD3upKzfxKP8u1hiuOydexDuWL/CwpLTq+svTojTryvLn9MZpxaUbm1X4d+GJ7S2LEDoL7EJTT9Zc6ig1xHuogA22g7L10+ajiOwhHVMRw40IHyOQzngk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692054; c=relaxed/simple;
	bh=/BD3wxAtMeBhjQcyimNBdRRV8wUoskv6H5KUanY3Oqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cd5rav99Hh9bdbROHtLvDDdhgD2vlgITntzKPeASseCL5S6MIlzbaK/63OA7DitbSubJvgOTAboFTxG8YcS+9cUY2dvM88KVG3ESD5WNWCKIMU+hgtXVUzwW6XzDFQ3IiTd3N3c8TQC+gwyjQocrWAItZdpcXzqcSseLS29KYr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=RBczdBse; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RBczdBse"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a58772187d8so1111018366b.3
        for <patches@lists.linux.dev>; Thu, 02 May 2024 16:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714692050; x=1715296850; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ByVaaMKgikK9K01TQNZAeU3i4lX5j7GPcDDDxv6HGU=;
        b=RBczdBse4Oz3upLQVh0C/GSD99zCxNeLn6Je6Nqc0VbJpTcp8dxezxtTXMvFYa/kSa
         ckF0aN39YGug1Fp0am0EGu08YBfIHPS1YabANcBHfY/qMG1uNVitpOUUK1hMeevWie+p
         U46SJnp1Oal7ocbGcjdwVzBm4545OG3I7oKIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714692050; x=1715296850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ByVaaMKgikK9K01TQNZAeU3i4lX5j7GPcDDDxv6HGU=;
        b=cwXE5U+rYlnBqoRDz4RqCwqRc0o55iQwoRy5Y/sTglHzkAIIodnnHSzIwcUcbuBnVe
         q4Cj16aSN+riUn3SUh8gF7C0S64z/ouFHEGz6JbLcEt4bvoJQzzBk334gw3LZ6U0usSn
         3wl4/zkuv2UZ5eFQQXwUpxccyk7/QAetpIkfPCJbsBZfYlQumDY9e7LCXWOofEmVjsCx
         mFSDUnG57dfw0Y6l+9S3gffO099uF5kDdzgVlahcOki0+9iBTFygy5AXhiS1B3Yq61nO
         KT+CZcKh0XpYI56ERyTraDvni75MCuA7IOT6gUKT+tbStJZmeMc+2w33ZwFqKsbCJzDZ
         baEA==
X-Forwarded-Encrypted: i=1; AJvYcCXNYCVYZUAejUWGkJQI9ymL+28plPcGNTYC0y5UPyHbnAvFxYHhHGJVEymyg2QK1Mt/3FoLYq5Hmbi+D0fPalsRzGXNvMEYPw==
X-Gm-Message-State: AOJu0Yz6tHjNfxuamtqGKYBPDN8U6EP4fxpR8Nq4wnZ8CChSQySO8gAd
	l5AftsZOjgwmLDLaz3vVN0/mvjlgAFUdus7J7bLJS4nToa4R8EIVn05onnDkph/1EAwCkn7syPK
	L5Q==
X-Google-Smtp-Source: AGHT+IGzHWdPLcy+eLoVeET33Zplyv4Jgpu2xPdV1iorodfIaaHEA2a/q63ciKc9XAPDuNzzZDp15w==
X-Received: by 2002:a17:906:1452:b0:a56:62ed:c33d with SMTP id q18-20020a170906145200b00a5662edc33dmr558768ejc.62.1714692049940;
        Thu, 02 May 2024 16:20:49 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id ay20-20020a170906d29400b00a58aff25d77sm1024431ejb.193.2024.05.02.16.20.49
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 16:20:49 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-41b48daaaf4so17355e9.0
        for <patches@lists.linux.dev>; Thu, 02 May 2024 16:20:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXnhPNCwp5lAufix4shoFImzvYDMQM+XRPKhrCsSCCqHhgt0yuMYAz5x3jwDaMDXr/J2H5G6itiZMykNgZ6VA7pSRABcIP3ZA==
X-Received: by 2002:a05:600c:190c:b0:41b:e55c:8dca with SMTP id
 5b1f17b1804b1-41e1cf3429dmr334315e9.7.1714692048795; Thu, 02 May 2024
 16:20:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240502224703.103150-1-swboyd@chromium.org>
In-Reply-To: <20240502224703.103150-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Thu, 2 May 2024 16:20:31 -0700
X-Gmail-Original-Message-ID: <CAD=FV=UtSiueVky6jX2DjQwS58gYU07+0em3jW0juHcDM4K0mg@mail.gmail.com>
Message-ID: <CAD=FV=UtSiueVky6jX2DjQwS58gYU07+0em3jW0juHcDM4K0mg@mail.gmail.com>
Subject: Re: [PATCH] clk: qcom: Park shared RCGs upon registration
To: Stephen Boyd <swboyd@chromium.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Laura Nao <laura.nao@collabora.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Taniya Das <quic_tdas@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 2, 2024 at 3:47=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> w=
rote:
>
> There's two problems with shared RCGs.
>
> The first problem is that they incorrectly report the parent after
> commit 703db1f5da1e ("clk: qcom: rcg2: Cache CFG register updates for
> parked RCGs"). That's because the cached CFG register value needs to be
> populated when the clk is registered. clk_rcg2_shared_enable() writes
> the cached CFG register value 'parked_cfg'. This value is initially zero
> due to static initializers. If a driver calls clk_enable() before
> setting a rate or parent, it will set the parent to '0' which is
> (almost?) always XO, and may not reflect the parent at registration. In
> the worst case, this switches the RCG from sourcing a fast PLL to the
> slow crystal speed.
>
> The second problem is that the force enable bit isn't cleared. The force
> enable bit is only used during parking and unparking of shared RCGs.
> Otherwise it shouldn't be set because it keeps the RCG enabled even when
> all the branches on the output of the RCG are disabled (the hardware has
> a feedback mechanism so that any child branches keep the RCG enabled
> when the branch enable bit is set). This problem wastes power if the clk
> is unused, and is harmful in the case that the clk framework disables
> the parent of the force enabled RCG. In the latter case, the GDSC the
> shared RCG is associated with will get wedged if the RCG's source clk is
> disabled and the GDSC tries to enable the RCG to do "housekeeping" while
> powering on.
>
> Both of these problems combined with incorrect runtime PM usage in the
> display driver lead to a black screen on Qualcomm sc7180 Trogdor
> chromebooks. What happens is that the bootloader leaves the
> 'disp_cc_mdss_rot_clk' enabled and the 'disp_cc_mdss_rot_clk_src' force
> enabled and parented to 'disp_cc_pll0'. The mdss driver probes and
> runtime suspends, disabling the mdss_gdsc which uses the
> 'disp_cc_mdss_rot_clk_src' for "housekeeping". The
> 'disp_cc_mdss_rot_clk' is disabled during late init because the clk is
> unused, but the parent 'disp_cc_mdss_rot_clk_src' is still force enabled
> because the force enable bit was never cleared. Then 'disp_cc_pll0' is
> disabled because it is also unused. That's because the clk framework
> believes the parent of the RCG is XO when it isn't. A child device of
> the mdss device (e.g. DSI) runtime resumes mdss which powers on the
> mdss_gdsc. This wedges the GDSC because 'disp_cc_mdss_rot_clk_src' is
> parented to 'disp_cc_pll0' and that PLL is off. With the GDSC wedged,
> mdss_runtime_resume() tries to enable 'disp_cc_mdss_mdp_clk' but it
> can't because the GDSC has wedged all the clks associated with the GDSC
> causing clks to stay stuck off.
>
> This leads to the following warning seen at boot and a black screen
> because the display driver fails to probe.
>
>  disp_cc_mdss_mdp_clk status stuck at 'off'
>  WARNING: CPU: 1 PID: 81 at drivers/clk/qcom/clk-branch.c:87 clk_branch_t=
oggle+0x114/0x168
>  Modules linked in:
>  CPU: 1 PID: 81 Comm: kworker/u16:4 Not tainted 6.7.0-g0dd3ee311255 #1 f5=
757d475795053fd2ad52247a070cd50dd046f2
>  Hardware name: Google Lazor (rev1 - 2) with LTE (DT)
>  Workqueue: events_unbound deferred_probe_work_func
>  pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
>  pc : clk_branch_toggle+0x114/0x168
>  lr : clk_branch_toggle+0x110/0x168
>  sp : ffffffc08084b670
>  pmr_save: 00000060
>  x29: ffffffc08084b680 x28: ffffff808006de00 x27: 0000000000000001
>  x26: ffffff8080dbd4f4 x25: 0000000000000000 x24: 0000000000000000
>  x23: 0000000000000000 x22: ffffffd838461198 x21: ffffffd838007997
>  x20: ffffffd837541d5c x19: 0000000000000001 x18: 0000000000000004
>  x17: 0000000000000000 x16: 0000000000000010 x15: ffffffd837070fac
>  x14: 0000000000000003 x13: 0000000000000004 x12: 0000000000000001
>  x11: c0000000ffffdfff x10: ffffffd838347aa0 x9 : 08dadf92e516c000
>  x8 : 08dadf92e516c000 x7 : 0000000000000000 x6 : 0000000000000027
>  x5 : ffffffd8385a61f2 x4 : 0000000000000000 x3 : ffffffc08084b398
>  x2 : ffffffc08084b3a0 x1 : 00000000ffffdfff x0 : 00000000fffffff0
>  Call trace:
>   clk_branch_toggle+0x114/0x168
>   clk_branch2_enable+0x24/0x30
>   clk_core_enable+0x5c/0x1c8
>   clk_enable+0x38/0x58
>   clk_bulk_enable+0x40/0xb0
>   mdss_runtime_resume+0x68/0x258
>   pm_generic_runtime_resume+0x30/0x44
>   __genpd_runtime_resume+0x30/0x80
>   genpd_runtime_resume+0x124/0x214
>   __rpm_callback+0x7c/0x15c
>   rpm_callback+0x30/0x88
>   rpm_resume+0x390/0x4d8
>   rpm_resume+0x43c/0x4d8
>   __pm_runtime_resume+0x54/0x98
>   __device_attach+0xe0/0x170
>   device_initial_probe+0x1c/0x28
>   bus_probe_device+0x48/0xa4
>   device_add+0x52c/0x6fc
>   mipi_dsi_device_register_full+0x104/0x1a8
>   devm_mipi_dsi_device_register_full+0x28/0x78
>   ti_sn_bridge_probe+0x1dc/0x2bc
>   auxiliary_bus_probe+0x4c/0x94
>   really_probe+0xf8/0x270
>   __driver_probe_device+0xa8/0x130
>   driver_probe_device+0x44/0x104
>   __device_attach_driver+0xa4/0xcc
>   bus_for_each_drv+0x94/0xe8
>   __device_attach+0xf8/0x170
>   device_initial_probe+0x1c/0x28
>   bus_probe_device+0x48/0xa4
>   deferred_probe_work_func+0x9c/0xd8
>
> Fix these problems by parking shared RCGs at boot. This will properly
> initialize the parked_cfg struct member so that the parent is reported
> properly and ensure that the clk won't get stuck on or off because the
> RCG is parented to the safe source (XO).
>
> Fixes: 703db1f5da1e ("clk: qcom: rcg2: Cache CFG register updates for par=
ked RCGs")
> Reported-by: Stephen Boyd <sboyd@kernel.org>
> Closes: https://lore.kernel.org/r/1290a5a0f7f584fcce722eeb2a1fd898.sboyd@=
kernel.org
> Closes: https://issuetracker.google.com/319956935
> Reported-by: Laura Nao <laura.nao@collabora.com>
> Closes: https://lore.kernel.org/r/20231218091806.7155-1-laura.nao@collabo=
ra.com
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>
> This is an alternative approach to [1] which doesn't require any hacks
> to disable clks during driver probe.
>
> [1] https://lore.kernel.org/r/20240327202740.3075378-1-swboyd@chromium.or=
g
>
>  drivers/clk/qcom/clk-rcg2.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)

I'm not even close to an expert on the Qualcomm clock stuff, but the
description of what's going on here seems reasonable to me. I agree
that getting this fixed is important, so I'd be OK with a somewhat
weak:

Reviewed-by: Douglas Anderson <dianders@chromium.org>

...hopefully others more in the know will also review and make sure
it's not going to break anyone's use cases.
