Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061997;
	b=b/7rYUiQliSMFh8xZbK/A6Bkn1jxl6qDlESLUp7Fs89jHk0x84XiVcD6PUV4L4t98QjQ
	 AlNmvqNfdirxrWTet1fAwkzP78YEBTceckCaRo9iEu6McCYMMZpKgE0095c3mrIVd4Ag7
	 rm9I6Qdo1AOhBNruoyzEg4nFPTwW3hnX35eoh2+S97nTEKJB4qXkGwu/P/AcZNIqnhbKd
	 WVq6NmMdDfijbKl+7PtsX3aIxnRG7fVqlBBpr2NK/Y43Y4tnADr0hnmY/qV2uj7AtbYmx
	 CC/8N5nsAK4BDEI23xFDzzXEL/8tKqj9dESqMmEJClXuNDRG4oVbKBCSIIz0lQHkgQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uZZ+WTb/5FCLh6USJdQzLuQbWm/PD9gNx4zuHWxeAnQ=;
	b=5AZ/rNeUwa7rvfie0RNCFXlcBVS02ruURbQaURJ+2Mo6LKVNY0UnTdSVmUTM3VekG8Sg
	 FxnpgXp6i26ED0fBwfcR5M9LWcWz9TpMn4Iszk+CmmQF9zhMYCKF+onlZ60VQFRzdeMyV
	 aRZzFqdreY+r9aNb5v5Ib00Zz1bQOyr49R9R/q8SNI/sGdg9Q0OMCHV7HFDlOig11+V24
	 BtO5mg0ZRxGEe2YOCv1rCdly5ZEKp/APACTotc6My7Zo7kiY7aNAWRGXjjL7TcxuG7nHZ
	 GoTzDKv+UtD24bXOk485tPfQRc30UTRMeEpvClJkgIBL8TbMRuJRQ8ac7UvxecCQgww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpHEV9bN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A69606A32E;
	Sat,  7 Nov 2026 14:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpHEV9bN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160941F008A2;
	Sat,  7 Nov 2026 14:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061997;
	bh=uZZ+WTb/5FCLh6USJdQzLuQbWm/PD9gNx4zuHWxeAnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpHEV9bNyTwP8ayKffY5Aihc+BiGc02TCuctwchkfsLyhkBDWJ3IHFnKDG5G2vEk+
	 RqmL2/oWG1pKRIJDkBJyspmXIGSFUe/3S4ivNZka65pwUMt4K3axEz9VJI7XJ72QYo
	 yHQ0/GXGoZouRJ+nnTMEJ8PdjqsEpGFdOMm/Ry+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0951/1536] media: microchip-isc: do not touch WB registers when not streaming
Date: Sat,  7 Nov 2026 08:49:27 -0500
Message-ID: <20261107135024.367546065@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/microchip/microchip-isc-base.c   | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-base.c b/drivers/media/platform/microchip/microchip-isc-base.c
index 97506304f2391..bd58d65a7c273 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1513,20 +1513,24 @@ static int isc_s_awb_ctrl(struct v4l2_ctrl *ctrl)
 		if (ctrl->cluster[ISC_CTRL_GB_OFF]->is_new)
 			ctrls->offset[ISC_HIS_CFG_MODE_GB] = isc->gb_off_ctrl->val;
 
-		isc_update_awb_ctrls(isc);
-
 		mutex_lock(&isc->awb_mutex);
-		if (vb2_is_streaming(&isc->vb2_vidq)) {
+		if (vb2_is_streaming(&isc->vb2_vidq) && !isc->stop) {
+			unsigned long flags;
+
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



