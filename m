Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044943;
	b=TEMWlBR2xUjgClH8Jcbw9MAfzzXIqPAYEaNmG8QuLP98G5rjbo2/tL3yf4wiDueZLYU1
	 Ruke3aylENdyoAZIgM9CgFmjKpJjV4IWxHy8N/0JccMOelRU877y4jL5hDo8Lch88eAm/
	 B8Xp8MRvwoCfI2DMI7YuxDcY2Lb6H/Sbshk/kBF4OXfbfUS/68H1gzuZ3dB189VUT0iHi
	 zoqxMQ5yoaiBtQq5LlcauL5JnJ5fluhdknN2XvBvGPPsGrVYkjiDfAJ5DiZCR/ubcdtJA
	 heOceYzDChPimeLplldl05TQASvNlnKD8/Wp0wR5t0KeEIhA71W+N+XeLkrdmWIqahg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AdgKNW5XloCacJJRInYyWlJo2Iq+hMvhea+wtf0XUnk=;
	b=FZG3NHgGVKKb3CE4PjSeefEguuuCyKfYIb2Yi8Qb3EoLUNR3xxS6jEAWsV5uw7G7gyig
	 aQcvJNBx8yvuQ/4bc+s04KtyDk0Ny3jyOUBwZXxU0Ji6eTlOpfL4/bDVbC9NUUiKErSBw
	 6ys1w6dcg+Av6+dA5fDNcoRWPmLhZKaY4jIrdjRGMgRL7aWTd54e1ItcT/JsLhwvufyQw
	 bAHJGoh9prIm1TmUVd3QBY6f/7/J46cYX/fjqsB8oUGk9POtmEkiKQMJpPCfUTjghOMNB
	 Vu5R1M4rHvAH0QHm2yu23zHLKx6Jq7ln7nmExoHwctcKR/CXN+PzXOklUZJgTocoUrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PCkRWqF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82B3606A32F;
	Wed, 18 Nov 2026 23:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PCkRWqF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7511F000C6;
	Wed, 18 Nov 2026 23:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044942;
	bh=AdgKNW5XloCacJJRInYyWlJo2Iq+hMvhea+wtf0XUnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2PCkRWqFSyjSjMCBOm3/l4A69ooFSXJksq0PdXZFXapIeBCPORc3RKMTmVXBdf4e0
	 y7eZT6rNn898IFyqn98J6qmg2YuUTDR0V/0QxCQER4y6m0fOvTjxaaten3HeGJJwK9
	 vrlv5fpKNNgbSAqBlWv1evedVyD6HF4E2nqbf6nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0748/2857] media: microchip-isc: do not touch WB registers when not streaming
Date: Wed, 18 Nov 2026 15:29:42 +0100
Message-ID: <20261118150228.484692178@linuxfoundation.org>
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
 drivers/media/platform/atmel/atmel-isc-base.c | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index b7fc4177f10bd..bb9c082764076 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -1550,20 +1550,24 @@ static int isc_s_awb_ctrl(struct v4l2_ctrl *ctrl)
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



