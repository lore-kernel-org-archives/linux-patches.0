Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622277;
	b=qS5kfpbLllcOZVgKRydevIqThvn9lL4G9YgtwkXL2Ht6raTIJXHWfNE4pE05o+zXOUlk
	 VAXIVcLccJRJ+NOFB2qYWAHJmBQKUMvaQfroRCH8CFMTTZwPCxwqJdppE/iWIh/k6nVt0
	 PU3NDw5iFYrPwQ8Erc2gkxZs0piZa9iRExYkw3ZlxAKieTRfAqzd5wc+ntDzqayHOdbkv
	 NrfTcGPSuzO9pwWTTVKxk6i1ZPbQtK/74f/qnToNcBr9ilYW86oBvsasUBbOcR72rrJod
	 xd4ppDHEXa2bc8LTqgxOv2529UZ1OtHd+xgtVhtBrH4Y9tQLIKH1y+uVGLnYE7m76wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LGVT6D45IfSZPqEbhZt+LMNkUmd+FHHH7hplLD4435c=;
	b=qdcyeUJymdB22PuGJAtdEZIBByed5be+DwtTpRvYcfCFZ1qwcRb1QEm3YPb9TBsauJdy
	 OZwwvlQSW3axPUZq/mH1jCsRAaVFHTjhMd9IIjCtFKwOdpQoPbwy0TGagKG2Zx7lcB/Vp
	 GQ1j0NyfblYY84dFpzmM1vbJT3b9iFhTgQ46sgnBiMvUmVDn909UroUZlaTQuB40EBCXO
	 A9jxRDDHZ6dfyPHUBTlpEJ8MdjlwgsoI08Ddx7VJFez2qOtFOKSEENiXNcXYPaF+4hXjk
	 GuQphThkTkyYmGnCyFFkLBNpzwvmsoSq61qantsM6EIYSHwaf+paAlySsxpqiO41r9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kaUShi1U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F686606A321;
	Wed, 25 Nov 2026 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kaUShi1U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03AC1F000C0;
	Wed, 25 Nov 2026 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622277;
	bh=LGVT6D45IfSZPqEbhZt+LMNkUmd+FHHH7hplLD4435c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kaUShi1UjvKjozPwVfho0hQe76sJrWxaJ1WsVeJ0aJp1zYmwad8DZ6OT392rcLUTC
	 YzQq6SVD6vsv0YznRAWkDvOoMWVS86xqD1oV3g8ThxMxkbZtZ3GmyUyjgmD+2LWSYV
	 LTHzBryYRvoLPVhYECVOxr8VJVrxqLVMyd12xGTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 485/990] s390/zcrypt: Explicitly use a card variable in _zcrypt_send_cprb
Date: Wed, 25 Nov 2026 15:30:52 +0100
Message-ID: <20261125143833.455781019@linuxfoundation.org>
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

[ Upstream commit 0e72b785b60e2a33f7bfe1c492f0717e7835b9a4 ]

Use an explicit variable "card" for the card addressing in
function _zcrypt_send_cprb instead of the confusing field
"user_defined" from the ica_xcRB struct. This makes the code
somewhat cleaner and easier to understand.

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: 7b88e8b6d714 ("s390/zcrypt: Guard domain index uses against speculative bypass")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_api.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index eff9ad7aa14ed..640a5b35081f6 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -854,7 +854,7 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
 			      struct ica_xcRB *xcrb)
 {
 	bool userspace = xflags & ZCRYPT_XFLAG_USERSPACE;
-	unsigned int domain, func_code = 0;
+	unsigned int card, domain, func_code = 0;
 	unsigned int wgt = 0, pref_wgt = 0;
 	struct zcrypt_queue *zq, *pref_zq;
 	struct zcrypt_card *zc, *pref_zc;
@@ -900,6 +900,7 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
 
 	pref_zc = NULL;
 	pref_zq = NULL;
+	card = xcrb->user_defined;
 	spin_lock(&zcrypt_list_lock);
 	for_each_zcrypt_card(zc) {
 		/* Check for usable CCA card */
@@ -907,8 +908,7 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
 		    !zc->card->hwinfo.cca)
 			continue;
 		/* Check for user selected CCA card */
-		if (xcrb->user_defined != AUTOSELECT &&
-		    xcrb->user_defined != zc->card->id)
+		if (card != AUTOSELECT && card != zc->card->id)
 			continue;
 		/* check if request size exceeds card max msg size */
 		if (ap_msg.len > zc->card->maxmsgsize)
@@ -952,7 +952,7 @@ static long _zcrypt_send_cprb(u32 xflags, struct ap_perms *perms,
 
 	if (!pref_zq) {
 		pr_debug("no match for address %02x.%04x => ENODEV\n",
-			 xcrb->user_defined, domain);
+			 card, domain);
 		rc = -ENODEV;
 		goto out;
 	}
-- 
2.53.0



