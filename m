Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212442;
	b=tpzU1UV4xv25hIisxap9QyhQlkFNq1iatSRxN0MVmNmkM38PMFUg+k8ivP8fj6wfzXlF
	 FIKlLIzN2bsWGAMCbqj1HrWAeYmRGN37o8eu2zFZcVIXzsyeLt44jdiC4Gtt7LSP7AykD
	 ObpZsT9QfvaGl3lzgrnMrMoVQRFISGN0Q6NjCufX5mmCxdVSyXSRzDDCD1BnzgPlgykDi
	 3cYHH+Y2eWW2VRf2Ou41JBxuozbBuLMXduscj0LxLisPMdKc7qi4sBxAB9Gs+Q2SF+i66
	 xqvkoQSJ2rkH1Fv3miRAUU+p4C3BH16BZv7OVcM9JxJQv/VZX219VHiSuhn0+te2J9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BnghXp0ulQl8A87ob2NvUniUcnOpjNRX6LfpU6Bq5ds=;
	b=tK8g7I8IvuWgMs0bk+IOfDgoAjdIYxZWzrEOSTMK5G4vGhQyNmXT1x6eyjOLvbdQc8sp
	 UYbpJm9OH7miXjHCoTZ3qBOT8Vt1ZslhhZFALXBM+NPXKWWHmFNmysrWo+In2Ns2WACZm
	 1mRxFgyzTamygXZu05XlZDVhWKio1TzTzjrqo8g0BkOvEGEr1wllr18/mqqsb9j6Z8Ply
	 XiLRSQo6POByQfm+Y3euNlS+KqNanXiRQR6n7nYhnwO1sqb8gDDiQ8DiYKp9Y0FtZE81K
	 4oZcAIHGxCvIJJRH2y3mPT8ujt2mlxfJkYYfiVW4AyrFtlVHkc0NdHbLUnAj59aL6ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v/VqGeZW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7536606A32A;
	Wed, 28 Oct 2026 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v/VqGeZW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE861F01825;
	Wed, 28 Oct 2026 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212441;
	bh=BnghXp0ulQl8A87ob2NvUniUcnOpjNRX6LfpU6Bq5ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/VqGeZWyLMNm1Rg7WYTZ24C6q0obmH1QNP8aLrBM7U3xoo5EWSiRpFFdqRgw0C7m
	 6XJ3cOJ3nhry5a1u6eFF1W8X/dpfOZaUj2WtKvn9s4CUpLqt8HIDx5+5JVkBGSmbzw
	 ggSylqEyiArdqgyVH1Tu1BRavvaspJRBSGulrmWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arinzon <darinzon@amazon.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0153/1887] net: ena: Remove autopolling mode
Date: Wed, 28 Oct 2026 17:37:29 +0100
Message-ID: <20261028170502.716333601@linuxfoundation.org>
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

From: Dr. David Alan Gilbert <linux@treblig.org>

[ Upstream commit b356b9170815f822394667010d478d53901ff581 ]

This manually reverts
commit a4e262cde3cd ("net: ena: allow automatic fallback to polling mode")

which is unused.

(I did it manually because there are other minor comment
and function changes surrounding it).
Build tested only.

Suggested-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Link: https://patch.msgid.link/20241103194149.293456-1-linux@treblig.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9476b4468862 ("net: ena: fix MMIO read buffer leak on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 25 +++++------------------
 drivers/net/ethernet/amazon/ena/ena_com.h | 14 -------------
 2 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 276f6a8631fb1..a7b98c0b5f285 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -763,25 +763,16 @@ static int ena_com_wait_and_process_admin_cq_interrupts(struct ena_comp_ctx *com
 
 		if (comp_ctx->status == ENA_CMD_COMPLETED) {
 			netdev_err(admin_queue->ena_dev->net_device,
-				   "The ena device sent a completion but the driver didn't receive a MSI-X interrupt (cmd %d), autopolling mode is %s\n",
-				   comp_ctx->cmd_opcode, admin_queue->auto_polling ? "ON" : "OFF");
-			/* Check if fallback to polling is enabled */
-			if (admin_queue->auto_polling)
-				admin_queue->polling = true;
+				   "The ena device sent a completion but the driver didn't receive a MSI-X interrupt (cmd %d)\n",
+				   comp_ctx->cmd_opcode);
 		} else {
 			netdev_err(admin_queue->ena_dev->net_device,
 				   "The ena device didn't send a completion for the admin cmd %d status %d\n",
 				   comp_ctx->cmd_opcode, comp_ctx->status);
 		}
-		/* Check if shifted to polling mode.
-		 * This will happen if there is a completion without an interrupt
-		 * and autopolling mode is enabled. Continuing normal execution in such case
-		 */
-		if (!admin_queue->polling) {
-			admin_queue->running_state = false;
-			ret = -ETIME;
-			goto err;
-		}
+		admin_queue->running_state = false;
+		ret = -ETIME;
+		goto err;
 	}
 
 	ret = ena_com_comp_status_to_errno(admin_queue, comp_ctx->comp_status);
@@ -1658,12 +1649,6 @@ void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling)
 	ena_dev->admin_queue.polling = polling;
 }
 
-void ena_com_set_admin_auto_polling_mode(struct ena_com_dev *ena_dev,
-					 bool polling)
-{
-	ena_dev->admin_queue.auto_polling = polling;
-}
-
 int ena_com_mmio_reg_read_request_init(struct ena_com_dev *ena_dev)
 {
 	struct ena_com_mmio_read *mmio_read = &ena_dev->mmio_read;
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 3c5081d9d25d6..bb33fe209eec0 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -227,9 +227,6 @@ struct ena_com_admin_queue {
 	/* Indicate if the admin queue should poll for completion */
 	bool polling;
 
-	/* Define if fallback to polling mode should occur */
-	bool auto_polling;
-
 	u16 curr_cmd_id;
 
 	/* Indicate that the ena was initialized and can
@@ -484,17 +481,6 @@ bool ena_com_get_admin_running_state(struct ena_com_dev *ena_dev);
  */
 void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling);
 
-/* ena_com_set_admin_auto_polling_mode - Enable autoswitch to polling mode
- * @ena_dev: ENA communication layer struct
- * @polling: Enable/Disable polling mode
- *
- * Set the autopolling mode.
- * If autopolling is on:
- * In case of missing interrupt when data is available switch to polling.
- */
-void ena_com_set_admin_auto_polling_mode(struct ena_com_dev *ena_dev,
-					 bool polling);
-
 /* ena_com_admin_q_comp_intr_handler - admin queue interrupt handler
  * @ena_dev: ENA communication layer struct
  *
-- 
2.53.0



