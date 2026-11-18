Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047534;
	b=auxGznFmbkJXtuMTHcGSjrNWL/7yPN1LRHtcpaywMBsVyuEOo60et9gjwxMZT6ofRTzH
	 MN1LSDOXftnj/bRqyTITX1vnqQuOTkoziNgfpxF0ehqOco1qBife4WtR63ZViBoIIW7eX
	 TCXLu5PkAOCVAVo/0m0I/AwdJfCnUB1GfV3jHNmReoze6GjfsRyCuIWsiTJyQBVgDUDvR
	 uw6k2yhTJS3qCFeoKnyN+qaXEjsLd9UaHNlaW0bOK6OW5Uya0HeHP3VxkTotVY+lP5VWI
	 FriJFWj6pVfFtG6iDECeGo3jL6wyXYx6RIPj5esUMQtes1sjYp+peCRmqg4z7by3eAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OME0u0ewg0TMDnX+e1ElQg1XwGmHftu7zlNPtdcaGfQ=;
	b=sLvRLj2GEaffe+RYQ78ypT3/yP/o+RFw6KQWOfAshN4fNn5TWTQgGQN7ST3pv0pZSIu7
	 u75EwkfpDbdhE6DhOhtRyE229ecKs01QzXgMmfCfTY8pP4fmeZbTL5l6R0L9Xhicjteu8
	 DYaI2hE8pf3Hyq7VnUyG0q6YN0RWHDkSxJYjsu9G1OsIugQ+ZzPUuT9Svb1bk89gasPuO
	 UMJDKUYXa+cxjgq2Miri5phPsIB08t5SqlCIqfnztHXsHH2i33png/nAQImXkbsHuujQt
	 UGiyuRb8SDbE4XOGjTT7CZGLYB2JNS3g+Y+RLqAaXv4PZSY6QY3MCJtG/9H5WJpRPXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="op/ETZwH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF16606A320;
	Thu, 19 Nov 2026 00:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=op/ETZwH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CACC1F000C4;
	Thu, 19 Nov 2026 00:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047533;
	bh=OME0u0ewg0TMDnX+e1ElQg1XwGmHftu7zlNPtdcaGfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=op/ETZwHGOualECfAvjqkLOKxti+tPdXgJtf9dwePoOmpS8uMWICW2u7/qMMW6U9P
	 BMBGE2/CzUcEyBGKWjT3nPnsq1SZdO8v0whW7bMFO/SMirzJ8s6bopmJT23c5MbP45
	 PRotVoj75FgLAug+36UsKAA9bGLBrpkVJtxScIcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1672/2857] nvme: unregister when pr_register() is given a zero new key
Date: Wed, 18 Nov 2026 15:45:06 +0100
Message-ID: <20261118150301.529796182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the change to the existing nvme_pr_register() implementation using numeric values for unavailable reservation-action constants ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 61a34581ca70a..d3f4fd67a0ec7 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2236,7 +2236,12 @@ static int nvme_pr_register(struct block_device *bdev, u64 old,
 	if (flags & ~PR_FL_IGNORE_KEY)
 		return -EOPNOTSUPP;
 
-	cdw10 = old ? 2 : 0;
+	if (!new)
+		cdw10 = 1;
+	else if (old)
+		cdw10 = 2;
+	else
+		cdw10 = 0;
 	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
 	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
 	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
-- 
2.53.0



