Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE681A76A4;
	Tue, 30 Jul 2024 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359924; cv=none; b=RCJy+B8VWHwAoA/tifzjd4gxEvktKFjfvY9CaSwtJwfksKVAOoYq8u2V/bB7B5n8+Zvb13yG/+PFr47N99+Zj8eSdlBuVYqaGYfZq3bjgzU0dBkWFJMYQueAXaHrUyMPzsF1z5YkVX2Xp/Ju9Tf9FQUqno4yKHsSUO5/hvvBxp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359924; c=relaxed/simple;
	bh=k7HEe/FBe1ZbO7s3h0FmRcGB7yUAWzouu8oQPOant5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vqe6kujN8pfVMHMyTvTVqmLvfUNu+PZ7AbynTnq7BkkqsooKQI+oB3cLag0BvH2d2AV8hU3Ldn5MkQhEqLCyQ/TmEDQ9KHEhwGZSp1uF0zeN9/i1yhx70gNjJwhhq8mwsQy/grGTI9I5jLti9jEcJWnAKxsstf+OroeBSHLK8bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zw0+nfQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zw0+nfQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB97C32782;
	Tue, 30 Jul 2024 17:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359923;
	bh=k7HEe/FBe1ZbO7s3h0FmRcGB7yUAWzouu8oQPOant5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zw0+nfQBIG1Qen5mh42igWfIq9F6HQSmtNMFynA8GA85HclBYI5fOvq8QvWt+7M3J
	 hMKG46UXLLShodT3pI0x92Ov8OzTrrHFIrO/glbWxF7drJ27BtWJBx4e+ugEt4EMUW
	 lngMsX69iw8PedYKgXDqvgcU9o5ZTVn2JFvLBYFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 556/568] nvme-pci: Fix the instructions for disabling power management
Date: Tue, 30 Jul 2024 17:51:03 +0200
Message-ID: <20240730151701.890741993@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 92fc2c469eb26060384e9b2cd4cb0cc228aba582 ]

pcie_aspm=off tells the kernel not to modify the ASPM configuration. This
setting does not guarantee that ASPM (Active State Power Management) is
disabled. Hence add pcie_port_pm=off. This disables power management for
all PCIe ports.

This patch has been tested on a workstation with a Samsung SSD 970 EVO Plus
NVMe SSD.

Fixes: 4641a8e6e145 ("nvme-pci: add trouble shooting steps for timeouts")
Cc: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 710fd4d862520..7c71431dbd6cc 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1275,7 +1275,7 @@ static void nvme_warn_reset(struct nvme_dev *dev, u32 csts)
 	dev_warn(dev->ctrl.device,
 		 "Does your device have a faulty power saving mode enabled?\n");
 	dev_warn(dev->ctrl.device,
-		 "Try \"nvme_core.default_ps_max_latency_us=0 pcie_aspm=off\" and report a bug\n");
+		 "Try \"nvme_core.default_ps_max_latency_us=0 pcie_aspm=off pcie_port_pm=off\" and report a bug\n");
 }
 
 static enum blk_eh_timer_return nvme_timeout(struct request *req)
-- 
2.43.0



