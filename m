Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217332;
	b=lkibHAJsyUumMzblIsHf8q+WcS0KPdOF8xJk4Vr/3T7zODrQk4u3H916b0vHXrJbDeYo
	 Opmq00RZ4YPZm/fUeoPPUHJttFNvYU0N9M3BD+x9l5wlMn0+k/SQRnMtY6F7BZ8gldpoL
	 lWomb24ViVzqMwtaaVbeuG8lOaFdappwIvqNoqGUER+JDCACr9zuhcQNPaY/fGOUkOips
	 nkkIALEOusnBf7RSWx6oOIRIDfTd/6L889i8Wjuir5nfiTecQv17byAPRqytAL1GNV+mO
	 Nz4OWJdozxCfLrGSK5L5yx2mk3o77mW2rkSLVI9Nsm2BtzchnHqsvSM23UsWlU9907A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=70Ok+Yhkei3oNIeZrCN5dyQKQ6sQfJ1TpLCAhAw8wGs=;
	b=zJJRKrYzHa81lWKmvwQdxUP6dX1PzGXaRJ8B18yMKSZH3i54xTeq/qrluuX20IaS1e2r
	 8iixjT/y2mB10cXWWhFJQPl5Y2Y34MNMK3TKaP7RBbqiMdBKQrSula82OvFqygNyh9TdU
	 nALsUW3OonDw2SQ3PordcHih8L72+GNDJsL2SwglPUSdga1Tlq9XLGet7WxAhfBnpgwux
	 5sfEssMGMY6nxh13psiqP8KWn7CuWNPq5rfQ4P7F9QuJLPvT3U/Lan0mjaeiRBqiTlrKk
	 TaoMh/nKRhkL/yrmpxdDYPprBQ1D2qzjCNRY3TJEjcNv5JaaChGGKzH0enhKbOtdM4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIOzMSqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38270606A31C;
	Wed, 28 Oct 2026 19:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIOzMSqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B091F01825;
	Wed, 28 Oct 2026 19:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217331;
	bh=70Ok+Yhkei3oNIeZrCN5dyQKQ6sQfJ1TpLCAhAw8wGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIOzMSqwe0cYgmT6UuRcAzh0SRtbdpboDOC3dQEFso2JEhn21eUxP9YmxA+ZDOyoT
	 5uRytQIaNve4+Ebo5p5I9JgDjAVeUKxIGaCj4ydbUt+tktPcnY82vldbPo74I2cZCM
	 8hb8tAj4i3K5LQ3vRK8NLtowFrTtTWXqHO/qJlfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1866/1887] i3c: mipi-i3c-hci: Preserve RUN bit when aborting DMA ring
Date: Wed, 28 Oct 2026 18:06:02 +0100
Message-ID: <20261028170541.917066722@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 093eb8e73c90aa0c8cfb0421aa85bd70c23488be ]

The MIPI I3C HCI specification does not require the DMA ring RUN bit
(RUN_STOP) to be cleared when issuing an ABORT.  That allows the DMA ring
to continue to receive IBIs, although an IBI is anyway not lost because it
can be received once the ring restarts if the I3C device has not given up.
Note, currently ABORT is only used on a timeout error path so the change
has very little effect in practice.  In the more common case of a transfer
error, the ring (bundle) operation is halted by the controller anyway.

Adjust the RING_CONTROL handling to set ABORT without clearing RUN_STOP,
bringing the driver into alignment with the specification.

Fixes: b795e68bf3073 ("i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT handling in DMA dequeue")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260603090754.16252-3-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 60da4be20c5f2..d1d92be403253 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -456,7 +456,7 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
 	if (ring_status & RING_STATUS_RUNNING) {
 		/* stop the ring */
 		reinit_completion(&rh->op_done);
-		rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_ABORT);
+		rh_reg_write(RING_CONTROL, rh_reg_read(RING_CONTROL) | RING_CTRL_ABORT);
 		wait_for_completion_timeout(&rh->op_done, HZ);
 		ring_status = rh_reg_read(RING_STATUS);
 		if (ring_status & RING_STATUS_RUNNING) {
-- 
2.53.0



