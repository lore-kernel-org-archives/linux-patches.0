Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031411;
	b=WbBoS/Ig7FDJp1bt8s+t6U6HcH3OlCnzLhRFpw1rJhHYBBiDYdjyugUb/vkJmaFcLVQY
	 NiXQL4UZhrAIIH5MzTBSMBVPMuRHJ95QjLWK2pIoshnVanv7oHf8qmgQuTLeKhESyIJwg
	 yDwUikHXjoTp2j83JqcSv8BkDlrnisvJh41hdQdvnUaJTAsXRLHE3S9GB9qvPqLg1yZfz
	 jqeJjDx5q1SJBxtLPL2M2iUYRLivsGc5mQ5ax2QDyzvCf4ejVj2RZ2dPwfLA/6qj/pb7D
	 Zstc+Y60xlQbaUFt+NiYy3XHzG/jHpn8oXJ6tfWo9FkbalCEylvewpjZcjXEsLZ3ebQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FbXLJ6hwT7f5Quh/xXC/kTfKXu3sPyPwmhEJNk5egjw=;
	b=WT6RPxyu73qxzRpqAO2thKOYM9gbpm41fMd50FIOKRvvmC1VIe93b6kljQAaZ1dpUq7+
	 04pEjhdY0f9hpAN6yZzzavrMu230AS+pzNNfAYC7QzBeiQ0a1gxL1t9yEFn2qEEciLHgM
	 /eocG8fwu0mm2J8tQvP4AR2RbM53pVxE1OE+TS1Ui1BPC6QnwR74sSg/VnKE8ghw0Hg0H
	 AHT1/A7DskXITDGAU2lTc1BlpBk34Us5rylZECagGtPO80gct9h/Ixm+XxpIpmX8lB240
	 4Q6OHqt8jEExLe/5Qd0iA4S8m1uqHzZ8FBxSml9ebdZJVRMJR8a1fRR4o5TEPB7CWfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FiwOUUHw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A7C606A339;
	Wed, 18 Nov 2026 19:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FiwOUUHw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7A11F000C8;
	Wed, 18 Nov 2026 19:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031411;
	bh=FbXLJ6hwT7f5Quh/xXC/kTfKXu3sPyPwmhEJNk5egjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FiwOUUHwMajh4OVe1V3pGrBTtfwfzHACve/S5q/GwqU5mAGoOyS7kXpd0PaiqSvfk
	 fKHFoI+PdoWPcBmOtMuT/vYuB1tmZSUSszQxHhcvJxnQxEXXzlIOx33QAuaYxNqo1p
	 ieUHLRQSdgh68oRDIl/CP7hnnPSDq8rBk6QbUzeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1048/1756] mailbox: ti-msgmgr: Read exact number of trailing message bytes
Date: Wed, 18 Nov 2026 15:52:55 +0100
Message-ID: <20261118150051.816004903@linuxfoundation.org>
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

From: Beleswar Padhi <b-padhi@ti.com>

[ Upstream commit 645ae2edd5597501b4af3837a644877fbe194227 ]

ti_msgmgr_send_data() copies the message to the data registers in u32
units. This has been harmless so far because the clients (TI-SCI)
always passed its preallocated message buffer, which is sized to the
maximum message size (60 or 64 bytes, a multiple of 4), so the extra
bytes read were still within the buffer. But, with a later TI-SCI
update, the message size can be varying now and not guaranteed to be a
multiple of 4, which would trigger KASAN out-of-bounds reports.

Therefore, memcpy() only the trailing bytes into a zeroed u32 before
writing it to the register. This is at most 3 bytes, so the overhead
is negligible.

Fixes: aace66b170ce ("mailbox: Introduce TI message manager driver")
Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Acked-by: Andrew Davis <afd@ti.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/ti-msgmgr.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/ti-msgmgr.c b/drivers/mailbox/ti-msgmgr.c
index 9d2d4ff6cda40..df88da50a886c 100644
--- a/drivers/mailbox/ti-msgmgr.c
+++ b/drivers/mailbox/ti-msgmgr.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/soc/ti/ti-msgmgr.h>
+#include <linux/string.h>
 
 #define Q_DATA_OFFSET(proxy, queue, reg)	\
 		     ((0x10000 * (proxy)) + (0x80 * (queue)) + ((reg) * 4))
@@ -425,10 +426,15 @@ static int ti_msgmgr_send_data(struct mbox_chan *chan, void *data)
 
 	trail_bytes = message->len % sizeof(u32);
 	if (trail_bytes) {
-		u32 data_trail = *word_data;
-
-		/* Ensure all unused data is 0 */
-		data_trail &= 0xFFFFFFFF >> (8 * (sizeof(u32) - trail_bytes));
+		/*
+		 * Copy only the trailing bytes instead of reading a full u32,
+		 * as the message buffer may end right after them and a u32
+		 * read would go past the end of it. This also leaves all
+		 * unused data as 0.
+		 */
+		u32 data_trail = 0;
+
+		memcpy(&data_trail, word_data, trail_bytes);
 		writel(data_trail, data_reg);
 		data_reg += sizeof(u32);
 	}
-- 
2.53.0



