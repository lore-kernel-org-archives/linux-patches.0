Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2C62DE6E3;
	Mon, 20 Apr 2026 16:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700957; cv=none; b=Io14szSOI7/WWR3FahuwEMfM664N+Klyl9NVHJlj0og1C9Z0Jutao68JNhgv0Yqmh1QyumtbTfo8ThN4yMdMoZseq0zkwfRIKuv+9FTIJxJXS3tdl4/pBDxlPF/sqbaeGVypdRae8vwsv+BtCjcJVQPaKXwrWWBa8nPwR9re54E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700957; c=relaxed/simple;
	bh=JINLryBGRixUhu7DMsa+0Jx3a9yZu8UfNXO9O2xx5X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJX/66TRwKNxJGgKB7hts93QLEkMG1zfGmxkiEcD7WrUV/6qbOMAszH72/LinrZy8HouQN3DrvKroSWGLFecwXeJ7qSvSpJLIsvcl1BobgI39hIgkjiSDIhtBzOzadFTbnpg4L4g0iAwTeeMX3aPQFY3JbDH0tma061E2EOMfmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAO2VSJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAO2VSJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3822C19425;
	Mon, 20 Apr 2026 16:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700957;
	bh=JINLryBGRixUhu7DMsa+0Jx3a9yZu8UfNXO9O2xx5X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAO2VSJRwesP3WntLgtj6skiZe3HquMcVumglBuLLpwHtg+F7cqB1uFhRXl7Ik3Is
	 soQ2PDOA6GvEzfiR/3Lbizr18fDzTmnlsmqUcXYphSwUC5rU32tNc9kTYfXuNhG0iL
	 JQojP+Nnm79No/CKweaev1XMJbI71BJ8/SnJ0zF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Lin YuChen <starpt.official@gmail.com>
Subject: [PATCH 6.18 125/198] staging: rtl8723bs: initialize le_tmp64 in rtw_BIP_verify()
Date: Mon, 20 Apr 2026 17:41:44 +0200
Message-ID: <20260420153940.108326141@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin YuChen <starpt.official@gmail.com>

commit 8c964b82a4e97ec7f25e17b803ee196009b38a57 upstream.

Initialize le_tmp64 to zero in rtw_BIP_verify() to prevent using
uninitialized data.

Smatch warns that only 6 bytes are copied to this 8-byte (u64)
variable, leaving the last two bytes uninitialized:

drivers/staging/rtl8723bs/core/rtw_security.c:1308 rtw_BIP_verify()
warn: not copying enough bytes for '&le_tmp64' (8 vs 6 bytes)

Initializing the variable at the start of the function fixes this
warning and ensures predictable behavior.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-staging/abvwIQh0CHTp4wNJ@stanley.mountain/
Signed-off-by: Lin YuChen <starpt.official@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20260320172502.167332-1-starpt.official@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_security.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_security.c
+++ b/drivers/staging/rtl8723bs/core/rtw_security.c
@@ -1321,7 +1321,7 @@ u32 rtw_BIP_verify(struct adapter *padap
 	u8 mic[16];
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	__le16 le_tmp;
-	__le64 le_tmp64;
+	__le64 le_tmp64 = 0;
 
 	ori_len = pattrib->pkt_len-WLAN_HDR_A3_LEN+BIP_AAD_SIZE;
 	BIP_AAD = rtw_zmalloc(ori_len);


