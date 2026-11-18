Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033652;
	b=AiDCyZ9uHeMptfmdbvZG875S1AcUxSm2AzwFeTg3IrFV6BTkX61KH7S+otLZMzWj1XBu
	 7Xepa2OAc7rEfdHJatUEhp7rNr0x3Dv96bqToAhULhjStsFPWeX+bYaJKs1NFVXSs6VhW
	 cRvmBjTJiGmVz+6Jp/lJp+77Iuz2mS0HoAhlCsQdV96yNruwW45gSNnuFy/jAczA1Rgui
	 f30uaN7ZXWsGxNLaM/SsnYyvGVORnLFkt+YzkgYvqxblDU5jZMf0eZGqIYQUyJiHPTSW8
	 4B/6UkO3gP/mBUPLmw2Do0ljOCMvnPZT6mTakD67IUqOgEQc0ONCnC2ngQewid2eGcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YhpImrY7P+7bnjbTK4yVt4hDYNh2wPzKXj0Fkbl6t74=;
	b=tVivhVVtbKfmCDTQ4wh8S1efG/Kada0DUVb/uDDHg296BjOnvmRrLIYNEEeTXUYDaRBq
	 4IWQiTjomJ+5lpLrRB3kzDpqNg86JyweRM4UyIq7ygCpE1lhfCFx+qCI4z4DiIpdKPoNB
	 k+Q/6HokKg6kavBoMRSLQGI2LNV2NfH+RlMu5iUGkFbl8k6ZL9qV75VqGQYXR1lvG7Vng
	 XIBuTyTQ4Ly7ynWJLAC+qxBCy/4nd+RtzwPYoE3J8cpOoburSKVGl3Z6Ru1l/iEJoiHHV
	 Dly0cfgJ6UC8u0l6iRwGFfl4AvztqqlxRP9mw4VVY3hj8mlNeyyGwcT0o2mIXZ074Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="et/PDgWp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF104606A31C;
	Wed, 18 Nov 2026 20:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=et/PDgWp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118571F000C4;
	Wed, 18 Nov 2026 20:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033652;
	bh=YhpImrY7P+7bnjbTK4yVt4hDYNh2wPzKXj0Fkbl6t74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=et/PDgWptZnzBQbsM6UsLqa9iHnaHl748F/kMWnYdjtOsSN93GTWSFbtRGa5+WNeP
	 f/UgrK3kedLviKnzSzA/HzssD+fhpyxR03WVbYmqWRSvbY/fWgyflZlFrQG+gXbJOz
	 Y7UVJBoxqABoeGAaUG21mQKXR0cDyl5ppK0F4uN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0091/3318] usb: fsl_qe_udc: check qe_alloc_request() failure in ch9getstatus()
Date: Wed, 18 Nov 2026 15:11:53 +0100
Message-ID: <20261118150316.882385278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4aae86b47edfc..ab26eee45baa9 100644
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
@@ -1982,8 +1983,11 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
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



