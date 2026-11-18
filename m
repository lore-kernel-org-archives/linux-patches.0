Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026141;
	b=gx0Zx383MAvIFw3BWmi3JnfSsUq1YZYU55yAl2jUvBe6JYcazjAqLNikTxIVsL5+iigU
	 L0vIxCzYpWaB9TQuGLeG6twvsDrG2SkUhy8siHVNzO5bdWqDiZ9m+v2guzyCuk31pBB4r
	 3IzgKRYgy4j8ik21GJ9Ss2yjILDHmakeQ/HRxZ+k7SUq0EE6GVHBxEsG442IXEqUC1Fsu
	 IFK//ZKwRjx6Xr/uNo8rFvMfibXYPU/MvmIO3S/NBtk+Feh5o83bRk7TKdaU/h9G/CfsL
	 js8AalWEiL/UUnkQDvFcI5O+saYv2zm5E2lEcMA5bHOlMRhToQ5lLwUMjhv1IKPwfag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NnhYN38T0o5Ov6DZswe/UrS1zb76wudpauEDr7D6nKM=;
	b=UTZPFryoBsJNgumK6kySqS8Gr1kutfgZuPzZI+9tkF8YcacYTBje4ft0Qyri2FJFt8f6
	 dntTE5byaStjunJME5XLQR0lfjTyiTyBYSDT1exM23v9H/G4V+M7L2l8wWpIPaZBAY7sQ
	 vvdA+NhSiUBM6gydEGNe202PXybuks3MYgN8mYXnEhpIx+2u1anOjl1K0dCfSPGvsgMZ6
	 0fPjCUnTN5WCb4NZmt224w1yGMJZIOYjATHfJuxdFgB0zcqJq4Zf9qiZrjQcVFolyMzfB
	 1P6aOv0lABfldr8o1E+hQisRVrHeSCwUowrOpGqh7h7BEW3qHhSeg/1IYI/ZDa3G/AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YUEVUBi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601B4606A32C;
	Wed, 18 Nov 2026 18:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YUEVUBi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70E91F000CD;
	Wed, 18 Nov 2026 18:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026141;
	bh=NnhYN38T0o5Ov6DZswe/UrS1zb76wudpauEDr7D6nKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1YUEVUBiHB0RJVLfK2PJiMURShPwZgYv0x8U6h5crk5QKLLplKppsl8Jk3cSyZQps
	 QJmYfrEyCxf3e8UOiBZOsrcp8csW71m1WTwigJewOtQ0gJ+B37xmu5PQ8fBnP82tVa
	 9OXR7h1atgFLXRp3YNRFi3CpjgzSOeBj9fOVJaxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1327/2151] mailbox: arm_mhuv2: time out if the receiver never comes up
Date: Wed, 18 Nov 2026 15:51:02 +0100
Message-ID: <20261118150210.420499566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 213fd4a399937..a5d5a2e09bca4 100644
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
@@ -1008,8 +1010,11 @@ static int mhuv2_tx_init(struct amba_device *adev, struct mhuv2 *mhu,
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



