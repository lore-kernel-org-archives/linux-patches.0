Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031649;
	b=SYd0otCtr5iCyXuX694yd3v1CUTimo5RL0wDLZ2jy6cX3Yzfe+xHp6UrQyKOo5MQ9G5S
	 iASWXbIfCltGrhd1KJ8Kyed3ndAvf8eEcU14RqG33SrgsL5UO0PuMnVgdOWksDTiOyT31
	 5vx1VnXtbm7M0czIAt3/3+y+f+arLFygRalR0V/FiX39EiujidgtInCG9Rg1eDRUtiNLN
	 vAVV89e8V0AY6LF/dBwaOFIMoi6Pzr6P8BmV3gjcN5lzo6W1e/mdTXNQS6raRyZmHFNMi
	 BAS++uylF/HzOxAijAtz5MFWk2XpPfemyx/G7gd6PzAq16pMGPtG3TcJNw3SVrEP+vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pu7sER/aNrhWCcx+K5l4AUhzyko3jR+/BQbhaPG8zac=;
	b=dWDRjD2Auj/iKwHuDEqO/BPXwPs3jTO9ghDKNlLMPaCHxzhsoXXw/VLHmhGYp+aPgOem
	 uOPCbXVS3KYMHlZXS/UIR1l9aYLaNGEMuNDkVR18C9N2BJ6ENha+Tm+JEMPSyWb9Y9qQA
	 p2K03ab+zzycfuEHCh7W35l3gKFHsZAezaiaQU+ss3MmIu63WXX/MXeUKcbulkTjJ06wG
	 0gBQr2TMRLpH+Ski/LzzhB/Epn4OEv3H1dTAP0fec/yajBIo7KB0ECIPM6RlGUs8vGneZ
	 M+nJVG0q/1sp6mXf5+50+gdQo7B4INpEomM+qwiaQBLuwBG/CQxZK3das8ahK6iWRnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0pTogeW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9294606A320;
	Wed, 18 Nov 2026 19:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0pTogeW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068791F000C4;
	Wed, 18 Nov 2026 19:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031649;
	bh=pu7sER/aNrhWCcx+K5l4AUhzyko3jR+/BQbhaPG8zac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0pTogeWs2uE4xzaV3lqOuFgeKnXUF7/cpz5kWcqtAN2GAgiilDq/nu0OB2VNnzIH
	 eU/heQfOxvSXElXMdrOAeGK532sRgYTyKrF2OjiLA1Pv7fDhGesUUTAXp6lvhc0tEQ
	 uf62GPjHpiGpZ6kSRoi4t24BTblTH0AR7mhFkcJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: [PATCH 6.12 1131/1756] tools: hv: remove unused rte_smp_mb()
Date: Wed, 18 Nov 2026 15:54:18 +0100
Message-ID: <20261118150055.101726380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit b67eeae485e22893b678229169024a73b87cf113 ]

rte_smp_mb() has never been used, and its "static inline __always_inline"
declares inline twice, so clang warns:

  vmbus_bufring.c:61:15: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
  vmbus_bufring.c:62:1: warning: unused function 'rte_smp_mb' [-Wunused-function]

Remove it.

Fixes: 45bab4d746510 ("tools: hv: Add vmbus_bufring")
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Reviewed-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Acked-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Link: https://patch.msgid.link/20261011223358.2327625-12-sashal@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/vmbus_bufring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/hv/vmbus_bufring.c b/tools/hv/vmbus_bufring.c
index bac32c1109df8..23542e59a2ee9 100644
--- a/tools/hv/vmbus_bufring.c
+++ b/tools/hv/vmbus_bufring.c
@@ -58,12 +58,6 @@ void vmbus_br_setup(struct vmbus_br *br, void *buf, unsigned int blen)
 	br->dsize = blen - sizeof(struct vmbus_bufring);
 }
 
-static inline __always_inline void
-rte_smp_mb(void)
-{
-	asm volatile("lock addl $0, -128(%%rsp); " ::: "memory");
-}
-
 static inline int
 rte_atomic32_cmpset(volatile uint32_t *dst, uint32_t exp, uint32_t src)
 {
-- 
2.53.0



