Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210704;
	b=riO+3s0zV6C0FgMMmX+d1WK0du9HIN1Uqt5mYQWPvlIoN20sKtssR/niEuCK7S7mT5uM
	 86z7QER1MW3L+2VJihF0ql/xtzlJOEkkORIdDbWSdq+kO3o6NXDReZGkXh/GRafwqdpF5
	 dK1dALlu5nKwR8RbMKS2y7pYQwrZYRz1XiRYd8mdUXEosquyb9uDjdRGgk/WrTjXHuE+p
	 3NuCz6uRigLuyrbW1ukiLYIj0QJeMFsGWa5nxJfGCG8qvNwDSZLY6cUf48lYkYZQQQ74d
	 /CuNqt862GoAU5YaDE/7kMWTYVVwfOH63Hpml1dHM2uoqz24AdJNcfwp6EcsjNN2JPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qn1ULvwnUhQ3VwlQjw9TNu24RxclMgMY+vok6TmZ/18=;
	b=lMkSeJThFTf9il7KqBqKX3sDZVML2UygObdPF58B1WRwSfoPo5YJm1fmUBpkmLWVFhFz
	 ZwsBIsT4D30B6b8I/33EWdMy6t6wvClmBrxXuzsdSatKvWRDT2KTePsvTWxP3VbthbOGq
	 1DXNVBkVvHP5EpjKyQad+yCN61P4g9+8M7G+HAis83gUMcAxG0c7bE/PILYP50O8vWvtB
	 tA5y5oOoPfFCfpE4gWhPAznHReP3mnzUZIGU2AMtXFzfp4GqhK3y7ZIlxDIgLdrXTkUN6
	 0t01DURLXIRM6btDrOORSTi30DddbSb2DGXAuOoQVqmUUBSRhDZtn4xQXYM/ZHXtfig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVUvV8C0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72F1606A31C;
	Wed, 28 Oct 2026 18:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVUvV8C0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B751F01825;
	Wed, 28 Oct 2026 18:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210703;
	bh=qn1ULvwnUhQ3VwlQjw9TNu24RxclMgMY+vok6TmZ/18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVUvV8C0TalNayeQawq3HR1Y/GnRI3YXVvdT4Lmfxo2l46YNJJVQ9mw6DuVQLorjN
	 rkAs6zd61WNRtfdQBb1/9JtPWbqlAvvFKTve9dVkhGY+0xtcaEVz7dWRe7E2gqZjk1
	 7BHQK4A3qTgfEhhZjaBJGofqVvG4VU1hTcY5/HpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arinzon <darinzon@amazon.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/571] net: ena: Remove autopolling mode
Date: Wed, 28 Oct 2026 17:54:25 +0100
Message-ID: <20261028170010.819855800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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



