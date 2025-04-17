Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A694264615;
	Thu, 17 Apr 2025 18:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914845; cv=none; b=RcqjOtE1MrVqIftvwbkLjSjn3gG24n385E4Zlbxen0r387ZafhmWlGhb6AUAaRxyA1zouGFvWjaBGoPR8dhHSWzxm7Njz4o22k18VDWH8PhFKtoV1Nvyn4s38D8ckrPqGz6e1Fp2dLzRT78s+J523oxe+W1LPFwJA2sUllGfR54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914845; c=relaxed/simple;
	bh=dBCmFsEtki+QfBfpRHd9dbN0I76qTKgZoE8tnmeoPhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdLwcUJV9S2jrUiEZklAFfT6Ban2Z23nsoQTK+w5Qi6qUc59M6zefkLhfTsttPgcdGUIHFB5YTlpCBAdkFuxyjEFoeQQKuDgssSBrimvdzXcQuGpzxQnSPvTw8Q4ELV9InFl48Evn/Z0s5IofkkU+PMdWK8HxbL6dWkBXQFjln4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LM5gzcRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LM5gzcRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2477AC4CEE4;
	Thu, 17 Apr 2025 18:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914845;
	bh=dBCmFsEtki+QfBfpRHd9dbN0I76qTKgZoE8tnmeoPhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LM5gzcRZDxemafn1yqOHAIH2pOZYOawqCRsZZQvxpVUdlOHCSUurGZ35fejQQd/4i
	 5MjXfRdu+3DpykjfunnYTumjKnaUwGByDO5XjLu/WM+wxXI2S/43JavhlynZUdFLz9
	 PoNvG2j/TqptRwK0RjOGBO7bwyZKyknhJlRX+9qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dionna Glaze <dionnaglaze@google.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.13 350/414] crypto: ccp - Fix uAPI definitions of PSP errors
Date: Thu, 17 Apr 2025 19:51:48 +0200
Message-ID: <20250417175125.510736737@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dionna Glaze <dionnaglaze@google.com>

commit b949f55644a6d1645c0a71f78afabf12aec7c33b upstream.

Additions to the error enum after explicit 0x27 setting for
SEV_RET_INVALID_KEY leads to incorrect value assignments.

Use explicit values to match the manufacturer specifications more
clearly.

Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
CC: stable@vger.kernel.org
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/psp-sev.h |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -73,13 +73,20 @@ typedef enum {
 	SEV_RET_INVALID_PARAM,
 	SEV_RET_RESOURCE_LIMIT,
 	SEV_RET_SECURE_DATA_INVALID,
-	SEV_RET_INVALID_KEY = 0x27,
-	SEV_RET_INVALID_PAGE_SIZE,
-	SEV_RET_INVALID_PAGE_STATE,
-	SEV_RET_INVALID_MDATA_ENTRY,
-	SEV_RET_INVALID_PAGE_OWNER,
-	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
-	SEV_RET_RMP_INIT_REQUIRED,
+	SEV_RET_INVALID_PAGE_SIZE          = 0x0019,
+	SEV_RET_INVALID_PAGE_STATE         = 0x001A,
+	SEV_RET_INVALID_MDATA_ENTRY        = 0x001B,
+	SEV_RET_INVALID_PAGE_OWNER         = 0x001C,
+	SEV_RET_AEAD_OFLOW                 = 0x001D,
+	SEV_RET_EXIT_RING_BUFFER           = 0x001F,
+	SEV_RET_RMP_INIT_REQUIRED          = 0x0020,
+	SEV_RET_BAD_SVN                    = 0x0021,
+	SEV_RET_BAD_VERSION                = 0x0022,
+	SEV_RET_SHUTDOWN_REQUIRED          = 0x0023,
+	SEV_RET_UPDATE_FAILED              = 0x0024,
+	SEV_RET_RESTORE_REQUIRED           = 0x0025,
+	SEV_RET_RMP_INITIALIZATION_FAILED  = 0x0026,
+	SEV_RET_INVALID_KEY                = 0x0027,
 	SEV_RET_MAX,
 } sev_ret_code;
 


