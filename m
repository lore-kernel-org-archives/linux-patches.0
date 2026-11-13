Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585569;
	b=gmwwF4OzBnkPpZafPhoMky8vLDjAIoRVTvmNN7q3a986ImFtEZk1bxjxe5Mlxfe+8cPr
	 xAmQ6RRFljN62RyHk7oS8Q37KKhn+mdr7cTtb6hDG/lsRNtufDDnSFXHWFOlPXC2dQPwt
	 oZ/Y+dsYA0NZejDMwlLxENl5SySa29Tml4MzWyBzUtyuPq5m6XRTEkN2fIc8bGNtYUY4j
	 G93mn0C7j1RhFlMncyzj2l3mLZ3WWUk6BoGNEyBxoK13GU1vo8oNxngpBNmKqh6A3dqHJ
	 c/T0OUHcs8LauIvg46PeuS8RSWtWcBih4Th1CGnihq3FOcmwzPqZwJvObs0kYEMBVng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ssv8+DGh3oTpZjmOT0zt1mAUpK8cwKUy8Wr9JP1a8ZE=;
	b=Cld5i7QirtIw+nRKPyNtTigldnI21uFN0x3++5Ho2ZGawYAgg5kCnwGFEifk1bgSZrkS
	 U4skbOjoccK7D3hdpSWW6bA9urV7xY7E86S4Ekdj7zOXEx2xAs+48nFimYzaZrWeTN6S9
	 hw+Gy7ChL2Jxmdn7pstBtlG21y/B200V1tJSaqRYRjX/4BkBX6TUbtc3wabHkCidNFHfm
	 BO7Fg1DBoLNApySUDeQdmurJynzvSD3TFg9kY/JyCBeIsDVWnOBRrmIdAxuV7/ETGSwic
	 Wz4txEwZXlbEvvRr63s+nTtUXY++M7Oz9TR8RLgm/Qk35KqP6RgpeNvTnHkdk9ndtrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPKFmSb0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB00606BA88;
	Fri, 13 Nov 2026 15:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPKFmSb0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED06A1F000C4;
	Fri, 13 Nov 2026 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585569;
	bh=ssv8+DGh3oTpZjmOT0zt1mAUpK8cwKUy8Wr9JP1a8ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPKFmSb06iJQuoBk6JYRKF/8Yxa1PuA0XunbUflTmJmjoOoirhy8ReHercE0KkRDQ
	 VJpiYdKSc+B5ORSY6ztoPHoSci60WLUrVPFqbxJjC0wFTiWAoBEtB688Mbo+kWBaKp
	 pj7txGTslSRHRVT46k3qM4vKGaFOuXre/f8Uo7KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 204/507] nvme: unregister when pr_register() is given a zero new key
Date: Fri, 13 Nov 2026 10:48:28 -0500
Message-ID: <20261113153801.394375262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



