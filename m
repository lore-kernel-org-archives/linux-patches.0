Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063611;
	b=iqd47FVwuC+lnttx9M2mwS/RhbDCK7sItMuQxnqIG9kDAIBaSH5ULVyh0JnVodGjOAHu
	 OM39NPD40H/kjRhfgJuqAUmu4UxpdifJi/sr5RjITS37jVpxIFh4/IT+nB0y23saprxuo
	 M86mjEEnzWayZouGBkajqTcfAYvX0EFCHrJeSl09HcfQ66TkCGGLgLx2DQifqy9dTL1kN
	 vmMGGpj5mD7FeT2/lfy+5dMSo0SmtZxNtagRvlKw2TvBWaOiz7vh4qfZaHYad3LZa+1fs
	 VMnHSsR7LXEASiE/lomccDkiGqi35IvsLDzrpUzpVg18sJJ7dTe8gVgQcrc0JoqRUIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fQNpZG0NZmz2irJBJqTwTw4KZyoPl++z6yW80DwEUDs=;
	b=luUh6gO8hY9CtKaxOMXtr8y4V+hShcseNH1Yj/1aqHHjjUjRuHEJnjhQGrt7W9aRySYN
	 zuaJKl1DChs5hDdS4y08yXiGROTLKCbmLsU+DIK6oeRVeLw4PwfxDzgqjb+LlJwxd9L0y
	 TeIRIOVjp5XEa9KjsET7oqJKHdrYqak0rUIqdLWdNO2Qus9HP7ZSdepM2+FWroa2AQkzy
	 apE7vRkl4V1wyOzEDRCs5VYFZFkoHMODiNspTFnC34Jk9dzFdaGy7pm0fPmMPtULGG8Ol
	 Sxn2vSbUCxq0gnZj7x6dQdRHPI6yt30Len3yT+MI9NgSSHJl2F002eT4tqXWEh/IjyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlL9f9mB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AAB6082BE2;
	Sat,  7 Nov 2026 15:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PlL9f9mB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DA01F008A2;
	Sat,  7 Nov 2026 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063611;
	bh=fQNpZG0NZmz2irJBJqTwTw4KZyoPl++z6yW80DwEUDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlL9f9mBgIiHxQzgQ+CePrHAEtwALS+5R4MNX1/t8VAyL2EgoMSK30YXAmszo3zgp
	 EUycwglsuVNYpiMg19f1V3wsXYw4FmfaKOHSjjCscHr/ApSWVs92Ed8d6fv7P0wV3L
	 WF1IrEeR3kdJuk4ZkmUfgEhsol5AMaxJ9DNCCxbg=
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
Subject: [PATCH 6.18 733/869] scsi: ufs: core: Clear stale UIC result byte before peer DME retries
Date: Sat,  7 Nov 2026 08:56:55 -0500
Message-ID: <20261107134917.676911021@linuxfoundation.org>
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
 drivers/ufs/core/ufshcd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 52df1df6333aa..d225ad90cc392 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4219,9 +4219,12 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
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
@@ -4285,9 +4288,11 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
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



