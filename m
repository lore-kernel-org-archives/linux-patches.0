Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4099922256A;
	Mon, 19 May 2025 21:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689720; cv=none; b=AhjGfFaSOIUt2/dPtoceZ9q0+kRhATbqBy+fZvYfuGOSU+SPwWie+6j4Ytl/Sn4w872nh1zbruCJV15HT8Ab5QBW1hKe/g1dwuYTE4SF8O+o3CTw2rxpXIrcLPIqss31C+BAn2klijXdAlqJYgdFYNNE8UiSINRP8fkGQIgDxOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689720; c=relaxed/simple;
	bh=WCKkJdBWCioLO8FQG9u8oom9Dd0HozzpkWeDZzzGoBY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=obCy9L4Y1SeYBsf7f4l1TtHEhbC9ZlqQugxM6mRjMQTG2iNPzMnhUpHkuD/NTFo8w/ZgKgo8vWA/khzC0YYO6xBLVNv6tUTXBYj8/4oGYDerJEjDeOPRj5ePSryUu3UXzp1n5l5dtft+U7dDnMRCvDn8rL6UQ88cc3rAgIC+KNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XzmZu4HN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XzmZu4HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC30C4CEE4;
	Mon, 19 May 2025 21:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689719;
	bh=WCKkJdBWCioLO8FQG9u8oom9Dd0HozzpkWeDZzzGoBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XzmZu4HNI0laCDwu/VYEjZmiEfQMsD/WAUSt7rton/J7LugwP00gn6IaGmd9yTAA7
	 cGVld4oppLJtQwly6j4P8x1SM+qCQR9ESlgppLD8k98VdhffAxd0Jy/tUSLwHwCw0Y
	 xzWHgQTkqVEnGH/SdBipQxFiGZ7eY+tsDc4LGzSHMyrLsn7IzBXNFug9fRxK9AmdDI
	 l5uHfgafJNS9kZFxePHYUNsJNGQavuEe5/NZmHDN+zoSL65l15L/IrxmB6UqPzB0fT
	 h0P/jzsK6XhbpAaeBEUoNhew+inCrg3zat/takSweWy3wZM7eQ0BQ0AkENosEt38XO
	 XcjY7fmABdoVw==
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
Subject: [PATCH AUTOSEL 6.14 18/23] nvme-pci: add NVME_QUIRK_NO_DEEPEST_PS quirk for SOLIDIGM P44 Pro
Date: Mon, 19 May 2025 17:21:25 -0400
Message-Id: <20250519212131.1985647-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212131.1985647-1-sashal@kernel.org>
References: <20250519212131.1985647-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.7
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
index d49b69565d04c..d62fef76cc078 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3734,6 +3734,8 @@ static const struct pci_device_id nvme_id_table[] = {
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

