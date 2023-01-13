Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FA3320F
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 20:45:52 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id o13so20051101pjg.2
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 12:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oBsnza7SjgnXFTIjLQUDwUcM1ztzwvsDYDJycxWPRuM=;
        b=fuxKQIX4GR/eDBiDhjV4CW0niwbhXkxfJ/TM8VnS3wi8/N4+NaR71L5t1VxEjktnvl
         +5S2NjYa9zX/G5bYUyXsJyx4c4KSw2TWkzpNecUl19IS0+x8fXpIzufoQbgaXE6sQm9t
         e/zSqznM+RQYAIQZOOpFaKliJdXqtCr2M/x0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oBsnza7SjgnXFTIjLQUDwUcM1ztzwvsDYDJycxWPRuM=;
        b=Sub0yWznAMcoE97THQg7oPn0EQ7WbK4e6KNBrlu67juXn3+VjNdBs/CEFpNhgaLKpZ
         O5i8wU8NJOdPBDg/DVLNnpEx6yxUGbdsoQcxHTAdZZp/P8gLNgX0wJLFTtf0lxCZe5JJ
         /FaHvcQZ9LSReadks8KptwAb6mbdBGja5Is20fdEw2wZmfiMA3auxu23eBSrTUhJlEUT
         fgETbFwhisfJLtGLIUiGK7w/vpr+r1ILtZyZhpU0wtgO4xMTHuJu6Vxfc8/1SA77WIZi
         O+eOpG7fxaAW6vteLAJ1JIBDz6pHO10MxoElOzYs8gGBkKVj9dvRiW7Fuu6brIuT8jpW
         0s2g==
X-Gm-Message-State: AFqh2kruvMTuzDMfyqYf8PcfLpY2pKGyQc9RePXWBZL4qfjth/FIG6l2
	O7ivkia/H4+zmBPDmUp7gk/aEQ==
X-Google-Smtp-Source: AMrXdXuPPgSWqm02NFgZb/rwdZksyLT26TQx05NI4EC+9K85sk+xYfvLjW2F/eEZQHMlVPhY5ovpNw==
X-Received: by 2002:a05:6a20:93a7:b0:b0:42a5:fe24 with SMTP id x39-20020a056a2093a700b000b042a5fe24mr104817648pzh.4.1673642751435;
        Fri, 13 Jan 2023 12:45:51 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id f21-20020a170902e99500b001945b984341sm4010081plb.100.2023.01.13.12.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 12:45:50 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y v2 0/5] phy: qcom-qmp-combo: Backport some stable fixes
Date: Fri, 13 Jan 2023 12:45:43 -0800
Message-Id: <20230113204548.578798-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
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

Changes from v1 (https://lore.kernel.org/r/20230113005405.3992011-1-swboyd@chromium.org):
 * New patch for memleak on probe deferal to avoid compat issues
 * Update "fix broken power on" patch for pcie/ufs phy

Johan Hovold (5):
  phy: qcom-qmp-combo: disable runtime PM on unbind
  phy: qcom-qmp-combo: fix memleak on probe deferral
  phy: qcom-qmp-usb: fix memleak on probe deferral
  phy: qcom-qmp-combo: fix broken power on
  phy: qcom-qmp-combo: fix runtime suspend

 drivers/phy/qualcomm/phy-qcom-qmp.c | 97 ++++++++++++++++++-----------
 1 file changed, 61 insertions(+), 36 deletions(-)

Cc: Johan Hovold <johan+linaro@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>

base-commit: d57287729e229188e7d07ef0117fe927664e08cb
-- 
https://chromeos.dev

