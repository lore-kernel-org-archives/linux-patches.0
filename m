Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235592F37
	for <patches@lists.linux.dev>; Mon,  7 Nov 2022 19:15:38 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id h193so11273239pgc.10
        for <patches@lists.linux.dev>; Mon, 07 Nov 2022 11:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dCHSGnCFJ0y/u8SQ+Xtk+pvjFKxhWsoTtgBkVZ7qxaM=;
        b=TwTXuGCgoe+Z65wLfGNAl2YpRz2wltTlH9WaarTkzyxcNuqjq7OP/xRtRRBMbAKp/r
         yBLXUgFsTL3cz7EnQAj/lTBse27z/05qQbXwve0LY0Qhyox4COYPH5+V5SLO/lBcFYK8
         BqbpdoK40GlI5FVGftaGRXyN3+w6eU8I99ZA8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dCHSGnCFJ0y/u8SQ+Xtk+pvjFKxhWsoTtgBkVZ7qxaM=;
        b=kqfmJgXdervpTUa3N0VEOa/Fu0Go78o9nfmrs8VsTZgJuX16iEz6zQ4d7hFglMLYLy
         5cfV0liAkQSLkMZUG+hLoe2oJfumlg5v+FUYe70ajGmKz7IB3xJYhqTWwioaPFGQmbJh
         Tmx28ph6gwChV5qvFGeZ/ulhS2gCOtcaJdcjX1Ywdf0mPAGAG5iMD/QQmHgCfmjhcQuk
         vT9CmSNUpDaGy8s8RmnSdPG9+Aq7lHq/NgNAOgx+5B9N6/XnuZ4SFaohxN4l6A4+f4dQ
         5vZAx2/juBeesZpZ9NTPL+vqzjjCnF6bhbW0OyehOm7jw9UNQbClPxMR9CCf3vWrDAQM
         PTxQ==
X-Gm-Message-State: ACrzQf01924AVwPVM1Jwvo7832sNFQGetXTm8zBndlVVeqG3B7R20jX4
	A5RB1Lngidv1dSAw3YQ8JGk7GQ==
X-Google-Smtp-Source: AMsMyM57yEmLDsxYkqy5WClNr4Ff1qFsZt/FJwLmrYrNwVcO744HMtZOn/erJGiCcLU+9G/pqnohcg==
X-Received: by 2002:a05:6a00:2285:b0:56d:5d42:3aa8 with SMTP id f5-20020a056a00228500b0056d5d423aa8mr44174929pfe.79.1667848538360;
        Mon, 07 Nov 2022 11:15:38 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id r11-20020a170902c60b00b001830ed575c3sm5306627plr.117.2022.11.07.11.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 11:15:37 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Matthias Kaehlcke <mka@chromium.org>,
	Alexandru M Stan <amstan@chromium.org>
Subject: [PATCH v2 0/2] Update fingerprint node on herobrine/trogdor
Date: Mon,  7 Nov 2022 11:15:33 -0800
Message-Id: <20221107191535.624371-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series updates the binding for the Trogdor and Herobrine
boards' fingerprint node. Now that the binding has been accepted[1]
we're ready to merge this in the qcom tree.

Changes from v1 (https://lore.kernel.org/r/20220317010640.2498502-1-swboyd@chromium.org):
 * New patch for trogdor

Stephen Boyd (2):
  arm64: dts: qcom: Fully describe fingerprint node on Herobrine
  arm64: dts: qcom: Fully describe fingerprint node on Trogdor

 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi  | 20 +++++++++++++++++--
 .../arm64/boot/dts/qcom/sc7280-herobrine.dtsi |  5 ++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

Cc: Douglas Anderson <dianders@chromium.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Alexandru M Stan <amstan@chromium.org>

[1] https://lore.kernel.org/r/166718941539.790.4332712127794687523.git-patchwork-notify@kernel.org

base-commit: 95fade4016cbd57ee050ab226c8f0483af1753c4
-- 
https://chromeos.dev

