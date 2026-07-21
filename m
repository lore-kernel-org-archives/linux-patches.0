Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5251433BAC;
	Tue, 21 Jul 2026 19:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663947; cv=none; b=kN03RVPcTQ2pW+GUDdLSwaqg/WIvaIuMdj8zZ+6NGNb/4NMnTEGbnSaLwxWUAE/q3+1yJcmiKD92oaNbThAMOQ6Rmj92CRPJLy1VXv6cC7DOmJQQAyf6xqbdodZHn43JWHzacrdpSWGkPKSgE/cpDA9CQxaP4q6Hlgbwbzvcbro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663947; c=relaxed/simple;
	bh=H73aS8NQGNeSiw1rvDrkkewJnukKHzMFQPX1qFj/Q+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adWE6009XBUp5XsBK8NtvEGQgP2dxA0gY8lXN4EeASry/RgI4CRYAstTq8r6qt4AGSun9a8PdCIqSz6O8Lzij6g5yWH6K1lyNXmiJGCKGMdhC1iK2ctlJItPhr2U8NGdHY71PJvFjPq2jxR7z6OaCNDt8erI8eovLWavjqCxKEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcPcCFEE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcPcCFEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0CC1F000E9;
	Tue, 21 Jul 2026 19:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663945;
	bh=vuwTjT0hZ6CltaXFFw1G1Etjy7MqqdZrJQlNechFvmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RcPcCFEEmEgSEwcuiphwhRMVjtUQKJde1wJhFLGxlHjqOlSX/Q5fsyfO5Fn0tgCh/
	 yz06cRxoT+Ggcw8mofvSYDZMoIiopCpYzk0VKz+QOHL5gvPU6/+R1vtROKd8t0T7Qw
	 jTvwJ4tHBRddrgGili/SIyJFJUdi/ldGsIjy3Res=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	stable@kernel.org
Subject: [PATCH 6.12 0972/1276] pkey: Move keytype check from pkey api to handler
Date: Tue, 21 Jul 2026 17:23:35 +0200
Message-ID: <20260721152507.770857568@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Holger Dengler <dengler@linux.ibm.com>

commit 754e9e49b76fd5be339172aa98544182ed3ca75e upstream.

The PKEY_VERIFYPROTK ioctl takes data from user-space and verifies the
contained protected key. While checking the integrity of the ioctl
request structure is the responsibility of the generic pkey_api code,
the verification of the contained protected key is the responsibility
of the pkey handler.

The keytype verification (based on the calculated bitsize of the key)
is part of the protected key verification and therefore the
responsibility of the pkey handler (which already verifies
it). Therefore the keytype verification is removed from the generic
pkey_api code.

As the calculation of the key bitsize is currently wrong, the removal
of the keytype check in pkey_api also removes this wrong
calculation. For this reason, the commit is flagged with the Fixes:
tag.

Cc: stable@kernel.org # 6.12+
Fixes: 8fcc231ce3be ("s390/pkey: Introduce pkey base with handler registry and handler modules")
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/pkey_api.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -325,7 +325,6 @@ static int pkey_ioctl_verifyprotk(struct
 {
 	struct pkey_verifyprotk kvp;
 	struct protaeskeytoken *t;
-	u32 keytype;
 	u8 *tmpbuf;
 	int rc;
 
@@ -339,14 +338,6 @@ static int pkey_ioctl_verifyprotk(struct
 		return -EINVAL;
 	}
 
-	keytype = pkey_aes_bitsize_to_keytype(8 * kvp.protkey.len);
-	if (!keytype) {
-		PKEY_DBF_ERR("%s unknown/unsupported protkey length %u\n",
-			     __func__, kvp.protkey.len);
-		memzero_explicit(&kvp, sizeof(kvp));
-		return -EINVAL;
-	}
-
 	/* build a 'protected key token' from the raw protected key */
 	tmpbuf = kzalloc(sizeof(*t), GFP_KERNEL);
 	if (!tmpbuf) {
@@ -356,7 +347,7 @@ static int pkey_ioctl_verifyprotk(struct
 	t = (struct protaeskeytoken *)tmpbuf;
 	t->type = TOKTYPE_NON_CCA;
 	t->version = TOKVER_PROTECTED_KEY;
-	t->keytype = keytype;
+	t->keytype = kvp.protkey.type;
 	t->len = kvp.protkey.len;
 	memcpy(t->protkey, kvp.protkey.protkey, kvp.protkey.len);
 


