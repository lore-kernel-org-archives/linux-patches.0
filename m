Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715657B
	for <patches@lists.linux.dev>; Fri, 29 Apr 2022 00:30:20 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id s14so5759723plk.8
        for <patches@lists.linux.dev>; Thu, 28 Apr 2022 17:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jmljM4FICPNK95l/noM5ZqyzaP70WYeuCPsRfukH3zY=;
        b=HL/MPvnZa4kAs14Bpx2qes8HJc/78pX0p3ekNAtGu9o1l5XhdX4BW/Vu+CP/yaoyg9
         qVA8SFH+sCtqAdq60kc0UpEyxr4j1sEM+r3+4FpWYV4Efaj9SaAW0Jqd0eYUhs++WnNU
         aM/7YPvyXUgqk5kns1OGlMQr4gEv+SOv+Nj2k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jmljM4FICPNK95l/noM5ZqyzaP70WYeuCPsRfukH3zY=;
        b=ryTZjNzWUz7L1r5tG86asCEqHuuYMht4azIwF/8Z30NSkt/kivGETLuocKMw+721+/
         SDqq2LT4uczm4hNodT6GBsHoHV5SdhmL1+zf/DnbDkDZxR4j8OkmSUGQqMX2RzBEtwkh
         B4BZQr8xyvHFhgQefKnkLZDZth1watF3qSfoFfNW2uDH/ifVxBleAFCWqEAik/mLEDyo
         wwe+ouU2LMA/yETi+/i+MJ9OsuSNlnWeFZ5KDHaNnNlNTe7x3jKwB4Suyj4QO6wU0KZK
         jMjvG47Yfz5rrQ6et75nk/l1elEMxnYuzFS88L245OdxUoL748cHmAIL/nsXH/a5jYeA
         GjVg==
X-Gm-Message-State: AOAM531+t2J1tymqFP8Oj4a2Qa2XkBNdyIdtL/cga/cNk3yPXLtkfUg2
	yVUSmNH3Hv1KkDxPVUvO9kZvOA==
X-Google-Smtp-Source: ABdhPJwxcuz8buO11jDSkmrug/EvrwKpN67kCAVXPYAtg1DJlGtv1dxcrFgy/3qS1eexgynXqygYSQ==
X-Received: by 2002:a17:902:da85:b0:15d:3a9a:aad1 with SMTP id j5-20020a170902da8500b0015d3a9aaad1mr14838800plx.113.1651192219978;
        Thu, 28 Apr 2022 17:30:19 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:7d14:5f45:9377:9b6a])
        by smtp.gmail.com with UTF8SMTPSA id x4-20020a628604000000b0050d2ff56603sm945978pfd.60.2022.04.28.17.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 17:30:19 -0700 (PDT)
Date: Thu, 28 Apr 2022 17:30:18 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	"Joseph S. Barrera III" <joebar@chromium.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 3/3] arm64: dts: qcom: Only include sc7180.dtsi in
 sc7180-trogdor.dtsi
Message-ID: <YmsxmjykRaykun32@google.com>
References: <20220427020339.360855-1-swboyd@chromium.org>
 <20220427020339.360855-4-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220427020339.360855-4-swboyd@chromium.org>

On Tue, Apr 26, 2022 at 07:03:39PM -0700, Stephen Boyd wrote:
> The SoC is always present on sc7180-trogdor.dtsi and thus we should
> include it in the "generic" dtsi file for trogdor. Previously we had
> removed it from there because we had to do the spi6/spi0 swizzle, so
> each trogdor variant board had to include sc7180.dtsi and then
> sc7180-trogdor.dtsi so that the latter dtsi file could modify the right
> spi bus for EC and H1 properties that are common to all trogdor boards.
> 
> Now that we're done with that we can replace sc7180.dtsi includes with
> sc7180-trogdor.dtsi and include sc7180.dtsi in sc7180-trogdor.dtsi as
> was originally intended. We still need to include sc7180-trogdor.dtsi
> before the bridge dtsi files though because those rely on the panel
> label.
> 
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
