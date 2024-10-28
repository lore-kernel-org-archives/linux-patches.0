Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6016D8837;
	Mon, 28 Oct 2024 06:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098106; cv=none; b=Aq/uYjsKa7OW8wnL27z8y6DcdsMbejaGJ+30RMPCF5SXAK9wdXCsDaKWwzUC5oJyhSqXBF3sxpcrf1hc3VsJGJCYjJ5EP4Op2RWEioiveZiRs1pPASI/40373ngAsVxU6QHuabPd4ppSW9ORGoE2Xfz9m5Ycfnc+2snRg/9Q22A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098106; c=relaxed/simple;
	bh=XBJ/ngkKuBdM28CSpxMxvn1dqbUT2PkvsPOQOgghofY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoMxCmx5t9NmKQc0cHWP9i/5JXcgSR2J+074Orwt1cwm0mVa+lj0aY9NfTrtJlANsteYzIP6+0nzeehxMXROg0X1g6823fWPiM9U5yjgbIEqkDz0QMMqx0/DreZHqCVvQNO43cYqJHeYLskOJPlREr6UecvqiyfmmNtrxkxKkNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0y/oVWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0y/oVWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9736C4CEE3;
	Mon, 28 Oct 2024 06:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098106;
	bh=XBJ/ngkKuBdM28CSpxMxvn1dqbUT2PkvsPOQOgghofY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0y/oVWpdcn3c1kK3pZaoYc4DZy1lIg3ahtB6WDyxlSmMEhVJMVaLgHJ+coG9g2wh
	 Hf7/iC8QFbZa4MdxExgalnJTclfJycN3GsQRMZdf+Dj0wDX9AX4Kk7gvadmiXBkMGr
	 ekVNRT6lGqBk2Xp5wi4wro1chs9kDf+nRqaDm35g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rashleigh <peter@rashleigh.ca>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 079/261] net: dsa: mv88e6xxx: Fix the max_vid definition for the MV88E6361
Date: Mon, 28 Oct 2024 07:23:41 +0100
Message-ID: <20241028062314.009637294@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Rashleigh <peter@rashleigh.ca>

[ Upstream commit 1833d8a26f057128fd63e126b4428203ece84684 ]

According to the Marvell datasheet the 88E6361 has two VTU pages
(4k VIDs per page) so the max_vid should be 8191, not 4095.

In the current implementation mv88e6xxx_vtu_walk() gives unexpected
results because of this error. I verified that mv88e6xxx_vtu_walk()
works correctly on the MV88E6361 with this patch in place.

Fixes: 12899f299803 ("net: dsa: mv88e6xxx: enable support for 88E6361 switch")
Signed-off-by: Peter Rashleigh <peter@rashleigh.ca>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241014204342.5852-1-peter@rashleigh.ca
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5b4e2ce5470d9..284270a4ade1c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6347,7 +6347,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.invalid_port_mask = BIT(1) | BIT(2) | BIT(8),
 		.num_internal_phys = 5,
 		.internal_phys_offset = 3,
-		.max_vid = 4095,
+		.max_vid = 8191,
 		.max_sid = 63,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
-- 
2.43.0



