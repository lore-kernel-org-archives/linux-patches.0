Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DC9254B1F;
	Thu, 28 May 2026 20:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999963; cv=none; b=UWHZvtFCvDtNfAgDIGPOzGvKF/PzrqPLHfphd1/6U31MpYAj8zcIE28DiyRnSwLGNQJPOHR0v+WnerJ4cJl3tUYTrbPstUelPjGluil067f2adZGNtw6bwMIxfdoAjmupntbE3QM4kJyBf8Ga0cIYuJHXQBdDrXLM8/89psu8FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999963; c=relaxed/simple;
	bh=vsg0tpqYc9iWEOIdGwUF9KRcfytqPaYpCP5aOZUI0/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3BtON0GuCuf6ZpUkfqcmrEaAQpFzM33Uk0qNANp6K25TXaQNazAI+OCBy8d/y36Q8Or/VYo8EZ/CMLpJdKuJt7ifhdsyyK2z+p8huNQWPEh2BR/twO+S2yxFSQGx5X44fzyyK5wvnm4r5ZkJosigYK86z0QFPGCdfQpcEQeaC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+Q4Uilj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+Q4Uilj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1BA1F000E9;
	Thu, 28 May 2026 20:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999961;
	bh=sAQmej2u4tQFH8+i+yrc9jk4H1YzAxY3igbqFGmK2X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+Q4Uilj4Cpe2jrNpefBrDXmQpOGRxlYZ7xawdakiFKN87hLyuLdxoSfg1ZZ5pi3U
	 Po7sQag2S3PbbrZ9HSKnyaIAWN7CzuXribXOK2TMtoZJQEmfnFz+WKw1SPwYCsxK1w
	 mDgBVUZPwMdmoq9tXCgSZToeXdhoLneLG8GqdyKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 253/377] net: ethernet: cs89x0: remove stale CONFIG_MACH_MX31ADS reference
Date: Thu, 28 May 2026 21:48:11 +0200
Message-ID: <20260528194645.700253031@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fa5857923db4c..b4bfd6c174e78 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -1271,7 +1271,6 @@ static const struct net_device_ops net_ops = {
 
 static void __init reset_chip(struct net_device *dev)
 {
-#if !defined(CONFIG_MACH_MX31ADS)
 	struct net_local *lp = netdev_priv(dev);
 	unsigned long reset_start_time;
 
@@ -1298,7 +1297,6 @@ static void __init reset_chip(struct net_device *dev)
 	while ((readreg(dev, PP_SelfST) & INIT_DONE) == 0 &&
 	       time_before(jiffies, reset_start_time + 2))
 		;
-#endif /* !CONFIG_MACH_MX31ADS */
 }
 
 /* This is the real probe routine.
-- 
2.53.0



