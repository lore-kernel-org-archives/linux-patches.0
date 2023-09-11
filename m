Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB82011706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF3DC433C8;
	Mon, 11 Sep 2023 14:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443514;
	bh=QT0q63fr/xeQGXOzFaiFj/4S4NaQugSBh/tH2iN/Lqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hx98m1nnAWniaEWFDq8zshVBYq05P8RFlL7ILBGciaiVAyzkZ27xVNa3RxlANz1bv
	 gVC4/TyhgO61brvG2rCH8OO87srhDEBbQqqp9FcXDiDK21UVR2MxCBaC6mB977QuuW
	 AiuO9NJ8fId89sWLuDNSJ9hx7o3b3M6XyNUbjJnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 405/737] of: unittest: Fix overlay type in apply/revert check
Date: Mon, 11 Sep 2023 15:44:24 +0200
Message-ID: <20230911134701.939118227@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 6becf8f845ae1f0b1cfed395bbeccbd23654162d ]

The removal check in of_unittest_apply_revert_overlay_check()
always uses the platform device overlay type, while it should use the
actual overlay type, as passed as a parameter to the function.

This has no impact on any current test, as all tests calling
of_unittest_apply_revert_overlay_check() use the platform device overlay
type.

Fixes: d5e75500ca401d31 ("of: unitest: Add I2C overlay unit tests.")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/ba0234c41ba808f10112094f88792beeb6dbaedf.1690533838.git.geert+renesas@glider.be
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index be41eb246b6b2..03a1de841d3b7 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -2210,7 +2210,7 @@ static int __init of_unittest_apply_revert_overlay_check(int overlay_nr,
 	of_unittest_untrack_overlay(save_ovcs_id);
 
 	/* unittest device must be again in before state */
-	if (of_unittest_device_exists(unittest_nr, PDEV_OVERLAY) != before) {
+	if (of_unittest_device_exists(unittest_nr, ovtype) != before) {
 		unittest(0, "%s with device @\"%s\" %s\n",
 				overlay_name_from_nr(overlay_nr),
 				unittest_path(unittest_nr, ovtype),
-- 
2.40.1



