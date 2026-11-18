Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045292;
	b=LZ5sfiFAbjeGEKHIOZaui+zGMMnGcrqcwSeEE840Iz936UIoWWUwX//WHPTnQ5HnJrZS
	 lzFJL3of09Cz9KxJddTFHFHBrISY8yEPodqxtt8HA/dwwW1tPU2V2dWJhAiRUqT2wWfv4
	 PlA3WN7Fz6wk0moeDbOA6K7VHU81QGyIGlJHBZ4m/gSo02RP0e7T+hkB/Y3MIzd/RFHmb
	 QSviJQuWzZB1wnwcDLakpucyOUnOuuHHMoeITiSr/ygrTYEDJkAlWn2ByxQLpNPsj+Zls
	 9SqxegCkzh1FGoJo8504ww9qh2qYhpT/zQeZo0rAwnsE/C+bShTIyKeK14nGwY+fk1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qkv8+10Epa9riAR3nr9/ZFv4v/QKw45vpsCIg3DFSWA=;
	b=nZNTUUOjxZZzPM7hY2ubsc8gANtjxYqKV25+rwIQDl3oAKaNAeSlzThPwBNvj1M9iiYX
	 +Q2bzAPK1eq1vVmEOT9P8+OhZx6Qx6fskVMzT96Kdfn60SQxJNQ9iSFeP0jJbMlzfPL2v
	 FUubZzcL4cf0obIIuHvClPzzxbFM6in15u3Vw09ctAfgNkRoDvh552aoEvHgLKyxLAm7c
	 P3Hq1qlbSJMIigANlx7hYI98I1/SUgAwdbL0PAze5fXHa/vEchlh7NQzvWIEa8W51GxJ3
	 d7IwENX8ev/l2GoIGzjMUF0WPeFGhFhRGhZhA5LebQ2s1Jok5gsQPFiJoRp/1mDlJ2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gNfAJzsa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA2C606A333;
	Wed, 18 Nov 2026 23:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gNfAJzsa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAD01F000C9;
	Wed, 18 Nov 2026 23:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045292;
	bh=Qkv8+10Epa9riAR3nr9/ZFv4v/QKw45vpsCIg3DFSWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNfAJzsa8Kgx/vg1G23RY3o1n+D57CPmVXQmAHkibW+AWL+gyS5j6mlBOSYc/Vdku
	 dKdLKJH1n0CTV0AaPdtrRxIJoI/5f0I1mtPl1Leee6bw1C1ZSP4IuLC0OzTBVODLao
	 U5N7HHUOk1uBWngSwO3SlB/aBMVbzisemob01cr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0870/2857] media: mediatek: vcodec: destroy core workqueue on remove
Date: Wed, 18 Nov 2026 15:31:44 +0100
Message-ID: <20261118150232.888841940@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit ceb6e96122e1013550f378c738e621a6e82d246b ]

The decoder probe allocates core_workqueue for architectures with a
LAT processor. The probe failure paths destroy the workqueues, but the
remove() function only destroys decode_workqueue.

As a result, removing a decoder on LAT architectures leaves core_workqueue
allocated after the device lifetime has ended.

Destroy core_workqueue during remove for latency-based decoder
architectures, matching the cleanup performed by the probe failure
paths.

This issue was found by manual code inspection.

Fixes: 365e4ba01df4 ("media: mtk-vcodec: Add work queue for core hardware decode")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
index 42df901e8beb4..6eb96ae75c6f9 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec_drv.c
@@ -493,6 +493,8 @@ static int mtk_vcodec_dec_remove(struct platform_device *pdev)
 	struct mtk_vcodec_dev *dev = platform_get_drvdata(pdev);
 
 	destroy_workqueue(dev->decode_workqueue);
+	if (IS_VDEC_LAT_ARCH(dev->vdec_pdata->hw_arch))
+		destroy_workqueue(dev->core_workqueue);
 
 	if (media_devnode_is_registered(dev->mdev_dec.devnode)) {
 		media_device_unregister(&dev->mdev_dec);
-- 
2.53.0



