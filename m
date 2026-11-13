Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590310;
	b=ACciw/WlC0mUMgMx2N9xfJYqSP29tXq1rg7pr8QG35CVgdiqpo+TAbc9TU4A2uXiWR0I
	 eGx7yos9Sbi6ZTA3Z5axBa2w43u1L2tdYlj42FxuI8+o9oiAyQSiN35cwarLQSrFgK5+K
	 BFRp19naWgJ3AEpU2zBGwKQoBL6jJSOoog9OOABKeMX9tKkyA0guNryFM2T1W32701Diu
	 317NegORrqtklS0kysxaklEGMNNlEBU2VUA/GvLNnzb3M0VrWWHjL2fPzphgiuKXGq7Ee
	 4UDqB8tG9c1ZQUTbkuvnoP0rpuUPIw0SECiIIo6PsLqFHYpSnvtOa4q6d/U9sxMkDJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wZN0zT7jarGS5cym12GXxcd73OCLVcHG+pRMkOgNVyQ=;
	b=f94taxa+vYCqRStx5JKsYmHoHpRk1eR+qWe7pRomzqkD+LpkKvVHKOtpVvwOgg+Q+df7
	 UVFcdeYOwNRkibA+9eNZFgIYsfUOvhwQr/3Q7T2gg6u88VJfURbmJq6mr0PKlJluCHZ6A
	 3ISpR7+Ij2TWuCEIRbxsTgPuGRoPw6wa94x2E9JCCXrQHgk+EYTbpCgeEEmPYsVLA7i41
	 lZ+Cq5NsDCZMkFQ1VjJdW5CnapHVjKJvJyAQ7Fg/wp+ZQy+SGSccPoUg5fbi01oyRQuHg
	 fRB6IWBmY1ZjVb4fy+ZbIFlQwk0gZsbe7nh0Mx79UjvX878/jNHlCctHA2XwR0BBp+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XiyQXylb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5005607D2C2;
	Fri, 13 Nov 2026 17:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XiyQXylb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C7C1F000C6;
	Fri, 13 Nov 2026 17:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590309;
	bh=wZN0zT7jarGS5cym12GXxcd73OCLVcHG+pRMkOgNVyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XiyQXylb8H94OHhi61IgKtZ7EutCdV7qd6or1rgfTs17Pyc2d5XT1VKSTc1A2DxQN
	 zJxj37ksOutoFe4JbwLpqKQyzs1BNDZdg1oxIzm2ElN7ttKlYK9851yLmd1SstvTE8
	 Y+gIverbFT46Mk/zpxYeHltDzLuEaCfueykz+v2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 294/686] nvme: unregister when pr_register() is given a zero new key
Date: Fri, 13 Nov 2026 10:47:07 -0500
Message-ID: <20261113153830.925691161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



