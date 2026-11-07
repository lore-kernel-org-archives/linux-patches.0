Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062794;
	b=n/f55imOWvjNmVBlt80QW1+nhbA++W3CZz6hJf9x+fu7k2eERzlxB8Di3vuQGSPxl4fH
	 N7joWP8SGaEAhpm+uANSjrEnsDTitymrGU4Hx211ZYr3wHesSk41475Gk8Frn6pqmjjvv
	 8RngSedrQBd6bOb1qKgOD93KehAN3k2PhlWMey+s0WbVWD6toQb8mnYDN0J0sTljy+RJ2
	 1l072TgNfj+536bewa9TjAPeCG8Kp9lLtHpjYf/tr+96Lf/xx5IcxURi+nuOjUO70TagA
	 jqNOOfC89R0PJm6NG5Y3EeRncqvmeNHcuCpoJocSOzDj7mIWbDE0I4TPLI3nyKP6z7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sae2eOkkoCBxbkcO7hENwj2Clvo+lYWPJcQkvDkQH3g=;
	b=bfs/m4IzTvkaPRpzlV5Q016HFjk+4A6rP5kdjoDwrp7X1h1ZLU/S95wnmoQYJ8W2S+Ab
	 ksh+bue1PYRsVB+uNE3tLjyDIrPcpXR6Xz4ZQzs2r3VkK4ugk5lmRgX/CLuO9jXOxsQ5m
	 ESMVmoeIQUL4YQxJTvdpDaSW0uBEzKI5MhYfucTcX79GOibOtIUR9Du/tTl3+/QISlmip
	 FMY3JhpX4937FxLxmQQKjbCwqL2UbiAFvyQlZqjgM6N7nlCTEx7G+Y+xm9Y3xgL0244ah
	 w9QnUuictmh2A2KWIDBRQktvBeX32HIaSutaPUWU/zJezd80imlL8GPaFTH4asxqXKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEgVr3cJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124EE606A32F;
	Sat,  7 Nov 2026 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xEgVr3cJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768D91F008A2;
	Sat,  7 Nov 2026 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062793;
	bh=Sae2eOkkoCBxbkcO7hENwj2Clvo+lYWPJcQkvDkQH3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xEgVr3cJ9OE8V9UtGztTC1zxlwHza1vfV6SLcu23AbOeDNEYAYZf6e7kROuS3tZwz
	 sqt59ub64hjjWXdd2+3+JgSHB9oaXnnvl9kPA6KhOn9I3hsZtFoqLD0E3C8MkAYSOf
	 SV0KEG6CXM4VO60EUdfJ512l1GF0vXaiQ7WJmxLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/869] media: microchip-isc: do not touch WB registers when not streaming
Date: Sat,  7 Nov 2026 08:46:20 -0500
Message-ID: <20261107134855.987125905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



