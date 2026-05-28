Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE79D24677F;
	Thu, 28 May 2026 20:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998600; cv=none; b=FkSHnhsqvb2S/1wit3lTBr0Nd7Ag1B63u+jqbIzEVASHYxnNtSHtdLXoU8PhhT62cdY+K21t/kHHm+7Lg/MVT32wgJhp7+4D7PgN0+VRdYv4IU9getVkP/EygOfOeyZK58V/SgIYbJY+AQbtI1YqP/dJHZK1eIYYMuzN6/L8GLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998600; c=relaxed/simple;
	bh=3T8OVkeBcK1ruXu3XVieMMp/5tlL2q8m7X12uw4SXHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ta7RZDG4yyLk8V0VnRqkEpglGvx7behm8IVrnY6C9M2sqVIPNzGIOe5TRFjiowdhAUSO5GCvdqJJLz516LT5RDoJBg96Kdz0HY1w3+sE0FkgLBHUjt2jUCU6QN/jJETkP4YqS/LVsdbe2U4TxT82E8fIhtOSj0vyw+Z72JvniDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cyv/A1mL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cyv/A1mL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60031F000E9;
	Thu, 28 May 2026 20:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998599;
	bh=O3gr39a7bvysjcANWitaEC/daJpG7joHWX84dUokPg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cyv/A1mLVlZDYqAqhukA1hAcrnpU6JcsOki+bbX2Mj4wRCaqcsKvNZQYC69zFEMWY
	 zIfoXCKacZJVLbZ5zMrigf1Y7j/TZ8+ToPOp/2JMvAUTbAJCgw6jpyJogHrV/1wXTY
	 XxM0Je8YP70lHep3j9QOIDLn2TaO9t7SA2efDv8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Ze Huang <huang.ze@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 230/461] phy: spacemit: Remove incorrect clk_disable() in spacemit_usb2phy_init()
Date: Thu, 28 May 2026 21:45:59 +0200
Message-ID: <20260528194653.794336746@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit a4058c09dd6e28ec33316fd6eb45ddae4cab1f31 ]

When clk_enable() fails, the clock was never enabled. Calling
clk_disable() in this error path is incorrect.

Remove the spurious clk_disable() call from the error handling
in spacemit_usb2phy_init().

Fixes: fe4bc1a08638 ("phy: spacemit: support K1 USB2.0 PHY controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Ze Huang <huang.ze@linux.dev>
Link: https://patch.msgid.link/20260326-k1-usb3-v1-1-0c2b6adf5185@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/spacemit/phy-k1-usb2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/phy/spacemit/phy-k1-usb2.c b/drivers/phy/spacemit/phy-k1-usb2.c
index 9215d0b223b2d..e8c1e26428a91 100644
--- a/drivers/phy/spacemit/phy-k1-usb2.c
+++ b/drivers/phy/spacemit/phy-k1-usb2.c
@@ -97,7 +97,6 @@ static int spacemit_usb2phy_init(struct phy *phy)
 	ret = clk_enable(sphy->clk);
 	if (ret) {
 		dev_err(&phy->dev, "failed to enable clock\n");
-		clk_disable(sphy->clk);
 		return ret;
 	}
 
-- 
2.53.0



