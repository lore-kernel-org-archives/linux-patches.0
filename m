Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DCA7E
	for <patches@lists.linux.dev>; Fri, 20 May 2022 23:21:55 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id wh22so18002171ejb.7
        for <patches@lists.linux.dev>; Fri, 20 May 2022 16:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f989wjQBWky1VnvYFagt1zjTfmuK0hLH870FJFKov5Q=;
        b=V+kj5frWT026Sqek0GhQVobd/rXWEguXk45ZmlnyWIvQCGnsAhnGB4YNjWneQ9yzIo
         nXGaoT/lYx6hAxi0VlTEH2ST42EmfMSwH/eh2HQhA2aSYo3PaApIA++ilEBadxkzs6As
         ILXzSTtH1x1yby8OP+C8kScsWWyWM+hnoBoVE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f989wjQBWky1VnvYFagt1zjTfmuK0hLH870FJFKov5Q=;
        b=ID6Qf0mKuIucJYNNBv6UqD1OvUbMzjW0zb0nNAHSsBN1HR6P9DaEZ9ptwXK3iN4M4G
         BO3DL1nmQpSEJAvMCnH0oLW07pbZnuK0/9j23oPs/Q3ZwmHTejWi5VHMeB5/Qiupmg/h
         ebYed78/3W+BmSwvU0LA2z0fEWN0efvj7ncyWXWQqDzUeqWdQSBYy4EKt3IRSwPrf1Hs
         rV/8g3ELhUmhUze237Vg/bTakX4b4/vMCKxbm0apFxNDszs9agBhl7O+uWd2Y3u4+Zc1
         HBCGwZ7KgREydlzraiCQ49bEM1BT4+xE0sQ393YN/0uTXrLVJfbDayCQ7BSOGP+igUJk
         1StQ==
X-Gm-Message-State: AOAM533qOacKuOa1JM1dVX2+PS9Srmg7nLQ4UhdGK9RQAhIIv6MWZHvV
	OK9kfzCoAzK3TCS6uzhbhIbwg/KWr9z0GHwPBYA=
X-Google-Smtp-Source: ABdhPJyhtzdqYAw4OxkVSwHAyMRYyNx8Zt0w7eDZvh8gx0ZTfPfg8f1be1pqdn1aKRK18t1d7xRA3Q==
X-Received: by 2002:a17:907:86ab:b0:6f5:93d:e106 with SMTP id qa43-20020a17090786ab00b006f5093de106mr10439238ejc.573.1653088913885;
        Fri, 20 May 2022 16:21:53 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id c21-20020aa7c995000000b0042aaacd4edasm4930891edt.26.2022.05.20.16.21.52
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 16:21:52 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id e28so12704496wra.10
        for <patches@lists.linux.dev>; Fri, 20 May 2022 16:21:52 -0700 (PDT)
X-Received: by 2002:a5d:5085:0:b0:20d:5f6:63fa with SMTP id
 a5-20020a5d5085000000b0020d05f663famr9821782wrt.679.1653088911844; Fri, 20
 May 2022 16:21:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220520231355.1559104-1-swboyd@chromium.org>
In-Reply-To: <20220520231355.1559104-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Fri, 20 May 2022 16:21:39 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WFnq42qBgsASPD9_71zFehO3kW2jPWPaD8L5AzixCbjA@mail.gmail.com>
Message-ID: <CAD=FV=WFnq42qBgsASPD9_71zFehO3kW2jPWPaD8L5AzixCbjA@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: Remove duplicate sc7180-trogdor include
 on lazor
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>, Matthias Kaehlcke <mka@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Fri, May 20, 2022 at 4:14 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> The sc7180-trogdor-lazor-*.dtsi files all include sc7180-trogdor.dtsi
> and sc7180-trogdor-lazor.dtsi, so including it here in the
> sc7180-trogdor-lazor.dtsi file means we have a duplicate include after
> commit 19794489fa24 ("arm64: dts: qcom: Only include sc7180.dtsi in
> sc7180-trogdor.dtsi"). We include the sc7180-trogdor.dtsi file in a
> board like sc7180-trogdor-lazor-r1.dts so that we can include the
> display bridge snippet (e.g. sc7180-trogdor-ti-sn65dsi86.dtsi) instead
> of making ever increasing variants like
> sc7180-trogdor-lazor-ti-sn65dsi86.dtsi.
>
> Fix this by dropping the include and making a note that the
> sc7180-trogdor-lazor.dtsi file must be included after
> sc7180-trogdor.dtsi
>
> Reported-by: Douglas Anderson <dianders@chromium.org>
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Fixes: 19794489fa24 ("arm64: dts: qcom: Only include sc7180.dtsi in sc7180-trogdor.dtsi")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Douglas Anderson <dianders@chromium.org>
