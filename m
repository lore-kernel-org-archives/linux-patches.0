Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065296;
	b=E5Y0EB1CPX4HlRbSKD89VP/EtfaID3hKURt4ekxtcr+YOtfm8pxqWGSgZn9nj8ZJiIgm
	 S7fCU616oqnJ+jYxnyOrlJ0wVGfuwe/PhAV+cm8y4zCsouicwJuPXUmtl9pgq1MmcJ1H4
	 xstwobNfN5NlOt9ryjFdXxC55JY2CQZ4Tf0ZVODFDxDUPNTJzfz4mTw0esMsTQuMmt/sC
	 /3SS2/6UvxEihRcNKAh2S1qi95rsZERKGiwj/P1s/q6ht3vENaV76ZyfDx2r12Z9RM0X/
	 G8jOdGhXh6DOjzOCFU9fl4zmqLfroKGmmtHd3wqTXMjgHnB9Y9Tz48mOPPfWNegnsIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pBblZpsUMlywdtkJVkSb4OrSpMInCOHJABx2h2t5of4=;
	b=4X4k8+co5c1kOSrQg9h7uztmwfKbaZpeS9/e3L0fRpAscShA0xpi5b6QOauUOZtv3UnQ
	 gYEEbDncxWHWHgl0Q3yal4xIVZmyiyQCykkw1OcW/EHX3SAU/Oeq7TcU1kMw8upOFjANR
	 CVC1gpeTkVrfuCEXS26B5iVCNFmr0ezy2/LMN5X01c+k5b5V8AII4ixBTXsslRJnrbREm
	 MKVCdRSEzTCBTpGvRo7HOPV1BiL1IfqHBevcfxNmJqG1TqIN80e02ath3jtWjhgsY3bre
	 SVmulkAdti3xw7zVHKed9zAmXqjXAlEAThzhnk4WBF8P4PHZj0q3/0QIhGivvvr4KRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GUG/svJc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC71606A326;
	Sat,  7 Nov 2026 15:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUG/svJc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027B01F0089F;
	Sat,  7 Nov 2026 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065296;
	bh=pBblZpsUMlywdtkJVkSb4OrSpMInCOHJABx2h2t5of4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUG/svJce3hSqQiE7R0dNSFSbzFz6m92CIocneWiE0n3duedOgJEpfjVfdANA70CF
	 Lg6/R46HBZe/Ub3lnmXdvUXEPsdeID/mfrsi9npWGOOZCquiFPeyXmZPKufGgZfxAr
	 +RGyZr+HE9RXiJIF+VYVrkV6T0trJj3MVXwY8GoY=
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
Subject: [PATCH 7.3 1052/1257] scsi: ufs: core: Clear stale UIC result byte before peer DME retries
Date: Sat,  7 Nov 2026 08:55:48 -0500
Message-ID: <20261107135008.349336541@linuxfoundation.org>
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
index ca8329052cbc5..6f92e5b4cc832 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4359,9 +4359,12 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
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
@@ -4426,9 +4429,11 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
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



