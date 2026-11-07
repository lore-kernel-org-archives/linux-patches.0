Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064258;
	b=tJO8/RQnc9RV8rBHv/E/5VGOAOaubyTtGm3roB7AhBh+POXoCJiOUhMgbcsWRB4+N8h9
	 Lah19ExoHchq6xnrf15f+5//KtVL+gkum99jadUhnuW281c7vpyiqN0fuAFMERniQvIHU
	 81gTyhT78alFSEGv5BhuTi0p9VZue+J5nG/1omQ/kx95jzzVt6ksSzEVHX++OCn5Cft6H
	 5L7TkGWLXHruOvwQbZ+K4lvnDt4/5oNNpwm49o0+pUKeHwQ2UlcRBJmhxUdEe55XKBfiW
	 Vpfi3k1AK6saTjcd8T4syY0UoDTqiDn4Fl0OdOqM5zAW3QuS/6Q9vR1LIijzrKnteAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pz7ctIKkMwoIvvyTzJGqTk8UkvrR8SdWqk7m0zW7osM=;
	b=zQIU4MItQxSteHBlCMJn1LVA+o1zvZQvVg/jBl7lwyefWoMkVm2S3m6KKoQg/KKoQDE9
	 Rpo3hoUMkh2j2+ZSwmG2Mi4qUWCgApLBF17NuvwEkn94vfNtFszsA051yK/ynIETZ42Fk
	 xrGk8/1xUnWJl3pZ+vxbPG3QuS5YGv4a4ISpb/q14ubJsYeKFK2ahGj8gm8lrH5JM1Ssg
	 i73xRKGL7nVQ7OHYYLNCh+mnYbg6sQi6cdFP3R+f8HtFV3vSOzNKDnhIT0GJ8vH8YATiJ
	 Hj43DwWxxfv8drycoZzmhecgJH0kf/NNatrcpu/L6BdUgEZOfqAe5O+ILfCz8clut9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWUP5CuS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018E0606A334;
	Sat,  7 Nov 2026 15:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWUP5CuS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BCA1F0089F;
	Sat,  7 Nov 2026 15:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064257;
	bh=Pz7ctIKkMwoIvvyTzJGqTk8UkvrR8SdWqk7m0zW7osM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWUP5CuSidHbghiAF80Y9+aM+PX/aOt8n8nVhWLjCCMc41l2Fwz+h8fYp+Sfc6oqe
	 DufMEN/AMou5kKCUbc8rVoQhPxMjMaCvssEfDv78pnnKTfqBnTUqS3mCRzK0B/j3Yf
	 WyoSop7qP8pUiCLrDwbTTnlUY/rX0Ts3TgRWzyrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0358/1257] media: qcom: camss: vfe-17x: Fix write master buffer done being dropped
Date: Sat,  7 Nov 2026 08:44:14 -0500
Message-ID: <20261107134949.267631192@linuxfoundation.org>
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



