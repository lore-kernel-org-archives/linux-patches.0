Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E6379FD;
	Thu, 11 Apr 2024 10:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832475; cv=none; b=DBs3wKxQQEbzK8RCtYB9YshfJwSO8rGTEAdKwvbKPklYdB5t3lk+MkLAlGRxgBbXsYCT/kvBt+3tTO0B8nYiGAZOSO1YwgrzisKtLyPHHaHctqF2n4U8Fesn5TseIVBNMnph/E//HiD51IFglto1id4UDzaEhGMxo6Sq0rf9tuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832475; c=relaxed/simple;
	bh=GXrH28C+wwE4dcNGYD7Hi2n01T0Vd8UrrfKuUvWFSdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uS6kuovNbxjyyrFamzdhwFQY91Vk827kx0MByegFYixeuTmE6fui7K0ceou2ZnJ1A+R4QXkkjF5MpQQr6mDSUuzq2MLEXB4exEI1WoDRo3xPXIiBtWzTrpgiNnolBPvVYOIbJNUBRdnUW+i3Hojo5wEWT8zTVf86gBJ0ELyPq4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkZT1hlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkZT1hlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0431C433F1;
	Thu, 11 Apr 2024 10:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832475;
	bh=GXrH28C+wwE4dcNGYD7Hi2n01T0Vd8UrrfKuUvWFSdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkZT1hlNOP+7Qi/XGrIhNWnSh0nOLNSWFMx9pNFAwTMcStvC/3Qe144Td53JOltLb
	 jc1sFagU85wTHK+i5QM/E4mLeQzfsAnaY2gjXxDbq6bE9p+/PAN/i9maAbXxOivgmI
	 JQTafGDvbb1X8gFv2BO8LNSwaNyf7eLueSs4NRV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 61/83] usb: typec: tcpci: add generic tcpci fallback compatible
Date: Thu, 11 Apr 2024 11:57:33 +0200
Message-ID: <20240411095414.521207902@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 8774ea7a553e2aec323170d49365b59af0a2b7e0 ]

The driver already support the tcpci binding for the i2c_device_id so
add the support for the of_device_id too.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240222210903.208901-3-m.felsch@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index 816945913ed0d..f649769912e53 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -875,6 +875,7 @@ MODULE_DEVICE_TABLE(i2c, tcpci_id);
 #ifdef CONFIG_OF
 static const struct of_device_id tcpci_of_match[] = {
 	{ .compatible = "nxp,ptn5110", },
+	{ .compatible = "tcpci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, tcpci_of_match);
-- 
2.43.0



