Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25F1235364;
	Mon, 19 May 2025 21:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689773; cv=none; b=asZLwBRdqvPJF4ng8o4KeQ7GLRkkE5A+LR7EEovgq10CzzI316opoWC0FsPYkQGNn42xBnR7KE3FdUik0XgQeroDDFWsdZw0XU9hTt701kNXOfsy7IQTSXF2EB+PL4zrKg4Mp5pceZiBXUdtCtlqUJ3IGPaQ9KSOvL94cFlK0e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689773; c=relaxed/simple;
	bh=OdAFbaqqvqqn0JoN+30LNaAJcQ6twsERV993d5E2HwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PhoDQcD9pwzzZF5Hk8TAfNU3rK6xvoK0S/lZL2YATR61I1PLW370NVUUuFCpWQeEhWd/nHcJfyPEtGPZesvCQiSx4qwZre5uAJcZUy9kCawtYCYtKqOWk97UUoAyLJJgglomyDD3hE/qOPcKs6wPOpRqxpLEAtoO9pC+J2HB5NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kWnBFA8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kWnBFA8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C74C4CEE9;
	Mon, 19 May 2025 21:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689772;
	bh=OdAFbaqqvqqn0JoN+30LNaAJcQ6twsERV993d5E2HwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWnBFA8jtTCdFTrnFRY0ewz5HeEc7XmpAyi1lDl+u4nPLYFQwET4tvfpyLwsRoDKN
	 GOWdKIQDYx8vP4I9JMYmANxxCsvCyZ0HiumjB0i5r23EvaemjENHemHJK7VhlFJNM0
	 Dp4O8hF0C6E/+vXPKvfc1rRcAJuhqS9bEZVROPntBUbCss5M3OMl+rf1SFoHJfk2aj
	 +ldMkggWVMIIvPWz2tFx2a98XaTXPI0gxU2N8m6WQxE/caaVqF1WVOpy8UmXcGFXFv
	 7F+SDXL+Nre+oit7k1xJDrLLssbE/hO3CfiMdc2H4m7Zyiz4mWAVRaiMqALv6I8GOj
	 4PIbPJMIMYy5g==
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
Subject: [PATCH AUTOSEL 6.6 09/11] nvme-pci: add NVME_QUIRK_NO_DEEPEST_PS quirk for SOLIDIGM P44 Pro
Date: Mon, 19 May 2025 17:22:35 -0400
Message-Id: <20250519212237.1986368-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212237.1986368-1-sashal@kernel.org>
References: <20250519212237.1986368-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.91
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
index fdde38903ebcd..3773230c09d4f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3533,6 +3533,8 @@ static const struct pci_device_id nvme_id_table[] = {
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

