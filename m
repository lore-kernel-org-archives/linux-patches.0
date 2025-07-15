Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B85D2DEA72;
	Tue, 15 Jul 2025 13:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587018; cv=none; b=rVnjxAWx+Udj8O/E1I7DzzQhtr7h8GL7TBNJ8Q+sHUz2pW/Jasg+9mVpnJ4YSKfq/kfcHYhACGpRZuILXgmxl0hVBsdI/Wqgk8QIZzJz+CW2H37UpD+Cn36IEkxpOZfDKddL1sDzU9LCgtHlu5liMgWXfnzvqveMKviX6k4FkLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587018; c=relaxed/simple;
	bh=0jV9dox07iPXWBoTqzMm1jExZ9RGQR3kfDL8XfIkzeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAf7yj2VRxugHML0gi1ciNF3TdjNbexQKCpgWCqsyMWHxgaqPr37cDPQQKjLqY6RMWqieWdsdsxOBNS1BwIap1apPHh8UfptxbFey6t0pFIQ4cPeaSEkvOQMNA+UkUXeUAJDZH9AhrmGSy/0mTgQO1SezNQyLUIpzKBD5Z4Q3l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXVXnuFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXVXnuFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3676C4CEE3;
	Tue, 15 Jul 2025 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587018;
	bh=0jV9dox07iPXWBoTqzMm1jExZ9RGQR3kfDL8XfIkzeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXVXnuFWEwXvzcC/8Ee4S2H76hT5H5geSqvDjKbG9DZvHL6DhpnU16wfvKcZKTYJ0
	 GGX4uQ9g+PtHNoRVQfA7wBLIapeYIMjwIcadVyqkvOpVwXr1e7eW5cTkGuVVF6t84+
	 iIwflzAGHQWYKjVUrequP/O/K7CUHCj7PsLNFLtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 136/192] wifi: rt2x00: fix remove callback type mismatch
Date: Tue, 15 Jul 2025 15:13:51 +0200
Message-ID: <20250715130820.361014028@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 2ce6ad9262256dd345cb104ba0ac6cf4aeed25a3 ]

The function is used as remove callback for a platform driver.
It was missed during the conversion from int to void

Fixes: 0edb555a65d1 ("platform: Make platform_driver::remove() return void")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20250706092053.97724-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00soc.c | 4 +---
 drivers/net/wireless/ralink/rt2x00/rt2x00soc.h | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
index eface610178d2..f7f3a2340c392 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.c
@@ -108,7 +108,7 @@ int rt2x00soc_probe(struct platform_device *pdev, const struct rt2x00_ops *ops)
 }
 EXPORT_SYMBOL_GPL(rt2x00soc_probe);
 
-int rt2x00soc_remove(struct platform_device *pdev)
+void rt2x00soc_remove(struct platform_device *pdev)
 {
 	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -119,8 +119,6 @@ int rt2x00soc_remove(struct platform_device *pdev)
 	rt2x00lib_remove_dev(rt2x00dev);
 	rt2x00soc_free_reg(rt2x00dev);
 	ieee80211_free_hw(hw);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00soc_remove);
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.h b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.h
index 021fd06b36272..d6226b8a10e00 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00soc.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00soc.h
@@ -17,7 +17,7 @@
  * SoC driver handlers.
  */
 int rt2x00soc_probe(struct platform_device *pdev, const struct rt2x00_ops *ops);
-int rt2x00soc_remove(struct platform_device *pdev);
+void rt2x00soc_remove(struct platform_device *pdev);
 #ifdef CONFIG_PM
 int rt2x00soc_suspend(struct platform_device *pdev, pm_message_t state);
 int rt2x00soc_resume(struct platform_device *pdev);
-- 
2.39.5



