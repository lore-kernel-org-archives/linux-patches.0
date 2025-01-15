Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EE8248BD5;
	Wed, 15 Jan 2025 10:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937549; cv=none; b=UyZ0/jC1pbXmWrNMCBCG7fReABLXVCPDelgZwdLGPTA5O3NAbqJY+ZsoT7NQsLYU7Ge2Hf//TKhqSOyLriuqiRl695BVqaDcjudWNxlk617JzJalDUap0WF0LYmwHKWBWFC7LfM7EQFYxAxWfe0axVSgpMNcHTbmFYWb7Aj/2/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937549; c=relaxed/simple;
	bh=k5o0B9GDgcnVw3Wf5W2Q4YG/yz12LaQ00aYNcqRebpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aW5w7vtuoyMwDSNlIM+8A4F/qSbw663yyijvF1kRHRBZDEg0wKlgKOBu99kPxV5/bVRw0iAZPdFXKOlZgCdwcVYXdFa2wzGmFb3CKiEv1aCOFhWIPAs8RD11C+nDQ9GDFvh6DWD12KdTmgp9PTQ7XFY9vTzaUOgq2hJFb/JO+f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxadTR/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxadTR/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CD4C4CEE2;
	Wed, 15 Jan 2025 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937548;
	bh=k5o0B9GDgcnVw3Wf5W2Q4YG/yz12LaQ00aYNcqRebpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxadTR/I4GsmZKBz4svB27+iu/n8Jp6PIQKCHLid3/bLiBhoBUm2zL6DvjMGcO9Am
	 71jiRKzq2LXt+OoPapFJmxhlZBKyRd0yESkGLu0yzAO9yPo1kOSTsjG716C8oTZenj
	 CuuevI4DWRekBD9UYF3+Xo14SLDUyIYFdT+Alub4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Simon Horman <horms@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/92] ieee802154: ca8210: Add missing check for kfifo_alloc() in ca8210_probe()
Date: Wed, 15 Jan 2025 11:36:31 +0100
Message-ID: <20250115103548.070523646@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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
index c2201e0adc46..1659bbffdb91 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -3078,7 +3078,11 @@ static int ca8210_probe(struct spi_device *spi_device)
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



