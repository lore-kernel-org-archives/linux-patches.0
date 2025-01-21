Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B021F3FFE;
	Tue, 21 Jan 2025 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482878; cv=none; b=Hz1JkzkU9Wkj1pC5XmMj30dLTJoB9oJzmFXkMXF/297v4r2M0m64J2uhPaWDN6WfDiFI5s5FmvU18CHiSz6x/FwonoYZBQo5z+Sh841+Y7xP4PhnR24bTuu0SxlZrUWZavCRhjBhLwRCceM6tjYqVPWxFca013lfihslXOx6RZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482878; c=relaxed/simple;
	bh=nNku1UyEIL3QMwmVL3zYcMdj64Cn3XclaUEfXM8RTw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIdHb5g4x4krW2ooOr2JyUaMe9AQCR1vgsAKATLvr5HzdnewQ6ZiNxYRRPych2xkCYmmSQOzmHemmNbjcpwiSeIXj5AFxu3M6/B3EtaW0Pev5/U0QqShSoc9OBBGIZ+tVA6CwzzCoHPu09FuBGxCWe9XhxIMFQY5KBH6RhfkJCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KL0IEPcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KL0IEPcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23DEC4CEDF;
	Tue, 21 Jan 2025 18:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482878;
	bh=nNku1UyEIL3QMwmVL3zYcMdj64Cn3XclaUEfXM8RTw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KL0IEPccaXZ1YcsCRjb/POwH+dX/IPd+Lxc5ZwLhZ4vc9mrgKy8poHic2UoPfjCMc
	 vVnqUPfPWB2lbpKgHOQYwQYiabOGLNDBXyrZn+nA6KVra/zLIKP68seFCxPzOnAKoq
	 3V9H1ptaZAFWz/1QlTr2M6torrYM7Lyf2WcubPss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Simon Horman <horms@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/127] ieee802154: ca8210: Add missing check for kfifo_alloc() in ca8210_probe()
Date: Tue, 21 Jan 2025 18:51:21 +0100
Message-ID: <20250121174530.033864478@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

From: Keisuke Nishimura <keisuke.nishimura@inria.fr>

[ Upstream commit 2c87309ea741341c6722efdf1fb3f50dd427c823 ]

ca8210_test_interface_init() returns the result of kfifo_alloc(),
which can be non-zero in case of an error. The caller, ca8210_probe(),
should check the return value and do error-handling if it fails.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/20241029182712.318271-1-keisuke.nishimura@inria.fr
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index dc786c3bbccf..d6dafd9876d2 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -3125,7 +3125,11 @@ static int ca8210_probe(struct spi_device *spi_device)
 	spi_set_drvdata(priv->spi, priv);
 	if (IS_ENABLED(CONFIG_IEEE802154_CA8210_DEBUGFS)) {
 		cascoda_api_upstream = ca8210_test_int_driver_write;
-		ca8210_test_interface_init(priv);
+		ret = ca8210_test_interface_init(priv);
+		if (ret) {
+			dev_crit(&spi_device->dev, "ca8210_test_interface_init failed\n");
+			goto error;
+		}
 	} else {
 		cascoda_api_upstream = NULL;
 	}
-- 
2.39.5



