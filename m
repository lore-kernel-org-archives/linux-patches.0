Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213804;
	b=zUmaDEjxh3x5mZ7MRslAr9JaB7jSOWd8So9NG7KWFEMktytB5+1lBakZWOQY6AiDLuM+
	 euI/iUVLoQsVJBzAVL99JszZhK5F7insl3IZI8T89rgmcehVp18qEBiNPSE4K3CgdJ/av
	 j8PaWYHAgfnHZ+iABw0wAcqK4OYEP87HRO+wmi0Kp/QczRrBvIAYYsOirYolbSykjsQiv
	 5234nBP8MhP8sVCG4LamI/YevHZbaKPuCVnrB1QYZVR4O2xNVoA5Bcba4fcyriWCYJR7f
	 zifd79bsidSwt8CTg2394TeLcPc+17+KuhILRFFC/0tVU5AaWctFMjkD8y9NBXHzWgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p9fdoHuw5Vw3WvebHxq/uWWzTJk1JDLME9aU0b2VLbc=;
	b=ZqqUit/uw1r8ybs5qv15X4CWIIgbA8LqMd0/iuPwV8/RBWhSMVpjKqOXxC1wNFRGNiLw
	 XgXSvsK7zfMrX1yn5tBMWe1c9aN2ExuRLwx4C+rHzC8EbmbicuRqrzMt2hXR1P3v/lntj
	 Zz5VmL/8SeiI/EjY8HkO3N01zcFApMWIjBCba/DaJmyfB3qkMsmYaIzjqi1798MUfD1CY
	 zVSu8bZfsWtU82CE8oxh7+xdr4wmH7Isc1XPs/EJPWkLV6PGThAjHkeJ2GqixoJbwJbtZ
	 TAi/KdV8OBnKoMw+ieLh65ubfzlSB4yUoVrXsFduJm88GhbpaO55tX+NFzvHy6aV0Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1aKM0II;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83903606A31A;
	Wed, 28 Oct 2026 18:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1aKM0II
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42961F01825;
	Wed, 28 Oct 2026 18:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213804;
	bh=p9fdoHuw5Vw3WvebHxq/uWWzTJk1JDLME9aU0b2VLbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1aKM0IIXQU4o9GpQBG/kY7iCvAOQecdmq3c0es1rH4FUMyqTkuqdTPXtk0GTE3DQ
	 fu5r1JzVE9+9CM4hE4CZMYEZgFtXmus8xV5AHqv/1grT5thwPj7OPmZcwaUtIfLSre
	 ttr5bttf9FgCNfoCsvpEnDbULVfYKNwsOLOyDAsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jules Irenge <jbi.octave@gmail.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0636/1887] s390/pkey: Use kfree_sensitive() to fix Coccinelle warnings
Date: Wed, 28 Oct 2026 17:45:32 +0100
Message-ID: <20261028170513.882934160@linuxfoundation.org>
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

From: Jules Irenge <jbi.octave@gmail.com>

[ Upstream commit 22e6824622e8a8889df0f8fc4ed5aea0e702a694 ]

Replace memzero_explicit() and kfree() with kfree_sensitive() to fix
warnings reported by Coccinelle:

WARNING opportunity for kfree_sensitive/kvfree_sensitive (line 1506)
WARNING opportunity for kfree_sensitive/kvfree_sensitive (line 1643)
WARNING opportunity for kfree_sensitive/kvfree_sensitive (line 1770)

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Link: https://lore.kernel.org/r/ZjqZkNi_JUJu73Rg@octinomon.home
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 96fcaa0b6ff90..2e7a56073cc00 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -1299,8 +1299,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 			return PTR_ERR(kkey);
 		rc = pkey_keyblob2pkey(kkey, ktp.keylen, &ktp.protkey);
 		DEBUG_DBG("%s pkey_keyblob2pkey()=%d\n", __func__, rc);
-		memzero_explicit(kkey, ktp.keylen);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (!rc && copy_to_user(utp, &ktp, sizeof(ktp)))
 			rc = -EFAULT;
 		memzero_explicit(&ktp, sizeof(ktp));
@@ -1438,8 +1437,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 					kkey, ktp.keylen, &ktp.protkey);
 		DEBUG_DBG("%s pkey_keyblob2pkey2()=%d\n", __func__, rc);
 		kfree(apqns);
-		memzero_explicit(kkey, ktp.keylen);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (!rc && copy_to_user(utp, &ktp, sizeof(ktp)))
 			rc = -EFAULT;
 		memzero_explicit(&ktp, sizeof(ktp));
@@ -1564,8 +1562,7 @@ static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,
 					protkey, &protkeylen);
 		DEBUG_DBG("%s pkey_keyblob2pkey3()=%d\n", __func__, rc);
 		kfree(apqns);
-		memzero_explicit(kkey, ktp.keylen);
-		kfree(kkey);
+		kfree_sensitive(kkey);
 		if (rc) {
 			kfree_sensitive(protkey);
 			break;
-- 
2.53.0



