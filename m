Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063033;
	b=StZ9VEbNntY1Y91x2z1s6TkCF1jMvUJcFJB9Z4d/lVmZ5Q4EueChnXBztxYUe7hdnRzO
	 P8s60hwYyxN/57JKzy38mqRC5Yai7+M2DKCZ/tRBIRB3uG5jAcnoopXkyDOccvrniJ8Ku
	 A5+8RiBxo0s11n2f3Spr/IjAJ+pMxhLNW99mv/wV7XdEZM6dRUm0B+gjLiAZbJIwFTuaR
	 aBsfpU6dGZqoNDpolxcfIOsDr1AY7vls3a6Z4oQEbDB/UQa7XXpx7Hzh2mz3ivHf2oC9H
	 BZfNgXTfnSy5ZRthTDQYthVSvAb6yBfe2m5KFER2l884mmqpXQpJ55TjmlEqxAfW5gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bfoUVXa89xKmt/AkAizWDjk4Ls9MhW70PDNCyWu0sMQ=;
	b=G8GqwqPdeHLQHbkVM2WdV87sIYljIJUqCJww+mI23CQGEwn4Dl/xg4TzAfUyUECuOnQ/
	 cDk9LVt5z6lwm/tCRIMnAsxf1ah+Ye5rOqod4PwHvvHFdNMzgwfTVLGQBbatGzniYYUMm
	 dMgK12navklWVcH6zoelFyrra7hSlkDSfHKMOHuZ4TTDaZTFr89aOUHJnUAS8/+nYq7Kn
	 Q+lc3lnWnnSKPLsYva+fd5GfF9s6FVrH6Ey2U81noLPz7FTfJmhOccqtVJGCVOKTTcxzq
	 CDkuwdR5ziMwIfCtl0qsUpsyLhuj6yH3+LSBngmcs7BFRWe2+5ZV6tGhRAVYVozzh+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=reogAJC1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6248606D802;
	Sat,  7 Nov 2026 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=reogAJC1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A951F0089F;
	Sat,  7 Nov 2026 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063032;
	bh=bfoUVXa89xKmt/AkAizWDjk4Ls9MhW70PDNCyWu0sMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=reogAJC1jvjTET25tAaBKXpCOf2zXlFAy2o7RrklFh4zg5ggMyHLH0ArvfMfugNuU
	 +1Pk4l2a8M+GMHgC06l0wbMalL9TmblpIMZ6sO8tatExoiihVy1o4dmTjP6VqFqdio
	 V5CmMouPgiv4bNLjLnZOVlu4SJXKFZeGg9R5T57o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 282/869] media: qcom: camss: vfe-17x: Fix write master buffer done being dropped
Date: Sat,  7 Nov 2026 08:49:24 -0500
Message-ID: <20261107134901.282273861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index e5ee7e717b3bc..c011f64f63e93 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-17x.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-17x.c
@@ -364,9 +364,8 @@ static irqreturn_t vfe_isr(int irq, void *dev)
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



