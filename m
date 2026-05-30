Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7C32E7390;
	Sat, 30 May 2026 18:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165328; cv=none; b=QaaQdIu9xS8uf3BVkuALEGAaw6FLuBcCpEkcpkENFTjf3je79cJ5/duuMZUVJYXgyiyMyYA56PwW+9JpPpS8wNjidfsSwMvV779S1g/T3k8Sl8Da/wRUG9VD/AO7wMJCrV+kyOJ99EPllBzdwglksc6qLhRm0iYL9vDx4XskW5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165328; c=relaxed/simple;
	bh=abEUHBo3jR4SQplUAuiVNYHRNYwpdt6b0c1mX77NDFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emZDiqcxD5sGbDq+Q58iom8ph9SjXc/ZtKJllJfGjFlZtkfLIJjMDLsBJfMxjkjRruYxIrZ/c9dy69Sxpb+lGdO707tHZN4JJcr0fakqvl5ctnZSlJOzi3gY943JqqMp06pvavjlSCTxt8MoTERL+Vkrzj1tJWs8KtDcNgF8LL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/HpLamq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/HpLamq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6651F00893;
	Sat, 30 May 2026 18:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165327;
	bh=niWMNaUHpNSAI9ZES11EvFe3mOfuX+GfpzPc9lCA2HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/HpLamqMqN13HflzoqJHt/9BD01bGKmyfhkf3SbA2JFTvL8/nOr8ghJwYLFYFSOg
	 W7xCzT+ioKDN4/NSWYesnIzRZucfDtiL8PzlPlasaiX+EKJluAMiJ3Y3dQHFcakr2I
	 c576sCi4AggwFq9AzytGwpwt+5B11G3GJJ8zTFAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Lin YuChen <starpt.official@gmail.com>
Subject: [PATCH 5.10 046/589] staging: rtl8723bs: initialize le_tmp64 in rtw_BIP_verify()
Date: Sat, 30 May 2026 17:58:47 +0200
Message-ID: <20260530160225.800147433@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1889,7 +1889,7 @@ u32 rtw_BIP_verify(struct adapter *padap
 	u8 mic[16];
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	__le16 le_tmp;
-	__le64 le_tmp64;
+	__le64 le_tmp64 = 0;
 
 	ori_len = pattrib->pkt_len-WLAN_HDR_A3_LEN+BIP_AAD_SIZE;
 	BIP_AAD = rtw_zmalloc(ori_len);


