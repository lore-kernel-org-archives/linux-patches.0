Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584A82DF139;
	Mon, 13 Oct 2025 14:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367164; cv=none; b=tOki1+lRarmLX4dSpydl7Sfrtwp7Jx8vSyVr8qU0MnQGMRF3twJPxT7CzHJ1EBTXR7CzT7kBuMlXrMfKBAwemNo3Rj5qOeT9o+QGF4nRIeWKOsxOODJ9I177Sh+tQzXhLMojrNm6mfPdWUAJKOVf4d9HYjj1je38BZOy87YVRfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367164; c=relaxed/simple;
	bh=zmMbOMDi8IAkd5NFbdAysXAxLUeFxXczHAMzhcsm69Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OU7Rp1ukYWGqnTbMJrJhKIO8Ecv8Ts1cngBT+FjTvpcjFBoEyiMiEPfZZ9G9bbkU1bTLMIgvnydQe71Mmt2de3qIt1VNl1GD57uYaO+ABgh6EsKF+ftdJrAhZ1127mKV4OIxjNTW8qUCfe7y3w+iBLhWVumIDeH5EZ6jYYCnsBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXZ5B/dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXZ5B/dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBF0C4CEE7;
	Mon, 13 Oct 2025 14:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367164;
	bh=zmMbOMDi8IAkd5NFbdAysXAxLUeFxXczHAMzhcsm69Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXZ5B/dkBJftCyhZOhPn/arA2FBvmsPQlFVlLR1Zc1u6yh+dvkVPjdhvu4dKM/cU0
	 EMrgIzSIeBOqYEN/3hhieagJvX7tQ9jUOQ9R8KMUQituikOzWsDGu3bFKlnrNdnlV8
	 LS6CGuixNot4/IRMyXxuZCU4DdyV+IT4IBCiZq/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/196] usb: phy: twl6030: Fix incorrect type for ret
Date: Mon, 13 Oct 2025 16:44:47 +0200
Message-ID: <20251013144318.821895299@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ab3c38a7d8ac0..a73604af8960e 100644
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



