Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043186;
	b=uPIqDh+FUCfb+S+3V2GeWv2IoWxpDTptWT0Q6Ywa3WUx2fSYfMV5LItpl2Ir2lgnv5F+
	 YK4C9peC5K4p8wWvSiOUAB37PimxplQxBaatCepxvwwoEYhsRUZv3gheDOO6C76InGqpp
	 G03eF8muW1A6XTzoSEBBUdt58eltqK1NG7TXSboKJ7gvbaN4N1fYTXPTeD6iL2/ZQpOMI
	 MMxrr1+8WgVK/D84odf4iYJdrpwXFxZSEc9ko8/ViVbzmcL49xEuml4S5H5LSTkbo+2WO
	 qTpBXIN83J6nWXnl7GIv4k8iTQlc2W0dt6jSOYs5CJnp+eGqC8enDK5OtISGwo0Oyew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lrv8FDkQESUr6MWmS53vAQlEhDK6Nl9uEXrojSB78Iw=;
	b=ozRZx2RqLiaJE3hK416aS8JmKNXsSC6JRreMXawLK25PU7vOf5qPDXTJMuASFDN9mrJz
	 talRIgighdtTw8D+QKDaMuWlzIpItEG6Gn78TQgf4jXS25ly4TjfqJLcglxBu3jTM5fyj
	 Wsqi51vcgCCFIOlQMfyjPDSC8lbw7UcYa5SS6c4PAYYceL35Y6pRMwSKkmeNoX7/yDMzN
	 9I4TXhvuSosLP8GXP3BKSKpR8tAMWrrm6KiZQQRd6F8L0rPlaY0ZoOconjXFV7ev7d0T8
	 yv0OwsXXlsshQm4HgqQPup7X8ujKIxowryEjZEiqgSDotInPq8P5cwP141C9rTmNeng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QojEJxV2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25E1606A32C;
	Wed, 18 Nov 2026 23:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QojEJxV2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5EA1F000C4;
	Wed, 18 Nov 2026 23:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043186;
	bh=Lrv8FDkQESUr6MWmS53vAQlEhDK6Nl9uEXrojSB78Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QojEJxV2lIPPQMI/+105Hia8oouE6ec/IhN0wzVRbZwhwqMdaDz5IHKvqoHHfGzsM
	 wQhPHnp4shTMBf8AVptArrej5qXfCPw+TgRwJNx0GH0Gz8JFqmjg4hEpGnQsGi1gzQ
	 /+VCsLvCBwLajU1+rXaRc00x0OE9Eh9Aa+/i/uwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0122/2857] PCI: switchtec: Add Microchip PCI1008 device ID
Date: Wed, 18 Nov 2026 15:19:16 +0100
Message-ID: <20261118150205.739049306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 0d8a6306c680ee534be131e360f0cafa2bada7be ]

Add the Microchip PCI1008 device ID to the core switchtec management
driver's PCI ID table. Without it, the management endpoint on a PCI1008
switch is not bound by this driver, preventing userspace tools from
configuring or monitoring the switch and leaving NTB functionality
unavailable.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260714212010.230606-3-logang@deltatee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/switch/switchtec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index 37c5ba40d959f..04e0a15bd0157 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1875,6 +1875,7 @@ static const struct pci_device_id switchtec_pci_tbl[] = {
 	SWITCHTEC_PCI100X_DEVICE(0x1004, SWITCHTEC_GEN4),  /* PCI1004 16XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1005, SWITCHTEC_GEN4),  /* PCI1005 16XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1006, SWITCHTEC_GEN4),  /* PCI1006 16XG4 */
+	SWITCHTEC_PCI100X_DEVICE(0x1008, SWITCHTEC_GEN4),  /* PCI1008 16XG4 */
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, switchtec_pci_tbl);
-- 
2.53.0



