Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3EC11C9A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC92C433C8;
	Mon, 28 Aug 2023 10:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218653;
	bh=7bsitJEjCSpuPdbMY0zb75R11LOSh2UTloGhiE9Mseg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKttQ6L7L92aGxBqILP7WxzHBQ0pjyRJPPd4VNoJJgW5QQGJsrMetfW/qBPJAQ7W7
	 7xxtzlTBbksMCMoqXV0p+La3WuxqX1Wb733eSQ9n9MwsO5t7E8kAIX227ykj6qjCl5
	 4X3Bq5IMCUh/ZXslLpwx682Fue1f4srGa/M/cLB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhe <yuzhe@nfschina.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/122] s390/zcrypt: remove unnecessary (void *) conversions
Date: Mon, 28 Aug 2023 12:12:13 +0200
Message-ID: <20230828101157.050831997@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhe <yuzhe@nfschina.com>

[ Upstream commit 72c2112ce9d72e6c40dd893f32187a3d34453113 ]

Pointer variables of void * type do not require type cast.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20230303052155.21072-1-yuzhe@nfschina.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: 4cfca532ddc3 ("s390/zcrypt: fix reply buffer calculations for CCA replies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_msgtype6.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index f99a9ef42116f..37c01aaa21a2b 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -926,8 +926,7 @@ static void zcrypt_msgtype6_receive(struct ap_queue *aq,
 		.type = TYPE82_RSP_CODE,
 		.reply_code = REP82_ERROR_MACHINE_FAILURE,
 	};
-	struct response_type *resp_type =
-		(struct response_type *)msg->private;
+	struct response_type *resp_type = msg->private;
 	struct type86x_reply *t86r;
 	int len;
 
@@ -982,8 +981,7 @@ static void zcrypt_msgtype6_receive_ep11(struct ap_queue *aq,
 		.type = TYPE82_RSP_CODE,
 		.reply_code = REP82_ERROR_MACHINE_FAILURE,
 	};
-	struct response_type *resp_type =
-		(struct response_type *)msg->private;
+	struct response_type *resp_type = msg->private;
 	struct type86_ep11_reply *t86r;
 	int len;
 
@@ -1157,7 +1155,7 @@ static long zcrypt_msgtype6_send_cprb(bool userspace, struct zcrypt_queue *zq,
 				      struct ap_message *ap_msg)
 {
 	int rc;
-	struct response_type *rtype = (struct response_type *)(ap_msg->private);
+	struct response_type *rtype = ap_msg->private;
 	struct {
 		struct type6_hdr hdr;
 		struct CPRBX cprbx;
@@ -1243,7 +1241,7 @@ static long zcrypt_msgtype6_send_ep11_cprb(bool userspace, struct zcrypt_queue *
 {
 	int rc;
 	unsigned int lfmt;
-	struct response_type *rtype = (struct response_type *)(ap_msg->private);
+	struct response_type *rtype = ap_msg->private;
 	struct {
 		struct type6_hdr hdr;
 		struct ep11_cprb cprbx;
@@ -1365,7 +1363,7 @@ static long zcrypt_msgtype6_rng(struct zcrypt_queue *zq,
 		short int verb_length;
 		short int key_length;
 	} __packed * msg = ap_msg->msg;
-	struct response_type *rtype = (struct response_type *)(ap_msg->private);
+	struct response_type *rtype = ap_msg->private;
 	int rc;
 
 	msg->cprbx.domain = AP_QID_QUEUE(zq->queue->qid);
-- 
2.40.1



