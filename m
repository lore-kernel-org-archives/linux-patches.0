Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E677822F757;
	Tue,  6 May 2025 21:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567428; cv=none; b=YsuTu93VRPRf9FLozhvReRZepsp2S9yVzswF3EmBQS363Xx7O5r1tlRL1QX/sjmLVW+MbZjjkxMWAim/u8XWD3yAiDPW17kJwpYDG7HpuEqWmwC/ZPdjHNg9nZtOsFrgnKv/nZzyxrD1Qm3HaGQYLJxeZPm6wHFKZhTh+4K3CZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567428; c=relaxed/simple;
	bh=xcjlLSgn1Tt/P9DMlCgwzZshykWA3CEBFvuoEeQscz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G6MG5XinjqlUBwsxrGktdygNQAIgqzt/tXptGglhpAhtwRHr2O0NsYu/+lScLy4Ffkq7BgZw0/b94EfLVYo8hr2/Bjggfc8b2fEDDWeIT3WPc8S7pu1n7HpNhz6kL29ErIdsvm2F155WxCe0yvjPs2rMDdLBe+8kcfPQZx+Dh5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r5Rxwrdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r5Rxwrdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D68C4CEEE;
	Tue,  6 May 2025 21:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567426;
	bh=xcjlLSgn1Tt/P9DMlCgwzZshykWA3CEBFvuoEeQscz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5RxwrddDrS3vrU6vVChYh4xdeIAb/HLFFzau9osfjDKM6esIeC0nnB0oxW0GEVoM
	 mkArZPhEMz1MsDqZYp6cz44q2hogOXHDMRk7UtNqyblZT7L5GuemzFfMF16+w3cqbc
	 gEBZoQAOPUjkSpLPffvYkqCh0DIh+soad9N0L1MHyhqqgs9JxfMtaH7k9xxGes9aow
	 DZNGFlBEjikzabor1xdVkEwLYnGbYkZzR609fky+/UuPOf4pkj5iIJsX1JtGRDmRUr
	 ktsayt2zVVPI6tZykWVY7PmOKr/2W0L+83PQm/O12kjQDuaG2Sy7zzcxOUZzBxgS/k
	 JYxlRhf8ul3pQ==
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
Subject: [PATCH AUTOSEL 6.6 07/12] nvme-pci: add quirks for device 126f:1001
Date: Tue,  6 May 2025 17:36:42 -0400
Message-Id: <20250506213647.2983356-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213647.2983356-1-sashal@kernel.org>
References: <20250506213647.2983356-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
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
index a763df0200ab4..8eee28282b1e9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3427,6 +3427,9 @@ static const struct pci_device_id nvme_id_table[] = {
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

