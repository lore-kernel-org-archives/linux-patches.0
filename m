Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063053;
	b=XeLAxfXfjK7scd0evuzTehnA4fSNj56on/1DVw90ys2Is30XDYdIfJD4T2redHdNk0rG
	 6tJ1bN11tPJAPkLVBk3hFFXlX/b36XaU1Db4p2dimuZ5ZE+JqZp3iOmWzVvuyfm5K3Cpq
	 iDBB9YUMvROz+weHPNxQ4n2/1+liivwQ9kDWwuc6EKJ6b/+IFDQmhi1ge70PcAMfymxJZ
	 K92wuaSf+hrTVRM3DUr6OKihugMFdmJq9nBpmlpXMTnp597PtNyn5yzz0yCTvbvZeMZhH
	 piWOeXOP8+h243VG0ZHdeCypOV/3jS3cgXpw4OcMkxGv9q1Q4G6uEJN4CM2KG7nSALA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lT6pFEFrU+Wqb9tVM4h7LndLsmYyZz8UnHJjS52WCP4=;
	b=hKfdrjtx7B+sracQcFwhRF3cNLGEun97SiXjizNyskU2MhKnAEl2h/StsIocvCSbxpp8
	 QLh7+eJaeTV02d5muhEZvOYOuVYrrvLs5HCfSQYgHDPb8fnYLcF7C+BfwR56BxNdCEOkr
	 Q2ym17zS9o1yFwNK0XrnD4gmthAeiyTsXBUbEjC0n2qDVImctnvvf9V7hlUydvvPtEm2u
	 cOhKGZUDlCQ57uYg5CeDP7Jfvi5z6shfO58GjeqYrSvS79MVnwp04tfTeAzVx9mFSf6C7
	 fAwe58ZLDqy1kYGVQf8sVU/FRPsi/AYOAdxaQdvHoogpxx3ttgokjw5hCg9xi7+rkSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gwZT3XLR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A98606A331;
	Sat,  7 Nov 2026 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gwZT3XLR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841461F0089F;
	Sat,  7 Nov 2026 14:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063052;
	bh=lT6pFEFrU+Wqb9tVM4h7LndLsmYyZz8UnHJjS52WCP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gwZT3XLRylJ1TbHI0Ixm/OzBVaCKGFyJhbJXO+z/XXKvnYD7HpOK4Yl+lKnLaijTT
	 IWloOUrHnduyRlGmPSNYJQGcKrQTtzd+H71YHivn1dHbfP+nJFH/XwzfrZ+iBYeYFs
	 Q43mGUY8sigUg2nSsWLOXHAMLrBCplfz6SAgPKTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Greg Joyce <gjoyce@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 297/869] pseries/plpks: clear SED key data after use
Date: Sat,  7 Nov 2026 08:49:39 -0500
Message-ID: <20261107134902.365437335@linuxfoundation.org>
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

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit 217ba01e5b9096091acc2c1a3776cb3eb88c00ff ]

Explicitly clear the temporary buffer containing SED key data after read
and write operations.

Fixes: ec8cf230cecc ("powerpc/pseries: PLPKS SED Opal keystore support")
Cc: stable@vger.kernel.org # 6.7
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Greg Joyce <gjoyce@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-8-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks_sed_ops.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks_sed_ops.c b/arch/powerpc/platforms/pseries/plpks_sed_ops.c
index 7c873c9589eff..ac3ec2ca7fbee 100644
--- a/arch/powerpc/platforms/pseries/plpks_sed_ops.c
+++ b/arch/powerpc/platforms/pseries/plpks_sed_ops.c
@@ -84,14 +84,16 @@ int sed_read_key(char *keyname, char *key, u_int *keylen)
 
 	ret = plpks_read_os_var(&var);
 	if (ret != 0)
-		return ret;
+		goto out;
 
 	len = min_t(u16, be32_to_cpu(data.key_len), var.datalen);
 	memcpy(key, data.key, len);
 	key[len] = '\0';
 	*keylen = len;
 
-	return 0;
+out:
+	memzero_explicit(&data, sizeof(data));
+	return ret;
 }
 
 /*
@@ -102,6 +104,7 @@ int sed_write_key(char *keyname, char *key, u_int keylen)
 	struct plpks_var var;
 	struct plpks_sed_object_data data;
 	struct plpks_var_name vname;
+	int ret;
 
 	plpks_init_var(&var, keyname);
 
@@ -127,5 +130,8 @@ int sed_write_key(char *keyname, char *key, u_int keylen)
 	vname.name = var.name;
 	plpks_remove_var(var.component, var.os, vname);
 
-	return plpks_write_var(var);
+	ret = plpks_write_var(var);
+	memzero_explicit(&data, sizeof(data));
+
+	return ret;
 }
-- 
2.53.0



