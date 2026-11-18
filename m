Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030895;
	b=zpt2cBPuI28vjvtFFXufutsJVSjaEhG54yHZOUnbdpkGFkd5UCZfaY7j87UHy6sl7ILm
	 E2lbnwBgKvHA7YXk1cb4itPZqikOePPIHuFXH5bfzDGeKU0PEMhYNSJsqq3bvQOELEnUv
	 SykirBHDDaM1X8zYjxCb4gtQvL6aVh2wL0NCsrI4xTuT+be8laVo5aLMxNFcKUyH25hsy
	 uU7XgOBnjNZNSJ78Zu3VkNDhpFsWn7rxrGuqJ4gCWqrycGS8d0Mjkq+gbgH7tiMtCXpTH
	 efX3qW0RfV0heFNDW4mNLGGLAT4NXmT01n23hcKfBrxIdjZHyJp9lSt+hOL8eNz9Qkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rKU+VubzRrxugNRQvkoDw3NNOOmezF/UOLM9Vb7FWBc=;
	b=0Hx9sYCz52Otkqtppcl27NKr5P1xR9HqIuIrvUNSIujHFfacTKHaEm7DhH8XZfr1vQ1p
	 3yhfwqIBRLCnRz4I5yHzg5jz7RJNDutf3XmSa/Rn+9CMB7lgulhipvHV+LaoZEN4JNleb
	 FPtJv8DHFclhznQyi1amO4YaclS/9SKx8m5f2Yoj+MPpI188sv6uiW5oq5rFpUsXMCRxL
	 o7R6X+LTyojy8ddoTpKU6QFDbbvf+MzjfGLmoxT2kkJP63fNk3LzQMe4XIHb9J6G9FjNE
	 u6741LPFERreIApy9lSaRQAXdDjejIuodL3Gh52WeWsAx1Lejdwl5jiS892Pm+W6CXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GEJMy+9z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDD8606DD14;
	Wed, 18 Nov 2026 19:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GEJMy+9z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AEA1F000C4;
	Wed, 18 Nov 2026 19:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030895;
	bh=rKU+VubzRrxugNRQvkoDw3NNOOmezF/UOLM9Vb7FWBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEJMy+9zl42NVR5uO71y4aFD1/c4jOGiW9KeRzy94kuHhZdSMDoUcu0OUs1dHdi4o
	 317McSrsoahnBnsrWLowQXCaRiH3CMznpq3YS79+EU4RyVzyHwaK1FzD2a3obpO3IL
	 PZCwIS8Ctyv78ZMwIyL4RUz/+epANnpGHQF+kozE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0865/1756] wifi: b43legacy: debugfs: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:49:52 +0100
Message-ID: <20261118150043.759009932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit f94595252b318a9ae3c01d78b3bcd33b01b1c082 ]

The "buf" buffer is PAGE_SIZE and allocated with kzalloc().  We store a
string from the user in it and then pass it to sscanf() in the write
functions such as tsf_write_file().  The buffer is only used to store a
number so we never come close to filling up the whole PAGE_SIZE.  Reserve
the last character of the page for a NUL terminator.

This is debugfs so it's root only.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/909ea7a88658b5e7c183bf0fda31687a91d73818.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index 6b0e8d1170611..86f0c4b717c66 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -263,7 +263,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0



