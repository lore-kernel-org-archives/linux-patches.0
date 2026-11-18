Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016346;
	b=u0i2tLM/0YzfDnWz5nXb9XFMzJ1t3xGermc9wnfCGDLbhBxbgY25z3vmnZucptG/6Smg
	 atQbp6OXKu9rKsCQAJlixZ64ZT94tI3H5VO5RrOjnHB3HDy52IzwHJLTO2mGj/p9jTFv+
	 qh/ILk6QTGEpZpW2hrakyBhgXYzHtVWAzkhoZuwEv556Y4P/lmkMd1V5r/YE2GmOuhQcL
	 51aBm4gGAbP7frbucb0g61nTlTslk4+FGGQsIHwhB1+49tbr6sZi+7xFnBfwVK0vhenKo
	 QYtF6eyC6lcDp80gwawN9poT78k0N1HLLsrA/0BG0MTnuYL6sQ9CLHWGkQChQE9uwBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CZbn+Jbg/z2U+sCvuI6FYU1iZJEODpDt6M08jXVcyeY=;
	b=fwlpLDT+drNRXyHeexyA+i86Kxryq6UYJBFo848yXn7Zj4EFCI6VY45boF6d984ZHN3I
	 AhDSwElVlOSzTmJpEVDvhYoSudpP4TBBXTn9AA3XIdSyqwc5dev4NUayCGlE2zpI1Q1GN
	 H2R3ATnZRXpMpY8y72bnXw64igqgglrtg544KLIxELUV6lk+oDR6Nqvkcgv+TKZsspxAJ
	 jRzo1u5TTBlu5XHTDt4/v25WuSSNHGV6jg6iBeeVM1eVXMb6N5Chj3SYNufFa4o8SdUbd
	 07LYMrYN9v2sCaA7dmAHR86ZmtTm/TAFkg0LRWUBFdKyiMQkt+Ma4eMYmgAErJOks2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DrhduNJK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E4C606A33D;
	Wed, 18 Nov 2026 15:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DrhduNJK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E317F1F000C4;
	Wed, 18 Nov 2026 15:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016345;
	bh=CZbn+Jbg/z2U+sCvuI6FYU1iZJEODpDt6M08jXVcyeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrhduNJK1CGpNYlbMG4AVEFL/2K+LA6T8eNPlB/pQLendZck0d60SPmgtng2SY2OG
	 zS9FaTEb9W+DeCz/slvkW0T7SmmfvMazV1/0prYD3dn31X6lbaU7Q3viiFpEjwm99d
	 csXK/uoS0mFolh0kEypEF5RcYz7qYrM/pj92qcpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0496/2651] crypto: eip93 - fix ssl mac bit field definition
Date: Wed, 18 Nov 2026 15:28:56 +0100
Message-ID: <20261118150305.628584107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 8f808c8f32b67d42ba97457a7054bd5954d02856 ]

Checked the register definitions with the documentation[1]. Turns out
that the EIP93_SA_CMD_SSL_MAC bit field has a bad value. It's used in
SSL offload mode. This driver doesn't support SSL offload yet, so this
causes no problems.

1. MT7621 ProgrammingGuide DMA
Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/eip93/eip93-regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-regs.h b/drivers/crypto/inside-secure/eip93/eip93-regs.h
index 96d28c6651bdb..1d726bcdd77f3 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-regs.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-regs.h
@@ -281,7 +281,7 @@
 #define   EIP93_SA_CMD_HASH_CRYPT_OFFSET	GENMASK(23, 16)
 #define   EIP93_SA_CMD_BYTE_OFFSET		BIT(13) /* 0: CRYPT_OFFSET in 32bit word 1: CRYPT_OFFSET in 8bit bytes */
 #define   EIP93_SA_CMD_HMAC			BIT(12)
-#define   EIP93_SA_CMD_SSL_MAC			BIT(12)
+#define   EIP93_SA_CMD_SSL_MAC			BIT(11)
 /* This mask can be either used for ARC4 or AES */
 #define   EIP93_SA_CMD_CHIPER_MODE		GENMASK(9, 8)
 /* AES or DES operations */
-- 
2.53.0



