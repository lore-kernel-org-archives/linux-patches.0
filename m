Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212E22F260C;
	Thu, 28 May 2026 20:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998801; cv=none; b=EJRs3Z2Sv3QA5z+deRWWtK8tnu4s8MLuWUur1PFizgRRRSmpObwDgcm8ritppze7K6/mOiPEGzvmb4LuaqbKd5bCjIek6CzPE9d0Z6f10SwXtUyai/R55P+Kv+RW4jlsGF1gtdZpJIBuEI80N6TpOdMP+HW1/TkW5FTU1jAhrj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998801; c=relaxed/simple;
	bh=XwlLY8g5xZMv1VhaeuPgs2e/zznzzdd1ilOyDs3svnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uISZhNDqYXlJ5EC00pF+RQRpPsiYmerx4jc7wJQ/z1i4YvmlC6EJomnNABf0w+vwiTUqqJt1IZEM6Z+SZjadUW1rIh2cgYoe6kLr2UcrfB52Xvl2I9E7rZZ88/M+YXNQ2RBMC/dDAz3mzbX+BpnW8S2F9e6XDjUOFa+ns8L6AqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWThGVYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWThGVYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0B01F000E9;
	Thu, 28 May 2026 20:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998800;
	bh=scGJSXPNljCOpwv71QOzrVSaQ1oJMby+M++txFyXSMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWThGVYkU0x4USlBBZ8KLnhRuwLLZxYEMq3vUJPcBeMm4ym3H/hdd98LXWPp0bs1w
	 Fv+IvZC8SNTYKQUJeEpoNOKpqWojFJLuHi1CJuStVpOFqBSyHLc6IQFfCgiB9VABjZ
	 Y5sVdEwwdx3R7ww5pW6KgEEHKfCJZvCDdu6UhIeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 275/461] net: ethernet: cs89x0: remove stale CONFIG_MACH_MX31ADS reference
Date: Thu, 28 May 2026 21:46:44 +0200
Message-ID: <20260528194655.133001780@linuxfoundation.org>
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



