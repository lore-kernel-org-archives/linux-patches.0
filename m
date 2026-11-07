Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063610;
	b=C9DYySUp6n9notHLIIuUIqo20BjzjQ9lWQIB6+Pwp9MB1TXonRMYwVtKN1Umk/oFQSt6
	 3Q7KUMLa0iZl9IYbRt7XMFA5dPolFubjp5hNxlUje56bGbgQSzrAugB3Z8Pmj0rqoqjOq
	 0lBoOBR59aYVpL+sz6W8H7EzHiROKWcM561aY5GL8UHjw89wh91z9lpZQumxnJARQ+QMG
	 0gfpJo8IsR26LpKWSjZQaczmtlWQHEpd1TqqsNiakfn0gjwtV6ZYknL5pr3H/B9OW3QAt
	 ymGATj+3DxgSUCrtINn17tzOzDJl3StieZTY1bt5Rgd9onC3lqExo+IdOdjnKS5eoXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S3UNVcfLrkA/HOwttXSFIfiYLx/WsZ8RAzVk94xrYIE=;
	b=25w+z/YV9Qyb1Pw3rqJ/ea7kXmNOF9YKLVcM07dNCpiABezhQsGPrdIFcVGuQLMGKfpB
	 3P2iSzLETznG2bkgebx/EGCHf6pvF8mBs1n/qMBPkXrhP6no0/Cv/3W93LfJFo0ti58sI
	 s2AXLPePktjzBYA4x67Qr+xmI0RiAw81St6ZQ8FySQ4g7XMlzy1/2zUNzVaELmAzkgy89
	 jApYCE69usi6zLOn3qbzKfF8LuXw0PbPgvhhIKbkuijn3qEytVmbfkNYs13M7EABVkKTf
	 dpsqQhdP7dY56CMJgiYdAmTiD4izznGYa8Z2t+JtxwYN1vxLcEOsxsDHVmuWoMjpmWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3M+wB2A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462BA606EE87;
	Sat,  7 Nov 2026 15:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a3M+wB2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935E91F0089F;
	Sat,  7 Nov 2026 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063609;
	bh=S3UNVcfLrkA/HOwttXSFIfiYLx/WsZ8RAzVk94xrYIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3M+wB2Ak4QXZS4QgY5afPsl9eoUaCD98d5cxFSrZSvtJCAO5d/0rTEan9inWTJ+q
	 J1A3LqvYu3vHECxmADg2qTUw818tSqTcVrS0fQLYgLJfP9fZab4jGwGeHH1yaLMDV3
	 Uug0yszKUAr/X7icaAKi2ajjZP/mQ00NxaCvnLm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 732/869] scsi: ufs: bsg: Clear the reply buffer before use
Date: Sat,  7 Nov 2026 08:56:54 -0500
Message-ID: <20261107134917.588972313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 2e63ac76cc08ea376ba61fef52f7b7849e35024d ]

The reply buffer is allocated once per tag and reused. Requests that
complete with a positive status do not fill all of it, so user space
receives bytes from an earlier request on the same tag.

Clear the whole reply buffer on entry to ufs_bsg_request().

Fixes: 95e34bf930ea ("scsi: ufs-bsg: Add support for raw upiu in ufs_bsg_request()")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-3-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 237ade1f0cd83..0e0b08a3821c4 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -142,7 +142,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 	int ret;
 	bool rpmb = false;
 
-	bsg_reply->reply_payload_rcv_len = 0;
+	memset(job->reply, 0, job->reply_len);
 
 	ufshcd_rpm_get_sync(hba);
 
-- 
2.53.0



