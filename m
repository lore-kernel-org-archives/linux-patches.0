Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064335;
	b=4lNjxb9RPzaAC7+66WmDmivrdQVGQdx0l1zdbJ89tnix9g8zF1n7BlGaKdUDKzh8HIru
	 fn4pmmwi9kQYLMd7fHUL8iIbraFc0MQSCmUsXg3v6V/C2+m3KNPRoBW33JS0hbfVTfqAI
	 wXnVJulsHU90b43WdQvGPR8tOpQQeW/9TvOgOm+Zu5Vzoa+kRKhRUt7tmgPiUXUXaAeO9
	 SvKLazY4+qCp0wuEv/Nzz+UNsWpWH86Cdo7rjdcLCZ3qOiFG2mC0iNjK5T5TJZmPefd8r
	 kwXypxTlEVzq9xLwXuME6f9vLSP6P6Pwl/ioc6SJMKgsbyWmQwc0zcc803tG9/sIUxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cVNQyLM/A5tn0wRFgjaIA+IJgZ5Nu22VmDstLnPLmHs=;
	b=ZRhsgNwbift/R6rqourKpixlPoY8B8i2axe6YHqvGpf+0r6mcJvqhwxND4QPFryxhQXh
	 q9lzwo7zFhCvikFMvZLR0wkcTvef5xWYwc0ywC5axe2YFM3PDRfClisZvzzaNfTNRsef9
	 Ssn7A7xBFpzlPuBcC28I9dshwGn6RCIFTBYS/C7NwNyEOVivUJclnR8oxwthdU/abZrzg
	 2AzVqnfgWzl93aFAN1Kod4trtzDXWVb0doaenFP6QsixbiJiujl8V7vSNZrOcG/wiIj2R
	 SboQEnBUriPm6fJOhF/5c4X/CvGD6SPqeVGW6szFyvN3WnY6FYuwxijNHDCrQshEMDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+iYjLcy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5EB606A33A;
	Sat,  7 Nov 2026 15:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+iYjLcy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BD21F0089F;
	Sat,  7 Nov 2026 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064335;
	bh=cVNQyLM/A5tn0wRFgjaIA+IJgZ5Nu22VmDstLnPLmHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+iYjLcygROS6Z+kuD+IKKOfig7+ng94odDLfYRyAYU17y+b8eEGOYLkJonJBH6m5
	 QS4kTIe23WMOZzPjaSoLzc5px+J/5YDrE2BxM+VEvVUNJvqiQYOaBrARwvTbdZTNoJ
	 JN+p8j/nIBpqGkXGRh7Yyd78Gf8uY2ufBFrbuI1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Greg Joyce <gjoyce@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0382/1257] pseries/plpks: clear SED key data after use
Date: Sat,  7 Nov 2026 08:44:38 -0500
Message-ID: <20261107134950.101857800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



