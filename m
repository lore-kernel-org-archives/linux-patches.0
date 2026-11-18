Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019480;
	b=ocrg1cggYx5spo1Qa7I9a7beBGEa/Je2DpSrE7mNjlvhigUnRwYpnzAvfgqkB6WLN9tD
	 fqUmWpEvItjYLzuKW3iB18HvNoi14LnYZHoV5tb0nv8Nj1r2k7GcLM2Rtj6QFu2cVwSJb
	 Pg6lC6sNGkwLxjuoREa2KgejAFwukfd/7GUkDixBA/0U77hgZZHVCc/i5FlFa0hKAO9av
	 16y2A2UCNDChxQ1CCuH15Fue+R45Jw+TQgOOeBcFUlMuJEWDUusnJj2fFeWOa8g639sST
	 9oNunHwRyeBkY2Gul4Ctp4aYTa+gC1f/8+Z8rzm2Iv/bzpsZu5gEd4+xp8bz3vCUWug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=atgjTThSwwE/3plLSqeQWITTo6j3U2AByfWJpl4sb0I=;
	b=1Y93suDA9VcfIQU5SNnwLwm9gddKFq65uK6ijW66R6dJrxawGKFwBFAhAC7vBeRizOmL
	 AZIiu7nn6LRBw0irTEMdBlwKNnGDtQCeSzhXyf/ZNa0rS4S+v/Efa1V8NKykwgwOVgRcB
	 /oOybuOLMezyTSAuCyLWvF+rtNBHxiMRn8Zz6PAmlVFpjqIqlIF9rgEfmqrrG+OOcxBKE
	 IMccCEYe9ue0UvYrZTrWpTK4tGCs76gLLe4dsa9WWRuZHqEX/EQpvTJ0s5bRe7wBhngEt
	 NeeFg4wyzqr0mwFQRWSSKRtEJIMyR+1W1lPeFzW7xYBFUXO3dDBArcvwgwZohA1WpOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TohE7MBE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB79B606A7CB;
	Wed, 18 Nov 2026 16:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TohE7MBE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4DD1F000C4;
	Wed, 18 Nov 2026 16:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019480;
	bh=atgjTThSwwE/3plLSqeQWITTo6j3U2AByfWJpl4sb0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TohE7MBE+ov8c+wWEwW9yZ0e36ThgngnsP46c95YYET9bysvq7jJ14Si8g5T1YUyd
	 0idsJ+tPF/pUYPh5xzu/iW5xrMpUIadz+u3ZjyjfETieS60EzZKwYbcAB/PRCaaf/3
	 LlAG4KJGDmXFfvxfvAKOQJUxeMfIf+sqjKKO/s6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1609/2651] mailbox: ti-msgmgr: Read exact number of trailing message bytes
Date: Wed, 18 Nov 2026 15:47:29 +0100
Message-ID: <20261118150345.752096272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 8eb8df8d95a4c..fb3f7e41ac36b 100644
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



