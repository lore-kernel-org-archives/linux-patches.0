Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7301E1643D
	for <patches@lists.linux.dev>; Fri,  5 Apr 2024 02:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712285703; cv=none; b=ZW2YRJCccJzuaVrHt40hZXE90B2DT+Zx4d49YKqKB/V0/FF/0Z3/5ntzwKIQ1rOqP5TmNKZUdaDOsM0x0h0ar59O+ASKiVd5XVSKpXbm9zwZWowZDaQ8KxRDFxVRjiFxSgUsmXuhRGTrZUF/TNiApUCS3UN1mRH5O1jgJ+tWe3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712285703; c=relaxed/simple;
	bh=YdWgYZZy6+ImQbZGCSH7do3YA/hmyop0f165eRYq+Cc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L3qpETfUJ5+8zE4XLq3a4cJJk4y/u2k2xGEgQ+Fpi2YnJzw6uSzmq0rqLs9YXoI6CqpYSrjqU0TiT1WYBy6IKEKiI0hPjM+4b4E8gFE4BGTQRLO5w5AGX3Z9/Q1BTwzalYgRPZhB74m3kX8xGXlkFPjCqODG7gMNfpnnpRdefCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hVaIJZpq; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hVaIJZpq"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-dbed179f0faso2214404276.1
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 19:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712285700; x=1712890500; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EfDPM/jBlrvHW8pL/mwrjjQGf0cytLyBW2ZbeZaxa8w=;
        b=hVaIJZpqdWxm3TVCIvaJTRqrTflpTBO1wiXC2DvCX8eGxR6LqSaLOAKv3xCtLn4hal
         XkaFjEkCxDCeEGJ3cqhNZIEYsaOZQmj2p8dNy6pw3n866Q9oRxgQ29v5GRyMx0JTC98s
         yWz5H6Cq8CE5GxnEZCXuKZp6mA5sTpDCP9NkeCCO3+wN3e6rCDL8lf+L/Cq4oy9uiFv/
         4A6XNlslI0zpBt8sop63nklGQ1T4ebAbAvXZvWtC+hHwAwzfu7hBaL+/wN7snv11Q1yh
         kFB77vn0VFvopjbS7hh3FaKbe/xcPuNFDS3NoXrqziXzUpPkzKCtOLSFlX/Utkc0t2Mz
         EDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712285700; x=1712890500;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EfDPM/jBlrvHW8pL/mwrjjQGf0cytLyBW2ZbeZaxa8w=;
        b=UcxxPVuizK7ducoNq/GgwqF15EDc3IB5VGJD36kwnND3DWiV9J4SA4yN0Un14SMejL
         d3FShYGQ+dnjF1NK1QD6s/jwgbnOMd2IFlH8ejxE8ac0WHxzJfv21XM+UCYU0bMIdd0p
         xN1xOXRHVZifmwFcXhhzUgbu9HIZCDKbaCZ8niQjyON1pqjndYsQ/lZWHrXn9V2UdkZ7
         GbuEgaHsLqOkPw0EUuHwwcevCPp7ie/Y+Qb4j2dGDA2lOBmYgDJLEdB/UVkstqPRrLZh
         evMXgaffcwmql/z0/DJ0CcUhlowASorRXRSA789EPIps5WCyPmbJNfopKoqktX/OgV0k
         4Aow==
X-Forwarded-Encrypted: i=1; AJvYcCXwyc8FRpCw35udWsgiXrOBn2346Z+XSlPNUD60OYWAZhxlz1K8FPX9MZ36lVIXO3ZbdpX0IdY9FsATSVoI8WuAuC/VDdRGgA==
X-Gm-Message-State: AOJu0YwOy++PnwN50XupbGNFN5X/lXQkSJR/4YM4P92pOJARYHwRBOoA
	rCdx/NlgHo3o3Z/GJYxYn+j59QbGvlpfkvhCSWTlk2DcB/YmB1oahV6iZUpYiQ2SQQO0Szd62gq
	l18kNEcVNZ50rp9K2AGwsCR+3UjDemEodKCQcpA==
X-Google-Smtp-Source: AGHT+IFivS2hB8z2W9hwonWTCxmRcOXhWI/RFcC0uZQ37FAI9e0SKdalGASHEiDclHq2P1ZBRA6kcdGTvgLJPN2UQoc=
X-Received: by 2002:a25:dc92:0:b0:dcc:6894:4ac0 with SMTP id
 y140-20020a25dc92000000b00dcc68944ac0mr207083ybe.20.1712285700487; Thu, 04
 Apr 2024 19:55:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240404234345.1446300-1-swboyd@chromium.org>
In-Reply-To: <20240404234345.1446300-1-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Fri, 5 Apr 2024 05:54:49 +0300
Message-ID: <CAA8EJprZ8Ehx+M7vy1pH8OT6Of2v8-trecCJZhF5wxBRSGQoXw@mail.gmail.com>
Subject: Re: [PATCH] phy: qcom: qmp-combo: Fix VCO div offset on v3
To: Stephen Boyd <swboyd@chromium.org>
Cc: Vinod Koul <vkoul@kernel.org>, Kishon Vijay Abraham I <kishon@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-msm@vger.kernel.org, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	linux-phy@lists.infradead.org, Neil Armstrong <neil.armstrong@linaro.org>, 
	freedreno@lists.freedesktop.org, Douglas Anderson <dianders@chromium.org>, 
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Apr 2024 at 02:43, Stephen Boyd <swboyd@chromium.org> wrote:
>
> Commit ec17373aebd0 ("phy: qcom: qmp-combo: extract common function to
> setup clocks") changed the offset that is used to write to
> DP_PHY_VCO_DIV from QSERDES_V3_DP_PHY_VCO_DIV to
> QSERDES_V4_DP_PHY_VCO_DIV. Unfortunately, this offset is different
> between v3 and v4 phys:
>
>  #define QSERDES_V3_DP_PHY_VCO_DIV                 0x064
>  #define QSERDES_V4_DP_PHY_VCO_DIV                 0x070
>
> meaning that we write the wrong register on v3 phys now. Add another
> generic register to 'regs' and use it here instead of a version specific
> define to fix this.
>
> This was discovered after Abhinav looked over register dumps with me
> from sc7180 Trogdor devices that started failing to light up the
> external display with v6.6 based kernels. It turns out that some
> monitors are very specific about their link clk frequency and if the
> default power on reset value is still there the monitor will show a
> blank screen or a garbled display. Other monitors are perfectly happy to
> get a bad clock signal.
>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Fixes: ec17373aebd0 ("phy: qcom: qmp-combo: extract common function to setup clocks")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry
