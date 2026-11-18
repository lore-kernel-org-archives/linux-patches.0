Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041217;
	b=DFahwC4uXE8nWmfomaueixvwnf5eAnk9Eq5MdAtxh8KsxT8HYa0JNn5Fp7oKxix+JnG0
	 E6O1umJP7mcA0o2VnrKFBbO5Mf2FH2FsruadC0xClXykge/hVZcGEYrYfOED5hqJ+l4Bs
	 jkeDKCHu3PIWAN9N0NG056c7SXOvV+ahd0Gu7+Gp3XZ9YO1Vozso+89Zwd83cqDpDUJ+G
	 l7SqdhoUb0yFPK4UBRSnnqCnC6lAwbbbkb+VKjUIme0CfGM0GRVh8Zb57oUCsxpWKQGfG
	 CT+baDpLipWnLP5KZXcQKhAq/MD0ED2t1B0ca7RtYhRtZUPQfPBWx5DhtDaQ49+vTiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HQNSdft1pq+ot0LBR9E9+6QFjAIfGOzPXpa1Kc4Oi8c=;
	b=rHBIIPc0/zPKO46FhrSQg72CQbhemJe1sNH0fG3aCjgdY0sGl/99I+sq5Ji7fuyuzpme
	 TFQjxuoUHesE66zJiQViJg90rzi6GZuUL7OiGkDTEakwb9yE+TxIhsd+UVdIcqtARAxeB
	 RIc3NtkA/z+8CeTxavOXiY+cpqGfZ6LLiVCZNCtxOp8F01Z9F+zOj7DAX7uUj4oxV/fp6
	 GZUB3aOyFFbjt0QOpvYihb2XOWsoBiC9K2psgNmsWl8lTOEFryOwy9OyDFoaT45ReqX49
	 wzgvxiGwMRc+G/UcnOxdv6bUuSzhLlDIhRd7odS4N70lUjMjtTKeeb1OMogNGqccDqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QQM/UPxS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFF8606A32A;
	Wed, 18 Nov 2026 22:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QQM/UPxS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470A91F000C4;
	Wed, 18 Nov 2026 22:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041216;
	bh=HQNSdft1pq+ot0LBR9E9+6QFjAIfGOzPXpa1Kc4Oi8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQM/UPxSqX3cDOnKnG1xp6YIMZhuAoyDCTKK0UZ5MVuqTthZ5npQ9ClCqGO1ATkDW
	 z5xAicfWzAH3W5qUyHJTM5/6k+fpZ20aA4Z+peKQjkCmsrc9dADuNCoMC+Ebk/CcF0
	 sSUF2NmBCXV03wl/xOrkixwxEiMXBOxdu/KOhLWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2734/3318] mailbox: arm_mhuv2: time out if the receiver never comes up
Date: Wed, 18 Nov 2026 15:55:56 +0100
Message-ID: <20261118150442.829854090@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 86976f7cc324aac254136a352f74ac17f21e574c ]

mhuv2_tx_init() waits forever for access_ready. Fail probe
after 1s instead of hanging boot.

Fixes: 5a6338cce9f4 ("mailbox: arm_mhuv2: Add driver")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/arm_mhuv2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/arm_mhuv2.c b/drivers/mailbox/arm_mhuv2.c
index cff7c343ee082..76c274931e813 100644
--- a/drivers/mailbox/arm_mhuv2.c
+++ b/drivers/mailbox/arm_mhuv2.c
@@ -27,6 +27,7 @@
 
 #include <linux/amba/bus.h>
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 #include <linux/mailbox_controller.h>
 #include <linux/mailbox/arm_mhuv2_message.h>
 #include <linux/module.h>
@@ -968,6 +969,7 @@ static int mhuv2_tx_init(struct amba_device *adev, struct mhuv2 *mhu,
 {
 	struct device *dev = mhu->mbox.dev;
 	int ret, i;
+	u32 val;
 
 	mhu->frame = SENDER_FRAME;
 	mhu->mbox.ops = &mhuv2_sender_ops;
@@ -1011,8 +1013,11 @@ static int mhuv2_tx_init(struct amba_device *adev, struct mhuv2 *mhu,
 out:
 	/* Wait for receiver to be ready */
 	writel_relaxed(0x1, &mhu->send->access_request);
-	while (!readl_relaxed(&mhu->send->access_ready))
-		continue;
+	if (readl_relaxed_poll_timeout(&mhu->send->access_ready, val, val,
+				       100, 1000000)) {
+		dev_err(dev, "receiver not ready\n");
+		return -ETIMEDOUT;
+	}
 
 	return 0;
 }
-- 
2.53.0



