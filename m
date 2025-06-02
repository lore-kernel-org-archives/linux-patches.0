Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6B222259F;
	Mon,  2 Jun 2025 14:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873996; cv=none; b=LXnYs0MolWD9Dac3rVSRNWHS9DgPsDH4Bt/QQ3nl58Xbij+889I/bdpwRiymjNp+7Tv1sYEHe9+5Tkbbp7QwUJ55PlYQq3+wLKynuJKDygTiwUm/mq85GCWtqOk0W5YIT4oe6FRLCHkfL0NmVXUtvsCb4nJX3IU8sqnAXydSYPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873996; c=relaxed/simple;
	bh=dEFYs1z6m+ZdQD+RPLYtu025eJnhZLmu9MuYPV9uVfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzUK4dg2WoHx89GYxg7WgYL7bHVN/4b12C8zRi1uOIp7Jh1WILR3Kuj0Yr3sEHR6t2ntQgnmh9AGH2eR+7iDaRkwD4MG+tP3cCA3kwgoF7Lc/2YV1+2QsHIx1tS20lIwMl122JC8mgtKjTGrBwbZQQMs+waddp3YRK47c6bXN3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vK2Ud7B2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vK2Ud7B2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F5BC4CEEB;
	Mon,  2 Jun 2025 14:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873996;
	bh=dEFYs1z6m+ZdQD+RPLYtu025eJnhZLmu9MuYPV9uVfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vK2Ud7B26LEPqepW2gcHAnJjjvuAT8TdynQvKN9/my7XQpljLAso8xsrpkQHc5L35
	 YaXf6sU1y0SiT4YauWfjbvu8NzewMnn2JhOC6x2brd01JHmF777ZdfJynb1eTFGxvq
	 SHFGv6kWHP8OkwgAMjPCCcesqJBuWOhz/LqIAnGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <quic_yabdulra@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/444] accel/qaic: Mask out SR-IOV PCI resources
Date: Mon,  2 Jun 2025 15:46:09 +0200
Message-ID: <20250602134353.314148773@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Youssef Samir <quic_yabdulra@quicinc.com>

[ Upstream commit 8685520474bfc0fe4be83c3cbfe3fb3e1ca1514a ]

During the initialization of the qaic device, pci_select_bars() is
used to fetch a bitmask of the BARs exposed by the device. On devices
that have Virtual Functions capabilities, the bitmask includes SR-IOV
BARs.

Use a mask to filter out SR-IOV BARs if they exist.

Signed-off-by: Youssef Samir <quic_yabdulra@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250117170943.2643280-6-quic_jhugo@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/qaic/qaic_drv.c b/drivers/accel/qaic/qaic_drv.c
index b5de82e6eb4d5..e69bfb30b44e0 100644
--- a/drivers/accel/qaic/qaic_drv.c
+++ b/drivers/accel/qaic/qaic_drv.c
@@ -400,7 +400,7 @@ static int init_pci(struct qaic_device *qdev, struct pci_dev *pdev)
 	int bars;
 	int ret;
 
-	bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	bars = pci_select_bars(pdev, IORESOURCE_MEM) & 0x3f;
 
 	/* make sure the device has the expected BARs */
 	if (bars != (BIT(0) | BIT(2) | BIT(4))) {
-- 
2.39.5



