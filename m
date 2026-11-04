Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829444;
	b=F3tNY1Dydgb6S3ZD4ibSghkHEgeSWliKxy7NniHRTV2xhgMZYZ+3IlKq3pRt9TYSO7o6
	 XBiVclPHZcTNKK22Ul/sxh7oXkUkm3UAGTMApjuoRMo2+qAp/egDH40ao4Nd8azVssFVP
	 hYHfycP4FDjXN6xrWoAgzjAXl2gzIj8PeFzD/nPuf2LnYGiMGz6ivLybohISy8augXlbZ
	 xYKUqH6q57/WLbSCYwtzQ+yXyKGWjEq+/Igt0wXgXT/FTQdfDsBE2jyvscgS6XYPDbdNc
	 sUi/MzWjOSgoe7NTuj6zCf+MM3x10GZzBj1U+kYMrqlM6kqW8eHcTWtd1c6oxiTRxkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uC/wpDIVqaZlYkFT94VM/XD9y9C0g8Y0Hvoah0XD11c=;
	b=IZ/qid2M5VglhNpbq/BMAIkOjFOHPETa6DvInQpi8wYqgYY+limWzrPLZretEIZVUAr5
	 +Km33LvFqUl/CoFqfH8Vgt1kC0E7/J5OhsjP5bA6iELO607rok+P+X88JoHed5mpgUGJP
	 geFWuDU/dyun3c0fYPVU/PlXjSqlqqYlHKAyi626RZPxb1vOXFnrS6E32/uWJFATom3O+
	 T5ybeUKDTV65JBnUGN19zmj+MypL/CGVy1peVTVGKKNdL6PigNCDDoKPoe035LP/bjYkm
	 RSt2thxOhDS1Mt5cOnuqpO+vMw/E1pv4E5oYeZA0s7+MOG3K1RsVSWfMCfO1OKCJBwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmMQQ1y8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B858E606A862;
	Wed,  4 Nov 2026 21:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmMQQ1y8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FCE1F000C1;
	Wed,  4 Nov 2026 21:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829443;
	bh=uC/wpDIVqaZlYkFT94VM/XD9y9C0g8Y0Hvoah0XD11c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmMQQ1y8HtHxzCwRwxFSnAE98DLsgwUdLzNhJ36529c15Bzv5IAXTp+KDeKi/HSDv
	 OQdjeR3irCFc9ahrG6UvN/76nFP9xLXW5nPqaCIiWp7TTNDyQAl/yYfDUKCm8hB12U
	 Oj/iKLoreccMH6vbAlrbQcxD7DEROSaI4w1kF/GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0129/1005] usb: fsl_qe_udc: check qe_alloc_request() failure in ch9getstatus()
Date: Wed,  4 Nov 2026 15:57:42 -0500
Message-ID: <20261104211047.297754205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index aacfde06387c0..7911dca2135cf 100644
--- a/drivers/usb/gadget/udc/fsl_qe_udc.c
+++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
@@ -1945,6 +1945,7 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
 			u16 index, u16 length)
 {
 	u16 usb_status = 0;
+	struct usb_request *usb_req;
 	struct qe_req *req;
 	struct qe_ep *ep;
 	int status = 0;
@@ -1983,8 +1984,11 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
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



