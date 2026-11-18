Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049602;
	b=5A5w9alXwhAR4xzOgVzv0Hw9kKkfEfvsF4mi9ZrAyK66EwazBL/HQn4Qvie43uVXL8WU
	 iujr5acOQWLOUu5JUee0Qpin3GfrCuSiLlR2WIsrdOCqKV56by5F7OQe6a2hDJkNcGGO1
	 +9NYPtoLN7ifmKfI8/9MOuO1qUwR6lkUb8ABwX2K//Rc7YH/CMdTYgOTE2wujFgb/ruOA
	 +Kq9Fjf8wZmVFNQqUM9N8r8gbhzme4I1rVtLEjzGKrU47X7kMsIX3yB5Xr5jwGwZSy9/Y
	 JG8MyxoaDh11rrGtveYBlH3sAK3+LeEPqMsT3SW/73Y1uqz9Z+eawPHhiw+RfERMugg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PbaUXgpiUo/eB6MmmloIKMOuM2QpXnP1nG/N2uMcdPs=;
	b=E7Pn8eEyHobYlPdJNpR6Hzii1utMvKuLy2uVlYVGcY32lKLSEZ4TLEP5LD7GMPa5+QVu
	 qFLp09Aj8fnqoEGJFc6lwaDZiHHrefhWpD6rXo5jwGkQBpAWV8sJmwOzKTVsjmlaSfbfV
	 JwCNsc13FB8Fq4KaLUsw1PmuBMuSirTeL7UnKdALeKesRbkU7JnSVba7m2yemNkwQWE1Y
	 L55bv4UJIZ7UAawJNXRDQQcO/+wBfa+8eW0yRB2X6ivIuDJ6Hj1HclF56ZvJJfPmX6RR3
	 v5O/DGlM3ASMJoWfvH8UjshqNsHYTU70zWB4qU6WX7lIh7AD8NcsnImf96X7yCkScqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhqMvhWu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5252C606A31C;
	Thu, 19 Nov 2026 00:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhqMvhWu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96461F000C4;
	Thu, 19 Nov 2026 00:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049602;
	bh=PbaUXgpiUo/eB6MmmloIKMOuM2QpXnP1nG/N2uMcdPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhqMvhWu1syeWbfFwbqnMF1raFjMZ6abSICyygDNRcTDCr+PxrIqyGf0GG0calhiZ
	 H25Ju02+Z66FtgkFWNUwdMbG9BjksRi2hjEu8EuA9nSXDLSi+Ph35cLdRvxKihdqcx
	 Afx/ttgoXNBV9ZUUv0mndmSAzc1U8njkAKXh7bc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2359/2857] mailbox: arm_mhuv2: time out if the receiver never comes up
Date: Wed, 18 Nov 2026 15:56:33 +0100
Message-ID: <20261118150326.460670626@linuxfoundation.org>
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



