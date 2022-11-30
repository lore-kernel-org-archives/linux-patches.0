Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5368679C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D2BC433C1;
	Wed, 30 Nov 2022 18:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833266;
	bh=R19lxn1xtWgH6t1pyKQjnNdsehIkeSh3i2BwiMMBf6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jw5Uym73mcrUSyIbXpCwXbOku+HdBq0B8IsSd/1kZjAUTZ340pA0eMCo/VVxUztAR
	 n0QAQsNOMfgsmfiY0Qy/F/D4pkCqZkvYNNibtctQeeaoy1TjPFvKzTVkH8tZGj7Vie
	 l5uIrOWgiVS3b14wcb3RCIVKhlvjbf20lhYIAsnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xander Li <xander_li@kingston.com.tw>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/206] nvme-pci: disable write zeroes on various Kingston SSD
Date: Wed, 30 Nov 2022 19:21:10 +0100
Message-Id: <20221130180533.461176240@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xander Li <xander_li@kingston.com.tw>

[ Upstream commit ac9b57d4e1e3ecf0122e915bbba1bd4c90ec3031 ]

Kingston SSDs do support NVMe Write_Zeroes cmd but take long time to
process.  The firmware version is locked by these SSDs, we can not expect
firmware improvement, so disable Write_Zeroes cmd.

Signed-off-by: Xander Li <xander_li@kingston.com.tw>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 8d6e38f636ac ("nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV7000")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 66e252af9218..a1a803b3105a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3365,6 +3365,16 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x2646, 0x5018),   /* KINGSTON OM8SFP4xxxxP OS21012 NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x5016),   /* KINGSTON OM3PGP4xxxxP OS21011 NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x501A),   /* KINGSTON OM8PGP4xxxxP OS21005 NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x501B),   /* KINGSTON OM8PGP4xxxxQ OS21005 NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x501E),   /* KINGSTON OM3PGP4xxxxQ OS21011 NVMe SSD */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1e4B, 0x1001),   /* MAXIO MAP1001 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1002),   /* MAXIO MAP1002 */
-- 
2.35.1



