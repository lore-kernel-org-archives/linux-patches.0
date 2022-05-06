Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ACB7F
	for <patches@lists.linux.dev>; Fri,  6 May 2022 15:03:21 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id e189so7735486oia.8
        for <patches@lists.linux.dev>; Fri, 06 May 2022 08:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3k1CGf7ROX57d+5WZUD3Ci9D6iHGah8jUhJeYX8XYVE=;
        b=GLkj6Hv5d/A5rE/9DD6Tzor0/u1/R/gZYcHd8t7Sy1NbQe6ebZCGTY762QhRQ39y+J
         ZhuI+4PIwKDznGkJLClhPL3BRzBtCiJa06rjtiEfVYKL7gbaKUtX1nJ45dmd6L3Z4YN8
         dfcjiIsjQfuUHyIqb1UuaVwUXzwg+458tf/oMWnBDGs/Ev9ClKWlNeXLz/4Uqvu2OgUS
         PitxsoJisvfa4QiH1CzmlQH+HLGJiMXYItrbfkHiNVwbFN4HJ8C9foBql73pSv/RVZma
         8ki1qSiuRhMcSknR2/R5qIRwXorgaeCFDSQFRyGi5w0Y8cCC5m8jv1FZlH/s8ApQK2cN
         HeSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3k1CGf7ROX57d+5WZUD3Ci9D6iHGah8jUhJeYX8XYVE=;
        b=1EPwNJIyzOSwFPoqxev8sRYa7OIWNgM1BtFtCEn4ygkKNtMGNnLYChlkG1Eet12NFg
         9swjtzeNYhsnD4ddkOhM/SGdTAgjWoti4IZlQ2xcLUaSntxTRCi+qEKzqiPP5cQsmfwD
         Dw9PVpOLWg3zxpsrjYtTrut7HyUsx4kH+nanOKIWtGfMWoyLFSqLrMNc0nNUO7faFZG9
         3RNhiccwbQ/ocN2qyI0r4B4KVTFG/QWCnnZMXkmy8aoaAc3W2vtYuqF/Am0nueE5SrJQ
         3cAwpMVEWAKWqYSnPHEjd3H+LosWRp0gBBsYeXkM+kGW2+5KcGM5168Xx3igdV8nKIMH
         Ju2A==
X-Gm-Message-State: AOAM531zlogTmhUX9saLSg3xBK4jGqVO1UfK963buws0klHKGuQfQ9Jm
	MKsPRXrzQF4dLgbe9dLNM12kUQ==
X-Google-Smtp-Source: ABdhPJzthI21WXpbvORv0sr+tLijGFfFfgXmJyntLomCPe5H9CG1iqJcxfJs7oj+WmXU+xuUw55ANQ==
X-Received: by 2002:a05:6808:1917:b0:326:9989:5db with SMTP id bf23-20020a056808191700b00326998905dbmr750764oib.24.1651849400469;
        Fri, 06 May 2022 08:03:20 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id e21-20020a056808111500b00325cda1ffb9sm1665311oih.56.2022.05.06.08.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:03:19 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>,
	Andy Gross <agross@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	patches@lists.linux.dev,
	"Joseph S. Barrera III" <joebar@chromium.org>,
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] arm64: dts: qcom: sc7180-trogdor: Simplify!
Date: Fri,  6 May 2022 10:03:08 -0500
Message-Id: <165184936433.73465.13214953449519830284.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220427020339.360855-1-swboyd@chromium.org>
References: <20220427020339.360855-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 26 Apr 2022 19:03:36 -0700, Stephen Boyd wrote:
> Here's a couple patches to simplify sc7180-trogdor dtsi files further.
> There will be logical conflicts with the wormdingler patch because it
> will need to have similar changes done for the swizzle and include, but
> that can be cleaned up later or I can resend if the wormdingler patch
> gets merged first. Either way nothing will be broken from what I can
> tell.
> 
> [...]

Applied, thanks!

[1/3] arm64: dts: qcom: sc7180-trogdor: Simplify trackpad enabling
      commit: 51d30402be7506db007af6d29c6bc7c1cefcc82f
[2/3] arm64: dts: qcom: sc7180-trogdor: Simplify spi0/spi6 labeling
      commit: d277cab7afc7b54ea91808c0895d78c2021af534
[3/3] arm64: dts: qcom: Only include sc7180.dtsi in sc7180-trogdor.dtsi
      commit: 19794489fa2474a55c00848e00ca3d15ea01d36c

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
