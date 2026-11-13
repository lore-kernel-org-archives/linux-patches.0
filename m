Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585621;
	b=Yp9wFhr7fLRKOy+2k6nd3XNAcxq/TM62gcIbHiVhzzgnniHwWsLvfxOMCD7TQs5YIg0F
	 30Klr3VPJDCcrHUbnkr3fb+AVNjE024HJnALMQhMp98hGX0SB6lDjNL99IdGrzpApS7bu
	 T4jp9HJOEklGUcV5GVP3S7N32Hh3JDD5cF2yNQKHl6AA7cJBt733vIJElr/AX8qLhQ3B6
	 Z44Pcn7zrm1FbVwQNZmkFSpuMaaBm3zrIjoy3aoepxbJSPawph3dTRxMR9hT9vnVMp0TN
	 ZOFS1jm2MVT9uP75EkkypaZ4NNCx4160tChaYc3tBQgmV00KWdD8Mva4t8h83uGKTUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JKndjGrSuGEbziLw5tCSNDD/V13ghyVPUS64K3V/JFE=;
	b=ZfqCZzSJCnsFaMcx8MrQajRg6d36nwUXLGFWv0WrjjkPHenFrpJK2q4X6cJPsH+BVwae
	 4gQb4aHp1Hmv8TeqEcyReczpgicG/tDq/a9tW3gQLNsCQHvgJAIxT1lzMRhe/iFYeyAjZ
	 EpraaHEY1zLT2FYtPjUL2PvNk5HamnW56b9hJel/b8Qgg3UdhdGhl6vQarBArV8BlMuzh
	 JGvt4arLNPNMOt9iFIfumS+exto1AetcLPnPnkpzIAsWtIpzzQodUFZHZ+SMlU/0HIUcD
	 NFJFl0LGF4u5f8Tf8IzK3mUK4Uj+X1U8XYM2+gPw7oGJlcf+nwXvkJhcNUoeEpJr7Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ht7SYi3O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86234606A896;
	Fri, 13 Nov 2026 16:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ht7SYi3O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C141F000C5;
	Fri, 13 Nov 2026 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585621;
	bh=JKndjGrSuGEbziLw5tCSNDD/V13ghyVPUS64K3V/JFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ht7SYi3O761Bkw6TSGZ/Y1OJesSzLdF9YkeCCKDIZR89OWWct4vj4BsK4ASv5NvGq
	 Bq0GcZHs05f1uoT0L/vgsQyZGrmQj0dZfGpKQuF73mXbAaXutKKpPwWAh5lCTxMzN4
	 0rwELiIjnCvL+DOzPxAO2TjavRtVZO0T0YSdpPOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 244/507] mm/cma: accept memory of CMA areas reserved at a fixed address
Date: Fri, 13 Nov 2026 10:49:08 -0500
Message-ID: <20261113153802.852256255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit f8f9cbc34a309a388c052706f3329d1b52985aa3 ]

CMA areas allocated from memblock have their memory accepted by
memblock_alloc_range_nid(), but areas reserved at a fixed address with
memblock_reserve() are not.

If a fixed CMA area is requested by the cma=<size>@<base> command line
parameter, it may be in regular RAM and on TDX and SEV-SNP guests it
must be accepted.

Accept the memory of fixed CMA areas as well, so that all CMA areas are
accepted regardless of how they were reserved.

Link: https://lore.kernel.org/20261029-cma-multi-v1-2-2cbced8b5cb7@kernel.org
Fixes: 75d090fd167a ("x86/tdx: Add unaccepted memory support")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Tested-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 0035efb1130a5..f61d52796f4ef 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -381,6 +381,8 @@ static int __init cma_fixed_reserve(phys_addr_t base, phys_addr_t size)
 		return -EBUSY;
 	}
 
+	accept_memory(base, size);
+
 	return 0;
 }
 
-- 
2.53.0



