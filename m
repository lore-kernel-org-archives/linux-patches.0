Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213802;
	b=figWPOH2iLS/Io1Grl7usFlcuU0NuCrNR6rpJIVpUenlum9xdswIpglGY2iR99XiRp2H
	 ZlGOsLWm0q2xzJ2xd9XoiKaKhr5NMLA4t7Iwk3l9oOgYZao1FHNBIkVXXcRKb3f/RW5PK
	 vjadg1ni77R9mKx09edMopOZqdGpU9qbQpw/LKji6REBbzioPglGLSmFPXKDyZbzfzT4G
	 q+tZXvAHQ6Lywb0b6MG/Oyel6E4bCACoBi1tEG3GAxAIHORxtwNEhUVkMquJswSyusgML
	 fM03Q6lWSiIhuQ0LHJ/iW/jN2vOo9Tx0QbDCaevAwUO6xPS9e38hwsxKvzqRBkIi5Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ednnxBaCufW+lO8mupMsyCGKFmUwV2XhFYz/ARhH8hY=;
	b=VWc/CbU3QCy5m3ILMQCiOSbzXgXp4dthio5/XMtd/eW3qVXa7Yb60RG24PLITvqP1RL9
	 74ExvEPlm0m1RuI1iitYOTjGUBwDRV/v/o6h31tBgbbYTcLI7m+W/pkm+SspyvklYviWa
	 sw8CltJYMcz8E68lnESy+M/2dniWGS6cFiZMUbeNQn/qjySP8XcE6ONBA04AWYboZMVPp
	 YJfVvJlVR8jVfR/LwmKNmkzURWCFWvZOtgeJ4LP+TiqvTg+JNs495BG9yr6NrVkYLfhJD
	 UJy5ENKvNuiTGrY5YROcRuRoHWgoZ3K8xKLpbJjNFkr2WpBbXl9dy9WDbrOUK7KSwmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vDoVaPSQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AD5606A31E;
	Wed, 28 Oct 2026 18:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vDoVaPSQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0819A1F01825;
	Wed, 28 Oct 2026 18:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213801;
	bh=ednnxBaCufW+lO8mupMsyCGKFmUwV2XhFYz/ARhH8hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDoVaPSQzf8no1kpZsRalOEFSmqkYB8SKZDUmkmhumJtpuupZImqxtdXjHeCoLkWx
	 vg9bXePcmyto8VCayXx94PdHXxr+dGW+lDPsc28eHKMt51cBJ4WMS3PuACBk2I+FJi
	 HaIAudjhkE3mk+kps2MStq0C9WLVDYJvm2gaard4=
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
Subject: [PATCH 6.1 0635/1887] s390/pkey: Wipe copies of clear-key structures on failure
Date: Wed, 28 Oct 2026 17:45:31 +0100
Message-ID: <20261028170513.859632006@linuxfoundation.org>
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

[ Upstream commit d65d76a44ffe74c73298ada25b0f578680576073 ]

Wipe all sensitive data from stack for all IOCTLs, which convert a
clear-key into a protected- or secure-key.

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index f1686f172fbf5..96fcaa0b6ff90 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -1187,9 +1187,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = cca_clr2seckey(kcs.cardnr, kcs.domain, kcs.keytype,
 				    kcs.clrkey.clrkey, kcs.seckey.seckey);
 		DEBUG_DBG("%s cca_clr2seckey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(ucs, &kcs, sizeof(kcs)))
+		if (!rc && copy_to_user(ucs, &kcs, sizeof(kcs)))
 			rc = -EFAULT;
 		memzero_explicit(&kcs, sizeof(kcs));
 		break;
@@ -1218,9 +1216,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		rc = pkey_clr2protkey(kcp.keytype,
 				      &kcp.clrkey, &kcp.protkey);
 		DEBUG_DBG("%s pkey_clr2protkey()=%d\n", __func__, rc);
-		if (rc)
-			break;
-		if (copy_to_user(ucp, &kcp, sizeof(kcp)))
+		if (!rc && copy_to_user(ucp, &kcp, sizeof(kcp)))
 			rc = -EFAULT;
 		memzero_explicit(&kcp, sizeof(kcp));
 		break;
@@ -1362,11 +1358,14 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		if (copy_from_user(&kcs, ucs, sizeof(kcs)))
 			return -EFAULT;
 		apqns = _copy_apqns_from_user(kcs.apqns, kcs.apqn_entries);
-		if (IS_ERR(apqns))
+		if (IS_ERR(apqns)) {
+			memzero_explicit(&kcs, sizeof(kcs));
 			return PTR_ERR(apqns);
+		}
 		kkey = kzalloc(klen, GFP_KERNEL);
 		if (!kkey) {
 			kfree(apqns);
+			memzero_explicit(&kcs, sizeof(kcs));
 			return -ENOMEM;
 		}
 		rc = pkey_clr2seckey2(apqns, kcs.apqn_entries,
@@ -1376,15 +1375,18 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		kfree(apqns);
 		if (rc) {
 			kfree_sensitive(kkey);
+			memzero_explicit(&kcs, sizeof(kcs));
 			break;
 		}
 		if (kcs.key) {
 			if (kcs.keylen < klen) {
 				kfree_sensitive(kkey);
+				memzero_explicit(&kcs, sizeof(kcs));
 				return -EINVAL;
 			}
 			if (copy_to_user(kcs.key, kkey, klen)) {
 				kfree_sensitive(kkey);
+				memzero_explicit(&kcs, sizeof(kcs));
 				return -EFAULT;
 			}
 		}
-- 
2.53.0



