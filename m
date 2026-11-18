Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019831;
	b=fEya6SB4wtmbLX+AogrxHPBPSIxXZTGgWFxN2mjQJpgkfDVFe5vSFV70rZjALyck0xiq
	 FENJfnxwU5pUI9ZoAFqw98xQ6lx6ErUHhSh/KIcFU1VEKfaym3pn0zBXAh+e0DxIZCHcQ
	 1fKVmwJCrctHZSXGJwIOoWO8GnZwViI3bIf/KeGUTSeJSYmgcXNhcAX0Q44ZlnUe1K6H4
	 RBaRbDch8WsDx3tdLK/cxRZeKyWNTC1H6CQ/fm1wW+LcEdMSiDrwJrHWliSv4FkTu/jes
	 NZewZe+jw3SogWdMAaBY4bKbw8Ue6QUUHY6odRBA9VbI9TGhpLVw6s32sUk8IUa8P+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s0e2+0ZG+9+6++QS3WdWjDHixXiEqVY5OZX3yDwMDDw=;
	b=DhqVip0oEv2LzSC1C4+T9lqkxmb5Dja7Th4w2ntwg4posspUPTkPlTCNQilok+XTEkJp
	 xQ3t4pJOK8hQiqgRvudQOzNwGQYghhwKGGOjbPJpZo37lQA6bODZMCaIS1eyDQZcJoESu
	 D95tzSW1n1+moanhoX0T9bYWEHhLyG2th9ee8Rjw8aueQgQmYLV/nYxRrIcvlAaT+zaLe
	 Qe6dNNba6eQ5mZRSGGoAUDdiRJ8H9nSZuSN0vyv5UNOnwTK9n+5o1CQ8wq6WywW7n4VgQ
	 VDAniMBJvFARpr5k0Q8wB9VeNJ2nkqq6OB4d9pkDKT9epMXnGYyHkRrS7Pv5lzvUdPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hck3yvWy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632E060A2625;
	Wed, 18 Nov 2026 16:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hck3yvWy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92961F000C6;
	Wed, 18 Nov 2026 16:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019831;
	bh=s0e2+0ZG+9+6++QS3WdWjDHixXiEqVY5OZX3yDwMDDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hck3yvWyiQVGxDb9gq4sqeF3NXIZPKDoqpeTBc/9FLvyK2GKLg7aYEwXHSYUDzl6B
	 2k8CVeitiHlI31LtPKiF6TbvF5gfriMj0qOE4bNDM+sQhLasxbn1KA/QIYwRT1B5Ee
	 F97B1uf6c2FEurOM6FwtVAZ2HmisQuChOaPlk+Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: [PATCH 7.3 1735/2651] tools: hv: remove unused rte_smp_mb()
Date: Wed, 18 Nov 2026 15:49:35 +0100
Message-ID: <20261118150350.060560208@linuxfoundation.org>
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



