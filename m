Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064330;
	b=B0+hUPCndMMGMQRDUADXVYA3KQWW5yrvRrziNG1H5EVn6Xj1x7o+ybEsMSfA5hYCaUyD
	 IF1XqxT5gfRE2w2fj51P4BaTde7GjiUGG967OGKi1ypYOdTgriHYnIO1tW0//b1DRqNV5
	 RcZ4WJ8bE5SGeRmKrMKOGpiF3lwpgxj24DnLzUKWh7g+0BTbaoJpdZYv/EbiAmt6jRUkj
	 gaoVtTW6nLqNjPaaOgl3bDVM2UzBpmGn+//Ziwnj478Q53+qt/ddrybfPD+b5+M3onB8n
	 ijXncJpupXJBA0a8S/5QPsjaNT/Wo6Xi/1P4cE6IB98mDNzaMA17eDHnBHlNzUZWCgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cB8A+9I1ju5w81Trj6SQJjDaFTVaiXOORcslOIQNlKU=;
	b=wMzUafnhlwX3VDjE2AQ0EfvGQPHowfj3lC8udpIUVHb72N2pVykqVNpqqI2a8RwpOrK+
	 Kd2SefLrh5xKWwemCT9JMg1MlbQbbT7PCdzw6er4HVihtrp8fouOdZ4fiSTSbrCXcko4N
	 FMtCBxJxi9gurK99ua2zpYlgVWIAk9Qhq5EBWf8GibdUpWwZqmk/tnDMiBhLcTYlUc5Gw
	 sMkV5FFdPGT3CIFTM+ngtWTFTqCNNdMgXIJt2UsRUYg7GFMUXfrNuxVBO1zam9nedrQOk
	 5Ce6VztSZLqzVlC3sDjMMdunNNWeHd8IYhclxzr1XDNwbl5B2ZaxAe6atvnYUxctTsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wki1y7hq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4109C606A336;
	Sat,  7 Nov 2026 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wki1y7hq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E521F0089F;
	Sat,  7 Nov 2026 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064330;
	bh=cB8A+9I1ju5w81Trj6SQJjDaFTVaiXOORcslOIQNlKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wki1y7hq/vWvoU8impEHnzo6GbUzxg1eckbjXCDB8OVjc0RcXInA3qwE0SifQaDt6
	 kvWkMgm+2fNqo49a3j6PpFY+kgIuAyz68A3U0XgaXedHjTX8/Uzm0nDUQDwsgy96v/
	 aNSDXcSterLdwtqTb/yoMnjFD4jIa6x76Dp1Q0EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Nayna Jain <nayna@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0380/1257] pseries/plpks: clear sensitive buffers in wrapping operations
Date: Sat,  7 Nov 2026 08:44:36 -0500
Message-ID: <20261107134950.045730199@linuxfoundation.org>
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

[ Upstream commit 203695c109e37d8fe3531844218f75b98eef8e1f ]

PLPKS wrapping key generation, object wrapping, and object unwrapping use
authentication buffers that contain passwords. An object unwrapping failure
also frees an output buffer that may contain sensitive data. Freeing these
buffers with kfree(), without wiping the contents, can leave sensitive data
in memory.

Use kfree_sensitive() to wipe the buffers when freeing them.

Fixes: 133aa79e211d ("pseries/plpks: add HCALLs for PowerVM Key Wrapping Module")
Cc: stable@vger.kernel.org # 7.0
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-6-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 8dbf85e9714c2..17a73a04d45b4 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -975,7 +975,7 @@ int plpks_gen_wrapping_key(void)
 
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(plpks_gen_wrapping_key);
@@ -1100,7 +1100,7 @@ int plpks_wrap_object(u8 **input_buf, u32 input_len, u16 wrap_flags,
 out_free_label:
 	kfree(label);
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(plpks_wrap_object);
@@ -1177,14 +1177,14 @@ int plpks_unwrap_object(u8 **input_buf, u32 input_len, u8 **output_buf,
 	if (rc) {
 		pr_err("H_PKS_UNWRAP_OBJECT failed. pseries_status=%d, rc=%d",
 		       pseries_status, rc);
-		kfree(*output_buf);
+		kfree_sensitive(*output_buf);
 		*output_buf = NULL;
 	} else {
 		*output_len = retbuf[1];
 	}
 
 out:
-	kfree(auth);
+	kfree_sensitive(auth);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(plpks_unwrap_object);
-- 
2.53.0



