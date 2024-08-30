Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E641C1755
	for <patches@lists.linux.dev>; Fri, 30 Aug 2024 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725056966; cv=none; b=QO+DHrTMIfgHQ1Kc2zakFLb6edNi9bFGN5RdpiHnYKMbYMcu1vNxQbs/MILvoaFjPWI3467HJzmblIGVM62Yk8VertQd/GEs+kz2GeUyL7giHgzulWNr/L5C4wcRG3eIr17AluNOi/bDnfEUHqjen4kRCmElP2g1hVmn/YL65OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725056966; c=relaxed/simple;
	bh=4GgNHNsl6MTwxWAUSSgj5snocnM78gEmhGmvQuLddYQ=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AvpeQBnZQ/rPjik02U+aHdQCIn5ncPE584/jPok6Rw/ppfxCD54GYkDfvb1pUecK3TXBdkIdNCDmmlL55IKOdeQuuov4mfWE+wUTVb3+z4CpW9GpupixNcfXe0XUhyiLr93FPi//h3e1Mgf01K2nOYgt2WjHxFYbaDDruW8uxHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=bA5dQJaS; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bA5dQJaS"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-49a6d056fa3so346709137.0
        for <patches@lists.linux.dev>; Fri, 30 Aug 2024 15:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725056963; x=1725661763; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2GtqqHeMLIVZafaXXKgt14nskpie4/u6kUld6V4M6X4=;
        b=bA5dQJaSvYTvMCPaUh7NwXKZaG5mKFqi0jW9FY2ZtqOIKEsR2JcF9y4WQpKhlQiE06
         x4o3gnYApdlIrbxI2OBQtHUwWv4T400qlF4yTsiZZ6NeECzyz4Vmoi7/HgZh42ssa5J6
         qzpGQW/qlysXTTO2NBF+z/En6MxxcFuNOJeX4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725056963; x=1725661763;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2GtqqHeMLIVZafaXXKgt14nskpie4/u6kUld6V4M6X4=;
        b=wZaAVHMaSormI1TG/hI0vrkzMVJdmLj68mD/N/Nn3Igc2n4+GLs01W5+xR59YsXflo
         eK0R5upsOZhIcsFZhUQNc3qwGjWQfBq57FiGLiyKZsaClO8IUdeXZuZxD6q5GKmEklqY
         vwZsBxcf6XHJuua10eqIFI1Qvr83U/bNJfGZzrvbpHvU96bpryGZnh70UOrwABQmPpOo
         SdmZyYX3XnBKxWn/A5fod7Qn/wznMEYbxTzFpeoQMy2hvp4bgI+qk+jNEhPoGK3cxkAy
         JvIU4PRLoL5VrOlYxLXLPCS9D/Pden97puYyG+wJf7Aoa8DYgPSIgbeFYktCkJh9smSj
         QwsQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2eaJ84+1EbPLjzM1DQMWPcE79pNx2yO8MUQTNPSSwOcHf6WJcUB+mmJ4qmCcDlfkiQEueracm@lists.linux.dev
X-Gm-Message-State: AOJu0YzKZueFzb1P1on71aYbOzUj+iUi9yjaMxF159BwWExgYfQM0KjW
	p3ndVydHuiuylmryccJKWKNWxVUScHSqFy8JoQfUX0cHPN8vvPM+Uc0YGaz+pC9SFFtZF4uREO9
	znm2Hcs9WE1UaxDse1tNMif/suG6c9LxZQ94k
X-Google-Smtp-Source: AGHT+IH3cxSAtR2IOZY8n4PObzrdg7w+qSsS34kPT9uz2UEJg985EoHLslmaQuDZB6axejHFWN7bvxuNbWFx030eruA=
X-Received: by 2002:a05:6102:c87:b0:48f:cb62:231a with SMTP id
 ada2fe7eead31-49a779a41d4mr878635137.23.1725056963156; Fri, 30 Aug 2024
 15:29:23 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 30 Aug 2024 15:29:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAE-0n51Ag1wpj0uUPVtMvgZJE2FF_FZkw+j=bRiAq3vYk=Y_Fw@mail.gmail.com>
References: <20240828171722.1251587-1-swboyd@chromium.org> <20240828171722.1251587-2-swboyd@chromium.org>
 <c1e35d3d-fa00-4453-aaa3-9f23a07acb4f@linaro.org> <CAE-0n51Ag1wpj0uUPVtMvgZJE2FF_FZkw+j=bRiAq3vYk=Y_Fw@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 30 Aug 2024 15:29:22 -0700
Message-ID: <CAE-0n53rNuyXcVcqTBSgbNzuJzCBkaHE21dPNkMTrs=BCTkmPg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] clk: qcom: dispcc-sc7180: Only park display clks
 at init
To: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	patches@lists.linux.dev, linux-clk@vger.kernel.org, 
	Amit Pundir <amit.pundir@linaro.org>, Taniya Das <quic_tdas@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Quoting Stephen Boyd (2024-08-29 09:34:05)
> Quoting Neil Armstrong (2024-08-29 08:32:48)
> >
> >
> > I've been testing this serie on SM8650, and with 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
> > it fixes an issue we have that triggers:
> > [   18.740736] ------------[ cut here ]------------
> > [   18.745837] ufs_phy_gdsc status stuck at 'off'
> > [   18.745929] WARNING: CPU: 1 PID: 197 at drivers/clk/qcom/gdsc.c:178 gdsc_toggle_logic+0x15c/0x164
> > ...
> > after waking up UFS from runtime suspend.
>
> Oof that's not good.
>
> >
> > So I suspect we'll need to figure out which SM8650 GCC shared clocks would need
> > to use clk_rcg2_shared_init_park_ops ?
> >
> > We also had random boot crash when initializing the display very late on multiple platforms,
> > and so far "clk: qcom: Park shared RCGs upon registration" fixed that, but I also suppose Ill
> > need to reflect the changes done to dispcc-sc7180.c to dispcc-sm8650.c and others.
>
> It sounds like it's better to make the default always park at
> registration time and special case the one or two places where that
> isn't possible, i.e. USB because it has special rate requirements. So I
> should just go back to v1 then and pile on the QUP patches.

I've done this now and I'll push out clk-fixes with the QUP patches.
