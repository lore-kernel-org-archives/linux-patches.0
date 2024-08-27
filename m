Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43A31D27A0
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 18:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724782355; cv=none; b=uwbSvFuuLwSdqk0BLDnbSxfqXbCnKVS1+eO77Wtg75M/dBt0a1mCV/I/aUyDLaSiK5HA4eXtKae4oTLnifhP1PfENjZQj4q23uDpY6gppUITglgGqT9Z/VgVJv28JvqQ+2ceRvsXZCF1wDt2KvHCULzFnAY/blO+LFd7a8RcYis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724782355; c=relaxed/simple;
	bh=2Gq+2musOhFx/RMETG21n43RSloaFRXCaGyo+L3E4Wg=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LUP7ekptteE9oMzdjbGGwCDd9LQ5z0DiurpzTWN5IWJk6Fm+oqCFugOcWYTlCPCalZev5lLyhxRsAC1Yqi953cya1RwzJ2NvFOun+kdfyQ98y/bD+8X0QlGjpkhSmYeqxhKHwS9No2pSwLdltJeRr9UFbstc2XSv9/eilOCPku8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=l9jrXdv4; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="l9jrXdv4"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3db22c02a42so600280b6e.3
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 11:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724782353; x=1725387153; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/+UZugxSnKhmm7RFCDsmleDRPP8DXg1UAuzoT1y4+P4=;
        b=l9jrXdv4rxN51HCs4DLn3ZLIcfPAN1N0tQ5iedooXqEe5vBZJBn9apSmf+hTFaLxWn
         u6hvYbpm/ONxxICXgRg9rH3Htgas4vmzm60qV76Z7p7d+nqW4uOIfcG7BSKLDw9GKPBP
         wBNuqe7C1d9mP1KZt7oyC6b9sUzMQzGnro3Q8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724782353; x=1725387153;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+UZugxSnKhmm7RFCDsmleDRPP8DXg1UAuzoT1y4+P4=;
        b=OeeihgwlMhX/vW+bScIjMwlstKC0JXTvTO7uu4D06Xw2fT4MiOhT82VORDAH8H5zIL
         CJBKKr6wDuX9caTFyfeW4n/CXTZw/+L1Q0fmsf0DFDgCldipbCz816Wu+X0sRo8yXPL4
         Es+DazHKIscbFrFIccBE+i2KIeLQ5qHl/prqy/nlLQShXBqRnxhSnkXie5tmQAlMGilj
         MAcNq/kC/Xt26SecgVdobG7aOdSmLHMEr1sW7D+o0cZkYHnWlNGYq9anyzfQfdGubctB
         mmrNpRhrraiE/rbozqzLUkq47t6TqcZdRStXFuM93t4vlGkWO/i+K0qOmhM4v88PO4iG
         BC+A==
X-Forwarded-Encrypted: i=1; AJvYcCXiKEMvgv4nBRXcx7WJj2vGU70A17Ge/QFW/YTbE/vpYhYkpj0yGRLFGZks3lXbADcWo4zQyZdt@lists.linux.dev
X-Gm-Message-State: AOJu0YwfUAAdt0hZV++ZXFV9yX3OMqKlN1RCWEBIU7VGavNmKl4ykB0/
	Flo/oLa2TTc95Zve3JtdMN5AvaJm6IObWl5MT9+vpZaYs37nNdsocGGjE+pdZMx+v7tbVOUHVIG
	zqvF0s3rstmtw5Pty/9F67W/nfM0iIC5FWfPc
X-Google-Smtp-Source: AGHT+IGl0H4rNd8NW0ENgt9xGW7rk51tX57pU2aohNgYNq8W5Pr4zVblVKQwHr9lpbRFsQig9r5rX8R15eQqRrrD7jQ=
X-Received: by 2002:a05:6808:2118:b0:3d5:4256:26d4 with SMTP id
 5614622812f47-3de2a86e26amr17368925b6e.7.1724782352645; Tue, 27 Aug 2024
 11:12:32 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Aug 2024 11:12:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240819233628.2074654-3-swboyd@chromium.org>
References: <20240819233628.2074654-1-swboyd@chromium.org> <20240819233628.2074654-3-swboyd@chromium.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 27 Aug 2024 11:12:32 -0700
Message-ID: <CAE-0n52rYVs81jtnFHyfc+K4wECvyCKmnHu2w9JhPNqvMYEeOA@mail.gmail.com>
Subject: Re: [PATCH 2/2] clk: qcom: gcc-sm8550: Don't park the USB RCG at
 registration time
To: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	patches@lists.linux.dev, linux-clk@vger.kernel.org, 
	Konrad Dybcio <konradybcio@kernel.org>, Taniya Das <quic_tdas@quicinc.com>, 
	Amit Pundir <amit.pundir@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Stephen Boyd (2024-08-19 16:36:27)
> Amit Pundir reports that audio and USB-C host mode stops working if the
> gcc_usb30_prim_master_clk_src clk is registered and
> clk_rcg2_shared_init() parks it on XO. Skip parking this clk at
> registration time to fix those issues.
>
> Partially revert commit 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon
> registration") by skipping the parking bit for this clk, but keep the
> part where we cache the config register. That's still necessary to
> figure out the true parent of the clk at registration time.
>
> Fixes: 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration")
> Fixes: 929c75d57566 ("clk: qcom: gcc-sm8550: Mark RCGs shared where applicable")
> Cc: Konrad Dybcio <konradybcio@kernel.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Reported-by: Amit Pundir <amit.pundir@linaro.org>
> Closes: https://lore.kernel.org/CAMi1Hd1KQBE4kKUdAn8E5FV+BiKzuv+8FoyWQrrTHPDoYTuhgA@mail.gmail.com
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/clk/qcom/clk-rcg.h    |  1 +
>  drivers/clk/qcom/clk-rcg2.c   | 30 ++++++++++++++++++++++++++++++
>  drivers/clk/qcom/gcc-sm8550.c |  2 +-
>  3 files changed, 32 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/qcom/clk-rcg.h b/drivers/clk/qcom/clk-rcg.h
> index d7414361e432..8e0f3372dc7a 100644
> --- a/drivers/clk/qcom/clk-rcg.h
> +++ b/drivers/clk/qcom/clk-rcg.h
> @@ -198,6 +198,7 @@ extern const struct clk_ops clk_byte2_ops;
>  extern const struct clk_ops clk_pixel_ops;
>  extern const struct clk_ops clk_gfx3d_ops;
>  extern const struct clk_ops clk_rcg2_shared_ops;
> +extern const struct clk_ops clk_rcg2_shared_no_init_park_ops;

I'm considering inverting these two rcg2_shared clk_ops so that only a
few clks are parked at clk registration time, to minimize the impact of
commit 01a0a6cc8cfd ("clk: qcom: Park shared RCGs upon registration").
We're up to three or four band-aids, that we can probably wait on
applying if we make all the shared RCGs determine the correct parent at
registration time but skip the parking, except for the display clks on
sc7180 where that exposes another problem with shared parents getting
turned off during probe. It's possible that other SoCs will want to park
their display clks as well to avoid that secondary problem, but it can
be an opt-in case instead of a change to all shared RCGs.
