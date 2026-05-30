Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4A230E853;
	Sat, 30 May 2026 17:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162468; cv=none; b=bmEZdb3lrNJ1NOk1X8khYSEUvG+T6ixRp6gG2rx/l/Mqzx0mya1hk1Z0BNKCMrxADWjWtHhlM5EOL0NewvdT7L1TZE7E6inK/NqT21j3n6JV9WyjzWrzalvFaWt/YOibADtwsJGx5S4MnJAl6By6jSnKNF4rTqZAem8d60fi124=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162468; c=relaxed/simple;
	bh=BCsVWheMWAlDuCpthfbeeyKee3e+KBjY+nVpRc2ug/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmEBw25daNmqonPbrefGsROnilYL0d/EUkUXBtsmyRtBT9NdCXaliXtDrHR7q4uoWXnZbX6PytVZXET/OLUMAuS9QWRUdUDvsk7LrbI3XhA+EuHsoxX5bK6q1xgNjr81z7l0+2OdBjUIwc9pPnSrmPia5soyyv7y42tK6+NXWaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyLaE0Sv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyLaE0Sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49B81F00893;
	Sat, 30 May 2026 17:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162467;
	bh=aL8VmTJdG74DsuD/HXNaljp4PUUFiK3on49b3YhiQIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyLaE0SvZVfB4rqaKDKQPUvRIszxQ0LoVsPmeEeXbuXGzUgXu4LufniKsZjYkFiy3
	 ZXWlXR1yvvAyqEyYxgn5dxUxJchfOBgEmkKJ6LaPpTxIp+KZGWreLAW2OcZOHQ8Pax
	 LitWh8wERL7pZbsG02Lxgjjs5wKIGvj7aFkoeDHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 929/969] net: ethernet: cs89x0: remove stale CONFIG_MACH_MX31ADS reference
Date: Sat, 30 May 2026 18:07:33 +0200
Message-ID: <20260530160326.394117872@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 06a0c00af99c7..75ab9b9668172 100644
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



