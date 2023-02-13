Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235DD8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCC0C433D2;
	Mon, 13 Feb 2023 14:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300008;
	bh=l5w8aGc2uijod/aRcxK5DaJQ6aqrKb4fHIJGLXiU63s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxfOa4DLY0xt8+QcamHmoIt0gD2uz9H9rQqF73NNNClA5rTSEIuMYCF1IPkO40yV6
	 d+rAPZbB2ytRjRU8BmuJAjJ6mNOiHy2REGxgLGBuMSMK11T4wrHj8KqP+V4hDlO/O1
	 qSWPvZ3saKhpS6SwXhQBoCp8gqnC/HLAEhCdiA4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/114] net: phy: meson-gxl: use MMD access dummy stubs for GXL, internal PHY
Date: Mon, 13 Feb 2023 15:47:43 +0100
Message-Id: <20230213144743.590982716@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 69ff53e4a4c9498eeed7d1441f68a1481dc69251 ]

Jerome provided the information that also the GXL internal PHY doesn't
support MMD register access and EEE. MMD reads return 0xffff, what
results in e.g. completely wrong ethtool --show-eee output.
Therefore use the MMD dummy stubs.

Fixes: d853d145ea3e ("net: phy: add an option to disable EEE advertisement")
Suggested-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/84432fe4-0be4-bc82-4e5c-557206b40f56@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/meson-gxl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 5e41658b1e2fa..a6015cd03bff8 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -261,6 +261,8 @@ static struct phy_driver meson_gxl_phy[] = {
 		.handle_interrupt = meson_gxl_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
 	}, {
 		PHY_ID_MATCH_EXACT(0x01803301),
 		.name		= "Meson G12A Internal PHY",
-- 
2.39.0



