Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A571474C3
	for <patches@lists.linux.dev>; Wed, 21 Aug 2024 15:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724254524; cv=none; b=d9D9iGmETlkDHJJYNuq/nncEQ4/L3DI/esb9RJoeXRt/uxfyK22SRoYvIYt2heXryXqOGj67pX9IDh9IgcjYQ7wi/Du1G2M9B2aOrAbR+72q7P0tSIHo5HYE4AqLpamlNG5SzD6axQFG0GkHNYIxUhMe4haARd95hctgeW5fH5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724254524; c=relaxed/simple;
	bh=q0aRixnhWUWpxjM3Ck4bjrpb4pe7AI96MxRCxkxtVwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d8SpV2RuZWLxe4ZpXukI+W3gxj33X/JvAe0XsnxcN8xdQCzqHRw7jPPcLGGcaj0vVNg7LZt1j1mJyNSuqrgtmV4Q9sq5nbYTMnOfbG5mG9j8yJruyxDsA3pm4+v2CFPoPxmjZaPRll19ze0iEzCdQEAuK7jjwLHdENKj/v084ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cyx61K1l; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cyx61K1l"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5d5e1c86b83so4354880eaf.3
        for <patches@lists.linux.dev>; Wed, 21 Aug 2024 08:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724254520; x=1724859320; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B92SIehQD/sLMBWjePhjq8cDV+wlqZQrnnvx6Bm71co=;
        b=cyx61K1ll5WJkNvAgpTZCZ5hcY87bF3ytsZmyux4SI179Mw17jWAlJ4oepnP3M7/Up
         Z03DRdudKSgtpiu0akBY2UVI3BNjlZT+OLGxporDskxGIC62+xQ/xXMb6G6gRXI1elcU
         rHrlyGU0GLyE/xj9fm7o74zoMSAKk1jfMI7Vy8/lkrxHUcHpVs8TbLhEBU9WrkKtsbdN
         B5K410DzJRhaJWf7pN81rah3HjAHaGw3NAlFukAvxJVf/siWwLFG3TbL6X+04otQLfUL
         Hz87mLGw7xs9DRo0xRs5+BsRirsYQRWrJjIJhZZkGlqhYnr8fbIZzr134RPdwnzgdI4B
         82nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724254520; x=1724859320;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B92SIehQD/sLMBWjePhjq8cDV+wlqZQrnnvx6Bm71co=;
        b=WzS2EzI5iaxyL/PJV9nuQJEKYu4W8MIZQ0U0TY0aIBeMpJcvpAry79BjZSDJ1r7jGQ
         RbW4vO3rQtdb3iNTqA3L3mZtmAWC8fzhgSBbuRa86dpeUDhI9gxsqMroDdDB/qk6spnn
         8/ALAlXEA04+Y9TSOlCIx9HWlgClzV2HsFZuanucaBQWh1QKM/rqbI2oykGtC/w9vKQu
         t5feTS7A8vsGd4GYnHXLjI+RtdkYcrjnlQOhhkjUlu24X6FchsM1y1tgSvD1SM3nr3ud
         n1izENBjJkF4owAEMI50Acwf3b7wYLFFh2nXqrC9blMgl7tWDA8RpGGpcTAmWK35iLtU
         zMJw==
X-Forwarded-Encrypted: i=1; AJvYcCV2UfmnAwd/buwTrNMleWai6SsUIpB4dQqeL9m1/ugV75iX9SV61n+l7T8gWkzWhsI8YcFLKEIp@lists.linux.dev
X-Gm-Message-State: AOJu0YxqfCCX1mJiqoZ2JElf53v4mUww51Br2+Het+tMulPA5v12JSF3
	TP2oDIK0u9/gGVJzyHyBbIyaNnggYQ2HbHlvhjb0b0FS5Wg8ziC6V2BkLuvkFiXyhVAb7yspV4J
	uKfDmIUHFHKfqQVzy97hjClZ8zDYxN1r6nCpbHw==
X-Google-Smtp-Source: AGHT+IHtjLVFoilgrnbbIQMVwq05/DqJA4CW2+AENaI/70z5AgIJxpdFSd6TduzT2Mi5cnCvDMGVL39BMCO82c2hHq8=
X-Received: by 2002:a05:6358:310b:b0:1b5:a060:678b with SMTP id
 e5c5f4694b2df-1b5a265b26amr290392655d.3.1724254520067; Wed, 21 Aug 2024
 08:35:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240819233628.2074654-1-swboyd@chromium.org>
In-Reply-To: <20240819233628.2074654-1-swboyd@chromium.org>
From: Amit Pundir <amit.pundir@linaro.org>
Date: Wed, 21 Aug 2024 21:04:43 +0530
Message-ID: <CAMi1Hd3=1S0Jktej0vv0ZJna1Z=Kb6WHEzpbxuHFHdCaEUKWrQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] clk: qcom: gcc-sm8550: Fix shared clk parking breakage
To: Stephen Boyd <swboyd@chromium.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	Stephen Boyd <sboyd@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, patches@lists.linux.dev, 
	linux-clk@vger.kernel.org, Taniya Das <quic_tdas@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 20 Aug 2024 at 05:06, Stephen Boyd <swboyd@chromium.org> wrote:
>
> Amit Pundir reported[1] that a recent commit 01a0a6cc8cfd ("clk: qcom:
> Park shared RCGs upon registration") broke USB and audio on sm8550-hdk.
> These two patches fix the issue by skipping the parking bit of the
> shared RCGs for devices that can't run so slow.
>
> [1] https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com/
>

Thank you for the patches Stephen. This series fixes the serial
console garbage, audio, and USB-C host mode regression I see on
SM8550-HDK running AOSP.

Tested-by: Amit Pundir <amit.pundir@linaro.org>


> Stephen Boyd (2):
>   clk: qcom: gcc-sm8550: Don't use parking clk_ops for QUPs
>   clk: qcom: gcc-sm8550: Don't park the USB RCG at registration time
>
>  drivers/clk/qcom/clk-rcg.h    |  1 +
>  drivers/clk/qcom/clk-rcg2.c   | 30 +++++++++++++++++++
>  drivers/clk/qcom/gcc-sm8550.c | 54 +++++++++++++++++------------------
>  3 files changed, 58 insertions(+), 27 deletions(-)
>
>
> base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
> --
> https://chromeos.dev
>
