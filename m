Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020367;
	b=oJWMMGuVutWQQSbxa2liYJxR4H7LjsTiY/SpR3gbaum6aM/uD6t0rAliM2JdS25bVsGf
	 jFXScdRnqNbyt/o0FLUkfmUntGgVF4yJVjTpw+uGdmsAnXQuyAe+YSs5HJtmXAHi5ZbXT
	 /p82+4ujwljPjuIB+LgwMBX8tWdEMziAiYTNPpAseRclswkfxQwmYNMkUhUvjTwPCWDqd
	 6P7yE4P2Y07J7tjSU8zOGmDGZ628PZ+f/Sj7rX9kIEUG0adyihRHdlzNE60o+z6L8SDVx
	 +wcYct6j+gw4W+5NC4IILjUWJLsCifcr6TeRBoJKeJN33fjEuK9SgA3R2A6/4ZOsCcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k3BIb9y2udAo0+qzuH+301PWdAgEMoGjZyLzyrzv0aU=;
	b=FRx9+vRaW+w0IJwQ4emRsVVT4/cjR9Ts8noH9y6LNyIjivjT1fdUiI0FAViiV0+bWXMt
	 Ii67BLl0U5YdNlEjkyhz+GHc51ZoMCv/uvl4hjYVLkDvO6r6YlXAXVppb28HM2i0T32fL
	 7ldUkxh8KKMT7RJqRK+W+ARmREScSOsgvscUCRi0lcNGnP/4P1aa3PBUvePlgvVh9uiD5
	 mMXn1ao8yH6GrYPSvlk+I5VdaAsJPtt/Z4XaazT45alGQZUJSpfkgkl1G/+jSqg1w6U7C
	 1ZVZU0l64X74xom2CKNEmfyu5DkGEtol431yOnW/UInrNrA5LmHeklKiKb88aQkTh3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goYDSlZ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DA0606A320;
	Wed, 18 Nov 2026 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goYDSlZ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5387A1F000C6;
	Wed, 18 Nov 2026 16:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020366;
	bh=k3BIb9y2udAo0+qzuH+301PWdAgEMoGjZyLzyrzv0aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=goYDSlZ8e7UViMuKQnbuHvz4x/3aKGGNpxAU+61LHb3dkqf3pQJpDaygI7l5q2Luy
	 XzkN0QzvntpvRgbWag1kES2Cy8ooQ2omgYESTgSQ8xMoyJkUPwEfsqr2L/Mm/jIAgy
	 zfNPOI7NfZY7MsG+GUKqjQ/L+LtsXU6V22i8q/BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra <ravindra@intel.com>,
	Sergey Lebedev <lsa.uz@pm.me>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1885/2651] Bluetooth: btintel_pcie: verify and serialize D-state transitions
Date: Wed, 18 Nov 2026 15:52:05 +0100
Message-ID: <20261118150354.769434001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Sergey Lebedev <lsa.uz@pm.me>

[ Upstream commit 4f6ead67b93bcc4ba1fbbf97c7c8bc5a0c45b80b ]

The gp0_received flag only reports that the GP0 handler ran. It does not
contain proof that the handler completed the requested D-state transition:
a matched case can leave the state unchanged.

Refresh the boot-stage register before treating the transition as
successful. When the controller is in D0 but the handler did not re-arm the
interface, restore the alive context, reset the IA, restart RX, and
complete the mailbox/alive handshake. Propagate RX setup failures to the PM
caller. Likewise, when the controller is in D3 but the handler did not
record it, restore the alive context so the next transition dispatches
correctly.

Serialize the alive-context claim between the GP0 handler and the
set_dxstate() fallback with irq_lock. Only the path that claims the D0
transition resets the IA and rearms RX, avoiding concurrent updates to the
shared ring state.

Co-developed-by: Ravindra <ravindra@intel.com>
Signed-off-by: Ravindra <ravindra@intel.com>
Signed-off-by: Sergey Lebedev <lsa.uz@pm.me>
Fixes: 88c6216a52ea ("Bluetooth: btintel_pcie: Suspend/Resume: Controller doorbell interrupt handling")
Tested-by: Sergey Lebedev <lsa.uz@pm.me>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 80 +++++++++++++++++++++++++-------
 1 file changed, 64 insertions(+), 16 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 9f7a9bf592f69..8bf9a9b4ae78e 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1316,6 +1316,10 @@ static void btintel_pcie_msix_gp0_handler(struct btintel_pcie_data *data)
 	submit_rx = false;
 	signal_waitq = false;
 
+	/* Serialize the alive_intr_ctxt claim against set_dxstate()'s
+	 * register-based fallback, which can run concurrently.
+	 */
+	spin_lock(&data->irq_lock);
 	switch (data->alive_intr_ctxt) {
 	case BTINTEL_PCIE_ROM:
 		data->alive_intr_ctxt = BTINTEL_PCIE_FW_DL;
@@ -1371,6 +1375,7 @@ static void btintel_pcie_msix_gp0_handler(struct btintel_pcie_data *data)
 			   data->alive_intr_ctxt);
 		break;
 	}
