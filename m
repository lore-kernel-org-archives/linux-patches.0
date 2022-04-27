Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61420621
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 02:03:42 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id d15so350215pll.10
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 19:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wc+2XZPEQYFH8y8VTjcF8pWwSz487fhH3cfdOdvAYWY=;
        b=mZ8usUoirqcoTx9Hs24a9CJ/Vus3WeuHhFuyQW79gUnyF0wurc/Bx6DpY9EEYitYiy
         x5OBFxn8PVsSVmB6f4nEvvHOMR5x7akAdh5p/MaEh2aopCQAWSZ2X2q56b0xG/M04sZF
         1BteDlHlgMMv6dDVmdphUnP04lkZfHxtWaNgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wc+2XZPEQYFH8y8VTjcF8pWwSz487fhH3cfdOdvAYWY=;
        b=ljBVOqH7kk6wGL3YkmSB2mY+eInbaN/gEDRbeA3uYHjDzr/f0tfrXLPd7Tiwk4cL0U
         MvyHTHqZZp/fJd60HVYdVa9c6cPlRPYufKjpSOf6RKrw9zxVHPCc/+LKxd35HDHQNTkd
         gjkHHGLZHb5iF1j+Qs7A7j9HYsw0sWoQFOnJK7oWlICt/dZxYXKuw0MELrbwgb+bapha
         Zh17iL7xVboE9FcdEfFSke2BcC2hJTApLZUKy3amA8flWhaYjCj14QtvZL8J0D2A8pVM
         hbb+WM12RHi0jfwc6KmGJFoc7JcEZgDFU2Uplp0ww/6TM4gTK1cI8ToJYtFQTP2X+mPT
         //tA==
X-Gm-Message-State: AOAM532Z9ZopTgSkUnRw6Ol7r/2zGeOeJ8KHkOLvwT/xev9EJDPGyL/1
	xoEHTw8HDCer6lxKU7Vdpk5i8g==
X-Google-Smtp-Source: ABdhPJwbzaogkQCtlbv1RZNPvF9OcQIiCWJ5G1M9CMws5WnO3sCYZskphMfOjbW7oZHd3/44RVMyZw==
X-Received: by 2002:a17:90a:3d02:b0:1ca:7f92:1bf1 with SMTP id h2-20020a17090a3d0200b001ca7f921bf1mr41124131pjc.177.1651025021797;
        Tue, 26 Apr 2022 19:03:41 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:482e:60bc:84d1:bf5c])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a0023cf00b004e17e11cb17sm18324197pfc.111.2022.04.26.19.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 19:03:41 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	"Joseph S. Barrera III" <joebar@chromium.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH v2 0/3] arm64: dts: qcom: sc7180-trogdor: Simplify!
Date: Tue, 26 Apr 2022 19:03:36 -0700
Message-Id: <20220427020339.360855-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here's a couple patches to simplify sc7180-trogdor dtsi files further.
There will be logical conflicts with the wormdingler patch because it
will need to have similar changes done for the swizzle and include, but
that can be cleaned up later or I can resend if the wormdingler patch
gets merged first. Either way nothing will be broken from what I can
tell.

I compiled these and diffed the dtbs before and after and found no
changes.

Changes from v1 (https://lore.kernel.org/r/20220325234344.199841-1-swboyd@chromium.org):
 * Another patch to move around sc7180.dtsi includes
 * Fixed trackpad for trogdor-r1 and pompom
 * Made spi0/spi6 patch not as aggressive

Stephen Boyd (3):
  arm64: dts: qcom: sc7180-trogdor: Simplify trackpad enabling
  arm64: dts: qcom: sc7180-trogdor: Simplify spi0/spi6 labeling
  arm64: dts: qcom: Only include sc7180.dtsi in sc7180-trogdor.dtsi

 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi   | 11 +----------
 .../boot/dts/qcom/sc7180-trogdor-homestar-r2.dts      |  2 +-
 .../boot/dts/qcom/sc7180-trogdor-homestar-r3.dts      |  2 +-
 .../boot/dts/qcom/sc7180-trogdor-homestar-r4.dts      |  2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi |  7 -------
 .../qcom/sc7180-trogdor-lazor-limozeen-nots-r5.dts    |  2 +-
 .../qcom/sc7180-trogdor-lazor-limozeen-nots-r9.dts    |  2 +-
 .../dts/qcom/sc7180-trogdor-lazor-limozeen-r4.dts     |  2 +-
 .../dts/qcom/sc7180-trogdor-lazor-limozeen-r9.dts     |  2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r0.dts  |  2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r1.dts  |  2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-r3-kb.dts      |  2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-r3-lte.dts     |  2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r3.dts  |  2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-r9-kb.dts      |  2 +-
 .../boot/dts/qcom/sc7180-trogdor-lazor-r9-lte.dts     |  2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor-r9.dts  |  2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi    |  7 ++++---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi   |  9 ++++-----
 arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts        |  9 ++++-----
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi          |  8 ++++----
 21 files changed, 32 insertions(+), 49 deletions(-)

Cc: "Joseph S. Barrera III" <joebar@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>

base-commit: f238ff81e8946540e1a7c1496aa92fa2386893dc
-- 
https://chromeos.dev

