Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023707;
	b=ac1B8I3p/Ghu5rLgcA2srDMTjDKPR04W+k8Owh6RrOAYly5yFwVue97xWBmqdQvr6VGI
	 oCU80ZqC53ePcgLVjekzA8g5xehbMQ+wwpU+2OTdOLJ/NG/DiPK99YSHa+7+t+lCUAUEq
	 tbwuvNZdmcnQS8e3HmHX/P+57Ax+5KGNntvyr4J3PpYUjSfZnyh1uIURGrkOi0ClzZW2b
	 +r49wibUEiXwX9MNrhEbM5WZWncqO69Hox8D5jpc/Cu3Zmq6Q1ZXdWVFMP7IzYSCwFtg4
	 Slwtm2iL9pE8LwxeYr6gzadfeFmiuGLlQRIK9ipzOJLYYEyWIDhu4LG06DP8ftp3Wnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nb6/sEcDRR7cnNUf+lyrCfSCeKd9e4snX3e8kYMPa6M=;
	b=zUZNOfiNLrVzz/fKGPDKVIC2lQgLxT10aLsRPswYww55TZKx71tO1ba26KXuyoTd7oGZ
	 WnxLhAaDuy4Z+XNb1pCfDQb5LhLpkvap/VsfPW+V3txwTmYUt3+2FVhC/vGIvavn3w/Jx
	 gtTS4wPtEbI57lwP01diAMP8u25Y96Q9OMUI6g9HcEe//ZiakunyZ1EKqUdhuZf6jG5KW
	 9rcfkkQJ1W8M2BNXwMtu7QtDMk41JDWM3imD9a/9XctL/no9A0l3mmU8peceFFpt3OiDA
	 R96Xg90ez9eqD2JB77QdlOcpEcGakmL6xyB7JXd4NCjrr2TjBWGf4pjhMRgEdp6AlrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fej9y5MF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02465606A31C;
	Wed, 18 Nov 2026 17:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fej9y5MF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFC01F000C4;
	Wed, 18 Nov 2026 17:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023706;
	bh=nb6/sEcDRR7cnNUf+lyrCfSCeKd9e4snX3e8kYMPa6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fej9y5MF/5yb+sPM8/vvQ7jQjquaLjuAZQhZSxYpRAj+JTU5Cirtl42IMRa+2RRjj
	 wu6uwc+YVfHWwW2SIZ39ia28/26oq+ZqP1VV+A60Tqd9dOLfYYTM1yWnczXJT9n/xG
	 ZDcsWrxVtwlyrEhfE6GbUhnkjxUiU4538q0LDvoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0464/2151] crypto: eip93 - fix ssl mac bit field definition
Date: Wed, 18 Nov 2026 15:36:39 +0100
Message-ID: <20261118150138.921906897@linuxfoundation.org>
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
index 194436837147c..3a806c277d3a3 100644
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



