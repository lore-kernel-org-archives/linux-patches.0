Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622271;
	b=aieu66ncyllDMahBG6PB2EAspb2d8DsyC9iDc68GxuhsGiaLLP3373iYyKW9NCjN1+AU
	 R2iL3zA3IfakHGBGqigIS9RUCmEAzVLc6EYpN+mNwSgbfr/l6gq1UWj16LC1HBT+TbSeN
	 12OVA6bVs29vT5i8wbvsYugdDBTp+ozuGI2i8nNn/7VWJg9YnH8ckN4KSryWJuennI52P
	 lH/k6u3CrhNQk3USEz/SeOGU8BzkEqfzUrQ/61YUAs4zWIa01ol9VtDEetpxYrjFVs/XQ
	 7nq4Rgkg6HmyQ1jEH3b+U9GQNUzEGrJIV5S+n1/Rm3ZNxVsVA4FVpTgHb4B6vPlOSrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jFKt711PZdN5XXrLEFInpa6vux01ySkV006/D6+KkSY=;
	b=hl5r4YO0tOI2G3cfWDboJcKGurLZxU/mBusfCuqlZuyMQZZnQmyrNiL3JL/hyu3bgru9
	 7fa7UNYB8noxqLrleLY5hkkbuw8kxChlQ3aM5RPF+Xh7Hi0VlUeDWXKlh8kZxEFn2Q+2w
	 qGUbZhf+vthZRifsLh17PJUdjbwoY9c80QtDyTE4L3BUKzytsqD/HGhttM1coQQe2PYTp
	 W5vxoaKepfu4nw/EMJO3WwcpdQOR5UBXd6GOmHy8+vwwzpaglvUovJ8KPDHigfY8k3GRe
	 GnZyox9TiB5XusZ0V85UngrolqIwOIiMPMdmLiihwMJQGS4xTb3EVaoUKcVqMcjbnPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ysu5me/R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70962606A31E;
	Wed, 25 Nov 2026 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysu5me/R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FEC1F000C4;
	Wed, 25 Nov 2026 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622271;
	bh=jFKt711PZdN5XXrLEFInpa6vux01ySkV006/D6+KkSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysu5me/RFx9WmErr9/vQwUeqarlURj0zHx35cbTiHwIgkttAOAa3lGzmpuQAhg5pi
	 EGISU6la9zrKGtU3JlRGpQCLsJKw5LDaUMrBYdjcSNOTunGROgnNTzbIMMW5pEjrhm
	 +uBElPE71yJe/D3CARYYqWyolzGG5VyshMCYX4Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 483/990] s390/zcrypt: Make apfs a real unsigned int field
Date: Wed, 25 Nov 2026 15:30:50 +0100
Message-ID: <20261125143833.409186278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit ecd2fd113e89978ca750a81dea033a2e9f3347df ]

