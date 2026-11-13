Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591228;
	b=BJcwZR0F/owR4Whky4MPjqNvDnhyPV/CQy5wZ8ChxLePfzH2Knqb5T4cj78ZfxY5gcUi
	 ZXRidK1DgEVHwBAXxQko0SeVdEZSZbaxIL3CkZiAqW5g66wE9BUKeOLBXPjuXLuF0Pc3S
	 nZjdusSKIbxSI2cN/U7iAJWjBZXqCEHWXY7qc9JpkK+9lzfJe/ooAAOCcIRHCEF5mL0H7
	 A8taBXXJNja3E4ub29RWZWkO6t9Ui8IpRxdMFzLdi6NOucQG0/54GQG2o1/OtDYNeFA+T
	 iKNcW8Xcm21uGzLeivfiqmyoFpSZoUCbAhDSmqeadxEqRL6jIPVghZ4p35uOYPKAT/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nedXRIgeOGL/A4KzL3t/boA65utUqvLCf9aLjInejP8=;
	b=lHkTPPL0Y0UN7T7bP6lXatBCainD522PLLeCG4+Q71vH0VqQ5lw7g/WlqZoDv7vhYMQP
	 Nc2f4gz/AWptcGDtESYYOF8U9TXYhWWE0UbBao65BBd0+PlYIPFs0LScjoKHUiU7LObt1
	 2wf+ux7hwa+88hq5yYGf8gCBnsNymIACFCIKNkQ2Hx5yxMz+fi39G0UsEUKtUsqhirRKi
	 nQExe/9+KwQlaTD8Yd9fy+6qNNa3YDxRLyctOJ4YpchwfclkhM4b3x6v7tNW1S5zA/+UG
	 wgeEyZL95634S6RQbydrkXiUzGYTJVIHN6opkRBLR5u6dK6gF7CfRP83B2egoSdflHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PrmA6Okb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB9E6075E34;
	Fri, 13 Nov 2026 17:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PrmA6Okb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0759B1F000C4;
	Fri, 13 Nov 2026 17:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591228;
	bh=nedXRIgeOGL/A4KzL3t/boA65utUqvLCf9aLjInejP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PrmA6Okb/YrLkg+vBjsKCE2HQ4XzPNIGZELuAZzwW61IfNOst6h7AuagQLP6feRl7
	 26eI0tBX2r9EJvYlz9MpeJWTBuMNDeyiCfR1/CFZvSSYj115pX2FOfqhxb9x25Iucy
	 ijX8NBsP49wmI4TETN6SLC6iBMiMQ1NjJBQ8EckY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 358/670] nvme-pci: add NVME_QUIRK_DMAPOOL_ALIGN_512 for KIOXIA XG10d
Date: Fri, 13 Nov 2026 10:48:42 -0500
Message-ID: <20261113153823.945493894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit c64d9b2c1f4fd1d8fa52dab37b48428a99c4d58d ]

The KIOXIA XG10d reads past the end of a PRP list that completely fills
a 256 byte small pool block. When that block is the last one in its
dmapool page, the read lands on the next page, which usually isn't
mapped. The IOMMU faults it and the controller craps itself:

  arm-smmu-v3 arm-smmu-v3.0.auto: event: F_TRANSLATION client: 0001:09:00.0 sid: 0x20900 ssid: 0x0 iova: 0xff7fe000 ipa: 0x0
  nvme nvme0: controller is down; will reset: CSTS=0xffffffff, PCI_STATUS=0xffff

Filling the block requires a slightly larger write, and those became common
with commit 2e8e30b3cf9f ("Revert "nvme-pci: clamp max_hw_sectors based on
DMA optimized limitation"").

Do what we do for other disks and use 512 byte aligned small pool blocks
for this controller.

Cc: stable@vger.kernel.org # 6.4.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index df08ebe13ea03..8cc6023e478e6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3683,6 +3683,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		 .driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1344, 0x6004),	/* Micron 4100AT */
 		.driver_data = NVME_QUIRK_DMAPOOL_ALIGN_512, },
+	{ PCI_DEVICE(0x1e0f, 0x0032),	/* KIOXIA XG10d */
+		.driver_data = NVME_QUIRK_DMAPOOL_ALIGN_512, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1c5c, 0x174a),   /* SK Hynix P31 SSD */
-- 
2.53.0



