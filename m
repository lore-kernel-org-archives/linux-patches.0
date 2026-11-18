Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045216;
	b=UqgoadQOL0FwD6QBNWEwQ5mlK8AXv19JRCLnKwTY98f9P/Nd7ldzb2O+1XOk9Yc7qGbo
	 Nro98kQ6OBisadlcouzvUQcXNi0qwW5OH9mk0tjMB4GGjsuxVMnmrBgZofzgIUEW/tUqK
	 m0Hofq/KhiDe0vWpPdjM1eP0Vaf4d2Eyl1M2XX2yaHtxY5aveOzHtBZWmPmgJkeNI6s6Z
	 lr/QnDALQC4u8MHjfmmeleDjb23CUx4FCIwWaXTklyW6k47UXJwfd9BgxlVd2y6XNTJPS
	 PuzL869LbFXDTJTaYqCBHag01zSJPj3XLYhRYcdZS+C3aXyxryGa5ZuUYbSams3WeZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wd8fDRKkJ91AJH0jhKFazuby5XLCUYrjVvEhuPw2aI4=;
	b=a1CWhfuARILHbw5aSxmggovzopBe5zjdwbVi+DQnqL3WbK8wPNpLe+zRrtpEFdgWIJ6S
	 hpM7n1Uhf35ksSypUSCcO0HHwKxxRy3A78hmJIalNRLbKTRRF8u2me0pIp5HiZ3Lj8rpF
	 KIuXEUj5NVF0HB1FuLKd3ziS7UIK5h6425OSA4K9l9bBXo23e5wjnJ/bqyWurYYwRk5IY
	 TTXVTFY5eksU4Y18y5lgrGsFAsXu0Er1U3SZiAOtlfkMRKNqx7lwK79TzGd2D4+2YcEoH
	 c29nzj9fVDz3es0XaiHP7josaM9Lg5j8qISb2/PFA0+mmm4ogN1Qe4X8OpcfNBfySJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2o0E+iaX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE46606A31C;
	Wed, 18 Nov 2026 23:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2o0E+iaX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCB91F000C5;
	Wed, 18 Nov 2026 23:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045216;
	bh=wd8fDRKkJ91AJH0jhKFazuby5XLCUYrjVvEhuPw2aI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2o0E+iaXgkhFjlopbhtKfLKyBMZnm+wqP5XBJWWH8LeuirGcmwddUneE/GYfa5+b3
	 6shWIDCc7krQdrYUe0O4Re3C9PHJkFTu0QT8t4cd63eQavwb3x5dclq7NKudkka4kt
	 mMWeH3mKbH2xqX8qGBsliwVlzDqZXZS4VmTmrXBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0837/2857] media: qcom: camss: vfe-17x: Fix write master buffer done being dropped
Date: Wed, 18 Nov 2026 15:31:11 +0100
Message-ID: <20261118150231.707636547@linuxfoundation.org>
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
index f9492b1d16e3e..a6625aa050b66 100644
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



