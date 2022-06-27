Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE994C77
	for <patches@lists.linux.dev>; Mon, 27 Jun 2022 20:03:56 +0000 (UTC)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-fe023ab520so14292212fac.10
        for <patches@lists.linux.dev>; Mon, 27 Jun 2022 13:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7oqCMEdZOFPWtNjZHK0DpD/hkul9N6jiiMvxLAkZPi8=;
        b=c+TaVHeiDxOdRSm0ioO42BbHne9So3WLc5XJeNOZJ0rlSBJX8kDh46TLhftBwFlbWn
         HK7QBu4r6BG9KjAVqWRp5xRRFadAYmtOFHuy0jkt9R6fxCbOzRDCaZmwE5lLBVllCWSB
         hmYTENrkqHis3PiqY8HssRMdCTttNd7AF/LpEcEL2GZL6t71+Rgyt+lXyUCXZVunfKCP
         UO41Kf+TKuX0racjRt7Tfy9WM2qg13jKk7BS5L3zszXk/YC10PfxRAEPcgFg8aIT2v3R
         1uJ+4yBWHLu72quE2OmQT+3JmN1rD0mHTn9I/xgHAs//j/ZeP8lnN9guMrGCo5lxCPA9
         W2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7oqCMEdZOFPWtNjZHK0DpD/hkul9N6jiiMvxLAkZPi8=;
        b=A496TSOrgPYnqtmCYXXyvEASj4/V6BNzpjg+xJcATF5ueUGRvZAXiGFv1myquJO7xf
         dAofRe5aatoN7EQy3/575SQeksQv2vjisZxDi04POB25JXZORUhsq4/UuE56Cabg1loQ
         jHAsJTMSJoxdOYG56KhaBbA6nnml9003TOUbx888UQa7kn8b7ZzlXybWR/uvxIjs58Bq
         koKqcYtKChzf1RSn9vvfvmh2kTrzsRT95XklzjwulbVHq2NjZ+M0YSsLftwW8yJhsuAN
         kWJ4UiBszYA75jwdICsfpZ9yCx37Dz1weKQ3Cb6rmBoefAJafUALGak0A5MTvwBYXCOE
         o6aw==
X-Gm-Message-State: AJIora+ZsL/mXmsXZsWP9CQqE4HpBM+e/F7V83DGEtlNnJZxg/scCby1
	xNQ6IjbOF43onUujjruD80Sdzw==
X-Google-Smtp-Source: AGRyM1sdW18nt1XKn8B2l/2cRF49xuAu2AWS1n2ZrV4v5duSEyRQaafDGupWeaB+wveruRsG7nA6Hg==
X-Received: by 2002:a05:6870:5ba6:b0:f1:5840:f38e with SMTP id em38-20020a0568705ba600b000f15840f38emr11148453oab.210.1656360235978;
        Mon, 27 Jun 2022 13:03:55 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id m16-20020a4a9510000000b0041bdf977c6dsm6428729ooi.31.2022.06.27.13.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 13:03:54 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Andy Gross <agross@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	"Joseph S. Barrera III" <joebar@chromium.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2] arm64: dts: qcom: Remove duplicate sc7180-trogdor include on lazor/homestar
Date: Mon, 27 Jun 2022 15:03:07 -0500
Message-Id: <165636016347.3080661.3020909807591656315.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220602190621.1646679-1-swboyd@chromium.org>
References: <20220602190621.1646679-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 2 Jun 2022 12:06:21 -0700, Stephen Boyd wrote:
> The sc7180-trogdor-{lazor,homestar}-*.dtsi files all include
> sc7180-trogdor.dtsi and sc7180-trogdor-lazor.dtsi or
> sc7180-trogdor-homestar.dtsi, so including it here in the
> sc7180-trogdor-{lazor,homestar}.dtsi file means we have a duplicate
> include after commit 19794489fa24 ("arm64: dts: qcom: Only include
> sc7180.dtsi in sc7180-trogdor.dtsi"). We include the sc7180-trogdor.dtsi
> file in a board like sc7180-trogdor-lazor-r1.dts so that we can include
> the display bridge snippet (e.g. sc7180-trogdor-ti-sn65dsi86.dtsi)
> instead of making ever increasing variants like
> sc7180-trogdor-lazor-ti-sn65dsi86.dtsi.
> 
> [...]

Applied, thanks!

[1/1] arm64: dts: qcom: Remove duplicate sc7180-trogdor include on lazor/homestar
      commit: 372b2aee97028c75a6e12d205a2e5f0c8626efc6

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
