Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDA0330D35;
	Mon, 27 Oct 2025 18:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591053; cv=none; b=r/A5XE8KD0sPYzqGHPJyu1tYJINwEl5vUtwn00jxuzpOEEbkuk0mlejynManebp8Ofp8tw7pOLYCmYRBPAq78jHi42HAnTRTDDV+PYnl7CcohDJDLlh4aCyxvsgFauu13qGTTZNZsUIk7wkbzazdaYRNTvGkm/yMKF/AlptnHwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591053; c=relaxed/simple;
	bh=b+nQ1I+nNsccYsJSXT2wqOZnbHWof6cBf9xdT74X/fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHf25yrDto6XqRijIUs9gzXSOj3TjbBB6M269NL6mXJbkTvd+YifhVJTFZHyIZof3j1TVPzTksU0dsiQCsFQqFHe9hAMVs9vdvUji+lr/ZVNB1J5GjdlRJtbN4VlkBfIPiyYrMCyTaTrkSQLyIKTSbf+yB4LVqYwMRLotUVcxi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Udr7EHIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Udr7EHIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CFBC4CEF1;
	Mon, 27 Oct 2025 18:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591052;
	bh=b+nQ1I+nNsccYsJSXT2wqOZnbHWof6cBf9xdT74X/fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Udr7EHIvldlwG44vVJuzwMZ+sml+4OdA5Ms6/fRbj8/cw890ZHgNpLpEtdGBHVTqm
	 TEr8XYbM6jit9iLPKljQA4J+027f8TtlEF/B812zDA1cqDA3V8TyVpkgfk2svefsV+
	 2vZhydzWa6MUSbGP8gjRieFVyGAbS3kt8vvb0Irw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/332] usb: phy: twl6030: Fix incorrect type for ret
Date: Mon, 27 Oct 2025 19:31:43 +0100
Message-ID: <20251027183525.942600896@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



