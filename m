Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026507;
	b=ygWHJ63y0rdSNP3jzInrIMvGv1SGaNclqUlPVpip3T/JnF2CyCqKuNmrisF0ijt/T9yt
	 Onx/OXdKEtXaGwYuWRLKXMS8rnhyiR3Zzs02fu4o5YaLIXgrVuR9nmT4BkNdIk4dqHV4M
	 MAUyWoo0675YVyzO1Q+slyzmMIGOCTcQOMQoEjNHyo9FgzoIFFmNMETp6r2MZQtwtZQd5
	 psMQVduPYbcIqV4KkS1uzwCXdJHjj2ZQg3Y2JmMQyqApOQttAlBCsu9QbMNgHkCsKYoAp
	 VkNMO0MBHBndL1NcqbRgf+8/k1ZAJ6hmz5OGaikoO5d+dmC8WMvDq35PCW1Yc8A2ZWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EttsXjKUGEV5TJPvunoMEDHUvqG2bunvvO04NikA534=;
	b=NWTDyxZvYupyyaRm+PNashuxmJnHhYdk4FOg1iLq2OnKgiDvAiez8nUibO9yPnA5Y4cE
	 V/yYrdbDegdn8jiOsXZdgp/FGYCdrMwpD7RHJoD0W0syLEPp1NUU0U6C0zd1QGn33hsEn
	 tMlhVFKB7dXHV+OCoCi/c7HDZpppiG56ZHiAOZmGqaeO/sh1O4qsorN/hcN3w/S+U1+tl
	 oxHG8E6ZlIpDqXC893EEoCvlmyP2T4rDupKRPuE9YG/6ei2bOY88qRU6HhKnAOY4QytXg
	 7E7utb2bJV2UO0Tb3pzSzN0UGyIdRz9z4IkePi18Wux7z81+VBR2T5q/hpriNNQAxFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qk97htrn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A6F606A320;
	Wed, 18 Nov 2026 18:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qk97htrn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2351F000C4;
	Wed, 18 Nov 2026 18:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026507;
	bh=EttsXjKUGEV5TJPvunoMEDHUvqG2bunvvO04NikA534=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qk97htrn8kduXsBALsujcg/tj69/mVnSWvxf/E0swHfguY+VUd+aPsqJbN6K47XUq
	 bOQKDFa7SB//wd58KrMQArT967p7uaOVCLrrKyWtmqpOMfweYhOeLsmpu6fn6yermD
	 c8gZNSPIEAqaYobKdOqyqfzajitzHKpb62/bhDRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: [PATCH 6.18 1423/2151] tools: hv: remove unused rte_smp_mb()
Date: Wed, 18 Nov 2026 15:52:38 +0100
Message-ID: <20261118150213.791854457@linuxfoundation.org>
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



