Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052395;
	b=DXMOME9XGRidE9/qdJR58ycHjJFpF3Xe+e8dRakV8NkdXYtqQVLQvLYaGWVQkY+odr18
	 1/hp8cZSOQ3JTz4ZXN/GpjNflQzMinsbnfc2hmfrNoCMhjDlPzaxc2QW5ekJvBw+iX1IK
	 8e+KCD+ihbUL7xSL7/ESRbFfCWKdNmGhDmqPZyrwZvS8e+hlmQSos6KkIGZsEMO0Q6EU8
	 XasLdZhdr5VQvTQT0IuJPUM2XmLRKtLXuajWQXcF+wy+qxiAKHOA1eqOuGlOKmZapCAeD
	 xO+p4etHKQ3Ak8e9pGdGGG7ac498OXVPk8WjZ2u8cV9sN+FG1GYdypYtu7TCT0kHrFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XKv4yBuJAMuTUy33uUKo8GAUz8WtLD9lvBuWlKBKhho=;
	b=ic+MRAgqywkRD3yKtIVe9JQbtU+EumlOO8x7zWZpXkhR0ulI+2Zg1cq9EVgMwJ3XIfkh
	 RUqyNhBp9FvD1h3aWUGZ3jMyUMK3j3bT53UoakMoIPOvWetzlyTp1nKY7w0YnvZyfdVQK
	 95WNKVAx3sHyuiBJL5xq7+67cFt8IetnQGo93q1oZaIbZPBiMNa/LpjUcc9kF7eB5vTcj
	 4tX+TZkReAmUVVsw0+Dix7DZh/2OkB7JfhRo5X1JTx/Z6iBGEkMV+5ymetxNa+Q2UB6xI
	 oHL9WsiUIYUgmj1IILh53AY5HXMUL7tjXXZ1wDm7+5hwTJ8DWVgvka6mrssFXjXkfjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knh2YsFV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0504D606A335;
	Thu, 19 Nov 2026 01:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knh2YsFV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F681F000C4;
	Thu, 19 Nov 2026 01:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052394;
	bh=XKv4yBuJAMuTUy33uUKo8GAUz8WtLD9lvBuWlKBKhho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knh2YsFV3l8QwP1lfHAQQdEAP65iy7WJ0ERNJQpmXiOTtugm/cz4ppPTfnAIoD8FL
	 8jjldgzf23UDDURQckeCIOOtjl7ByNcIMkOnYPEcmlY4NQ371eDCzBZft4YSlk8HKM
	 +yNilITA8+XXcd9zwHRx+uA06us+26Y7XK9MFQ4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0548/2214] media: qcom: camss: vfe-17x: Fix write master buffer done being dropped
Date: Wed, 18 Nov 2026 15:37:04 +0100
Message-ID: <20261118150032.925674913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/qcom/camss/camss-vfe-170.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-170.c b/drivers/media/platform/qcom/camss/camss-vfe-170.c
index af264c1f7b0eb..44223c08b87af 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-170.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-170.c
@@ -383,9 +383,8 @@ static irqreturn_t vfe_isr(int irq, void *dev)
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



