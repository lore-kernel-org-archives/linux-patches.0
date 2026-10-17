Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADB04CF489;
	Sat, 17 Oct 2026 16:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254557; cv=none; b=Ja2sgWZrIPXUd34AwnC7mE1xrAHu6FnQsw/UJG3rSTVux8yIPv6Bt9UKtE1MYKIOmlI4SRBkDVe3x6yaOoHKH4/J3fbCwS/cxcRTdz0GNYrFbPQTiKqWluT5UjLotLgMZEiuzEfnFNMoYj4b0myrxip/2KYzU7MhAt5R3MJ8BZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254557; c=relaxed/simple;
	bh=nkQmOPtF6ZRiEfQ8vf2PJYyj0Iu2zh5Z4fCF9dbt/wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQ+kpSaREA3CLci7CEJ1hoyY0AJww7Zyfh1qPikIJB3ImXfRKbGphNPLW7qtCLJLqCeCo7zPK/FEe++YbwmxSJPK+mNXzGKvdQ5kzFmOpOdU8JRWb67YQyoteVPCXw1t2dOIqBKOxdzphSVZwZ2BnXRDh/WssndlMu7OBVLl5og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2jk65y3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2jk65y3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1406B1F000C4;
	Sat, 17 Oct 2026 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254555;
	bh=yUCPtGT/0d/4pZwCzJDqBjak31ILt4y/s/SRZabY9ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2jk65y33fTiwcUTbbizHgAtVNFFxcuyTAtgVk1D2bgveQrzCVlAAa5O8xWYNgNXI
	 yv377HmZfGrhtp0nZFNuMxUK2H9MPqgovKLeZVuqfnhiJhwH7Lxopr6/9oqQRqGf5g
	 C2v9ZKfLcqhE7F0MGQ/9gBLGbHk+GUQHluv+U3JU=
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
Subject: [PATCH 6.12 486/869] s390/zcrypt: Move inline function rng_type6cprb_msgx from header to code
Date: Sat, 17 Oct 2026 17:55:27 +0200
Message-ID: <20261017160049.578285502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9cefbb30960fd..f6adb8ba3f95c 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -1251,6 +1251,55 @@ static long zcrypt_msgtype6_send_ep11_cprb(bool userspace, struct zcrypt_queue *
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



