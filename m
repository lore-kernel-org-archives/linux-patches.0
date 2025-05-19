Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F9C21D584;
	Mon, 19 May 2025 21:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689750; cv=none; b=hEmjK/kD4l9tR6TceM92Z1D2NogayogVMU2djGtH2DwJiUeT3cNkn/Y7oV9Cg4LbBhejoTsPBMls5T3VLbye4qRKeDW29ZnZOVuzKR0BYtBfW6OKgq3LqNEDmK8bSk2tGihIws7tFuSCKcAlDNBMwJgs+JBEroEE4YwByjIxLWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689750; c=relaxed/simple;
	bh=dZyFCARnSEGITE3TmTBboOfTWmLSUHWZzVwCmlaSCtg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=novvxBMDpjkU+kMKXbzond8kPwPFipNBIGJQwYkPWjFn1hB2mUG1L24vziySrhAgd3sOlt0r0zejPPL15yMh61YUJoxp38fOZmmVzCmuVyjwWFRBl+BNqrNfL+SDYB/9+QGvfFMxvw3epGKWmYM7jG7k/3PSStm6TltGTLukzT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SvjeLzJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SvjeLzJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC38C4CEEB;
	Mon, 19 May 2025 21:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689749;
	bh=dZyFCARnSEGITE3TmTBboOfTWmLSUHWZzVwCmlaSCtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvjeLzJP3aWKeDlXuAWmUqslDIhvvJHiTwyxFBD1M85vkRNjHYNTNmWM2Qb5ZtZGe
	 hZE9we+CE09WabmH/Yvm8PSzD9CdHznoXnqQ/FwT+9ABSbmKuqXRCp8e9DdjA2pMaw
	 hfKOW68ql5DsOj1VtnRTeppW/RkT9Y5FJhmgVkb4X9WFpXo1krZ6NvthUFFtFEoLhS
	 Jf0ChaRY39z+q+zn91kSN9q8x/UMm3ZMDrlsmeTo9xxw7yI2DIzklXShtPDHDJQJqr
	 YvygkADgc4vwkaptklumyVOUaOwVNuWhYNc5yuuqe1REx6S+r22SIdMXrR/RAdVHX1
	 A5jWh2o3qCdfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ilya Guterman <amfernusus@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>,
	kbusch@kernel.org,
	axboe@fb.com,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 13/18] nvme-pci: add NVME_QUIRK_NO_DEEPEST_PS quirk for SOLIDIGM P44 Pro
Date: Mon, 19 May 2025 17:22:02 -0400
Message-Id: <20250519212208.1986028-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212208.1986028-1-sashal@kernel.org>
References: <20250519212208.1986028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.29
Content-Transfer-Encoding: 8bit

From: Ilya Guterman <amfernusus@gmail.com>

[ Upstream commit e765bf89f42b5c82132a556b630affeb82b2a21f ]

This commit adds the NVME_QUIRK_NO_DEEPEST_PS quirk for device
[126f:2262], which belongs to device SOLIDIGM P44 Pro SSDPFKKW020X7

The device frequently have trouble exiting the deepest power state (5),
resulting in the entire disk being unresponsive.

Verified by setting nvme_core.default_ps_max_latency_us=10000 and
observing the expected behavior.

Signed-off-by: Ilya Guterman <amfernusus@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 83ee433b69415..8fc9a7e38daba 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3693,6 +3693,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x1e49, 0x0041),   /* ZHITAI TiPro7000 NVMe SSD */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x025e, 0xf1ac),   /* SOLIDIGM  P44 pro SSDPFKKW020X7  */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0xc0a9, 0x540a),   /* Crucial P2 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1d97, 0x2263), /* Lexar NM610 */
-- 
2.39.5

