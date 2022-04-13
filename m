Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FBB23BD
	for <patches@lists.linux.dev>; Wed, 13 Apr 2022 03:33:37 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id t4so622930pgc.1
        for <patches@lists.linux.dev>; Tue, 12 Apr 2022 20:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFDMYEJJJV4Dm4yq2iSPTcjmX9mNaLzAYx2JFyM8cxU=;
        b=UQYAdhGry+SuSzcGGY9z2ZyE0Fmpw7Zl5XqiQsCx1LE+kdYD7uNE/J+kjhveH3HQAV
         wGoUNxLBXw1pQjCyPJnbNrY/2J9tDkjLEkg7sQABZVTX8zm1JU29wTf3AP2isq2wnuX6
         Fsen15PJeUG5cP5g/ckjxlFriKKe1viowIJrg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFDMYEJJJV4Dm4yq2iSPTcjmX9mNaLzAYx2JFyM8cxU=;
        b=6cF+9lvrWevGOHCb/WlQ4hFQvb/M7nTDjbcPrK2agnr5E7KTNP0EputilslShvtK7d
         1vVAu6ul61Nja094fNqDdCAO4wC2/reG3MrmZ+US10rCLhZj8Vt/XIVXSf4rGcruNWg4
         sRL2aT1IwsirplaZP5mmnYp9Ed9ZxYQ+bnIoKM8p0HuS59SDB0RhWsdW6s/9/tJizSJW
         8z9AdBObfcX3qstBUnDfNpgVNTcNldqa7jhIFffx7FdzY7YU2PIu7ORCNlYvLdOIGTjs
         A0zp4Shyx1BlSDq9F/UlnJrzjclA+c/4FNAAbaCgzJqB01a8ht/hUvqEHESHHCP4eg2p
         bxEA==
X-Gm-Message-State: AOAM532DpT/pbXpZpKKI3oksLVJ+r+Dw4/dR/PzYdWuU256NrZLvAmPo
	KEkRMcTGRdDQBRVLI8ybM+ThRw==
X-Google-Smtp-Source: ABdhPJxo/Vu7AljpfVLohpoNHB6gSDViR/XOVE6fP0sezT0TZemgRYmKXJC1JNokbplnSB6Im1W5LQ==
X-Received: by 2002:a63:770c:0:b0:39d:adf2:ba83 with SMTP id s12-20020a63770c000000b0039dadf2ba83mr1811498pgc.184.1649820817164;
        Tue, 12 Apr 2022 20:33:37 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:87b3:e0ea:c924:6d1f])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm39788276pfh.23.2022.04.12.20.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 20:33:36 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-input@vger.kernel.org,
	chrome-platform@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>
Subject: [PATCH 0/2] Input: cros-ec-keyb: Don't register keyboard if doesn't exist
Date: Tue, 12 Apr 2022 20:33:32 -0700
Message-Id: <20220413033334.1514008-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're registering a keyboard input device on detachable chromebooks when
that input device doesn't generate any events. This patch series stops
doing that to save some runtime memory and to help userspace understand
that there really isn't a keyboard present when the keyboard is
detached. The second patch is an RFC because it should be picked up
through arm-soc tree, not input tree.

Stephen Boyd (2):
  Input: cros-ec-keyb: Only register keyboard if rows/columns exist
  arm64: dts: qcom: sc7180-trogdor: Remove cros-ec keyboard from
    detachables

 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi   | 5 +++++
 arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi | 5 +++++
 drivers/input/keyboard/cros_ec_keyb.c                 | 9 +++++++++
 3 files changed, 19 insertions(+)

Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Hsin-Yi Wang <hsinyi@chromium.org>

base-commit: 3123109284176b1532874591f7c81f3837bbdc17
-- 
https://chromeos.dev

