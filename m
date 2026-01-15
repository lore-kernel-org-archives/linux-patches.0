Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6713DA7D4;
	Thu, 15 Jan 2026 17:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499955; cv=none; b=ZcaVAwCeJCvdOWqzV7hvPk0C6mY5i3LsridWsnAk/YChNuUnh9owp1vHYBuutnAxCDpvpflm59m/mbfNb4aCYhdtZDR7QvdJpUddorlN3et+08C50shJMyTz1ZdZbGVoEGpBsuxc/ezphg+Kk2CGa0iayYESkFP+aQ1xoc4B93c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499955; c=relaxed/simple;
	bh=yIwLk//Pml53rkD5JNKCgZY0UdpqU4q+8ALIhVZRxsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ee1eaBKE2NDJF56qXx9qs7VkfyKG+8bzaP8djgGOq+p6ALYH8nrgak/Vub3EIC6mC5q3wi981cPKRTEn0c3+JbnPeiz5lUZkPJhOHsThnaOjDG9efeNF0+HOH/oW3QIPW4I4DQni5ZquOPBOVZH5FwMAYhdI2Zu1NVy6mTzbUgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sS4ZeBBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sS4ZeBBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA90C116D0;
	Thu, 15 Jan 2026 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499955;
	bh=yIwLk//Pml53rkD5JNKCgZY0UdpqU4q+8ALIhVZRxsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS4ZeBBi5xeB4zcNYBkdTs3s+AQXXVO2+TNZPnrGp1z1j+Y15UquwVREsYJhVABeg
	 L7NqCEVxPl6pYoZEjJjrYEYkcd3PAnwfuGvVewlfA6ykEDl68WWZzB63y6DRbRUCbX
	 AywdMP4Mh6REwgvljGQs5fsa0iqmRKWAfIHm6biA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <ashish.kalra@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/451] Revert "iommu/amd: Skip enabling command/event buffers for kdump"
Date: Thu, 15 Jan 2026 17:50:07 +0100
Message-ID: <20260115164245.628893616@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 30e91eeb0bc9b3daf402b26176d1d52c29ab53e4 which is
commit 9be15fbfc6c5c89c22cf6e209f66ea43ee0e58bb upstream.

This causes problems in older kernel trees as SNP host kdump is not
supported in them, so drop it from the stable branches.

Reported-by: Ashish Kalra <ashish.kalra@amd.com>
Link: https://lore.kernel.org/r/dacdff7f-0606-4ed5-b056-2de564404d51@amd.com
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Sairaj Kodilkar <sarunkod@amd.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |   28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -697,16 +697,11 @@ static void iommu_enable_command_buffer(
 
 	BUG_ON(iommu->cmd_buf == NULL);
 
-	if (!is_kdump_kernel()) {
-		/*
-		 * Command buffer is re-used for kdump kernel and setting
-		 * of MMIO register is not required.
-		 */
-		entry = iommu_virt_to_phys(iommu->cmd_buf);
-		entry |= MMIO_CMD_SIZE_512;
-		memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
-			    &entry, sizeof(entry));
-	}
+	entry = iommu_virt_to_phys(iommu->cmd_buf);
+	entry |= MMIO_CMD_SIZE_512;
+
+	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
+		    &entry, sizeof(entry));
 
 	amd_iommu_reset_cmd_buffer(iommu);
 }
@@ -755,15 +750,10 @@ static void iommu_enable_event_buffer(st
 
 	BUG_ON(iommu->evt_buf == NULL);
 
-	if (!is_kdump_kernel()) {
-		/*
-		 * Event buffer is re-used for kdump kernel and setting
-		 * of MMIO register is not required.
-		 */
-		entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
-		memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
-			    &entry, sizeof(entry));
-	}
+	entry = iommu_virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
+
+	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
+		    &entry, sizeof(entry));
 
 	/* set head and tail to zero manually */
 	writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);


