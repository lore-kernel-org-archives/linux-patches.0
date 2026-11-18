Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061456;
	b=eJUzIFXYdT7U4fn5eMggo0WsLhjfeU+i7NWb6LEIQG51N+Ag63gWXXs/J7g6n5X7yG8C
	 6cq2OzBCwJDppDEI0FKaTAJL0OnrNGrM1JfEedxnI+9jOo7S6eYJHT9s/XVx1Zj1mdEBY
	 9fOZHYpvg4QHFOw0+qWJASatjaGjyaXfidH1B2q6aZf9aOQ5Ke6FmQ1u4F3MDDCpAhBrU
	 /4ZOBHu6NBb/2mD7NI32nChMwyt0ZNo23F+0jdLbEuWcUCM72NyJzDVniCxi8uLXK/q0Z
	 C7Ff780f/6IyYBjN0nmFRFbNFM3hKa4/PgFwLX9cPPwCB8R77wr6CoZaUUBXAzB/MMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W8cYhzV34vAq2pf5Rm6IRMKZHS+nO25yCUCuwsfPAdE=;
	b=k+B3khqaKxeO4RhzEfB/ubncTGU3V6T5uzMnZONUcQPeqnjJ3RDkWtnwmOI6XPfrOEax
	 BRbzZ7XmWxm1D24fGS7/X1ZNfo3uHuH5d+TD1y1412CwTu9mYkgB8Ja1Q+cpTuYbKqceu
	 fmKS1sMMHF6T9+rB6R22XeM7IP2Y285Z64SKHHrgYEdWw2zZff2ZHQa7m5RorwV8YJXtE
	 oaCO9v9uFiC6Aa6uVJSlVDZhPmFapTgQTkubWNIJG8vVSXDsrSCQk63HVR4cc5B7IH/ne
	 xGZMLe93kOhOpP4TZgRa/OH/sUYmeCET9R17HAEFxOB0y4y/1+20VGB1WEPs6u/g4cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MypP6VD8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78E1606A325;
	Thu, 19 Nov 2026 04:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MypP6VD8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3AC1F000C5;
	Thu, 19 Nov 2026 04:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061456;
	bh=W8cYhzV34vAq2pf5Rm6IRMKZHS+nO25yCUCuwsfPAdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MypP6VD85o51bQ/7MSirRdAOw+SlQpdMXx9shMxkBMeniwadWJTZGHNE0kygV0ybH
	 +Ey0uKfuZGZ1BfSxIi9ETEESqxG4seHx+wOmQ4G5k1Efg1Eb+GVCK1aq2/6TSAkJj3
	 R+mo8uRlFeF7/+Kk2rSVE9MT+lpYUChv4VzXVRxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1560/1848] mailbox: ti-msgmgr: Read exact number of trailing message bytes
Date: Wed, 18 Nov 2026 15:59:58 +0100
Message-ID: <20261118150024.914538163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 535fe73ce3109..523eb0e3db369 100644
--- a/drivers/mailbox/ti-msgmgr.c
+++ b/drivers/mailbox/ti-msgmgr.c
@@ -19,6 +19,7 @@
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/soc/ti/ti-msgmgr.h>
+#include <linux/string.h>
 
 #define Q_DATA_OFFSET(proxy, queue, reg)	\
 		     ((0x10000 * (proxy)) + (0x80 * (queue)) + ((reg) * 4))
@@ -380,10 +381,15 @@ static int ti_msgmgr_send_data(struct mbox_chan *chan, void *data)
 
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