Slight rework on the apfs field: Instead of unsigned char[4]
make this a real 32 bit unsigned int field. With that done,
some assignments and some printouts can be simplified.
With that comes a slight move of the anonymous struct covering
the message type 86 header to dedupe some code lines.

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: 5e9b339f3232 ("s390/zcrypt: Fix and improve zcrypt reply message verification checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_error.h    | 28 ++++++++++-----------------
 drivers/s390/crypto/zcrypt_msgtype6.c |  2 +-
 drivers/s390/crypto/zcrypt_msgtype6.h |  4 ++--
 3 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_error.h b/drivers/s390/crypto/zcrypt_error.h
index 46e27b43a8afe..fd10302e68d36 100644
--- a/drivers/s390/crypto/zcrypt_error.h
+++ b/drivers/s390/crypto/zcrypt_error.h
@@ -78,9 +78,13 @@ struct error_hdr {
 static inline int convert_error(struct zcrypt_queue *zq,
 				struct ap_message *reply)
 {
-	struct error_hdr *ehdr = reply->msg;
-	int card = AP_QID_CARD(zq->queue->qid);
 	int queue = AP_QID_QUEUE(zq->queue->qid);
+	int card = AP_QID_CARD(zq->queue->qid);
+	struct error_hdr *ehdr = reply->msg;
+	struct {
+		struct type86_hdr hdr;
+		struct type86_fmt2_ext fmt2;
+	} __packed * t86hdr = reply->msg;
 
 	switch (ehdr->reply_code) {
 	case REP82_ERROR_INVALID_MSG_LEN:	 /* 0x23 */
@@ -100,19 +104,12 @@ static inline int convert_error(struct zcrypt_queue *zq,
 		/* RY indicates malformed request */
 		if (ehdr->reply_code == REP82_ERROR_FILTERED_BY_HYPERVISOR &&
 		    ehdr->type == TYPE86_RSP_CODE) {
-			struct {
-				struct type86_hdr hdr;
-				struct type86_fmt2_ext fmt2;
-			} __packed * head = reply->msg;
-			unsigned int apfs = *((u32 *)head->fmt2.apfs);
-
 			ZCRYPT_DBF_WARN("%s dev=%02x.%04x RY=0x%02x apfs=0x%x => rc=EINVAL\n",
 					__func__, card, queue,
-					ehdr->reply_code, apfs);
+					ehdr->reply_code, t86hdr->fmt2.apfs);
 		} else {
 			ZCRYPT_DBF_WARN("%s dev=%02x.%04x RY=0x%02x => rc=EINVAL\n",
-					__func__, card, queue,
-					ehdr->reply_code);
+					__func__, card, queue, ehdr->reply_code);
 		}
 		return -EINVAL;
 	case REP82_ERROR_MACHINE_FAILURE:	 /* 0x10 */
@@ -125,15 +122,10 @@ static inline int convert_error(struct zcrypt_queue *zq,
 		/* For type 86 response show the apfs value (failure reason) */
 		if (ehdr->reply_code == REP82_ERROR_TRANSPORT_FAIL &&
 		    ehdr->type == TYPE86_RSP_CODE) {
-			struct {
-				struct type86_hdr hdr;
-				struct type86_fmt2_ext fmt2;
-			} __packed * head = reply->msg;
-			unsigned int apfs = *((u32 *)head->fmt2.apfs);
-
 			ZCRYPT_DBF_WARN(
 				"%s dev=%02x.%04x RY=0x%02x apfs=0x%x => bus rescan, rc=EAGAIN\n",
-				__func__, card, queue, ehdr->reply_code, apfs);
+				__func__, card, queue, ehdr->reply_code,
+				t86hdr->fmt2.apfs);
 		} else {
 			ZCRYPT_DBF_WARN("%s dev=%02x.%04x RY=0x%02x => bus rescan, rc=EAGAIN\n",
 					__func__, card, queue,
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index f0ad39a33fb03..0073bfa369e93 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -829,7 +829,7 @@ static int convert_response_xcrb(bool userspace, struct zcrypt_queue *zq,
 		return convert_error(zq, reply);
 	case TYPE86_RSP_CODE:
 		if (msg->hdr.reply_code) {
-			memcpy(&xcrb->status, msg->fmt2.apfs, sizeof(u32));
+			xcrb->status = msg->fmt2.apfs;
 			return convert_error(zq, reply);
 		}
 		if (msg->cprbx.cprb_ver_id == 0x02)
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.h b/drivers/s390/crypto/zcrypt_msgtype6.h
index 9cbe6e2b2d33c..8cc227df55c88 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.h
+++ b/drivers/s390/crypto/zcrypt_msgtype6.h
@@ -34,7 +34,7 @@ struct type6_hdr {
 	unsigned char right[4];		/* 0x00000000			*/
 	unsigned char reserved3[2];	/* 0x0000			*/
 	unsigned char reserved4[2];	/* 0x0000			*/
-	unsigned char apfs[4];		/* 0x00000000			*/
+	unsigned int  apfs;		/* 0x00000000			*/
 	unsigned int  offset1;		/* 0x00000058 (offset to CPRB)	*/
 	unsigned int  offset2;		/* 0x00000000			*/
 	unsigned int  offset3;		/* 0x00000000			*/
@@ -83,7 +83,7 @@ struct type86_hdr {
 
 struct type86_fmt2_ext {
 	unsigned char	  reserved[4];	/* 0x00000000			*/
-	unsigned char	  apfs[4];	/* final status			*/
+	unsigned int	  apfs;		/* final status			*/
 	unsigned int	  count1;	/* length of CPRB + parameters	*/
 	unsigned int	  offset1;	/* offset to CPRB		*/
 	unsigned int	  count2;	/* 0x00000000			*/
-- 
2.53.0



