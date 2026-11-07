Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060677;
	b=5ZvCzwjwU47mAIOwHxz/37PaxDPakxg8aoYFktulfUC3GRQrn2kqMI4+EeoJquF6seGo
	 9VIRjsLFIYb54JN1e6gI3lBykIYGQtng5edtnsJ9tcYJCCi3WEJHrr4PKMQsh50hvS/Kx
	 w3xSc4X2S/0Ljy9gQrPkD9OtHrv5zylJybxRaV9sRlmFAUT/yFWpwt2O/jSD5+exfUPO5
	 Xc6KPcnLEWzBaFVeEQgFOlM1vvbwDD9FDSZUbsY4yNrX+ZHISVpP5yRqyBvixM8KuDxYz
	 DQ50J1og3nIV/pByItGkxVONARbpoFRMYN5zEKcM/WCvZbNG2JWYRZR8+sixJJPmwdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tQ+YWF4mawam4DjHkdSqsYSTAjYyAS0DJnOMvXdzxaY=;
	b=0qsRRK/yWRJSrcWEyQN/j8/K1TW7hd1IpsR9uKo/fbO2/tbw4tGDIGDnMIqxpC0P60XF
	 FBNbRr2dmh2fbUsqJ0giaN1cizZvhaAvlRVxSsGo+zRH3OqDV8n05cGv4lJoc2RoM+WEU
	 F1/M8hP2yyaYbJ8V2EnRfre8caFUKIYFXbtPsPKkrHlQ1TJJS8rbFIrA2BntIyCLjg72c
	 HVaDxE7WkwI98xog2y0h/HGOg24OJFfm0wcTxqhRSERmH4JN+lQWyU73hYrj59iofTKx9
	 068w9kXz4siRZ9aoXNQSIkDPzuobGy3D8zA+9nO8Im21C/nymBXidjIYKB92Q/FCNVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+RZy8km;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0412606A330;
	Sat,  7 Nov 2026 14:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+RZy8km
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7263B1F0089F;
	Sat,  7 Nov 2026 14:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060676;
	bh=tQ+YWF4mawam4DjHkdSqsYSTAjYyAS0DJnOMvXdzxaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+RZy8kmX4V5IQDGy8wsPcXb9nXK34OrCmkFyZ8gEB36lpOPrZWdgQzot5YDmVaqO
	 0tR8adaHYzx0L9YoW1GomwOjlpZFpTz4eC0Q55ZrQ1GKno21qc7UpWJaCKGF8N1Gn/
	 g+ZUsnXGIbkGHXZtpzHlIOtUz+3zE0wVrQtUN1Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0110/1536] usb: fsl_qe_udc: check qe_alloc_request() failure in ch9getstatus()
Date: Sat,  7 Nov 2026 08:35:26 -0500
Message-ID: <20261107135000.764588428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 4e88681a79b63..45c0b04675727 100644
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