+	spin_unlock(&data->irq_lock);
 
 	if (submit_rx) {
 		btintel_pcie_reset_ia(data);
@@ -3521,7 +3526,7 @@ static void btintel_pcie_coredump(struct device *dev)
 
 static int btintel_pcie_set_dxstate(struct btintel_pcie_data *data, u32 dxstate)
 {
-	int retry = 0;
+	int retry = 0, err;
 	long status;
 	u32 dx_intr_timeout_ms = 200;
 
@@ -3533,30 +3538,73 @@ static int btintel_pcie_set_dxstate(struct btintel_pcie_data *data, u32 dxstate)
 		status = wait_event_timeout(data->gp0_wait_q, data->gp0_received,
 			msecs_to_jiffies(dx_intr_timeout_ms));
 
-		if (status)
-			return 0;
-
-		bt_dev_warn(data->hdev,
-			   "Timeout (%u ms) on alive interrupt for D%d entry, retry count %d",
-			   dx_intr_timeout_ms, dxstate, retry);
+		if (!status) {
+			bt_dev_warn(data->hdev,
+				    "Timeout (%u ms) on alive interrupt for D%d entry, retry count %d",
+				    dx_intr_timeout_ms, dxstate, retry);
 
-		/* clear gp0 cause */
-		btintel_pcie_clr_reg_bits(data,
-					  BTINTEL_PCIE_CSR_MSIX_HW_INT_CAUSES,
-					  BTINTEL_PCIE_MSIX_HW_INT_CAUSES_GP0);
+			/* clear gp0 cause */
+			btintel_pcie_clr_reg_bits(data,
+						  BTINTEL_PCIE_CSR_MSIX_HW_INT_CAUSES,
+						  BTINTEL_PCIE_MSIX_HW_INT_CAUSES_GP0);
+		}
 
-		/* A hardware bug may cause the alive interrupt to be missed. Refresh
-		 * boot_stage_cache from hardware, since only the interrupt handler
-		 * updates it. Finally retry only if the state check still fails.
+		/* gp0_received is set at the top of the handler, before the switch on
+		 * alive_intr_ctxt. Error and lockdown are filtered out above it, but a
+		 * matched case can still complete without doing anything - D3 breaks
+		 * unchanged while the controller has not reached D0 - and a hardware
+		 * bug may drop the interrupt outright. Either way the flag says a gp0
+		 * was handled, not that the transition completed, and only the register
+		 * knows. Refresh the cache here and retry only if the state check still
+		 * fails.
 		 */
 		data->boot_stage_cache = btintel_pcie_rd_reg32(data,
 							       BTINTEL_PCIE_CSR_BOOT_STAGE_REG);
 		if (dxstate == BTINTEL_PCIE_STATE_D0) {
-			if (btintel_pcie_in_d0(data))
+			if (btintel_pcie_in_d0(data)) {
+				bool armed;
+
+				/* Claim the transition under irq_lock so a
+				 * concurrent gp0 handler run cannot also arm RX.
+				 */
+				spin_lock(&data->irq_lock);
+				armed = data->alive_intr_ctxt == BTINTEL_PCIE_D0;
+				if (!armed)
+					data->alive_intr_ctxt = BTINTEL_PCIE_D0;
+				spin_unlock(&data->irq_lock);
+
+				if (armed)
+					return 0;
+
+				/* Do what the handler's D3 -> D0 branch
+				 * would have done, unless it already has.
+				 */
+				btintel_pcie_reset_ia(data);
+				err = btintel_pcie_start_rx(data);
+				if (err)
+					return err;
+
+				/* Complete the mbox<->alive handshake */
+				if (test_and_clear_bit(BTINTEL_PCIE_MBOX_PARSE_PENDING,
+						       &data->flags)) {
+					set_bit(BTINTEL_PCIE_MBOX_PARSE_READY, &data->flags);
+					wake_up(&data->mbox_parse_wait_q);
+				}
+
 				return 0;
+			}
 		} else {
-			if (btintel_pcie_in_d3(data))
+			if (btintel_pcie_in_d3(data)) {
+				/* Do what the handler's D0 -> D3 branch
+				 * would have done, unless it already has.
+				 */
+				spin_lock(&data->irq_lock);
+				if (data->alive_intr_ctxt != BTINTEL_PCIE_D3)
+					data->alive_intr_ctxt = BTINTEL_PCIE_D3;
+				spin_unlock(&data->irq_lock);
+
 				return 0;
+			}
 		}
 
 	} while (++retry < BTINTEL_PCIE_DX_TRANSITION_MAX_RETRIES);
-- 
2.53.0



