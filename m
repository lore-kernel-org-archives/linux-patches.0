Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043052;
	b=0nVbp9ShuFVMg5njIuJgsRyPRb0dW0pCfzNRAdFkaii5dtlKfxJ6y1uEK7+w2pJI2KQH
	 hPrqEPT3Xp4xN4M/j77HRNlp485sMuw2m1GqPQfSknkpHA1pNyiQMWzhTRESWIvV+he8I
	 qv2jV/vlhPvA4GgmtQ3cpK2fMHMg32gnYuezt7dsTe2VyF0k5W5KuxLdJ6R+Zx6c78ldS
	 CBHnm60ZL0WWsGlgb5/ajcuzJ4Pqs/YoIS2YSXm7MBrbZAS5moI3PEOeoRczq4vNDDEnK
	 r4PcAcl+dZ5ujoVXIPkX6n8Jaa3T2za3Gm2o1DZ7IzjuREAxgj7DxQTBCRsP69iPuLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QkQ1YfHVDvSxN5IyKFoIipPl+2xwQDWW1XvnHb8BnQU=;
	b=POdbPE8GstPgrhIxAE5MTrFGkG+BNgQ57yTNxGkKfCiwnrKHmESPOs8dzewpF4L2uINS
	 8AcV68KmZDD4HTmQUt5CwjkhKPdK0mofWOblmPRoPTNGMtl1t1cSfKazUBy6ZSH8Klddv
	 aLkGD7ixIoYIDq0mNmd9UisE0Pu1E7hMmK/5v6K3l2gvTicOxL8T4dlc2s1XoHDkK5O+K
	 0qMmTiDUVF1KdoJ+yQyMBPSPtIjcD1Y9d/HuRABtKY+Rc96DsGtJTrKfCITe8nKRZOQAh
	 Wfkdjh0ex/BqrgQvhFNI3lva3NKbyUdJW3qS57KBjaWHev+cZPQHobHekvGgin4RWXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ir2bqUAG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A8D606A32A;
	Wed, 18 Nov 2026 23:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ir2bqUAG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1725F1F000C4;
	Wed, 18 Nov 2026 23:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043052;
	bh=QkQ1YfHVDvSxN5IyKFoIipPl+2xwQDWW1XvnHb8BnQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ir2bqUAG1j6W2/9HD6g8okNBa8+txBAoWHknAcQ8M6jnusIELXltjx7CADSbuomO2
	 STlZ1HNw39+2dG1O4hQCrYVWXHyQCTr8JxLdwAPcgr/WKsccSQEnl1LCEMiUcNSG49
	 dnRYthJ7QI3WCBRxiD40fZPW0usy+ZWxWXg6H/18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0074/2857] usb: fsl_qe_udc: check qe_alloc_request() failure in ch9getstatus()
Date: Wed, 18 Nov 2026 15:18:28 +0100
Message-ID: <20261118150203.976479391@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 612551bf7cf7113b8bbd5e8c1eea86d9427c2f95 ]

qe_alloc_request() may return NULL on allocation failure. ch9getstatus()
passes the return value directly to container_of() and then immediately
dereferences the resulting qe_req pointer. Check the allocation result
before using it and stall the control request on failure.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260620120631.2894977-1-haoxiang_li2024@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fsl_qe_udc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/fsl_qe_udc.c b/drivers/usb/gadget/udc/fsl_qe_udc.c
index 72b6d74b34982..2bf8b95093b74 100644
--- a/drivers/usb/gadget/udc/fsl_qe_udc.c
+++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
@@ -1944,6 +1944,7 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
 			u16 index, u16 length)
 {
 	u16 usb_status = 0;
+	struct usb_request *usb_req;
 	struct qe_req *req;
 	struct qe_ep *ep;
 	int status = 0;
@@ -1984,8 +1985,11 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
 		}
 	}
 
-	req = container_of(qe_alloc_request(&ep->ep, GFP_KERNEL),
-					struct qe_req, req);
+	usb_req = qe_alloc_request(&ep->ep, GFP_KERNEL);
+	if (!usb_req)
+		goto stall;
+
+	req = container_of(usb_req, struct qe_req, req);
 	req->req.length = 2;
 	req->req.buf = udc->statusbuf;
 	*(u16 *)req->req.buf = cpu_to_le16(usb_status);
-- 
2.53.0



