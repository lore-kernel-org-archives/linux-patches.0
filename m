Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034580;
	b=Thju9PoQ3bAuBWKZHag8aAe0GbpQ974ac5N+pGqoVLyANveaz1vpmVVM1scd2bu0Xhs+
	 EcaaakDtZ17aRPaxBt6se0zvgRFYGWqB0YS+V17Tl6xnEpOHe6OfMdMutUzYMPp2T21Bw
	 w+toA82zc45jmIpuOaY2tDna9YDROSUwDA6rSMbBNXjag+hqa7NAGyU4AiJBtyvMOkhvA
	 kPN9Eyoba8P9NgoZfPGODvPFsSfKcpuv0TtVQ73tDLYVyHtaa/FPSnLCcLPmGwLhCbpEl
	 pcMVogIRggR+FpQ41dkyRX1yPX2qUhGctdOZTCmyjIb2QqOzUhnis5YU6uLGv/uVBKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kINscQXQa/q5JVUNrUF71rpJGfQVP8biHu74uWLy2fA=;
	b=AjPwr+q4li10IQHU8upo7Fal2a8pjV4F8h/ElLWcv5OWWFkhmnsNT/GYPfSuWZri3tLZ
	 cG9hJPPfCl0b+NNFGMoEoyuJn4+VqTbX/wXlq6GOKLKzpLD7AWd50Xha59NwP/9QUEoFh
	 efiKiswp0UVtgk3uwwkqq414Pv6Cmxt00PWgXCjkhKlO7YkHCyB7mfKtxrbsjUwi7hyVx
	 tN9iS4cF868RtCV5IhjoIzVS++BlgvR5SpczitD5ZBDmZ4q3JzQmu/Nqa7qylMj+7uhx/
	 AzeIoCgm8IMTtaEmK/XrRXGLGWm4MED8OHsrRo2n8yBOdKJLFsFFGQ2jtbJf7R50wnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SwjE6f9g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7AE606A31C;
	Wed, 18 Nov 2026 20:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SwjE6f9g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E082B1F000C4;
	Wed, 18 Nov 2026 20:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034579;
	bh=kINscQXQa/q5JVUNrUF71rpJGfQVP8biHu74uWLy2fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SwjE6f9g2cU4ucFoRBbi7x58dLPfZ47mQ47URl0OenSFWocqt55/l3RF6U2LipTJn
	 66EVgxHzF1+XPqgyhJmiScJPaxsSGDW5c3pnr0x5kxL63iVl0XWocN+jnYb+BRV54G
	 j4QmwkJ/WeG/X20mY3zxmJ+Qx3EhS9ZpjpcI5eig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0418/3318] platform/x86: think-lmi: Fix certificate thumbprint sysfs output
Date: Wed, 18 Nov 2026 15:17:20 +0100
Message-ID: <20261118150329.087299308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 4f3183f5ae9b8ddfe338d79a96146a05342bbe50 ]

cert_thumbprint() already returns the accumulated output length, but
certificate_thumbprint_show() adds that value to count again, making the
next line use the wrong offset. Errors returned by cert_thumbprint() are
also ignored and their negative values added to count.

Assign the total length to count instead and propagate errors correctly.

Fixes: b49f72e7f96d ("platform/x86: think-lmi: Certificate authentication support")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/20260810120556.149416-2-thorsten.blum@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index d5319b4637e18..866c09f415e2a 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -680,9 +680,15 @@ static ssize_t certificate_thumbprint_show(struct kobject *kobj, struct kobj_att
 	if (!tlmi_priv.certificate_support || !setting->cert_installed)
 		return -EOPNOTSUPP;
 
-	count += cert_thumbprint(buf, "Md5", count);
-	count += cert_thumbprint(buf, "Sha1", count);
-	count += cert_thumbprint(buf, "Sha256", count);
+	count = cert_thumbprint(buf, "Md5", count);
+	if (count < 0)
+		return count;
+	count = cert_thumbprint(buf, "Sha1", count);
+	if (count < 0)
+		return count;
+	count = cert_thumbprint(buf, "Sha256", count);
+	if (count < 0)
+		return count;
 	return count;
 }
 
-- 
2.53.0



