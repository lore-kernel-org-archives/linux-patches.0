Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064469;
	b=gsMYfDzanZviTaK9MSKr/3fqTORtT9LZjto9OTQivs1XgtxHpHGvMvYbFYXy5qj7MpC5
	 aRtXMBMYenSenG9lleTOezmk+OoznigcCMVaLyq0roGP5m85ZU93t+SUOPalLfarK/9V4
	 y5JTnrH44bxURKAnIR6F17Rz3tyEA7KB//OFOs5NYuj7Q37oze0b7KWlGmwWzn5fC+SOA
	 ZfK90OjuaiCOEJOgBrJGMEgwUnQOpV3+viMKGnlx7x+JtM7l0IvgAYzbKcZlHz9+QPeXI
	 qRGaeDHY2HIx2bXhxxKyYsxeEPaVyLToZirBWMSKiDolEWy1bL0LTVaIj+JBCS17THQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9vDBc8oQK+naQiQgwR8pTHBLs69omax+/dKPo3OvwZ8=;
	b=c5L9tq6rrKaMs8Wpr8HY7P3YfaWvpBUnd7sziXb2eDDVlt64SUVj4xkZaXKG4KIy6K41
	 8+fOieAtnM40P0blQBVd2cFUc2NDXdBphT7eaxaYa35ysPaGsimcE3gBumByPIU7yADQc
	 gm9a9v9Z/+YiT9EXB4eubcgjy/cb/u8Q8NulbsnwtSDgyOtleUFTSAn7XdtEp+Cs+4y1g
	 dIwGq2kdzDIza7rRDyDiObR1bHwyPv/+vlv/pE03Q+b8JzeBcIAHlwK+0bOM5Z5UXMv/L
	 SPoT5zEaqw3A4gekZgSm39cf2f+KagekTehSVofPXM/ziETE1z63cwkFWGYziGolKuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzJa2+3k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EC5606A9D4;
	Sat,  7 Nov 2026 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzJa2+3k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1831F008A1;
	Sat,  7 Nov 2026 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064468;
	bh=9vDBc8oQK+naQiQgwR8pTHBLs69omax+/dKPo3OvwZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzJa2+3k25AMdq2d7HyA3BeHY6AF44klBB7ox4f61pQjV3jV+vQmWWMeT/B7m+8/t
	 3cDiYTsa2At1KRFMQh5zunpL0utbd1H9o1O1YwOxCBv9Nh1k/SpzpT0elY1/PYh2/9
	 /J8Ox1+NuEv+SEoMXfW/YrxhBKzWRzJ047PSFDhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0460/1257] media: mediatek: vcodec: destroy core workqueue on remove
Date: Sat,  7 Nov 2026 08:45:56 -0500
Message-ID: <20261107134952.172885779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
 .../media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
index e936ed8dffbaf..426d060d937c1 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
@@ -570,6 +570,8 @@ static void mtk_vcodec_dec_remove(struct platform_device *pdev)
 	struct mtk_vcodec_dec_dev *dev = platform_get_drvdata(pdev);
 
 	destroy_workqueue(dev->decode_workqueue);
+	if (IS_VDEC_LAT_ARCH(dev->vdec_pdata->hw_arch))
+		destroy_workqueue(dev->core_workqueue);
 
 	if (media_devnode_is_registered(dev->mdev_dec.devnode)) {
 		media_device_unregister(&dev->mdev_dec);
-- 
2.53.0



