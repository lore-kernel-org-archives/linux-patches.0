Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062131;
	b=n88NebLX52taN1GmCV76KyA07NCVgUCrpZ2ZlONU2q90e4axotHJdQVOg0hvij+T0idd
	 8hMxfPdZxxAILBh9jUWmvX/fy15v/MMC5P25DSzSD/mTZ7uv4jZTvP4wyyoLibs8jgGoI
	 0XlLFA9GiY+TPZOJ1S3AfMX4rYAwpJq02whINniRbbISVpjaiTxD/vl4F0WSa6rbVLU2l
	 kVxYhEbiZ1Xg/+cEDUBWuud61hmblVzMbQf9TFLm/8QAg4FZvUGzkyx2Vmo2HrNhBdv2e
	 g+N/N57Ucl3GsmXfLRzudvYnRqytbvqELV7SCNruTnw8Ag5cVE6EgyJu+N+IKu0KPJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aeHu5tFn9CKygRpwOKWaIxy1/Sd14uV+5bJF3/40JPo=;
	b=dVFCjO/TxEPKzQccJ/iIDhTUhdYmFkP1Yl5nsCgYIwBfDL7OGEhguXbHEWuMLkRqmLeM
	 7Jmr3wozE4hNZfjkUcNWbUUZAvlMTrjnFrO/Rk51HwEKcMD6StltBqhWSistbagg5OOA3
	 pnxjQ3jBP+Fy5lBrS1CJU8MEw58J0I7Pu19FwZPABs7UfSOrguFGBi8CxYtat17NDhNkE
	 Xt7gqdDCLVf9gWTjIsALYRkMbHRIlgsq8jd07fdSSpJn10D2rcxQoE+swAbLEbmn+llUP
	 ULRObNd73vf+EZYQmQWtx4yDXz/jXV41c7quEh0WL6LK56wbiWCQ7gPrYqQ358C/cKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnqSTwpQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE96606D819;
	Sat,  7 Nov 2026 14:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnqSTwpQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A31E1F008BD;
	Sat,  7 Nov 2026 14:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062131;
	bh=aeHu5tFn9CKygRpwOKWaIxy1/Sd14uV+5bJF3/40JPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnqSTwpQOeg8J6Es8giAxaqvWUntaiD3zTVyKDUtmwxNHrkoo+1KsNHhE/sKqewRZ
	 R9+fYzjlhubN/7MIq/jDf1mM+9cR702E3cWTPpzAo0leyeihIAFzO/xL1k1SEavLDC
	 4tghnNHQBjYlUXUIFooMyjyqkioK0egOybCYPDk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1099/1536] media: qcom: camss: vfe-17x: Fix write master buffer done being dropped
Date: Sat,  7 Nov 2026 08:51:55 -0500
Message-ID: <20261107135028.567324691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hitesh Patel <hitesh@ebytelogic.com>

[ Upstream commit eed550a8191c2f6984047a1b794b313d1bacf77d ]

The VFE 17x interrupt handler reads and clears the bus status
registers on every interrupt, but only acts on the per write master
BUF_DONE bits when bit 9 of IRQ_STATUS_0 is set as well. Bit 9 is the
ping-pong flag of image master 1. It has nothing to do with the other
write masters, and it is not guaranteed to be set in the same
interrupt in which a write master reports a completed buffer.

The bus status is read-to-clear. When a buffer done arrives while bit
9 is not set, the handler clears the status and never calls
wm_done() for it. The buffer stays queued in the driver and the video
node never receives that frame.

With one RDI streaming this is rare. With two RDIs streaming on the
same VFE, for instance two virtual channels demultiplexed by the CSID,
the interrupt rate doubles and one of the two lines loses buffer done
events continuously.

Act on the bus status alone, as the other gen2 VFE handlers do.

Fixes: 7319cdf189bb ("media: camss: Add support for VFE hardware version Titan 170")
Cc: stable@vger.kernel.org
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Hitesh Patel <hitesh@ebytelogic.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe-17x.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-17x.c b/drivers/media/platform/qcom/camss/camss-vfe-17x.c
index 380c99321030e..bf9aab7658582 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-17x.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-17x.c
@@ -380,9 +380,8 @@ static irqreturn_t vfe_isr(int irq, void *dev)
 			vfe->isr_ops.comp_done(vfe, i);
 
 	for (wm = 0; wm < MSM_VFE_IMAGE_MASTERS_NUM; wm++)
-		if (status0 & BIT(9))
-			if (vfe_bus_status[1] & STATUS1_WM_CLIENT_BUF_DONE(wm))
-				vfe->isr_ops.wm_done(vfe, wm);
+		if (vfe_bus_status[1] & STATUS1_WM_CLIENT_BUF_DONE(wm))
+			vfe->isr_ops.wm_done(vfe, wm);
 
 	return IRQ_HANDLED;
 }
-- 
2.53.0



