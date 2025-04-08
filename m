Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0442641CC;
	Tue,  8 Apr 2025 11:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112814; cv=none; b=q0tvLd4Xr0wTicCSpEYFvsaLKv2wFHp8byZuAfizjSUifQm/UwChj/R3qPK2pUcG85kT2ko50GIAX3UGkfNqqSmxHOxFIdnL6i+fGBZl7Q7N6uR3PccTDsrwRC/adCPXKtTPRkbZqOXg+I5V9B7kt0rDadqgDzNchT8opu3iCs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112814; c=relaxed/simple;
	bh=xcMPnH3/gLwHgaKIMrGugoKEK5Omm0p9Be7eFugIPbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLaAt47YCYUdbHePTxczk1w4v2lMaTEDhcdgSPu4/WIh5OvtHKilFzcO3GvHXH/pjCJqxjEoJD7zU4UQcx8D9PKTid6zKz4t/V7vEE25YaCijkOqzHyq35DH5xhsgx4a53YK91oBiPU+tvnA8qSYQBuSIUEK848CvzYdtUqXLFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyT85Ibj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyT85Ibj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6A3C4CEE5;
	Tue,  8 Apr 2025 11:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112814;
	bh=xcMPnH3/gLwHgaKIMrGugoKEK5Omm0p9Be7eFugIPbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyT85IbjcvJVyKGfI0w54fmXoZiUhk8I0HgDFBPdSErZSaC6XdgdLefDq4RPHwnSA
	 Z39q7+9WXR5Z/BtjKWQwBABtQVFoGofQuPM+RTX3+3PfwIe5aUyFCy0LjKAD98/utA
	 95oyMF7/uUxSTvzuLh51Vjs+/rPO6HoRshh3xPZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 205/279] i3c: master: svc: Fix missing the IBI rules
Date: Tue,  8 Apr 2025 12:49:48 +0200
Message-ID: <20250408104831.874224394@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7fc82b003b961..29440a1266b8a 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -807,7 +807,7 @@ static int svc_i3c_update_ibirules(struct svc_i3c_master *master)
 
 	/* Create the IBIRULES register for both cases */
 	i3c_bus_for_each_i3cdev(&master->base.bus, dev) {
-		if (I3C_BCR_DEVICE_ROLE(dev->info.bcr) == I3C_BCR_I3C_MASTER)
+		if (!(dev->info.bcr & I3C_BCR_IBI_REQ_CAP))
 			continue;
 
 		if (dev->info.bcr & I3C_BCR_IBI_PAYLOAD) {
-- 
2.39.5



