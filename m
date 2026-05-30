Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15BE24EA90;
	Sat, 30 May 2026 18:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165197; cv=none; b=tg9DQEuti3SKv+B3yWydJPBvjKrzRFR9++jsNr5bvADbewU+RS1eKNf6LkculOoE3JExntRhCGe0ssJa+dauXOiS77dB71hXoUXCFyIVAEh+h7a7B5pwJX1NQ3qAbYTL1VkKNwqTIRjwB3qJCs2weoefPxfuTfFuu3auzT0ccMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165197; c=relaxed/simple;
	bh=Aq090uecciokUzBlB1tr/6aXmjMS28OB7K5PXt86tPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5n36YUgYrPulcTJeO8YLFTH/E07Mo8dqMZ2o59+rYRNLHjrfKKMo2BdKSxOtp24oxfmRR2CZLSDGf/z7cc/M6wChjKCpBUxXMpmhLXVZrBwsl7C1NOwpiNtWr51QmWKdi6xj6WbiQgJ0wUnoa4OWndk6UqWmlC4LlMLrb4uwVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwjWukGi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwjWukGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0463F1F00893;
	Sat, 30 May 2026 18:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165196;
	bh=tZkHhVy4FJVMMkM+0PfULC8o9Bwf4Y6QqnxzYFUWpio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwjWukGiql0pdp8HohRVJM8/KBfJ3Yr/xwUBtwAbqFH6Z2nSJpBRtQ86RIVdR+6A2
	 K32BXYoGvyXTlcBB7nNlZbJ4X3SoVHCFStDQT4KjnnIeNWVn3fOFWRGTxcmt1cVzhK
	 01o3dDcOI0Pi+OOi5LZDbXPzOLUscp9YKsATEO1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 751/776] net: ethernet: cs89x0: remove stale CONFIG_MACH_MX31ADS reference
Date: Sat, 30 May 2026 18:07:45 +0200
Message-ID: <20260530160259.171233473@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

[ Upstream commit 36a8d04a8293afcb9304cf0cd3741f67698f2a1a ]

The legacy ARM board file for MACH_MX31ADS was removed in commit
c93197b0041d ("ARM: imx: Remove i.MX31 board files"), but a reference
to it remained in the cs89x0 driver. Drop this unused code.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Fixes: c93197b0041d ("ARM: imx: Remove i.MX31 board files")
Link: https://patch.msgid.link/20260509023732.42256-1-enelsonmoore@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cirrus/cs89x0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index d0c4c8b7a15ab..9795f959c9bde 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -1270,7 +1270,6 @@ static const struct net_device_ops net_ops = {
 
 static void __init reset_chip(struct net_device *dev)
 {
-#if !defined(CONFIG_MACH_MX31ADS)
 	struct net_local *lp = netdev_priv(dev);
 	unsigned long reset_start_time;
 
@@ -1297,7 +1296,6 @@ static void __init reset_chip(struct net_device *dev)
 	while ((readreg(dev, PP_SelfST) & INIT_DONE) == 0 &&
 	       time_before(jiffies, reset_start_time + 2))
 		;
-#endif /* !CONFIG_MACH_MX31ADS */
 }
 
 /* This is the real probe routine.
-- 
2.53.0



