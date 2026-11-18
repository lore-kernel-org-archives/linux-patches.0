Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041214;
	b=fHLj2SU2HX5N+DKQHH1fHmnZDthWoO5UF1Ex24EvbqIjSd6py912cDKTYcpJfBqqQZ4W
	 GVKo3aNr1g8Ft6hmoepaWP+rssNtYJ9LtxpLjHH6xS1Jne103jzjSR4Wupk+yMPpdzqJm
	 RgzrFWMBKMW9Vlu8XmwKbWZC8rhLuY54JGHWxnhBKmJbaupgtp3bx+MpSt6FgyyHsu2n8
	 rfwewHaT+/Md9RLrEa8AQwMwzS21wBjXh42NKlbhLog7mDiKXzAMnnaA7hwGAd4aClTp1
	 sVN0/gV/rhDOEcfq+Y2YrPSC9oqRKzuhUH0O1Kz0U7ZP/MplspJEyXr/fRYfssJp6tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CckkUWvWyEkYL8JjBiI+txAgQgkVEnlhIaD9897chik=;
	b=wZYSdeaS8r/4Q5zt7OuAn14c/UztUvR99sVVDmETFNSIDjWb6Z65//Wojzg72BUF59Qj
	 SkoEhI3d9OJ/VNVLM3QXZ0VsVjYhaeyWzcS/mPl/wU0FuF3sDBbjSJWLi4Z8UrEmkIGvF
	 n6vNaa+0BzNJShpmiUU6DhAfdeyLVbxXoPAo3rHzFZFH1wPX9Z1jSanxBw2KRXF0iktSu
	 njoKVCaCvIuhb/gX4meHCJy6fYHkne3UYK0cRcNVltFwtEsu2k69WoP56x/VZCJQB5rQG
	 6pqdfhfoCd1b0EUUdsBjghKm+wGEFNb/vn9gesQNTgXqnKCKMLz3Qgr6ZuGVUj0dNbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDO4fUbS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D41606A32A;
	Wed, 18 Nov 2026 22:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDO4fUbS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A361F000C5;
	Wed, 18 Nov 2026 22:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041213;
	bh=CckkUWvWyEkYL8JjBiI+txAgQgkVEnlhIaD9897chik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDO4fUbSh7YTmqxy1L/8JCReeOyC8UhZevg9Z9oOCH32acK5bNTjMbKKyn2qYvnjB
	 SfSzdKCy+/azmofVClkrwmNkXwJuEz5/P6MANGri/qdh8vCEQeNeLM/6eFHrFQovbm
	 3u+eyhPus56+DcCvjXCHuW7/uwQr+tFrUo6jnTHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2733/3318] mailbox: ti-msgmgr: Read exact number of trailing message bytes
Date: Wed, 18 Nov 2026 15:55:55 +0100
Message-ID: <20261118150442.798441087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a94577f16a473..a4fb039da4328 100644
--- a/drivers/mailbox/ti-msgmgr.c
+++ b/drivers/mailbox/ti-msgmgr.c
@@ -20,6 +20,7 @@
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
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



