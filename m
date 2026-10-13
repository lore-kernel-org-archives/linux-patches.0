Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892F93E0C67;
	Tue, 13 Oct 2026 12:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893714; cv=none; b=EsRyBSdBvAA8u4ltvGteFOwz2jFfulrogCJxXLEgYOfxPSRICUqjlTDKqAqt2CM/47H2MCtfw4oQ8ye2SZiS/AputJ2fUwTHtE8uvx8X1kPgxeSF5qk8aMPdPVV83KoGtgDbQX1lRzKMMLnvLiT4oq7DaLvB3AbJa7XLLTLSAEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893714; c=relaxed/simple;
	bh=XOPRKbqkhf0uU8s9aT5jl50syKXFUGeLorCa6ZvafmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptjm/nWCcoakltEim6GNcZpDA3J/LPe9lCj4n+oIlVrJ+Az4pogGbNM2ktzIfD97Dw6Apw+N9PiPSfA1Wu+nMblqL/A+Y4zakpbwHQswgkQgkMTA2OtWN/SOJCZqYLsK05NcOX2Z4sJsSGUaSg2F8LFPf7CMFyb/2MTLD7x66U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li4ZSNHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li4ZSNHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B8F1F000FF;
	Tue, 13 Oct 2026 12:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893713;
	bh=G7XmyFu110DJP05HOCTVFNt2bdcHET73+trs2LSUGLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=li4ZSNHcQtWv4yX6/PKB2bCFMCC7xP1MW76aOUTH4iVb6heBmH2bc3ROkxA+jhyrT
	 IxjxpRCAxhSwx0ItC3gj6ZOj23lilOaEhX81zqZuck2j8JFBVLMLts5XrHRBvJeg53
	 TUDg/LP3/6PBLO/zxdwQiVuu705S6cYl7HE3V8wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Anthony Krowiak <akrowiak@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 318/621] s390/zcrypt: Move inline function rng_type6cprb_msgx from header to code
Date: Tue, 13 Oct 2026 13:35:13 +0200
Message-ID: <20261013112928.400169878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 23a4757d6d699e602b358808359149d0e8be6db9 ]

Function rng_type6cprb_msgx() is only used once and thus no need
to provide it in header file any more. Move it at the place within
the code where it is used.

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: e935cd525af4 ("s390/zcrypt: Close speculative mem read possibility")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_msgtype6.c | 49 +++++++++++++++++++++++++++
 drivers/s390/crypto/zcrypt_msgtype6.h | 49 ---------------------------
 2 files changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index 5b9dce59db8b9..cbf9dc5c71cb7 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -1247,6 +1247,55 @@ static long zcrypt_msgtype6_send_ep11_cprb(bool userspace, struct zcrypt_queue *
 	return rc;
 }
 
+/**
+ * Prepare a type6 CPRB message for random number generation
+ *
+ * @ap_dev: AP device pointer
+ * @ap_msg: pointer to AP message
+ */
+static inline void rng_type6cprb_msgx(struct ap_message *ap_msg,
+				      unsigned int random_number_length,
+				      unsigned int *domain)
+{
+	struct {
+		struct type6_hdr hdr;
+		struct CPRBX cprbx;
+		char function_code[2];
+		short int rule_length;
+		char rule[8];
+		short int verb_length;
+		short int key_length;
+	} __packed * msg = ap_msg->msg;
+	static struct type6_hdr static_type6_hdrX = {
+		.type		= 0x06,
+		.offset1	= 0x00000058,
+		.agent_id	= {'C', 'A'},
+		.function_code	= {'R', 'L'},
+		.tocardlen1	= sizeof(*msg) - sizeof(msg->hdr),
+		.fromcardlen1	= sizeof(*msg) - sizeof(msg->hdr),
+	};
+	static struct CPRBX local_cprbx = {
+		.cprb_len	= 0x00dc,
+		.cprb_ver_id	= 0x02,
+		.func_id	= {0x54, 0x32},
+		.req_parml	= sizeof(*msg) - sizeof(msg->hdr) -
+				  sizeof(msg->cprbx),
+		.rpl_msgbl	= sizeof(*msg) - sizeof(msg->hdr),
+	};
+
+	msg->hdr = static_type6_hdrX;
+	msg->hdr.fromcardlen2 = random_number_length;
+	msg->cprbx = local_cprbx;
+	msg->cprbx.rpl_datal = random_number_length;
+	memcpy(msg->function_code, msg->hdr.function_code, 0x02);
+	msg->rule_length = 0x0a;
+	memcpy(msg->rule, "RANDOM  ", 8);
+	msg->verb_length = 0x02;
+	msg->key_length = 0x02;
+	ap_msg->len = sizeof(*msg);
+	*domain = (unsigned short)msg->cprbx.domain;
+}
+
 /*
  * Prepare a CEXXC get random request ap message.
  * This function assumes that ap_msg has been initialized with
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.h b/drivers/s390/crypto/zcrypt_msgtype6.h
index 6f5ced8d6cdae..9f7510019bc45 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.h
+++ b/drivers/s390/crypto/zcrypt_msgtype6.h
@@ -110,55 +110,6 @@ int prep_rng_ap_msg(struct ap_message *ap_msg,
 int speed_idx_cca(int);
 int speed_idx_ep11(int);
 
-/**
- * Prepare a type6 CPRB message for random number generation
- *
- * @ap_dev: AP device pointer
- * @ap_msg: pointer to AP message
- */
-static inline void rng_type6cprb_msgx(struct ap_message *ap_msg,
-				      unsigned int random_number_length,
-				      unsigned int *domain)
-{
-	struct {
-		struct type6_hdr hdr;
-		struct CPRBX cprbx;
-		char function_code[2];
-		short int rule_length;
-		char rule[8];
-		short int verb_length;
-		short int key_length;
-	} __packed * msg = ap_msg->msg;
-	static struct type6_hdr static_type6_hdrX = {
-		.type		= 0x06,
-		.offset1	= 0x00000058,
-		.agent_id	= {'C', 'A'},
-		.function_code	= {'R', 'L'},
-		.tocardlen1	= sizeof(*msg) - sizeof(msg->hdr),
-		.fromcardlen1	= sizeof(*msg) - sizeof(msg->hdr),
-	};
-	static struct CPRBX local_cprbx = {
-		.cprb_len	= 0x00dc,
-		.cprb_ver_id	= 0x02,
-		.func_id	= {0x54, 0x32},
-		.req_parml	= sizeof(*msg) - sizeof(msg->hdr) -
-				  sizeof(msg->cprbx),
-		.rpl_msgbl	= sizeof(*msg) - sizeof(msg->hdr),
-	};
-
-	msg->hdr = static_type6_hdrX;
-	msg->hdr.fromcardlen2 = random_number_length;
-	msg->cprbx = local_cprbx;
-	msg->cprbx.rpl_datal = random_number_length;
-	memcpy(msg->function_code, msg->hdr.function_code, 0x02);
-	msg->rule_length = 0x0a;
-	memcpy(msg->rule, "RANDOM  ", 8);
-	msg->verb_length = 0x02;
-	msg->key_length = 0x02;
-	ap_msg->len = sizeof(*msg);
-	*domain = (unsigned short)msg->cprbx.domain;
-}
-
 void zcrypt_msgtype6_init(void);
 void zcrypt_msgtype6_exit(void);
 
-- 
2.53.0



