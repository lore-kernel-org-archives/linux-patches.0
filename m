Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006D1207E14;
	Tue,  8 Apr 2025 11:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111235; cv=none; b=TM/UoivuNGX52sG7fKK4QaKSvWxNCnRYU6inIZ5ADfLOeAN9Tu/qJPzfHua9rouqoKuNprMiPlWa4un5tUCxoFDGjEMmQVSbTF6SrzulHPFlFQAvvWk+QhDgxSEyq0V/7D677JiMmGuXhzPSGUq7LNuYfugVj5URwDg1xwWdL0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111235; c=relaxed/simple;
	bh=1FOIL3PO8UzH//Lml0ej4bMRmJ+quQrq3k82aQLVDUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ldzl+Krlf5vdDy39BwEBqMH1xKcC9v8SirZrP5T/2ugicwF+fbcX5ab+GQ3v44yRoe20WtJpC3EKq9oqKqxRcyVyru/heEsJqsGRyY4GBcJpX8MzEv784umB8y+wWlSIfDLIifgLT3cwjbr2s4+IfJaYCfoWz7vLnSYhRt2ljco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKwihWhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKwihWhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856E5C4CEE5;
	Tue,  8 Apr 2025 11:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111234;
	bh=1FOIL3PO8UzH//Lml0ej4bMRmJ+quQrq3k82aQLVDUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKwihWhzkHqbdegDmdcqGi7pf1IH5592RL6Dv829/lbONBazr+uBbXkh1Hcj7A03M
	 TnJprOIkKnA6aYhKJlcbuH9kPjCk00UVapd5RTSQRH8oCnFmIrk7vNG6OA5rxaWEti
	 Y43MjWX1OMN9X3LP0zZcw29ZxVpzG7WxgMhB46ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 358/731] crypto: bpf - Add MODULE_DESCRIPTION for skcipher
Date: Tue,  8 Apr 2025 12:44:15 +0200
Message-ID: <20250408104922.600601530@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit f307c87ea06c64b87fcd3221a682cd713cde51e9 ]

All modules should have a description, building with extra warnings
enabled prints this outfor the for bpf_crypto_skcipher module:

WARNING: modpost: missing MODULE_DESCRIPTION() in crypto/bpf_crypto_skcipher.o

Add a description line.

Fixes: fda4f71282b2 ("bpf: crypto: add skcipher to bpf crypto")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/bpf_crypto_skcipher.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/bpf_crypto_skcipher.c b/crypto/bpf_crypto_skcipher.c
index b5e657415770a..a88798d3e8c87 100644
--- a/crypto/bpf_crypto_skcipher.c
+++ b/crypto/bpf_crypto_skcipher.c
@@ -80,3 +80,4 @@ static void __exit bpf_crypto_skcipher_exit(void)
 module_init(bpf_crypto_skcipher_init);
 module_exit(bpf_crypto_skcipher_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Symmetric key cipher support for BPF");
-- 
2.39.5



