Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7754412CD90;
	Tue, 30 Apr 2024 11:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475739; cv=none; b=qF6vGzvSB57JeCKn67FblXfO0c1Y5LaFGwfhV3O3t9KCwYj+ReWmclkdTHp+aUZBdePEkS6JGxSy99hoDYzJDC1XCgDNNFwv5vg5+28cdMhU59p/zX6WRQqww9N/yP54S8hxGYPa6zBnIGyVdoX0t3FrauFYTFvLMHgcip0pu74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475739; c=relaxed/simple;
	bh=LgJ1b3RCZ7XJ9k6mWpuQ1U9eSImfREWuuVN6G++FRN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOr2IO4Qi6Wti0pxdu0nvoXGLsbmXAusSgzu2YczolNmjehZS4qAiXRsoPXSZrktrZshnCl7+//TZ0t4gHaiJOFKAq43lCEht99WbXqILejrAicN8KwOeXjD6yaHqjlyAJUo7yaKtELV0z7tSQRpnM1W57+WZAPVnAPWGKSaHFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyYmK8Da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyYmK8Da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC82C2BBFC;
	Tue, 30 Apr 2024 11:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475739;
	bh=LgJ1b3RCZ7XJ9k6mWpuQ1U9eSImfREWuuVN6G++FRN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyYmK8Darj+J2jBNcJLPWBT/nA3Cdy5IDFrm5v/gDsnqGJp8ZxtEzVLpyaen/iJCI
	 fOKZfQY66nFZ/uFPgGbNh1JJT0mS60WMqHughV89F5Gr5xByPVGubrEuq2s3/A2Qa2
	 QphfP7+MA5kjobwczOYLDvqVnV4Y0da7fSubl/y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/186] phy: marvell: a3700-comphy: Fix hardcoded array size
Date: Tue, 30 Apr 2024 12:40:15 +0200
Message-ID: <20240430103102.764358157@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kobuk <m.kobuk@ispras.ru>

[ Upstream commit 627207703b73615653eea5ab7a841d5b478d961e ]

Replace hardcoded 'gbe_phy_init' array size by explicit one.

Fixes: 934337080c6c ("phy: marvell: phy-mvebu-a3700-comphy: Add native kernel implementation")
Signed-off-by: Mikhail Kobuk <m.kobuk@ispras.ru>
Link: https://lore.kernel.org/r/20240321164734.49273-2-m.kobuk@ispras.ru
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
index e2d0bf92a9ada..27f221a0f922d 100644
--- a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
@@ -603,7 +603,7 @@ static void comphy_gbe_phy_init(struct mvebu_a3700_comphy_lane *lane,
 	u16 val;
 
 	fix_idx = 0;
-	for (addr = 0; addr < 512; addr++) {
+	for (addr = 0; addr < ARRAY_SIZE(gbe_phy_init); addr++) {
 		/*
 		 * All PHY register values are defined in full for 3.125Gbps
 		 * SERDES speed. The values required for 1.25 Gbps are almost
-- 
2.43.0



