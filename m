Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8B143C7B1;
	Tue, 21 Jul 2026 21:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668495; cv=none; b=PHo7b9Yv4GFfIdFe5DiU8LhI2P4VU7nxuFnVI9vZVeF5Oui3N0oZbSW94IyZlbC2P9D8RBrTBSGuFYgQF7H6BGJ2G+Q4JQ9eiAt2nEej+bkUw1j3Kpz5s5U1vECP6sKOi6cnoaOsUZb87OK4m+tKKI2BMOyLmrwv8UZy3GT0I3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668495; c=relaxed/simple;
	bh=X5EBTW+xvQJ2kW+JA2H5TVVLPnM4Mq47oxzqlbMHrVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoSFMvZY3TjrWcaaOwZjVW7CYm4mFFsLr84vEYWBcAMpqdU1dWwI/FO+4/t8ReHwKlx1d/jJOvtinTtksqGGsXIQVER7XKB9UYX3Js09dRcW9lkXlcELk+sPDsf2XK3oEm8PVCIF1zFcZVQt4YVBpGjvtGH8BGUncA1lmLge0cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcGf2+oc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcGf2+oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EE21F000E9;
	Tue, 21 Jul 2026 21:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668494;
	bh=X8TRD66O6Xsn5LCIqBncNwnY2hravLPMmb/IKg7aNTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JcGf2+ociycz26ZKZfxcn7ulmHPeBrVochyf8IA0WhxQFIoiUyittazJI1M8uyCs9
	 KYFPgfLH4GH9vFeOkUgpIZuuDL7j0fmBoezUUQCrgE1uXYvikl2sT1nYegfPaieStL
	 4Xoi2ODfP1Kw0F3k6jqEMyiW1NwwY3ccmbv+zPdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Alistair Francis <alistair.francis@wdc.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 0154/1067] X.509: Fix validation of ASN.1 certificate header
Date: Tue, 21 Jul 2026 17:12:35 +0200
Message-ID: <20260721152428.037915338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 3b626ba431c4501512ad07549310685e07fe4706 upstream.

x509_load_certificate_list() seeks to enforce that a certificate starts
with 0x30 0x82 (ASN.1 SEQUENCE tag followed by a length of more than 256
and less than 65535 bytes).

But it only enforces that *either* of those two byte values are present,
instead of checking for the *conjunction* of the two values.  Fix it.

Fixes: 631cc66eb9ea ("MODSIGN: Provide module signing public keys to the kernel")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260508033917.B5873C2BCB0@smtp.kernel.org/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.7+
Reviewed-by: Ignat Korchagin <ignat@linux.win>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/x509_loader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/asymmetric_keys/x509_loader.c
+++ b/crypto/asymmetric_keys/x509_loader.c
@@ -20,7 +20,7 @@ int x509_load_certificate_list(const u8
 		 */
 		if (end - p < 4)
 			goto dodgy_cert;
-		if (p[0] != 0x30 &&
+		if (p[0] != 0x30 ||
 		    p[1] != 0x82)
 			goto dodgy_cert;
 		plen = (p[2] << 8) | p[3];


