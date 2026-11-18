Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028697;
	b=fCFI7Y38kzJ4fuX3sXNrnPy/NC1VQ/Nw/YITMRKUVTeXyRE2Sw3ttJ4bdvjUQDhfj8Bk
	 w5xLD1bk5W5liHT/d/qORGteygObq9BZWM8YG7MyomANP2ih9GlLVTHaeaQjLJNSvcyb/
	 70Qv86saMUv2E7k50mtu5fXtYQ/50HiaBp4XnEZ02FKWC+5NPqwwMtzihH4mQQwbjLQuw
	 IWLu1I85vKiVafM7cIVxmStSYdqNVyY2FMUSUHpOpbYL/zLYB+DcaGOLPhsD/4MM0ZUJc
	 5KSXJVKEfm9JJIZPtMxYSowuoC8rCdIE+b75J8MuK4U/YPQhjM9xZ0RJ2DpzO758JgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I8dA+0Z7X46ihU/0K4VDaFdCbhdrgThQuA1w7/jrKC0=;
	b=2D3dlbzddTWulC7faJFVHX1g0xusDpeVLu70/HV7Xexy8bkShlKQG7d9fWxHhyZuRYmg
	 qd9y6Bth5sDFuPMJ8b/i9hcltTqQrA4AmDW1XNEf+XUj6Qn4G4MZzfNn4u5JRi6pct6hK
	 iNSURDnKtPMitY7Z2tOjZxlkmolsM7OfN11U/GObxLji440vRbK3YFE+HR2FUUMJBSVHu
	 V1knpl80bQh7D/+7R/9oXicj13JfhYa8FkusuAkQ+L225bWTR3sHIXAQEu+IcIeDUD5xm
	 LW8X6wUcNvA8OUIlIaGAhpTL9lEBDC0j3zSf4PRKy9SmrhtE5zbX1+EQX1V7QZxCeIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOrcezIr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11CD606A31C;
	Wed, 18 Nov 2026 19:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOrcezIr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13DA1F000C4;
	Wed, 18 Nov 2026 19:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028696;
	bh=I8dA+0Z7X46ihU/0K4VDaFdCbhdrgThQuA1w7/jrKC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOrcezIrg60EiOAFjzi2lPaZ8ocScFU+RnH3M0C8kRQT3BGRVpfR/5p/NU4ugW5oj
	 jPEofXgDsEzMD5adxk6EwescOmQc1/AaXr9MPecXTw/OVbmjs4IPv5PwWaBi2RaTrz
	 t92amFD8FAPF/GWjDgbrhnSS6KONj32DoP8ZV/qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0087/1756] nvme: unregister when pr_register() is given a zero new key
Date: Wed, 18 Nov 2026 15:36:54 +0100
Message-ID: <20261118150011.722977028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit a9d431124fb2e58215daf0299d6fcf47bbc2d6b1 ]

The block layer PR API defines a zero new_key in pr_register() as
unregistering old_key. nvme_pr_register() sends Replace Reservation
Key with a zero NRKEY instead. The host stays registered with key 0,
and its next registration with another key fails with Reservation
Conflict.

The pNFS SCSI layout client unregisters this way at umount. A later
mount cannot register and sends all I/O through the metadata server.

Send Unregister Reservation Key when new_key is zero.

Fixes: 1d277a637a71 ("NVMe: Add persistent reservation ops")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index fe7dbe2648158..d8b6ac4d83bb9 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -128,8 +128,12 @@ static int nvme_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
 	data.crkey = cpu_to_le64(old_key);
 	data.nrkey = cpu_to_le64(new_key);
 
-	cdw10 = old_key ? NVME_PR_REGISTER_ACT_REPLACE :
-		NVME_PR_REGISTER_ACT_REG;
+	if (!new_key)
+		cdw10 = NVME_PR_REGISTER_ACT_UNREG;
+	else if (old_key)
+		cdw10 = NVME_PR_REGISTER_ACT_REPLACE;
+	else
+		cdw10 = NVME_PR_REGISTER_ACT_REG;
 	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? NVME_PR_IGNORE_KEY : 0;
 	cdw10 |= NVME_PR_CPTPL_PERSIST;
 
-- 
2.53.0



