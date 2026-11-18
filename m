Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057237;
	b=fTeJhI1H1jNtrbLzqWMEAMq1HmVnbsW5PurjXyGeSQGAggrq/6HRIlJww5fs5JOph0lf
	 PgFf6Z0RLFyzuSPmyUB6kMjK1GsL8w3hxg01qxxZhZkWRLchuQo86e2/O34FQeAn1lSuu
	 Q0RH2Oqfv5reJYJWAuhqYo5tgv5uMseIWjdKJ995MNLaFgCl8RLJx4HuACLtE7K1WI+V0
	 JBKgDqGEVucXr5MdDAu6Op0CnuqGqAuQwrj1Lxjtc1Dn0V5iuPvxJ+VW/8vxx3PmD5YCw
	 BSbhsb/0nOcyl64F46esKhVP4X1PCLOf8lLTTCJ9G6yUcI5GpwkNUfL21X8MKDdTdCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XDCF6oIvO6m1GFTQOXOj7k+Il46PXVqtfwxf/nhj5I0=;
	b=IBfWmgIFQz0blK46mcIk9bQ6T/kp5SFw3FOJMPeoRPQbKVUZ1aBMc+cL54uRAly1qiJn
	 +umk+opOvbqwso1SOP7l0C7I8HlVy+BRQ+4RiguyP6P7SeZLDsxJnPESvjUnK8tqBgj0v
	 ElpP+nQRGHcTg8tbjY9x+3VI5Hoee3NRG9Y7kfGYAC9T8lsUHgRORWnDjo41vKISHgurH
	 Y++n5/Nx4VwUZEMHxpBy5Lfa9oXR74Kd9yLEFnZ1p3la+dHPIVPVXl4XG4xOLMoXmbG8s
	 mEnpYFVPDfhD6pZm8MxfTmd808w7SRM+yuFLFu33q88XHSF8ud9kiFCAm1/0w66Z96g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m2wmJzKu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3545D606A31C;
	Thu, 19 Nov 2026 03:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m2wmJzKu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5551F000C5;
	Thu, 19 Nov 2026 03:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057236;
	bh=XDCF6oIvO6m1GFTQOXOj7k+Il46PXVqtfwxf/nhj5I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2wmJzKub0FtUZBGaCrpo8E6LsdQxRwfL56Vsx4N+NcOzAz1xdqOWXthJF/RnMOQy
	 P79AUAS8r5NLUHmRtz+Vll2QWgqygBZjQ+4wWYE3c4ktVUIYJ9TQVa5sBCqGaDiYw9
	 9HLc6T8HMK3jZln9q1uY0HM2G7gf3cy3OU7nZLtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0060/1848] usb: fsl_qe_udc: check qe_alloc_request() failure in ch9getstatus()
Date: Wed, 18 Nov 2026 15:34:58 +0100
Message-ID: <20261118145913.640358112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 618b0a38c8855..085071049aca8 100644
--- a/drivers/usb/gadget/udc/fsl_qe_udc.c
+++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
@@ -1935,6 +1935,7 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
 			u16 index, u16 length)
 {
 	u16 usb_status = 0;
+	struct usb_request *usb_req;
 	struct qe_req *req;
 	struct qe_ep *ep;
 	int status = 0;
@@ -1975,8 +1976,11 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
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



