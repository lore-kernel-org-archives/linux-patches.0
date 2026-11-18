Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043304;
	b=qh0IZKhZxNHRyEQw+kZ1OJ0dp2trbobJZZYygyZPS0WE4HFQsW+Zv3oJcqBphPuyUQR1
	 ydTtedTI809yMq3pBNmjtowiXr8xXmPKKg2iSLHKUKxVg3bb9IqMYeveSrIaTS65WFKHA
	 1ZjRAG4ahuF3WvND21Z4230/heeJCSy7/qp34ly4AfFJIxcphlYapiAZGUVznjNn8ss1c
	 SH+7tvV4TPP+HwudGNj1221a6T3/r/DONg1MiCgiYXbsXbJeQq9+ACddkbdb40hES+CA8
	 RSo3VYoxvgzCa8flQcyNkVIVqicwgM0hkLrYefpYrYJ0XQ2UfGj6KfzMqhv97YIMHXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nZkmGyayPzaWWgJ5g5S1Rz3ZK5ltJCK8ZIJYoWBgHGw=;
	b=vFxHUXvetEv+ZoEU9x92O+oAbJih6lSO55T74EjwsLiQVGY753T7/rfe70MlKc6+7KpV
	 PY8xxek4VzfW3xE2H1WqZNT5Ms91mosOEYvisIBpjadBzTNaPRiF4D2u7TLf/pGPx3JMg
	 VAGrfUALt0UUlQEDeCQsMWY7e3HV1CoXj3L6YQ/y0Es1gcHLT4L5bjibO0Wz5noZGZ5na
	 lcrEfEBMp97zJfqGauKNd9fo8b8xn3C0RRGkXGGScRu4uRa+tuJt+rk6lu9kBGJZe3nsj
	 XyS8xDWK/lZ2uh37PGNmHvErpiLQ5OAYc1tmLfsHfyrvkarAyQ8mv2zwDBGOWO6TFYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fqKQj4tu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E257606A31C;
	Wed, 18 Nov 2026 23:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fqKQj4tu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3911F000C4;
	Wed, 18 Nov 2026 23:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043303;
	bh=nZkmGyayPzaWWgJ5g5S1Rz3ZK5ltJCK8ZIJYoWBgHGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqKQj4tuH/K7SWhLO8FuXIX7UU3922S7uJQZGouWGFGBtPyQ+tpeQHJo4Lcmgj6Rt
	 f2XaRDkZyS/hL6itDfie5Iix6RlEmCOkP4Oom/pDc9/WuamiSEKgNLO+quREq7tE39
	 IaviTRb9Xpw5akNb4ls73nCe2vWISeNjFJ0+/r6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0164/2857] ata: ata_generic: Dont store pci_device_id
Date: Wed, 18 Nov 2026 15:19:58 +0100
Message-ID: <20261118150207.258677366@linuxfoundation.org>
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

From: Gary Guo <gary@garyguo.net>

[ Upstream commit 4f3075f629077a8cb3d3455c794a1f4a8fc8b43e ]

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. All information apart from driver_data can be easily
retrieved from pci_dev, so just store driver_data.

Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260723-pci_id_fix-v4-1-3580726844e1@garyguo.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ata_generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 20a32e4d501d3..177c902b2988b 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -51,11 +51,11 @@ enum {
 static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 {
 	struct ata_port *ap = link->ap;
-	const struct pci_device_id *id = ap->host->private_data;
+	unsigned long driver_data = (unsigned long)ap->host->private_data;
 	int dma_enabled = 0;
 	struct ata_device *dev;
 
-	if (id->driver_data & ATA_GEN_FORCE_DMA) {
+	if (driver_data & ATA_GEN_FORCE_DMA) {
 		dma_enabled = 0xff;
 	} else if (ap->ioaddr.bmdma_addr) {
 		/* Bits 5 and 6 indicate if DMA is active on master/slave */
@@ -206,7 +206,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 			return rc;
 		pcim_pin_device(dev);
 	}
-	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, (void *)id, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, (void *)id->driver_data, 0);
 }
 
 static struct pci_device_id ata_generic[] = {
-- 
2.53.0



