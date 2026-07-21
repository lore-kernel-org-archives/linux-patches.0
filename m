Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CA246F486;
	Tue, 21 Jul 2026 18:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659682; cv=none; b=sejVeHMUHcNt/m2YMkQgjxQeRKJ4gDQPJbcfOX6TyfQReP4A2YV7iPGF2YeJsm9dVEKujKaW5EuLtDAvlDU45DBaWDh4WchcLibL6NGwhuyLRdHT2JUa3/QlNzAri80F5uvhgyFdsBgkU0k74OAi4Im5ukgQQDXF+XqW1mU0+Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659682; c=relaxed/simple;
	bh=rY5DeixdEZnP/yDygDWDowRNc1vhoQdZ/pOgIrKhVzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbeTHYFpLm4gihTMYmv+jREhdKqhwZ7pVKwYq7fZobcKzmBF6CWQW+lJoKGbaW6Aynm1qOkDl0Xpe7R07/lA6a2wP5nRem/sg8eNBFWGc0sVSdlwYXokJhRZ18vgXYj20wyHyjwnLTp85mBr1rASIf0pSdR1X8gwjjCCMB7O0Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vunFKNaN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vunFKNaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AEE1F000E9;
	Tue, 21 Jul 2026 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659677;
	bh=aJnEt/Axh4PDSP/6uTME3fR/a7Db5iEXhwLckbZ4BgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vunFKNaNit+r5Ya7nuteiEysGxSvvbO0pi/t1StBhyR87br7DgrSlVmEjUthf0p2E
	 GdzSIT92XY9E3yFLyejfUnUxPqVScio8Ivf7aSYdsIz00mKGUj/R5FC6Xz7fvEWdmT
	 +cTn6f2nlIkiVIACX1W3TVG36B2dhOr72Tf5vjL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anantha Prabhu <anantha.prabhu@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 1610/1611] RDMA/bnxt_re: Initialize dpi variable to zero
Date: Tue, 21 Jul 2026 17:28:46 +0200
Message-ID: <20260721152551.689586831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

commit 978b27d6ce538bb832ccd69e45802824e4301c4b upstream.

dpi is initialized only for BNXT_RE_ALLOC_WC_PAGE, but copied
for all the cases. So initialize the dpi to 0.

Fixes: eee6268421a2 ("RDMA/bnxt_re: Move the UAPI methods to a dedicated file")
Fixes: 360da60d6c6e ("RDMA/bnxt_re: Enable low latency push")
Link: https://patch.msgid.link/r/20260615224751.232802-2-selvin.xavier@broadcom.com
Reviewed-by: Anantha Prabhu <anantha.prabhu@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/uapi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -76,8 +76,8 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD
 	struct ib_ucontext *ib_uctx;
 	struct bnxt_re_dev *rdev;
 	u64 mmap_offset;
+	u32 dpi = 0;
 	u32 length;
-	u32 dpi;
 	u64 addr;
 	int err;
 


