Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03231C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5127CC433D2;
	Mon, 20 Mar 2023 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326156;
	bh=JwpjM/WD8Rnle4fVUJBLIFWdz8yMifu+okXcPrSI+zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxvoBrNkDJG1KV+3e1mkhJaQ3RahEWnSgCFobK8kKUN/4euslyKYWRykyn2lsXfGo
	 0vkqVizoDeTaCX4JxiIYU7XGAVE29evUehsjY+/FM2b8r8em/T7jCFHJipR/jKdY76
	 wr/O6MqeOBYm4IXIan3hEJEdqJvYpQz479z7qkEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elmer Miroslav Mosher Golovin <miroslav@mishamosher.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.2 182/211] nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV3000
Date: Mon, 20 Mar 2023 15:55:17 +0100
Message-Id: <20230320145521.116511826@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Elmer Miroslav Mosher Golovin <miroslav@mishamosher.com>

commit 9630d80655bfe7e62e4aff2889dc4eae7ceeb887 upstream.

Added a quirk to fix the Netac NV3000 SSD reporting duplicate NGUIDs.

Cc: <stable@vger.kernel.org>
Signed-off-by: Elmer Miroslav Mosher Golovin <miroslav@mishamosher.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3468,6 +3468,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x2646, 0x501E),   /* KINGSTON OM3PGP4xxxxQ OS21011 NVMe SSD */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1f40, 0x1202),   /* Netac Technologies Co. NV3000 NVMe SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1f40, 0x5236),   /* Netac Technologies Co. NV7000 NVMe SSD */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1001),   /* MAXIO MAP1001 */


