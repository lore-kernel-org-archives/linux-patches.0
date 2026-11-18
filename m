Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036278;
	b=5ioEWMSW0gYnojUMbTW0tPM5zwTtgLQgKX9gDFkFBE0NSe5IIiJl6KdghYEymugBf+47
	 jLQMSvcKxVizvCXRctD0qpNReQRcmDuYiEdgazQ4afh1hRM2y4Vv8+moMmQFO86kVx2jK
	 UZCkdsigiabGnWyzeGvk5bUwu+ezoq0j2c/C5KgMwYaXpoSxfUHkKxZROzbSejDCbiN1u
	 DHiQwr5wUMh3uZ5+yUYBskYX46VVyOrmoKV4fO9Uw0/oDvrdcpxFlZN6yWd+jCF+cDUy8
	 8Ux+nqUHS4Xn4Wkrdle9ope6/wax8Rq1bzSVvczJhL7aaAW/A7TgyWcUV/oNm/hioyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3tyUPK/uGzLulvM2u2tAhKyPXWU6n3L54H81H8j08L8=;
	b=2g66kdctm/9J7/qIOW0xQh/Dd4uaPiZJzs4JxDrsBiwHlkr5QGmqbcVPnAsuPsaKb19n
	 al6+w5Cowp/8DXZCeqLr4zSMsWOtIcqbK8wQ4uhGQLmyNyAKyfRn7Q54xD+OjmhMWq+mV
	 G+fEHghJLjJISPDaTiKGcytAyABC3uBZGX2EWAjkVy5TEAA1WUamDlYaUDlX3yHc+Zj0S
	 8KKgXvU/82pDenhdK7luJigy/4zzRUW5+IuU8CwECF/Tcl42xEkVi1ILK2HwdpKu06bev
	 er955yx53GTvdlNiBebTmNu/fAmNHvJrCj9fXi2zbmf9EvLWRI2PrF2EAoDSi0+ghVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvV3NkH0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8C760A2609;
	Wed, 18 Nov 2026 21:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvV3NkH0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5E41F000C5;
	Wed, 18 Nov 2026 21:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036278;
	bh=3tyUPK/uGzLulvM2u2tAhKyPXWU6n3L54H81H8j08L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvV3NkH0mNVTnyPmFzn3KL5nZlIKyo33fa8cZpQLdbMhhnCmH+iwBe9+5hirQ+ODZ
	 ticSATL63XxtaTXbzHx6a/BntpQRxvvqt3d72yDcgm0hqp32O+4/PvCirOyq7RMrAa
	 hNOKKeU6m2A6RHtXQmuxz396yazI1iF1bXvz0sq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1001/3318] media: mediatek: vcodec: destroy core workqueue on remove
Date: Wed, 18 Nov 2026 15:27:03 +0100
Message-ID: <20261118150349.893384687@linuxfoundation.org>
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
index 69bd978e68a5e..578b2e16e8510 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/mtk_vcodec_dec_drv.c
@@ -545,6 +545,8 @@ static void mtk_vcodec_dec_remove(struct platform_device *pdev)
 	struct mtk_vcodec_dec_dev *dev = platform_get_drvdata(pdev);
 
 	destroy_workqueue(dev->decode_workqueue);
+	if (IS_VDEC_LAT_ARCH(dev->vdec_pdata->hw_arch))
+		destroy_workqueue(dev->core_workqueue);
 
 	if (media_devnode_is_registered(dev->mdev_dec.devnode)) {
 		media_device_unregister(&dev->mdev_dec);
-- 
2.53.0



