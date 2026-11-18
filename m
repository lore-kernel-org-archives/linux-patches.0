Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048635;
	b=qrr8nSJz3yOBCqqNKVkhv7zVryFNUkxGdWDc6npNsXWGzJIJ5bVA+0Twnj+I4vizUQSx
	 kWSZRTK341o2+w/l9FYL8lTacga48hW8mauGkI00WFnhq2T+XyjSnw5mf6wvgLqeTZhSx
	 FwdcsKA8VaGOGbAw5aiFI18+5QfW+LD/LN0BCmlzDqoadZsmUFBoQBcJyxdFAMMteiwfu
	 bJfksSdskGEirOVGKfgZ34ZS11BbUbMapBlpjaMRIvctY4KCJhXdtKP31Nvnus58vrx1j
	 SqK8YW0Nm61oaIFJ95LxC7c/gAYp17gXohKajYOdVj3edY3/05SpTabTH8/VdIBb/WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vLrP6dyBS8qZlCNTn7wOPQgItJXLP1OOJD9wvdHQR9I=;
	b=s6Vahf4i74cGBGYIkGa7njp5Xp9sRE2vzanKSJ1tEbNc99kZVfgLctsydWObDjQ1Aet5
	 Du+/iFVZQBBGwaj9RqkPXqGKm4Og5EfrNkG8Hfr2Hdx3xEGOwoMMe1Zy28bJbdNIMuy6B
	 To5h+iEEtggLOJ1KWHqxuWE6eAs++wA1od0a3nsMT+Bhl15zrv9U4CopG5SdYnSs44hv0
	 dRwMM4DaaXtDruzI5sQ2qBJGDQyrhao5w3hE/vk/5OCpbMcfl4gOe6bLlvCnezhE0NX8n
	 B/3qfwYjoiFH5t9mp1GIdHJ4+TyLCKjXwlBp9hFznVzjEyq/CAK2S/SL2fvHSuu0lcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L3c2PftB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D533960A2608;
	Thu, 19 Nov 2026 00:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L3c2PftB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384561F000C7;
	Thu, 19 Nov 2026 00:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048635;
	bh=vLrP6dyBS8qZlCNTn7wOPQgItJXLP1OOJD9wvdHQR9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3c2PftBnKw2n2DenehUVFLoNR97jc9womJRN2DrrL5SQbQF+A8sq5VFZs1nQdRuK
	 lWSL/EwlhNhtKWJTxG0Oi/SlUjOx9dPqBL6hsF4m/DM0UDUf/oFMd4s2Mmiv1dXDFL
	 NJUWblesbRRKov4wb8WBwIN+3V+2qEn6wrqiZB7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2064/2857] ACPI: PCC: Preserve shared memory signature in OpRegion handler
Date: Wed, 18 Nov 2026 15:51:38 +0100
Message-ID: <20261118150315.731676922@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 46c263c213876bdc2297ef61aa90f0b210ebac73 ]

ACPI 6.3 introduced PCC OperationRegions. Section 5.5.2.4.7.3,
"Declaring message fields within a PCC OperationRegion", states that,
for all PCC subspace types, the PCC Operation Region pertains to the
region of PCC subspace that succeeds the PCC signature. Its length
therefore excludes the 4-byte signature.

The PCC address space handler currently copies the OperationRegion
buffer to and from the start of the shared memory. This overwrites or
exposes the platform-populated signature and omits the final four bytes
of the OperationRegion.

Offset the copies by the size of the signature and reject an
OperationRegion that does not fit in the remaining shared memory.

The example added by commit 77e2a04745ff ("ACPI: PCC: Implement
OperationRegion handler for the PCC Type 3 subtype") incorrectly
included the signature as an OperationRegion field. A Type 3
OperationRegion containing a 100-byte communication area is declared
as follows:

OperationRegion (PFRM, PCC, 2, 0x70)
Field (PFRM, ByteAcc, NoLock, Preserve)
{
    FLGS,   32,
    LEN,    32,
    CMD,    32,
    DATA,   800
}

This contains three 32-bit fields followed by a 100-byte DATA field.
The fields correspond to the Type 3 shared memory layout in ACPI 6.3,
Table 14-372, after excluding its 4-byte signature.

Fixes: 77e2a04745ff ("ACPI: PCC: Implement OperationRegion handler for the PCC Type 3 subtype")
Reviewed-by: Huisong Li <lihuisong@huawei.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Link: https://patch.msgid.link/20260922144302.3847593-3-sudeep.holla@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pcc.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpi_pcc.c b/drivers/acpi/acpi_pcc.c
index 97064e943768a..974ab94e7ccfb 100644
--- a/drivers/acpi/acpi_pcc.c
+++ b/drivers/acpi/acpi_pcc.c
@@ -28,6 +28,7 @@
  * to PCC commands
  */
 #define PCC_CMD_WAIT_RETRIES_NUM	500ULL
+#define PCC_SIGNATURE_SIZE		sizeof(u32)
 
 struct pcc_data {
 	struct pcc_mbox_chan *pcc_chan;
@@ -74,6 +75,14 @@ acpi_pcc_address_space_setup(acpi_handle region_handle, u32 function,
 	}
 
 	pcc_chan = data->pcc_chan;
+	if (pcc_chan->shmem_size < PCC_SIGNATURE_SIZE ||
+	    ctx->length > pcc_chan->shmem_size - PCC_SIGNATURE_SIZE) {
+		pr_err("PCC channel-%d shared memory is too small.\n",
+		       ctx->subspace_id);
+		ret = AE_AML_REGION_LIMIT;
+		goto err_free_channel;
+	}
+
 	if (!pcc_chan->mchan->mbox->txdone_irq) {
 		pr_err("This channel-%d does not support interrupt.\n",
 		       ctx->subspace_id);
@@ -97,14 +106,17 @@ acpi_pcc_address_space_handler(u32 function, acpi_physical_address addr,
 			       u32 bits, acpi_integer *value,
 			       void *handler_context, void *region_context)
 {
-	int ret;
 	struct pcc_data *data = region_context;
+	void __iomem *pcc_opregion;
 	u64 usecs_lat;
+	int ret;
+
+	pcc_opregion = data->pcc_chan->shmem + PCC_SIGNATURE_SIZE;
 
 	reinit_completion(&data->done);
 
-	/* Write to Shared Memory */
-	memcpy_toio(data->pcc_chan->shmem, (void *)value, data->ctx.length);
+	/* Write to the PCC OperationRegion after the shared memory signature. */
+	memcpy_toio(pcc_opregion, (void *)value, data->ctx.length);
 
 	ret = mbox_send_message(data->pcc_chan->mchan, NULL);
 	if (ret < 0)
@@ -125,7 +137,7 @@ acpi_pcc_address_space_handler(u32 function, acpi_physical_address addr,
 
 	mbox_chan_txdone(data->pcc_chan->mchan, ret);
 
-	memcpy_fromio(value, data->pcc_chan->shmem, data->ctx.length);
+	memcpy_fromio(value, pcc_opregion, data->ctx.length);
 
 	return AE_OK;
 }
-- 
2.53.0



