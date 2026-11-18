Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054088;
	b=Nrj068SYwJEtPPpTei4jTLpxGego5zP3JURZP25zy0hfh4sZuRtgQzDA+jmhy7mDNj/z
	 Z3cYoenZS92SypmoagogX3cv6wmykDT+eBEGMYOiYaPi3x7xAeMjYMCQsqjmfVrqDL3au
	 TWgBRgL3FTlJeviS7bzJK2AgEa1qQrJC+ENonuTmxNtpyvieEbBhu48E5LVeSRjbVbYsz
	 YxXHNNCLGQq9kREcpfJY+YDjQRcijHaFnHCPUoRxM4I4a6N205BCshz1YHLaFYITLq8Nd
	 oLiMCVV2d50BX7QytvaAM7vlbG/67zdUJwvJ42GN4MzpkI5wdNTz3wCm9eNn9HLoNjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nIWRYP8gGY3MOA4P5nR3CLZmC2m4csNILPmPQ1yDl4E=;
	b=YiU/Ie42nFyPivqPfEMQd6whgI9CVXmKaorabH//Hm1xinsubIXpkcyI486PDOojO4KR
	 PfxpaZ0/6KCbVQJRCn8fiaTwD2IoxjXRiVwl9H5GuYjSdVYkrlFOCk3wJsFg+d3MaF/QJ
	 kPk5Gem39tL3wYtKJFio2I++FzjycxP9ylCe1RKOHBmElxFkRV5PoJT/JN9g7KpUQDCTh
	 wLHBHqJHu+wjYaH81KXazgITeSpWJghlb4jeeolMEbhtrA7ekgQsrrtJ1vYmLIEo1uLe+
	 D17I/Nb+ckaXan8RNIl4D16y5Q5CJa5GLLWJiK5jZBH1Qnp6Kd+tBV6UBjJQmq/rqWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMeBF2f8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9908A606A320;
	Thu, 19 Nov 2026 02:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMeBF2f8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9B21F000C4;
	Thu, 19 Nov 2026 02:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054088;
	bh=nIWRYP8gGY3MOA4P5nR3CLZmC2m4csNILPmPQ1yDl4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMeBF2f8aA3se/r2vR1+ZpPBkDEaYoRDmXbQoSD+6ui9NR+thOFiNG2zi9pmssCpl
	 Reg8Um7lNoF5DRUEk9QNqsuKBCWuGTJ8CePfspjyJPsH/CyFkQusKBh5Crpcoteuz9
	 XMoPDy16VGm/wyVcKUWddImE12gKm+lAng8/bFGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1113/2214] media: microchip-isc: do not touch WB registers when not streaming
Date: Wed, 18 Nov 2026 15:46:29 +0100
Message-ID: <20261118150056.659331697@linuxfoundation.org>
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

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit d8983c47d4d95eb1ed889dbb7516d3738fa854d8 ]

isc_s_awb_ctrl() called isc_update_awb_ctrls() unconditionally, writing
the white balance registers even when the device is runtime suspended;
on many ARM platforms accessing the unclocked registers is an external
abort. The write was also done without awb_lock, racing isc_awb_work(),
which holds it so the DMA done IRQ cannot latch a half-updated pipeline.

Write the registers only while streaming and not stopping, under
awb_lock, and update the profile there. The isc->stop check covers the
window where isc_stop_streaming() has gated the clocks but vb2 still
reports streaming. Otherwise the new values stay cached and
isc_configure() programs them at the next stream start.

Fixes: 4e52889f48fe ("media: atmel: atmel-isc-base: expose white balance as v4l2 controls")
Cc: stable@vger.kernel.org
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: adjusted isc_s_awb_ctrl() context to accommodate the missing awb_mutex operations ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index 5819875309d53..b0cdf13aa484a 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -1830,19 +1830,23 @@ static int isc_s_awb_ctrl(struct v4l2_ctrl *ctrl)
 		if (ctrl->cluster[ISC_CTRL_GB_OFF]->is_new)
 			ctrls->offset[ISC_HIS_CFG_MODE_GB] = isc->gb_off_ctrl->val;
 
-		isc_update_awb_ctrls(isc);
+		if (vb2_is_streaming(&isc->vb2_vidq) && !isc->stop) {
+			unsigned long flags;
 
-		if (vb2_is_streaming(&isc->vb2_vidq)) {
 			/*
-			 * If we are streaming, we can update profile to
-			 * have the new settings in place.
+			 * awb_lock keeps the DMA done IRQ from latching a
+			 * partially written WB pipeline.
 			 */
+			spin_lock_irqsave(&isc->awb_lock, flags);
+			isc_update_awb_ctrls(isc);
+			spin_unlock_irqrestore(&isc->awb_lock, flags);
+
 			isc_update_profile(isc);
 		} else {
 			/*
-			 * The auto cluster will activate automatically this
-			 * control. This has to be deactivated when not
-			 * streaming.
+			 * Not streaming: keep the cached values for the next
+			 * stream start and deactivate the cluster-activated
+			 * do_white_balance button.
 			 */
 			v4l2_ctrl_activate(isc->do_wb_ctrl, false);
 		}
-- 
2.53.0



