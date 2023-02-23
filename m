Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032D315B7
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 02:11:01 +0000 (UTC)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-536b7ffdd34so159604237b3.6
        for <patches@lists.linux.dev>; Wed, 22 Feb 2023 18:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=agmt99ERP4Lf0P7eQYv1KVKMj6iSmC6cQgnmN8jVaT8=;
        b=WZvGVnb+n+YRSIPY+/CTmrPz91UCo3sqyZ/dznec+MC+i4V9cCWSWBlKW4EgoThebN
         mW0X9hiTrUKd2Fl+aU0bKGMtGGV6/B97QZ3tL8iPlDkhLGoSVuEceCK6YWTGMVUY7IjD
         MSK4XIDFJyizrXC5JbI2ZfvodH4EuwHJIwUn2RvCpgwTqRNz7oFc3f9mtaV1wfGYP6kS
         tixxSoP9J7YsihVBzmRJ7y/pHmmjJf7LZNyqkYPoaJHLOb1Iu+lYdc5+PqJcE0Gggtdr
         JgQ/816rR88V4fv/WPmnt+dfyAICVmDoRoDxZIAQFXRZVjjfz+WJwOpjx48Eiu6H9XDT
         c2+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=agmt99ERP4Lf0P7eQYv1KVKMj6iSmC6cQgnmN8jVaT8=;
        b=nDyIi8b7JsrauwAalgN5I0fuZEAGMZxBap2WaObz0EAzqVhgwT7MhkOXdE/rAyw8I0
         D3tz1JAC0sYKTLj/jcZav+De8dPuDq2X5WxGNm2BjNcleC32TgohjvtoGMfd1NjHkWUa
         cgwz7/lSxB3W4yAor8cMMPJx9gNgOLZd0273vPvoFKuSQMHb5/KK74sxhHOJ52oeoEqs
         1BdJVrCidR0XE1XSjkQ+Zf2cEaExGG8ZtNq+kfOVgo2iZVBLjI1TjO5rtFeLjLM2xktK
         O0Rqbao3XR40kCUjTn+khGCLuPtIubg9imGAT5ei6SU4i/XkiytJBCj52etCAFK4Ny+L
         0qRA==
X-Gm-Message-State: AO0yUKUbSjN5mVW5wyHykfT2QLXdVCmFBNHbo7YTxYkUvJ1ZylTMWmrw
	wIFVDzMiWMQVGE4fla0CLy2fN0J73ZUVa9B4UJ1W4Q==
X-Google-Smtp-Source: AK7set9EP5ZbyAm7ORU/z9pS5I6CjY2Um0I5400dATxt8qpJFvve4/pI0e0j9SmFqqpSXv14xyD8Sh6ke7po12y3ISQ=
X-Received: by 2002:a25:f203:0:b0:9f8:119a:6f9a with SMTP id
 i3-20020a25f203000000b009f8119a6f9amr1055636ybe.10.1677118260856; Wed, 22 Feb
 2023 18:11:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223013847.1218900-1-sboyd@kernel.org>
In-Reply-To: <20230223013847.1218900-1-sboyd@kernel.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Thu, 23 Feb 2023 04:10:50 +0200
Message-ID: <CAA8EJppgarZnGHEAfNwi768B_wz1jF0WEbTE2W1sWcs2nYRFPg@mail.gmail.com>
Subject: Re: [PATCH] clk: qcom: apcs-msm8986: Include bitfield.h for FIELD_PREP
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Feb 2023 at 03:38, Stephen Boyd <sboyd@kernel.org> wrote:
>
> Otherwise some configurations fail.
>
> Fixes: 027726365906 ("clk: qcom: add the driver for the MSM8996 APCS clocks")
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

> ---
>  drivers/clk/qcom/apcs-msm8996.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clk/qcom/apcs-msm8996.c b/drivers/clk/qcom/apcs-msm8996.c
> index 7ec4022c5b43..3e91e9e6da74 100644
> --- a/drivers/clk/qcom/apcs-msm8996.c
> +++ b/drivers/clk/qcom/apcs-msm8996.c
> @@ -7,6 +7,7 @@
>   */
>
>  #include <linux/bits.h>
> +#include <linux/bitfield.h>
>  #include <linux/clk-provider.h>
>  #include <linux/delay.h>
>  #include <linux/module.h>
> --
> https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
> https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git
>


-- 
With best wishes
Dmitry
