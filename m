Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC1F2C327B;
	Tue, 15 Jul 2025 13:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585638; cv=none; b=gPbPOQuxeVKdbwZId9M4xUqsvBCM6QeoRKRDuyQGeSgXqbi6O2uv/FslqBFJz3dD3wje1NsiFjDrlYEOtaQ46dhAH3UBQoM9d3W65dYRs67tsf96XJqnMYx8YpKALUPD2wd4M5xzD+1G4F3BiIW4odbjui9Y5dTd/XgN2OQBzd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585638; c=relaxed/simple;
	bh=p1z5p33115nH6GUDefYCyHMxgSW8Zdo+Jx6+b3W7Zss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAYQq3jIQk3fK8FtVrz9vAy+nwm/jgPdQ2BdmKpDPhkxWAM6X+mvd7Y1NITfF7dtDsKgzKQOf3kNaWcy074eCmI+HUTnaPd6wwz6mcDoqeTOHOQay8+sZk8Umqljgps+rkcbi+vR77TJ7dFT7LLBOfuDAzHRfs9YRgBUhpa0/vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FX9tD/p/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FX9tD/p/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA95C4CEE3;
	Tue, 15 Jul 2025 13:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585638;
	bh=p1z5p33115nH6GUDefYCyHMxgSW8Zdo+Jx6+b3W7Zss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FX9tD/p/EEDK54J+OxD5piv9ie9iE/WAw3NwHCg3cVRQocerMF1uOfMECmAxKEpF5
	 KHAJ3ow+2iCliJmpEBQk9ElgcM7f4FCmwkKElqJ4mxTQT7e4RC13uUdzwZHYNZyfYI
	 AuxW80tYIPBjRaC6H8T/C+ZnYbaQBj8DgMWWudms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/163] wifi: rt2x00: fix remove callback type mismatch
Date: Tue, 15 Jul 2025 15:13:02 +0200
Message-ID: <20250715130813.428084892@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



