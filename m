Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15110D507
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 22:26:19 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id ge21-20020a17090b0e1500b002308aac5b5eso338335pjb.4
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 14:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iHxAFePE6v7rT4zOswJZdtSc+7UyWrXh0p5Q9UZZyzE=;
        b=lKfqlinQAeUhCIbSFIAy3NQ96mYo9oFgw3RGTz4iYu0FpfOVZfGxOdGngYCk6NwoU2
         7UARxZhoaYrcQPanC+zuDeqJRcmjmhq82eYXVYI8LCKnrB1lj3npybqxkBhC7JK2Qwky
         /bAIc02GG0JqaH/u0uHl0lUyF1KWhV1iJ7Dwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iHxAFePE6v7rT4zOswJZdtSc+7UyWrXh0p5Q9UZZyzE=;
        b=NwGDvbQ4cbxvOnu8TIIFlyJ9B+YrVjVnrwKHk1VOwiAHN0bJZkqTQgg2IAugaJvjDJ
         34qQ5hceukZn557s7ZlBM/XuNdX9j1gWK2ZlsMRklqch5xXnNxGH4+0gVLzGn7A6mfuL
         qh4AvJ8y+H227KrN1I/jZy+dJCXfzp/WaPSDLtXWXto7BCiXsUaJe39A/lRpAlQfxGxN
         z5Kc3QnezHcg5UbU4tRvurP112oNonfZd1hNZRbmesKfHnyVYPMtHVJ8y7k4fR8E8+hY
         6yp7TQwUzIjgHmGJLyCEAiyuX27akYmeEjnJG1moEUH4pXJMmqx9CVq3npQCzd9SpJJs
         oMAQ==
X-Gm-Message-State: AO0yUKUgf4IQcuMColWHYPzQO1Ti6DjZEBBEXWGZQ7X8CWbBckuaScJg
	m7CCMMlRrJkzmRUKqNEaz2SzaA==
X-Google-Smtp-Source: AK7set98RIMuVhD340OlniJTOMaJOWCS/UuD2DMsBdRnheHbwkuTw6SV50oE5XAftSx9a+3PbDm2Og==
X-Received: by 2002:a17:902:ec8c:b0:196:1087:ee04 with SMTP id x12-20020a170902ec8c00b001961087ee04mr14679200plg.18.1675463179244;
        Fri, 03 Feb 2023 14:26:19 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:44f:ac27:361d:7805])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b0019602263feesm2095071pla.90.2023.02.03.14.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:26:18 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v3 0/5] phy: qcom-qmp-combo: Backport some stable fixes
Date: Fri,  3 Feb 2023 14:26:11 -0800
Message-Id: <20230203222616.2935268-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the qmp phy driver was split it looks like 5.15.y stable kernels
aren't getting fixes like commit 7a7d86d14d07 ("phy: qcom-qmp-combo: fix
broken power on") which is tagged for stable 5.10. Trogdor boards use
the qmp phy on 5.15.y kernels, so I backported the fixes I could find
that looked like we may possibly trip over at some point.

USB and DP work on my Trogdor.Lazor board with this set.

Changes from v2 (https://lore.kernel.org/r/20230113204548.578798-1-swboyd@chromium.org):
 * Keep conditional that can't be removed from last patch
 * Rebase to latest 5.15.y stable tree

Changes from v1 (https://lore.kernel.org/r/20230113005405.3992011-1-swboyd@chromium.org):
 * New patch for memleak on probe deferal to avoid compat issues
 * Update "fix broken power on" patch for pcie/ufs phy

Johan Hovold (5):
  phy: qcom-qmp-combo: disable runtime PM on unbind
  phy: qcom-qmp-combo: fix memleak on probe deferral
  phy: qcom-qmp-usb: fix memleak on probe deferral
  phy: qcom-qmp-combo: fix broken power on
  phy: qcom-qmp-combo: fix runtime suspend

 drivers/phy/qualcomm/phy-qcom-qmp.c | 89 ++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 28 deletions(-)

Cc: Johan Hovold <johan+linaro@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>

base-commit: 9cf4111cdf9420fa99792ae16c8de23242bb2e0b
-- 
https://chromeos.dev

