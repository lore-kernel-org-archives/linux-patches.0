Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213799;
	b=DOA0BTR3birhbBz6qFSW/iilJfR2hgIXMBL4fPOBo+4fNjv0xcY0WPkWzlMzBknXtPFk
	 wl5I2cVpPLH6xvxQiztpfFsgXz+Fr9coVNyrVCWP6bY4br4KmyunVu8XhYIOJ4k++92/d
	 WBniatyGhMGJkDPXIF7uMLrJu5SqJd5bFLYyUHlwBfCRoOLmY+aapGozKTIAD6BHRBo/n
	 k/4pujEfjR/ZOzx2vkddPmjnREs0h9Gwnf1uXsy5An6qIf+0aKd42l6Or0W6PdCbzQYPO
	 w5HonzxLpbGbwWpjAj9zRY8/+Yaet9JL36taaGVLHpax2jfyS+uMBTKyjqudOy8cvPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DwV4V9CPPBs9VaRmvHQnoKAZJujOobsX+qMxCnG566A=;
	b=We7OO8mAXuYXyd3iybswviQchrb0TtHd1rjtBFpmUzfxz9/OvUnmQRknaeDxd1X/oxRO
	 Nm2QL6YVIXUjh/gS7GlS8K8x7S4Z8gPaA2CWH+KGgNtN+gyjQ66pqxIrbzipMtBCuNltK
	 V8/3yz+cMvmu3ga4fckKOw/QkqhjOtBJVOL4Bn4bcvzD7ZfLJSsQCEh5xsaCwYsEfMTF/
	 VRQgi5oeFg7Wu9VsPQu8FWGOfDXbninoL8tI3wZdtKRh1MQv9wjPn+M/NNU/ongzkn83W
	 qDm1U31keYLV2TGm05Zt+VFwv18Z3pU9acY4TVltpxXKlvqy8+Fdgcow2ohsxrjMEbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cp7wPHvL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88EB606A320;
	Wed, 28 Oct 2026 18:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cp7wPHvL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD3A1F01825;
	Wed, 28 Oct 2026 18:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213798;
	bh=DwV4V9CPPBs9VaRmvHQnoKAZJujOobsX+qMxCnG566A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cp7wPHvLp6EzJ1MZe1N/9JV1wx3U0vZ3iOi/nuiB1oFG9eMoHyjcaUMNw8wJZaHMX
	 ty0e6UVBG5NiWi4sD59Pref9vNCbRQhas0gaTUHvAf5XW0wXsshLHKlPlo9jhyBRQJ
	 fcG4vfCaCboSldnjjNklT9bXxc54VgBf9PuRo50Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0634/1887] s390/pkey: Wipe copies of protected- and secure-keys
Date: Wed, 28 Oct 2026 17:45:30 +0100
Message-ID: <20261028170513.836385626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Holger Dengler <dengler@linux.ibm.com>

[ Upstream commit f2ebdadd85af4f4d0cae1e5d009c70eccc78c207 ]

