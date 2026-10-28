Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213827;
	b=A+8i+zd1dAgYijWAnDGpcrjCaEOqRsJ1AXSBo5WBjnaEDcMheU9dsPovv9Tl3O2mJTHI
	 OiqdqOyIzdnH45EJdPV2nvF5ANiLumEKIucrUvvsAi+eRQj7eWTD3UUgVLVT6yzovu94H
	 xEzdq/cHWbbDTmjrBsNBHaJM/IxFZONqVR1JANxdZTN7bxhtYpRUfTNcpdRCr4If+Ouw+
	 qC1LIiuRhj9Ji4Hxu5Bke2wVZFgqy3WpexJpLz9Y3L0acLGoor9KShz4X9vCzsU/FVpGJ
	 u1WYKPZD8m8uA9DyTGTMDhp+R68jSsAoB0HwgfqPXSLA3C1JqOav5q88II8ElHXcQuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cK74aiF/gK+l7fY6SBYPeQU/b7r/e8f0ecEkUj5Kih4=;
	b=rBDRl9paVbvKgkmwtMy8THccHEvCRrvnSZEqEDD+viwWmfOVwR0J0nkHtyKhx/Hbqeqt
	 tO9dfrI0c6Ct6Pz2ENYPMi4aSaFYuYEjlZxBiLKt/m5BLHVlC48pcyk8JhVJ26zUTATkj
	 EqGSW/JJLyUDOTtR301HryYmBJy7KEETDDxgC3ROcYR+IoMAzetaAY8zp397q38tyFX7R
	 MMcrgX19ttlWXnmD6RelwbT5a6V/ddBZrpHuDMDvDK10Z7orCDqvHzscq3Kindds0gYIL
	 OVRqLNbJEF1YzRYW99LmaJUdWTa9Mh6X0O25D7Fo6KFBSlJTL8kFMVv2AOPtZDHDFpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEkcpS+w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E32606A31A;
	Wed, 28 Oct 2026 18:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEkcpS+w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FE91F01828;
	Wed, 28 Oct 2026 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213826;
	bh=cK74aiF/gK+l7fY6SBYPeQU/b7r/e8f0ecEkUj5Kih4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEkcpS+wMqOwBYUq3kxlZODQPkIbtq91ESjUjes3Xsxy7xVlvDXDvFSNZfVCZ4bk8
	 cZ2PQIW67KgrnRjabe8HNv0RnpcxN23fVOV4+Fd4SrEMBobO72mg8aRotRNdgqBROk
	 YWQh2QgNtVpU3Vq684GASFCQg32MqYVfOKEBJx+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0643/1887] nvme: apple: fix device reference counting
Date: Wed, 28 Oct 2026 17:45:39 +0100
Message-ID: <20261028170514.043284190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b9ecbfa45516182cd062fecd286db7907ba84210 ]

Drivers must call nvme_uninit_ctrl after a successful nvme_init_ctrl.
Split the allocation side out to make the error handling boundary easier
to navigate. The apple driver had been doing this wrong, leaking the
controller device memory on a tagset failure.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 994cf755de093..4822248a624ad 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1387,7 +1387,7 @@ static void devm_apple_nvme_mempool_destroy(void *data)
 	mempool_destroy(data);
 }
 
-static int apple_nvme_probe(struct platform_device *pdev)
+static struct apple_nvme *apple_nvme_alloc(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct apple_nvme *anv;
@@ -1395,7 +1395,7 @@ static int apple_nvme_probe(struct platform_device *pdev)
 
 	anv = devm_kzalloc(dev, sizeof(*anv), GFP_KERNEL);
 	if (!anv)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	anv->dev = get_device(dev);
 	anv->adminq.is_adminq = true;
@@ -1515,10 +1515,26 @@ static int apple_nvme_probe(struct platform_device *pdev)
 		goto put_dev;
 	}
 
+	return anv;
+put_dev:
+	put_device(anv->dev);
+	return ERR_PTR(ret);
+}
+
+static int apple_nvme_probe(struct platform_device *pdev)
+{
+	struct apple_nvme *anv;
+	int ret;
+
+	anv = apple_nvme_alloc(pdev);
+	if (IS_ERR(anv))
+		return PTR_ERR(anv);
+
 	anv->ctrl.admin_q = blk_mq_init_queue(&anv->admin_tagset);
 	if (IS_ERR(anv->ctrl.admin_q)) {
 		ret = -ENOMEM;
-		goto put_dev;
+		anv->ctrl.admin_q = NULL;
+		goto out_uninit_ctrl;
 	}
 
 	if (!blk_get_queue(anv->ctrl.admin_q)) {
@@ -1527,7 +1543,7 @@ static int apple_nvme_probe(struct platform_device *pdev)
 		blk_put_queue(anv->ctrl.admin_q);
 		anv->ctrl.admin_q = NULL;
 		ret = -ENODEV;
-		goto put_dev;
+		goto out_uninit_ctrl;
 	}
 
 	nvme_reset_ctrl(&anv->ctrl);
@@ -1535,8 +1551,9 @@ static int apple_nvme_probe(struct platform_device *pdev)
 
 	return 0;
 
-put_dev:
-	put_device(anv->dev);
+out_uninit_ctrl:
+	nvme_uninit_ctrl(&anv->ctrl);
+	nvme_put_ctrl(&anv->ctrl);
 	return ret;
 }
 
-- 
2.53.0



