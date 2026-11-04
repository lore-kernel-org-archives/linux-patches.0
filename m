Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830915;
	b=aPvtYf6fhotPygMn2XMbF5Z+ShmQ/DcR/oTQ+rRVC9/fPCVLGQwGXsrP4t42bfv9pJ36
	 wFSwePf1/6FJfPyato01hkSHmvUqaweaPR7fvEvlMQJ12gYuANMwXx9yJkOC4tLtH8j1P
	 lelr1GA1ynjDYInQ2ruyps1jWW5LCw5Nm8F84vmgZawid+X1xlDcV8mflm0SDO6iEEPTZ
	 36bYvK93ErzGGP454hvdSh/T7MadDTmCoIhp/bsXsLl/lJRcNyA2jhqNAHnVjbv/WVCSs
	 IHMdTQlaRZKFOi1JAVpFkMu2BsksLRoEoM49gj793eJ3EAmb0VB7r0S35NDGbyGJ2GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/MvQzBP9iV764am/wCut6VDGRFv5L1NuZtjOw1MOvms=;
	b=HT4pvuyIWHrIBldj233oFU76Uh1IZOmVx1tSzspp86dBlDMy00Nh3FIpDWHaL+x1MIPv
	 EIIT4EWrmOEvsj91YsFfa67dTrdqAeCrNTfRkZhh+OS/XgSnfL/ugMMSaAmFBgN5N0vyM
	 XKw7dN8v1Qq/fy9jnYlStsH3+qiDOhGvqVJxMiGa5/LHZwnM7QaP//fgDB9iDyQ+JjEFL
	 rFNR/xHmNVMtNlc2PZJ/fygS8ogTYjq37a+M92ABaeNHSd9MWGZdLcUGDw6E60SZSdYve
	 tVJQvzJyjv+uqBL5+lDBNo+AbXtSL4KCWRLPfgW+mGnNkp7iWCfOwG1gFgUPBJuvK/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uoKufXAC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03424606A841;
	Wed,  4 Nov 2026 22:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uoKufXAC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF8A1F000C1;
	Wed,  4 Nov 2026 22:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830914;
	bh=/MvQzBP9iV764am/wCut6VDGRFv5L1NuZtjOw1MOvms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uoKufXACPPkOqNxwftLq/H2MOoM+A84s5YZhBSh8hX7NJ+Lqf/kyeUyojk/ERdaQL
	 YnxozkYzdlo2zFqDh+2v8KWxEVnhivenoMNqtrj+H1KroT0Mauyl6IiG3HTjl+w+qB
	 Yv+MBwoQIvKZMV7z7Z+/XBw1R3t8E9RjXIMzR+2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David C.C.M. Gall" <david.ccm.gall@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0399/1005] crypto: keembay - use crypto_memneq() to compare GCM AEAD tags
Date: Wed,  4 Nov 2026 16:02:12 -0500
Message-ID: <20261104211055.245586081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: David C.C.M. Gall <david.ccm.gall@googlemail.com>

[ Upstream commit 353b3a85136f2a0cf3e872acf8ad6c1dec0b7a8e ]

Use crypto_memneq() for constant-time comparison.

The GCM path in keembay-ocs-aes-core.c verifes the received
authentication tag with memcmp(), which returns early on the first
mismatched byte. This leaks valid-prefix length and allows for valid
tag forgery which violates the INT-CTXT guarantee of AEAD.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
index 419f88af1031b..c4fd5e1849cdf 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-aes-core.c
@@ -11,6 +11,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/utils.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/dma-mapping.h>
@@ -919,7 +920,7 @@ static int kmb_ocs_aead_run(struct aead_request *req)
 
 	/* For GCM decrypt, we have to compare in_tag with out_tag. */
 	if (rctx->instruction == OCS_DECRYPT) {
-		rc = memcmp(rctx->in_tag, rctx->out_tag, tag_size) ?
+		rc = crypto_memneq(rctx->in_tag, rctx->out_tag, tag_size) ?
 		     -EBADMSG : 0;
 		goto exit;
 	}
-- 
2.53.0