Although the clear-key of neither protected- nor secure-keys is
accessible, this key material should only be visible to the calling
process. So wipe all copies of protected- or secure-keys from stack,
even in case of an error.

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 80 ++++++++++++++++------------------
 1 file changed, 37 insertions(+), 43 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 6a94f4965a2d5..f1686f172fbf5 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -1173,10 +1173,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = cca_genseckey(kgs.cardnr, kgs.domain,
 				   kgs.keytype, kgs.seckey.seckey);
 		DEBUG_DBG("%s cca_genseckey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(ugs, &kgs, sizeof(kgs)))
-			return -EFAULT;
+		if (!rc && copy_to_user(ugs, &kgs, sizeof(kgs)))
+			rc = -EFAULT;
+		memzero_explicit(&kgs, sizeof(kgs));
 		break;
 	}
 	case PKEY_CLR2SECK: {
@@ -1205,10 +1204,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 				     ksp.seckey.seckey, ksp.protkey.protkey,
 				     &ksp.protkey.len, &ksp.protkey.type);
 		DEBUG_DBG("%s cca_sec2protkey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(usp, &ksp, sizeof(ksp)))
-			return -EFAULT;
+		if (!rc && copy_to_user(usp, &ksp, sizeof(ksp)))
+			rc = -EFAULT;
+		memzero_explicit(&ksp, sizeof(ksp));
 		break;
 	}
 	case PKEY_CLR2PROTK: {
@@ -1250,10 +1248,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 			return -EFAULT;
 		rc = pkey_skey2pkey(ksp.seckey.seckey, &ksp.protkey);
 		DEBUG_DBG("%s pkey_skey2pkey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(usp, &ksp, sizeof(ksp)))
-			return -EFAULT;
+		if (!rc && copy_to_user(usp, &ksp, sizeof(ksp)))
+			rc = -EFAULT;
+		memzero_explicit(&ksp, sizeof(ksp));
 		break;
 	}
 	case PKEY_VERIFYKEY: {
@@ -1265,10 +1262,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_verifykey(&kvk.seckey, &kvk.cardnr, &kvk.domain,
 				    &kvk.keysize, &kvk.attributes);
 		DEBUG_DBG("%s pkey_verifykey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(uvk, &kvk, sizeof(kvk)))
-			return -EFAULT;
+		if (!rc && copy_to_user(uvk, &kvk, sizeof(kvk)))
+			rc = -EFAULT;
+		memzero_explicit(&kvk, sizeof(kvk));
 		break;
 	}
 	case PKEY_GENPROTK: {
@@ -1279,10 +1275,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 			return -EFAULT;
 		rc = pkey_genprotkey(kgp.keytype, &kgp.protkey);
 		DEBUG_DBG("%s pkey_genprotkey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(ugp, &kgp, sizeof(kgp)))
-			return -EFAULT;
+		if (!rc && copy_to_user(ugp, &kgp, sizeof(kgp)))
+			rc = -EFAULT;
+		memzero_explicit(&kgp, sizeof(kgp));
 		break;
 	}
 	case PKEY_VERIFYPROTK: {
@@ -1293,6 +1288,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 			return -EFAULT;
 		rc = pkey_verifyprotkey(&kvp.protkey);
 		DEBUG_DBG("%s pkey_verifyprotkey()=%d\n", __func__, rc);
+		memzero_explicit(&kvp, sizeof(kvp));
 		break;
 	}
 	case PKEY_KBLOB2PROTK: {
@@ -1309,10 +1305,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		DEBUG_DBG("%s pkey_keyblob2pkey()=%d\n", __func__, rc);
 		memzero_explicit(kkey, ktp.keylen);
 		kfree(kkey);
-		if (rc)
-			break;
-		if (copy_to_user(utp, &ktp, sizeof(ktp)))
-			return -EFAULT;
+		if (!rc && copy_to_user(utp, &ktp, sizeof(ktp)))
+			rc = -EFAULT;
+		memzero_explicit(&ktp, sizeof(ktp));
 		break;
 	}
 	case PKEY_GENSECK2: {
@@ -1338,23 +1333,23 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		DEBUG_DBG("%s pkey_genseckey2()=%d\n", __func__, rc);
 		kfree(apqns);
 		if (rc) {
-			kfree(kkey);
+			kfree_sensitive(kkey);
 			break;
 		}
 		if (kgs.key) {
 			if (kgs.keylen < klen) {
-				kfree(kkey);
+				kfree_sensitive(kkey);
 				return -EINVAL;
 			}
 			if (copy_to_user(kgs.key, kkey, klen)) {
-				kfree(kkey);
+				kfree_sensitive(kkey);
 				return -EFAULT;
 			}
 		}
 		kgs.keylen = klen;
 		if (copy_to_user(ugs, &kgs, sizeof(kgs)))
 			rc = -EFAULT;
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		break;
 	}
 	case PKEY_CLR2SECK2: {
@@ -1380,16 +1375,16 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		DEBUG_DBG("%s pkey_clr2seckey2()=%d\n", __func__, rc);
 		kfree(apqns);
 		if (rc) {
-			kfree(kkey);
+			kfree_sensitive(kkey);
 			break;
 		}
 		if (kcs.key) {
 			if (kcs.keylen < klen) {
-				kfree(kkey);
+				kfree_sensitive(kkey);
 				return -EINVAL;
 			}
 			if (copy_to_user(kcs.key, kkey, klen)) {
-				kfree(kkey);
+				kfree_sensitive(kkey);
 				return -EFAULT;
 			}
 		}
@@ -1397,7 +1392,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		if (copy_to_user(ucs, &kcs, sizeof(kcs)))
 			rc = -EFAULT;
 		memzero_explicit(&kcs, sizeof(kcs));
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		break;
 	}
 	case PKEY_VERIFYKEY2: {
@@ -1414,7 +1409,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 				     &kvk.cardnr, &kvk.domain,
 				     &kvk.type, &kvk.size, &kvk.flags);
 		DEBUG_DBG("%s pkey_verifykey2()=%d\n", __func__, rc);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (rc)
 			break;
 		if (copy_to_user(uvk, &kvk, sizeof(kvk)))
@@ -1443,10 +1438,9 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		kfree(apqns);
 		memzero_explicit(kkey, ktp.keylen);
 		kfree(kkey);
-		if (rc)
-			break;
-		if (copy_to_user(utp, &ktp, sizeof(ktp)))
-			return -EFAULT;
+		if (!rc && copy_to_user(utp, &ktp, sizeof(ktp)))
+			rc = -EFAULT;
+		memzero_explicit(&ktp, sizeof(ktp));
 		break;
 	}
 	case PKEY_APQNS4K: {
@@ -1474,7 +1468,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_apqns4key(kkey, kak.keylen, kak.flags,
 				    apqns, &nr_apqns);
 		DEBUG_DBG("%s pkey_apqns4key()=%d\n", __func__, rc);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (rc && rc != -ENOSPC) {
 			kfree(apqns);
 			break;
@@ -1560,7 +1554,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		protkey = kmalloc(protkeylen, GFP_KERNEL);
 		if (!protkey) {
 			kfree(apqns);
-			kfree(kkey);
+			kfree_sensitive(kkey);
 			return -ENOMEM;
 		}
 		rc = pkey_keyblob2pkey3(apqns, ktp.apqn_entries, kkey,
@@ -1571,20 +1565,20 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		memzero_explicit(kkey, ktp.keylen);
 		kfree(kkey);
 		if (rc) {
-			kfree(protkey);
+			kfree_sensitive(protkey);
 			break;
 		}
 		if (ktp.pkey && ktp.pkeylen) {
 			if (protkeylen > ktp.pkeylen) {
-				kfree(protkey);
+				kfree_sensitive(protkey);
 				return -EINVAL;
 			}
 			if (copy_to_user(ktp.pkey, protkey, protkeylen)) {
-				kfree(protkey);
+				kfree_sensitive(protkey);
 				return -EFAULT;
 			}
 		}
-		kfree(protkey);
+		kfree_sensitive(protkey);
 		ktp.pkeylen = protkeylen;
 		if (copy_to_user(utp, &ktp, sizeof(ktp)))
 			return -EFAULT;
-- 
2.53.0



