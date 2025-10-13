Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3544A30C342;
	Mon, 13 Oct 2025 15:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369643; cv=none; b=rcxDvo7YnzKvKRI2ixLmGHUsYrhrF5kCRr2dfcOvbSTGwQT5kSbedHL29If4FcZIy4tnLEIN4oV6IVsWa4UrvPJGA2KXpPBQ9RXFRhaZuwXz7Kw5pIynyvI2Ns4wpqgfHyyi4uSOzTJEQvK4h19awMxv8sVSXq0T9UKuhn3Yvko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369643; c=relaxed/simple;
	bh=HgACUjEWbYhTIVvCulOUTHcqlablLn8zjhf881BuvCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYu+1aZMiasQ8WMhedUurmyHHWzBzR1oNUaQ0eMgdI1ufAyPG6ERIEGcHmnsHzjFybhzbek+IGSC3AfVdTNrMcBjBIK45bQPjwOcx2lX8uE7wrgog45ATNFjhNCXQ3QQa8j4VKHfyO4IWV5HwAzn2UWMwus49BINS8To444mc3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvYl8JqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvYl8JqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52A6C4CEE7;
	Mon, 13 Oct 2025 15:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369643;
	bh=HgACUjEWbYhTIVvCulOUTHcqlablLn8zjhf881BuvCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvYl8JqTBHFppOkyzGpMD1DpPSpz9DgDVKZFL8Jv+2zb5a2HLCRcIRkGQczBgvZrs
	 TpJAlJP4d9VFb2uDp7I6E4iVF1Zhmq50Juye4hCwjdHBkEP1J4o+wCV3gGFy05N3z8
	 RdmIZPP5d1Ssms+JAy7zdlhdLsVLEIhfMJtt3BtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 319/563] usb: phy: twl6030: Fix incorrect type for ret
Date: Mon, 13 Oct 2025 16:43:00 +0200
Message-ID: <20251013144422.822886516@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xichao Zhao <zhao.xichao@vivo.com>

[ Upstream commit b570b346ddd727c4b41743a6a2f49e7217c5317f ]

In the twl6030_usb_probe(), the variable ret is declared as
a u32 type. However, since ret may receive -ENODEV when accepting
the return value of omap_usb2_set_comparator().Therefore, its type
should be changed to int.

Fixes: 0e98de67bacba ("usb: otg: make twl6030_usb as a comparator driver to omap_usb2")
Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Link: https://lore.kernel.org/r/20250822092224.30645-1-zhao.xichao@vivo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/phy/phy-twl6030-usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/phy/phy-twl6030-usb.c b/drivers/usb/phy/phy-twl6030-usb.c
index 49d79c1257f3a..8c09db750bfd6 100644
--- a/drivers/usb/phy/phy-twl6030-usb.c
+++ b/drivers/usb/phy/phy-twl6030-usb.c
@@ -328,9 +328,8 @@ static int twl6030_set_vbus(struct phy_companion *comparator, bool enabled)
 
 static int twl6030_usb_probe(struct platform_device *pdev)
 {
-	u32 ret;
 	struct twl6030_usb	*twl;
-	int			status, err;
+	int			status, err, ret;
 	struct device_node	*np = pdev->dev.of_node;
 	struct device		*dev = &pdev->dev;
 
-- 
2.51.0



