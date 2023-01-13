Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D810D36C
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 00:54:08 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id y1so21919971plb.2
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 16:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xsayLyP7nh0k2HOHnHJ4pw0bqMbBUybwNSC5DyRKIC8=;
        b=bMip9NCrJH3DnbTyVthFl9yIiF3j/16C2WV0j690Wq/w/Ow5h3S79FZMagva/XpF7e
         tXprTN8l54WBgwPZqJBu+hiHHC+UWMy0S1sDG/zAi1P0y/InvPPN7uWHrPBB4hYIiGUO
         0K5gjGa5AztHL5McB0FbEiUggdnsWQcrr3g/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xsayLyP7nh0k2HOHnHJ4pw0bqMbBUybwNSC5DyRKIC8=;
        b=iVC//aVM//PdXRJw43vLX6NhL2bCbZMeGuPgpe6jVgHgFCHsi/t8yVx+MXkuyXSabz
         edTO1ib1IpjZjwh4NPwpE79v4IGCwRh6QhJUlTQVRqAAhercJArSV5EQUw28F0L+35+U
         l5G/YSL6NFlO59CwoQbftxDJ+shrDEJZ8cAm8YljjfqQUo3mgUx08oig3u1bC7u0pgGH
         KN9JyQc/Fof1AOH5inSMLF2GFV6d/pluh/feFDGxciHrNdRNO/IRyTU2VW1SnOrpc4JO
         4DPT1r4ow2lxwl4whcmfj/YAVZB7N69aVEy1dqX+CV9JHOR0xTIGDtnhgwclfss7MDDl
         Q2NQ==
X-Gm-Message-State: AFqh2kqzLs5/6KHwFVomM/LJYlii83gCP4FjFdgXQfIAjaQfDaBIo0F2
	swtLivqKqXXtT/MZBY4kVWPDRg==
X-Google-Smtp-Source: AMrXdXsLH6UhWCasDyJvsSNInG39OEZLlwb5rDlmlSiORB314t+bQ4mWVdUfo0L9yrPzsFD0DI9lCw==
X-Received: by 2002:a05:6a20:9591:b0:ad:7428:d326 with SMTP id iu17-20020a056a20959100b000ad7428d326mr100677310pzb.30.1673571248151;
        Thu, 12 Jan 2023 16:54:08 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id u11-20020a6540cb000000b0046ff3634a78sm10676614pgp.71.2023.01.12.16.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 16:54:07 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15.y 0/4] phy: qcom-qmp-combo: Backport some stable fixes
Date: Thu, 12 Jan 2023 16:54:01 -0800
Message-Id: <20230113005405.3992011-1-swboyd@chromium.org>
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

Johan Hovold (4):
  phy: qcom-qmp-combo: disable runtime PM on unbind
  phy: qcom-qmp-combo: fix memleak on probe deferral
  phy: qcom-qmp-combo: fix broken power on
  phy: qcom-qmp-combo: fix runtime suspend

 drivers/phy/qualcomm/phy-qcom-qmp.c | 72 ++++++++++++++---------------
 1 file changed, 36 insertions(+), 36 deletions(-)

Cc: Johan Hovold <johan+linaro@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>

base-commit: d57287729e229188e7d07ef0117fe927664e08cb
-- 
https://chromeos.dev

