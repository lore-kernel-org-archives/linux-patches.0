Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025124;
	b=xAAIA8mCtZPyDJ7sNC5xEXA3Kib4f2p8bASFAYI92Vly2N7TzGMTOazDVnHutG2MpAKf
	 YTos5mHDovgAyjuBMoyqqzQYfDvJa6kKTvwrCn2CuLNmuRJzyKswDTWbZ4ZRF7WyzmvO8
	 OHQLVB1VJ/yZ7eVDJFvzRS0o1S8TpkZuNmy7oQGzpMcIe0Iz37dBWsbcN3CLqtLgC4gr1
	 yMQe5584+kka676GS9eG8IsD6dBPem8Gp1WuCWjKslQYo6hajTltp7JnzfZGn3MYg+fJL
	 4u3BihJJGXzOTCGNVCeDKXRUDJ9/RNnytMnREsZBm5tkMgYdJZ6Jv+1H1SV52taFUqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8wGDfW0f1ynABchh344P/npvxv6m+kf/XYxZMfRxmCQ=;
	b=YxWBAalO072EhDF6oLT6y34jjKcowD0A6t/OQ/PUlEuYKfZwjpFg8biU/R2fFvci9U5E
	 j/jApZ1URIwu5RT7EphePdQ4Bc8JvVUpqCkFXkoq3lMfkTjkeYqC1XX3atsFO4P49KwWz
	 W6K4jUJHJctZvRzHGMSAuYDSucn+PzfJf5KFaegTcZ0Se4SBxkrBTBJ8RNOwb9QKkZf2x
	 hhD+7RA87qr6Itj1Mta2VrCT/DfOLvNx0MwZj11HOH/j3ftmIWUGXgxXdsJe6Sqis79ew
	 PYMGeBMp0bzopz2B62dSH5iVf3ZxzHMiBkENxtMuh6MTFlFNvS46RG99dapFC699hXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNc9oaRJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CD1606A334;
	Wed, 18 Nov 2026 18:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNc9oaRJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32FC1F000C4;
	Wed, 18 Nov 2026 18:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025124;
	bh=8wGDfW0f1ynABchh344P/npvxv6m+kf/XYxZMfRxmCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNc9oaRJSRfKWSd/eahGCMpNGWiMAad+zOZ3tWpOg/TOWSsFtX7CX2pdIjRongDLK
	 6JU4sv+iungOKxSKqz/5yNmp2eyzdoiyYCI+0iRE0WjFICQEdjHiKLsoaazMTB6U44
	 WKLOoeD/kJTYfQSKLPaclgeZGD1wNZ0x+zQjZKDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0967/2151] hwrng: intel - return -ENOMEM when ioremap() fails
Date: Wed, 18 Nov 2026 15:45:02 +0100
Message-ID: <20261118150157.742995053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 4c3ca7c8c152278332590bfd3df1b0f086364759 ]

intel_init_hw_struct() incorrectly returns -EBUSY when ioremap() fails.
Return -ENOMEM instead.

Fixes: c24c95a085c6 ("[PATCH] fix Intel RNG detection")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 94f7116e96682..789a5c709ba87 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -318,8 +318,8 @@ PFX "RNG, try using the 'no_fwh_detect' option.\n";
 	}
 
 	intel_rng_hw->mem = ioremap(INTEL_FWH_ADDR, INTEL_FWH_ADDR_LEN);
-	if (intel_rng_hw->mem == NULL)
-		return -EBUSY;
+	if (!intel_rng_hw->mem)
+		return -ENOMEM;
 
 	return 0;
 }
-- 
2.53.0



