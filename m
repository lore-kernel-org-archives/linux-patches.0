Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036162;
	b=jbzKwcwX1/pA94x+wU9PxvkFlf5+xnOot717cLXQhmjri9mptCquGYH9uZ1aXz9VDd+q
	 pNcmZ01tBDUAqvEaRihzPFrd0hiu0R58+Day5cC0Eaf3BKxRpUbT8qiBQmNhdB62cDL7O
	 Hg/SEo59SycIFQMTnyCAYxkuQYJCWVqzAe74Ru2S9nihn/eoBPrPktor++FfL7dVZvD5z
	 OKUwa3lKmno+RvhyASUzxQC8//aLFC0LrBZ0sRURnB9l24RtCd8x0BRhOOYtvQnBDwAY4
	 rWeZ4nR22gM5TkG051LidSFjCS3G5+5NUM9byBWrWl/ZGp2rqsxC4LEYmpgU2oe896w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ibmqp2TZS9SAxqjEmRT02tSSQLU3bePKZxs/VkDA5+4=;
	b=xnNH4GItW3r0TsRWyOu9cLFDPzvnADBuXubZdyqYVvL7ItFgOD/ZRbH+TM/twA3Wn1op
	 WPePPoNm2CfE3UMiheaVIzwbX7eJSHqxzVmUGF58cUvAcoxo0ddd5ZNv3oGRjLIFL8DxR
	 MSs/KU1G1RRZy/x8dPKQ1Ht9IWGM9Avw/I+pS/yQl1g34hK+sC4SAJAzqOGLIlh5hFfx3
	 /hkwnLjTiYoqsjNMTfBIRxthzU1BbRvcQ+uR7noiWhEfXj39SaygA2XJzfnFQY6cuNA5b
	 dTEvjSNWrscnIbH3DA+68qlkDk0fTzagjqHr45fGoPkeRC2t3clJZ4rkpb8omtl3aZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=New2Z8vd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A67606A31C;
	Wed, 18 Nov 2026 21:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=New2Z8vd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943BB1F000C4;
	Wed, 18 Nov 2026 21:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036162;
	bh=Ibmqp2TZS9SAxqjEmRT02tSSQLU3bePKZxs/VkDA5+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=New2Z8vdISKeKYaeGEE9IA8A3gJiPVNVWCSB9OKJP9GLqzjHD0ge7tVPzh4B9tn7H
	 JmHqNU0jQy57qK7I6RLMVgsj7tZsXBSvXlD30FR540zRdYbA3ctzmM9djwjk07AjgJ
	 ZDmNmom13aAJaji2ssADiwz1FnVGq5SV0HEHFDaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0960/3318] media: qcom: camss: vfe-17x: Fix write master buffer done being dropped
Date: Wed, 18 Nov 2026 15:26:22 +0100
Message-ID: <20261118150348.440417591@linuxfoundation.org>
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
index 168baaa80d4e6..8dd5ec9adea60 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-170.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-170.c
@@ -379,9 +379,8 @@ static irqreturn_t vfe_isr(int irq, void *dev)
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



