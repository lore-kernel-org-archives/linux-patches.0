Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213580;
	b=bQ1WpqTHm3fOwzJySV14RWebrCXzi/liqDvEoB145qNoS4mPRrx2woeEEN5bgJXZzmum
	 FlcLWr7fOAY75zKUWQp0rgYGyOVvC5oKSpqJkFaKkle6RQgfKyoiJc/YFN43BLeL74iC4
	 CyZJrNuioecu1GRH+CaksJMAJQT7r1DAMS/HL/ccc2vHw8bauibA1dAhsticqp05652oi
	 furCog779G8jVaFAuv6EQI38wpLH5oNiaNV3v40QCR+q4Etz5MKv5m/fyXFB2IjeM7xqE
	 vEImqK5vG2ytWaQbqgMxhQQ9tPjO+PHaij3OCA+Fk6aZ75ztmP5IpKBjGbsTHt/pcow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ZC/JSBxbxcosRYhdBjQEVfqlw3vFHzTCeIlF0NN+GQ=;
	b=SdyLmAcZ4xH1e/QUB/zM21qEbGjhQkS56hF7tCTSaq0Jt8A1Boum3vp0zy7/nd3LDqwi
	 E6LnpydnF/cl+DRZrKli9aVqUblYbvdxN7kr8YABrgiQWE7cFoZ+zpU+aPbOcs0eiCxHR
	 f1tS7xS5kI7JD3CSWnBcgUg3MTLbkoMagEs8FBwjhnAuBByb+PVuATQAgawmZT5CyAEa7
	 UC2yQ+L+V3gog7c2HCTPOTdHHo5b2SAqd6QvEjTE2sBLWU5uQtflfredUppu+FDSPXe1l
	 q+1jxbtCUgi8KrTb6H858fa1ar1q/rVsa0nzdejPNu7+h62nIyA3F+h7UpcOnsO0vZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQEjBPTP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C31606A31A;
	Wed, 28 Oct 2026 18:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQEjBPTP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AAB1F01825;
	Wed, 28 Oct 2026 18:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213580;
	bh=+ZC/JSBxbxcosRYhdBjQEVfqlw3vFHzTCeIlF0NN+GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xQEjBPTPPACjlxiDcRbheRm7VfxleK5I4f2UEVEIhfOyYrT/j+4cJyIbpD4lPgTyg
	 NSoDxeK2lVFXgKk8dp3LOOGf1QtH4fA4Wqt0bdTfOGq3C0lt3Qcgajws/0wCI2omku
	 HIGhor0eo1M6FKR92BQPMITusy3MMflV0aYhcKgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0556/1887] SUNRPC: fix a memleak in gss_import_v2_context
Date: Wed, 28 Oct 2026 17:44:12 +0100
Message-ID: <20261028170512.033198137@linuxfoundation.org>
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit e67b652d8e8591d3b1e569dbcdfcee15993e91fa ]

The ctx->mech_used.data allocated by kmemdup is not freed in neither
gss_import_v2_context nor it only caller gss_krb5_import_sec_context,
which frees ctx on error.

Thus, this patch reform the last call of gss_import_v2_context to the
gss_krb5_import_ctx_v2, preventing the memleak while keepping the return
formation.

Fixes: 47d848077629 ("gss_krb5: handle new context format from gssd")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/gss_krb5_mech.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index 1c092b05c2bba..8fc6f25468ac6 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -471,6 +471,7 @@ gss_import_v2_context(const void *p, const void *end, struct krb5_ctx *ctx,
 	u64 seq_send64;
 	int keylen;
 	u32 time32;
+	int ret;
 
 	p = simple_get_bytes(p, end, &ctx->flags, sizeof(ctx->flags));
 	if (IS_ERR(p))
@@ -528,14 +529,24 @@ gss_import_v2_context(const void *p, const void *end, struct krb5_ctx *ctx,
 
 	switch (ctx->enctype) {
 	case ENCTYPE_DES3_CBC_RAW:
-		return context_derive_keys_des3(ctx, gfp_mask);
+		ret = context_derive_keys_des3(ctx, gfp_mask);
+		break;
 	case ENCTYPE_AES128_CTS_HMAC_SHA1_96:
 	case ENCTYPE_AES256_CTS_HMAC_SHA1_96:
-		return context_derive_keys_new(ctx, gfp_mask);
+		ret = context_derive_keys_new(ctx, gfp_mask);
+		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
+	}
+	if (ret) {
+		p = ERR_PTR(ret);
+		goto out_free;
 	}
 
+	return 0;
+
+out_free:
+	kfree(ctx->mech_used.data);
 out_err:
 	return PTR_ERR(p);
 }
-- 
2.53.0



