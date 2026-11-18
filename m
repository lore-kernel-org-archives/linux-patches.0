Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051039;
	b=vwKz6gXofwcuwQbuEMalQcdi0Yl7Jzf1UofAUHq17TZWIzk35oqqQBH2qb/eez4YLOS/
	 Pt8W74TPSjAOQ+n3Kg01i80o6QsfNmwoTe54JLGajt7nTbs6Oys8J+jrBiS5JyD9AVHg9
	 AdUSR+GjjVu4JZGX6QPTeedYQh+MnUHaEHUdt5oQ74OzOl24qHywCruNjn4WiiqINp0uF
	 Iqg5RDbVFat7fnJVfn8Eh5Npxgn5hv++PQHCnlHFca6lcDYS+XTiDRQvPuPXX/kqdqz2G
	 RaRTofLBd4aQQhc0vbPrbomqhtw8GYDcDtrPU3QEpbBKdq4OkUQwfD8JbOkp47eQYEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dDJ9iYxvn6rW4tPAGxAUopAC5OIJKbXb8lw2+qlcayk=;
	b=xGrrbGxHlXul/IRkTTLmPvJBIvbU7KIZ8MA53M424IllW0zqFVjZdDLL6nB6RBxGNqUY
	 hvdEFOKMnsFe9OIWxzyMHXcfiaQ1uvDXTa4bmEOjBe6G0B1Q8XS6IhgGxNTk7mAKarWQY
	 V1NnPJlAv16DPxaJzzd+wPLBfLn2YnTesS4zKFJucbhU88chU0zA8a74AC1/MH3EgKAhg
	 o89l7qva6ico21pUBNhizu2Oqvkmn3VVXjYcZRWc4nEg1T7v8MOi1W6ilp52aJHFI9PUv
	 pBobv70FkTnbmfP27con8Opinc7huwknoyPMzd0DHrzYonN9DArKVCMxwsyfNXHud4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ArC9W8Ob;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B7C606A32A;
	Thu, 19 Nov 2026 01:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ArC9W8Ob
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20A81F000C4;
	Thu, 19 Nov 2026 01:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051039;
	bh=dDJ9iYxvn6rW4tPAGxAUopAC5OIJKbXb8lw2+qlcayk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArC9W8ObmG1ufg1mj7lJlejOlYV/kGPrggdOAMVDAZbVyVMU1ybxJl/qNngTFv31T
	 ODvx1fKbfVimsBFFDgABwcXfkpdzGjUAG67Yo4XA/+70FKKOnBPC0QLY/MPh2Ds33/
	 8d6LR52AHL77sa0jjGv4XwLBUG1T+lS2BwMbRttA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0067/2214] usb: fsl_qe_udc: check qe_alloc_request() failure in ch9getstatus()
Date: Wed, 18 Nov 2026 15:29:03 +0100
Message-ID: <20261118150012.686141832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8bf767a80dd42..6c1402890ff9b 100644
--- a/drivers/usb/gadget/udc/fsl_qe_udc.c
+++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
@@ -1941,6 +1941,7 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
 			u16 index, u16 length)
 {
 	u16 usb_status = 0;
+	struct usb_request *usb_req;
 	struct qe_req *req;
 	struct qe_ep *ep;
 	int status = 0;
@@ -1981,8 +1982,11 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
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



