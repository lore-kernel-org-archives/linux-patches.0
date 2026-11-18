Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058675;
	b=AHo5nmGGEDyImKCvJst9pw6b8u7kYGIUMg+ZpyFpqKFwXK0MIjRPVAxkgSzPCixrq2ks
	 uHFBPztGFCTOV7EgDoo2rsh4bY4J0GPyE1lDDKkK4un+gxcw7fV2mpdS8dhxBomMAi21I
	 CGoLwkHLvROcwSevxMYrhNaQUa5ReyS+uTfEHcBbSow8l+xpVN8QynxvQ/bUAW7Y/tUCg
	 BkjriX5wCAQWTFEhP56unc7I1heD5jPr5EBnCL1xseNzcy6+SMIo6o/nTGMNZYmVHzATc
	 q9V76PWhP7ltbXzvODWyJFLC0KTDvBe9Z7+8nc8UKTmn1RJr7ny1sVELnmWpJLdBA8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8/4rY2d3KU2QtpAs9MsP2daim6OPYp4CnJLEv2+QREQ=;
	b=zoWpbWBZJjKm5q4oalFLJTNClJazLI1nXhhJrAFr8GaQ+g0eWMJdsNoXiY5nq2ZQfja0
	 vPyQhlpjKmFxhB/bffLeQH/Q5ZPksOzNQU3dPshGA9ezU0kuXNR8oRyOnXXrk8b5paWrQ
	 DAgsE6RWwfrvsMS0b8FkD9idFT0qhaPj+/KXWo93Kg66VRZ5KY11T3MQWRXh+92GoV6OY
	 9hHDZrRcTlhX7LPtxdsz6tNUneEct2eX7W9PemJ6/32UPw5qdT45+MSoqLeERyWcJH3q3
	 jPue+qZWjAFTAz+gW19tZwTutrB91eTI0B0baRGnTakZpS5guLbnF74T58cSsj0U19A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPj1Bm9T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB60606A339;
	Thu, 19 Nov 2026 03:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NPj1Bm9T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288381F000CD;
	Thu, 19 Nov 2026 03:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058675;
	bh=8/4rY2d3KU2QtpAs9MsP2daim6OPYp4CnJLEv2+QREQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPj1Bm9Tro8UaocY8RuM2KlLddw9fbd8zokYDiaiBaOINbIsgQesX2db+ea4DHiZy
	 oXoJVBjsIntq+AIZeswLUCX4+Ln1cBPdB+cPDNQGL70Y2uH7n/U6GgTTAoMUwMs2FL
	 tqoZPFK/sWUUtmFkkwH5J0aEHo+HXPK2KABNysXU=
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
Subject: [PATCH 5.10 0568/1848] scsi: ufs: core: Clear stale UIC result byte before peer DME retries
Date: Wed, 18 Nov 2026 15:43:26 +0100
Message-ID: <20261118145938.807303991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c7bf0e6bc303d..f489f25f81314 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3696,9 +3696,12 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
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
@@ -3763,9 +3766,11 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
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



