Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052827;
	b=Geb8SfQJGEyrg7aPJuN3hU6OfqrbtwrAY/HITxPQzaa2VfKZoKMMCyGDxKJk0zwOrlUp
	 sU6o6F84gWV3+vujRlU4jzSTVNxrJywjXJp9pWpIBlLQt0dZ34+8ETTDE0C3eCiGbXGqh
	 eqPzUUKBofps7HWuXa0tLKdMKPf22ptaMi0eyUHLeXAjimXYy1TKso9asYvLk9bQoo9/P
	 ZeJVZbk3L3RcdxUtEEx2EfHdanCTjpDzndqk8INtYEhsF4w0NjgSZjUcNNK6xOL4UoAUn
	 5FBlBFQ1j1vK8UTdD1mR6H5iqnQ6x5uLnGw0RzuhrIfZ3bWK2ZADDYJgDl0aV8LBsLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ump34aer8iv/rvdniQILFwWAHRpE6OPC3Y3HC6yub2w=;
	b=O0qVaBG/otYJCdLPRe404sxL9RgX+BMVcjYOsyOQYdRBuYcgIalvOPbjSnnL1RpWYfN2
	 cyKbHXxPVIygzwdQVh5ljazwnm/06EgXccrJPC5GJcl+GvN5lIu6hJsQWmE40K0Yswhpd
	 trxbh78RIuN32fqjTb4yFTFJjcZe6chMV53nQUpdYiPB5JEsVx83aUOsG9lkBgwYPEW3+
	 y1LT3ZmbMINpNx446n/c89Q5lmeAnjhSljOXkfCBq6HtHzwfU1XSDHP9XrZCFbgXfXZGY
	 TY9aUPSx5XYvo2VuxAtuoIMguLTBGQfjuqK2qkKGx1I7Qf9raYon6TZrYYSTTcIBfwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=17r1G9rT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123E9606A32A;
	Thu, 19 Nov 2026 01:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=17r1G9rT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2348B1F000C4;
	Thu, 19 Nov 2026 01:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052826;
	bh=ump34aer8iv/rvdniQILFwWAHRpE6OPC3Y3HC6yub2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=17r1G9rTdxzMiftPGdBiU9rzmUW/DR26mzVGa0pohlmd5iQeXKHc519h8l2vEPI5l
	 GGk31YLUYMKg1hYfdLYT8G4Fe9+zLjM67bxRd7JV1Xrb5IneocmOlEv8sGIchmifge
	 HDYS/Rckv41xRhIrwtLWPeZPRpFV3DMB8A2Ccqm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0702/2214] scsi: ufs: core: Clear stale UIC result byte before peer DME retries
Date: Wed, 18 Nov 2026 15:39:38 +0100
Message-ID: <20261118150039.888595924@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit e4a9b7640914b248eb7537d4507aa42db080586a ]

Peer DME get and set retry a failed attempt with the same struct
uic_command. UIC completion ORs the ConfigResultCode into argument2[7:0],
and nothing clears it before the next attempt. Once an attempt fails, every
retry keeps reporting that error code, even when the device returns
success, so a transient failure becomes a hard failure after three
retries. Each such retry also triggers the WARN_ON_ONCE() in
ufshcd_dispatch_uic_cmd(). In ufshcd_dme_set_attr(), ufshcd_uic_cmd_compl()
also overwrites argument3 with the register readback before the next
attempt.

Clear the result byte and restore argument3 in ufshcd_dme_set_attr() when
an attempt fails.

Fixes: 64238fbd15ea ("scsi: ufs: add retries to dme_peer get and set attribute")
Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-6-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 637607868f554..39e2fb416ec29 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3835,9 +3835,12 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 	do {
 		/* for peer attributes we retry upon failure */
 		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
-		if (ret)
+		if (ret) {
 			dev_dbg(hba->dev, "%s: attr-id 0x%x val 0x%x error code %d\n",
 				set, UIC_GET_ATTR_ID(attr_sel), mib_val, ret);
+			uic_cmd.argument2 &= ~MASK_UIC_COMMAND_RESULT;
+			uic_cmd.argument3 = mib_val;
+		}
 	} while (ret && peer && --retries);
 
 	if (ret)
@@ -3902,9 +3905,11 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 	do {
 		/* for peer attributes we retry upon failure */
 		ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
-		if (ret)
+		if (ret) {
 			dev_dbg(hba->dev, "%s: attr-id 0x%x error code %d\n",
 				get, UIC_GET_ATTR_ID(attr_sel), ret);
+			uic_cmd.argument2 &= ~MASK_UIC_COMMAND_RESULT;
+		}
 	} while (ret && peer && --retries);
 
 	if (ret)
-- 
2.53.0



