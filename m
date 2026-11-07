Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063914;
	b=njrGWj2qPehPnszXjbeM9f1Ez4pjysPpWbeoTQerqLGyhxNqU+LFzXqgwVN5ZvmwvmYf
	 YoW4pVSN3hLcEBCR15KkkKZfCyiHLoW9zqjdHN6Ar6H/Aa8fiBzQM48nOY7KWvT+BstdG
	 rYeqsTWsJX7iNRpsZspM0T/OwY9El+fbsbdOU0tQY/HO3+h+OAGmmVPlTzsYiGKq2Pu8P
	 1npFkIoLQlfgDlTo/FpfS6YpzUYiALNhgoRvsnJIEOxxxUm8z/rsAcP7u52sUUoNOfUcN
	 xFbOTkAMvdTniAmKQSvw/5OMMy/VfBey+ye6bB0NzWvtSxepMIDLo+hY8kDRs/aV1pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=628kTryIbQ4XKWYaRll+HsSXNABEYgH12Tx3gSfBxSs=;
	b=MElD3mWrui6ZdlVbiOpHDpUXAGEu9zj/di7dVoHUCgU7PVow1MxRGmv/078eSy/ih1yy
	 x5DIIrODUROBrkQI4Pd+cC/P/fFZMixZ7Hm1HV4SP2Psnm4Lje94MrMIdpxeuvMlbHaH0
	 SiPwQbJ800nVyVuiST2UWRhfYt26zSQNreFKipDbSEOAAujNizG9M3RDrZ7WuzWcWivS4
	 QCDmyJ6Fb58LNtD6ET8mijjJ2JjYOAfBEUF6+Hde+WFyEYOuSIh4udrClbVwypCq/TrKT
	 CYf3zQIvDKBlrpIWTr0zq2BZzC94ytqZrR5v9/sl0/9kU8xr+Jwi8t9sCYNLxkORj8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVPZzOfu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2958606E8E9;
	Sat,  7 Nov 2026 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVPZzOfu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5142B1F0089F;
	Sat,  7 Nov 2026 15:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063913;
	bh=628kTryIbQ4XKWYaRll+HsSXNABEYgH12Tx3gSfBxSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVPZzOfu2ZOwcFtFZ+dZt5nPz/sLizpJX/ZeSgwAovay2A3nx7ljCcd1wpNQ3IuQz
	 d94OCVW5zEU7o3q7i9kDrbZaF++6CVda6iPLmMo446+AH1n1Eayhz1MDbCoEvFEEOy
	 pGpnky21E7oLQRQkflN90ifc0S870e1y8Q4zJflY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0111/1257] media: microchip-isc: do not touch WB registers when not streaming
Date: Sat,  7 Nov 2026 08:40:07 -0500
Message-ID: <20261107134942.417003734@linuxfoundation.org>
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
index 0f486dd5bd82c..cf4611443fd13 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1511,20 +1511,24 @@ static int isc_s_awb_ctrl(struct v4l2_ctrl *ctrl)
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



