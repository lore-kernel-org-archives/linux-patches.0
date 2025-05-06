Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DAD220F2D;
	Tue,  6 May 2025 21:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567350; cv=none; b=ALc0ubtxB/v0nZIbzdSP5bX3RdT8H3HwCFrVsPe2twfGLKPsK2qgZ7ImXAvGCV5svqlFmtkFG8WxFoq46e3IXg5xT2Mh3xpzx8SREdJJ0m6E+tVbzI1dsxNCaSWvJIMnd8tLyA4KMs1IjLd6oqLEakmhWHN1FtT5o/NknFZ7VsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567350; c=relaxed/simple;
	bh=z+Mr6Ym3UPcatOcr7n2Yrm8AYWpQ6LViN7grat5QJLE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XJVGczDfbwvQnr5Wg+KeTZbzJ5FgNoHCkj3FBLhUjhvgbFoUYKmReosCcrvh9X266YH2EIrgFevBb0hUPlRYeq6y2y6SYVcdW4W8eShohx4m4ZFfnbGQBHYq8NkDvgFnTNI8Uzsq5t7ajqU+RKaX8pUiTGI9iXqdzXHo7qqYG8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O1RrPeDz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O1RrPeDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B1FC4CEF0;
	Tue,  6 May 2025 21:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567350;
	bh=z+Mr6Ym3UPcatOcr7n2Yrm8AYWpQ6LViN7grat5QJLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1RrPeDzaZqCaxOReuEZ4YpnlKuC+mfouX9EkNMf39/oL609dNZXbQ4K1S8+3sUCy
	 P4xTH1FUUjlPur3kW1sf8i07rJt3JzzkyPTU3kfP6mncR3g+XwFMyAj1Te2GG+t0lv
	 Srxydy+YnhVTd1pu5nARqs/660KdKUoyJcW64vlE+8Iwj+lXZYNzZwU9e1BcyJg88t
	 fACA7gIGGEqID+nIZPtPa4gGAjboHS2R1qgbLqLyfzr7Y9f5O90ZfGz1GN5lPQWY0p
	 09dl2ke7eagm4LH2Lk8afnFKr+Y+QbI4ajCIXoBJ2SsUzunbvStcmujoQkFl7jKmk5
	 eLCReClqdNjew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wentao Guan <guanwentao@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>,
	kbusch@kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 12/20] nvme-pci: add quirks for device 126f:1001
Date: Tue,  6 May 2025 17:35:15 -0400
Message-Id: <20250506213523.2982756-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213523.2982756-1-sashal@kernel.org>
References: <20250506213523.2982756-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit 5b960f92ac3e5b4d7f60a506a6b6735eead1da01 ]

This commit adds NVME_QUIRK_NO_DEEPEST_PS and NVME_QUIRK_BOGUS_NID for
device [126f:1001].

It is similar to commit e89086c43f05 ("drivers/nvme: Add quirks for
device 126f:2262")

Diff is according the dmesg, use NVME_QUIRK_IGNORE_DEV_SUBNQN.

dmesg | grep -i nvme0:
  nvme nvme0: pci function 0000:01:00.0
  nvme nvme0: missing or invalid SUBNQN field.
  nvme nvme0: 12/0/0 default/read/poll queues

Link:https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e89086c43f0500bc7c4ce225495b73b8ce234c1f
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 1dc12784efafc..d4d109df3c84d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3626,6 +3626,9 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1217, 0x8760), /* O2 Micro 64GB Steam Deck */
 		.driver_data = NVME_QUIRK_DMAPOOL_ALIGN_512, },
+	{ PCI_DEVICE(0x126f, 0x1001),	/* Silicon Motion generic */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x126f, 0x2262),	/* Silicon Motion generic */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_BOGUS_NID, },
-- 
2.39.5

