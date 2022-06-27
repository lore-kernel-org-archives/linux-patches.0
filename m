Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB8E46A8
	for <patches@lists.linux.dev>; Mon, 27 Jun 2022 20:03:53 +0000 (UTC)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-101b4f9e825so14320424fac.5
        for <patches@lists.linux.dev>; Mon, 27 Jun 2022 13:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zr/71miOpGKhog20TP0jCDwC/vOlvLa7msJCs05sI18=;
        b=IwisUBbN+ASrCJgfo69Rxxo0VEEFNMfOCTz8jToryKFzQyoMziiy1k66cS5vxubdRx
         hQvofkfcB28kcQanwUfEs14pPPBb3rX+wWa9i29LGy4Fd1Rb+0WHz0MqH5vmcaKxhOSb
         W+hl7YwdIDkoC7fnOwbNU/ez2TmFbMlQuOcrLraqMi8fDRadNFHC17s3yWC/zMvQ+O2/
         +vtZMteEid14WD1ORXMtjNDj5AYj60JrrdqAG95XDD7UL7tRb2aJqzw+bS4hIxGBu0li
         E7bQU9gVDccu4LCgtfb6KEqLIneqnJAhM8ALJOt5Fqd208NR38LflA2KhIUNYgQi2bUN
         minQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zr/71miOpGKhog20TP0jCDwC/vOlvLa7msJCs05sI18=;
        b=j0QW5kSvcA5wOoWuockWjClugIktJDtt8etacUy3eGUzzhPRuN9OIKbikrmGXT7gwr
         HEdpMeAfvKIQfbLLriaF174s1kmYt1hbPDOi8hgnSvm2fv0Ar3nDJmxkvf9u98fiBE9o
         vG27/tIRWp8GoMq/LGmBiYX98FAZx8gZxRnl/fPG2Zfe/fxeNAag5tqY668olfdj2yNJ
         Ft2yScOsW+dIp/lM00O4bOXIyu6LmjPv2pNlULEB8DAa4jCqzd7/gv0Q+G463KKYYPCE
         Y/q/YSFVdBdlcFquN/qAWLddd0fZBETdnVmK4eAttpfH9K/nkTTOFr/Fzyf7qUXm60Ik
         tdAw==
X-Gm-Message-State: AJIora/UIg0pRqdH0otB/RhYl4dfcc+yDwx2/u5VB7plWRiauCE7VT1c
	rG6egyWPv9t/s8xNuWdIUoeShg==
X-Google-Smtp-Source: AGRyM1vD/kgEZjgwPs0to4i2WZxKRjbJaz78WOZQQYkjuwx8IzcI8TCTSCVhuNq4mGb9SKkNPpWWDg==
X-Received: by 2002:a05:6870:8e1b:b0:108:561a:79be with SMTP id lw27-20020a0568708e1b00b00108561a79bemr10195365oab.243.1656360232259;
        Mon, 27 Jun 2022 13:03:52 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id m16-20020a4a9510000000b0041bdf977c6dsm6428729ooi.31.2022.06.27.13.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 13:03:51 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Andy Gross <agross@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>
Cc: Alex Elder <elder@linaro.org>,
	linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>
Subject: Re: (subset) [PATCH] arm64: dts: qcom: sc7180: Remove ipa_fw_mem node on trogdor
Date: Mon, 27 Jun 2022 15:03:05 -0500
Message-Id: <165636016348.3080661.5219140331391727062.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220517193307.3034602-1-swboyd@chromium.org>
References: <20220517193307.3034602-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 17 May 2022 12:33:07 -0700, Stephen Boyd wrote:
> We don't use this carveout on trogdor boards, and having it defined in
> the sc7180 SoC file causes an overlap message to be printed at boot.
> 
>  OF: reserved mem: OVERLAP DETECTED!
>  memory@86000000 (0x0000000086000000--0x000000008ec00000) overlaps with memory@8b700000 (0x000000008b700000--0x000000008b710000)
> 
> Delete the node in the trogdor dtsi file to fix the overlap problem and
> remove the error message.
> 
> [...]

Applied, thanks!

[1/1] arm64: dts: qcom: sc7180: Remove ipa_fw_mem node on trogdor
      commit: e60414644cf3a703e10ed4429c15263095945ffe

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
