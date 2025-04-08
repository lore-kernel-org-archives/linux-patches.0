Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6951AAA32;
	Tue,  8 Apr 2025 12:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115787; cv=none; b=g0OhyYRBdV7ojxq8irfNxPuOzlxKaJXcb17oA1UeKBJsj3BXJa5seYoU9dHWMUmaXX1nMBLKyQWJE+fWHp0Y6SxxjnaCad3aaiTh69wbwfBauq4P64TvEAO21+GZfGNIU1uYMHCo36Ti/ap2b82ivC1KAHKajBkUhEtWdh21wtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115787; c=relaxed/simple;
	bh=TcflWlFgNcNjflpyHo3MF8onswx90waotIpgaRHDKoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCpxFI4Ewg8dyS2qXPBepX7NLEOKbQoOYSWEKJlhs9vR+Y3Z/jCmVKEqW6y2Kat9HmvjiEnPKRU+lYa1WW6M3Wc9C/3u4LAP0bMq28R5EY1aUc9lW49zjhZ45CiO3kx64itsGwDQEhQz2o9HwVFG4LkJGG9+0qu6dRjsHe2LjWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XH3nSoqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XH3nSoqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE9DC4CEE5;
	Tue,  8 Apr 2025 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115787;
	bh=TcflWlFgNcNjflpyHo3MF8onswx90waotIpgaRHDKoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XH3nSoqzh+gJcMDLJi+EwXmGEn/4YUyYYnkTa0Syaq3GUT6cZm3QUiLUCo2PrFyHG
	 6FOrXhMnTlrRbD912TCviOA3pYSn67m5dn7jaHjl2FwNbtpmbycp3qEqyFOTUv9zsv
	 b+6FZGsARmQTr+eGLzdhaLK0US4oaVaT4DrDM9rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/204] i3c: master: svc: Fix missing the IBI rules
Date: Tue,  8 Apr 2025 12:50:33 +0200
Message-ID: <20250408104823.360149751@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit 9cecad134d84d14dc72a0eea7a107691c3e5a837 ]

The code does not add IBI rules for devices with controller capability.
However, the secondary controller has the controller capability and works
at target mode when the device is probed. Therefore, add IBI rules for
such devices.

Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250318053606.3087121-2-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 9039ebef8648a..157ff26d40be9 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -943,7 +943,7 @@ static int svc_i3c_update_ibirules(struct svc_i3c_master *master)
 
 	/* Create the IBIRULES register for both cases */
 	i3c_bus_for_each_i3cdev(&master->base.bus, dev) {
-		if (I3C_BCR_DEVICE_ROLE(dev->info.bcr) == I3C_BCR_I3C_MASTER)
+		if (!(dev->info.bcr & I3C_BCR_IBI_REQ_CAP))
 			continue;
 
 		if (dev->info.bcr & I3C_BCR_IBI_PAYLOAD) {
-- 
2.39.5



