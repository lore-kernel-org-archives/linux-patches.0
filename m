Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064638;
	b=chB2u2FiFCk+zMOLOXKRcuHEnPVIPECFlJWIQyG4HeKQFiY5+ejwPi0+IwaeXKWkV/Y0
	 6yNqShoNZxx1UisZNaFBGYHZuUR+mY5OPpsOCudlSSxjwr93N0k1+GpLGqkEEGXmvWPmm
	 YeLNpTcCCRUyyRTrcOf8LJwxV/slFRkeQjhk+TSdhLbsydobHz7sYvdnfGLVXm3SIEQvT
	 VdFyq/qmVttUAWwziU4fJ6c2YsmkE0jYt8GrNTadaLJdn8r5ohUtxJDB44A7t8wp9xFsJ
	 /N0aHYi2I+4+JPRnBQjJS4bHQd2AncQllpuVhyIa5pkgMhnNmDxVH2VRYPfbhnY5QmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rbuRHzBpb1g5byAvuJG4ltuAHnBj/11U+/5Gbm7RIOU=;
	b=0yVFxdS+xqEqXhClSmnTVTR20nG1kaZT/mXCOHVXIrf45zYUcMXM/z5+X+7CLlozcexB
	 3h5geGcK+KrhBlWf+OzHPnmC3bIgcbt6tMyGhjxFkX8wDRJVPvHc22Az3z0phxnUjhrVQ
	 2iBvKFJJrXs63y1aRVZjEVtiW3BwcHEdIZbhnqiku1IaAgh8roeB4xLMKvEduHaluImcg
	 ltV5LlvGP/IPZx4+zM9zgsxrph99Y2P0i1q+KUTmquTxQGSfFJaVJWeemtlK9uTViiOBi
	 FVu2u5QU268qpyGIx/L1ZT/c/RfGT7Gb7ITZcyuAV46GMGHgvmQ35t73wjYRVzQZUCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zPpt8ESw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6174606A33D;
	Sat,  7 Nov 2026 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zPpt8ESw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831631F0089F;
	Sat,  7 Nov 2026 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064637;
	bh=rbuRHzBpb1g5byAvuJG4ltuAHnBj/11U+/5Gbm7RIOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPpt8ESwTmHmoVvztDiu2K5AzoAWLt4YTGvqEWP1scRDAmRnq9gj525GYlxHvO5Tz
	 ipUDdXHiXd/eaUwHMywKTXb9BPBE+B+2V5NveUW/qXzyuY6asAfCA0Tf+c5ozHWPK0
	 bYxXcLxF2ny4cL9RQrTD9LyNlcmTR3hM04dZxeA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Gris Ge <cnfourt@gmail.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0626/1257] usb: typec: ucsi: Skip CAM query when partner has no alt modes
Date: Sat,  7 Nov 2026 08:48:42 -0500
Message-ID: <20261107134956.583997297@linuxfoundation.org>
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

From: Gris Ge <cnfourt@gmail.com>

[ Upstream commit 7c590f0716ed3c9ae9809dbc6d488d76c19fdf52 ]

Since Thunderbolt alternate mode support was added,
`ucsi_altmode_update_active()` is called on every Connector Partner
Changed event.  This made the driver send `UCSI_GET_CURRENT_CAM` to
PPMs even when the partner had no alternate modes registered. Firmware
that does not support the optional alternate mode details answered Not
Supported, which produced a spurious error on every partner change:

```
ucsi_acpi USBC000:00: GET_CURRENT_CAM command failed
```

Fixed by skipping the command when there is nothing to update.

Fixes: da87d45b1951 ("usb: typec: ucsi: Add Thunderbolt alternate mode support")
Assisted-by: Codex:deepseek-v4.1-flash
Cc: stable <stable@kernel.org>
Signed-off-by: Gris Ge <cnfourt@gmail.com>
Reviewed-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260930234611.468765-2-cnfourt@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index c1450639c7956..264338fd594a6 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1519,7 +1519,8 @@ static void ucsi_handle_connector_change(struct work_struct *work)
 
 	if (con->partner && (change & UCSI_CONSTAT_PARTNER_CHANGE)) {
 		ucsi_partner_change(con);
-		ucsi_altmode_update_active(con);
+		if (con->partner_altmode[0])
+			ucsi_altmode_update_active(con);
 
 		/* Complete pending data role swap */
 		if (!completion_done(&con->complete))
-- 
2.53.0



