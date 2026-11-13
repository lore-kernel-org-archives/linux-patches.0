Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590375;
	b=3LCColUmyZvO8QN/QtEGeebTYt54xt64wR0yB1SRR9Db26EWttDnFV9VB7lixUPXGS/u
	 stUIcl89c2TwIY3awc+BZDoc0lHTlBIJPcQvORlbH+ks063GJqgPJ+3szwp9xLst4EM27
	 KRD+copszfhstik8tJSkk78KUyJbdrsUbVf4I1tSGaVitZqlSB9T8Y1w7VDbA0pPB/qSe
	 QElsP6HOyh8mfeVsC4rfReJPDTtjet5mAnAukO1JsUnlk1/wIViMTeD4DJawp+orBvM3K
	 /GsnNVZ9JH1CKZP8wPzXcZm+0RiCgQ5XO2Uh2t07belAUjR6E19PgxJ93Vv7E+nLcZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9WSrCmDWSy1ZVRWsJs7yg7f8cnawSqiluImbXhzpJE0=;
	b=YxZFRncxolnwP67PElbP3TCqJzlZZfGoDBxNTL1hJ5vOI7volriNT+FZEf3J68rMW2qm
	 /KPZcKJ3wypY5fOb3ILCnSzokPs4EeNCxeEz7of4LpKa3tCE7OAn2NRFZkKTtgSjX0m9s
	 Nziya5iPf45L962lPkDGIs69Qyxb6JuFR7G2Qj/e7ngGK1IVchifaVboHK+XeclOkKfIE
	 3fXaF+rRCgt3cx03VfUot2PUQ2y23C48VXWJhEcKfH9fjfswr0OfXZzbfcQVL1CkH2FXr
	 kTw8bok6IZ8+k/yYomsgVxN/fd5XPXUQzLhRE+AJiC1BAJwRBOG1rkNKlKBui4gtSGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZWyV0mH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA5A606E649;
	Fri, 13 Nov 2026 17:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZWyV0mH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF9E1F000C7;
	Fri, 13 Nov 2026 17:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590375;
	bh=9WSrCmDWSy1ZVRWsJs7yg7f8cnawSqiluImbXhzpJE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZWyV0mHcGFR8urnyoQIXuOUEpt9ajqH3OdfNn7Q1HogPryxZ9MzBI2dR1WJPXELb
	 UxA5Y8QKlhnnEEaQI30ILXeGWB9kHdoFEDBPHyCMqruvdzbXiDbTR1bVFx8I1zDHHp
	 LHwJpbsnzmf7mTdGlVQ7dcfxG+lhc+dnw+FkP70U=
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
Subject: [PATCH 6.18 321/686] mm/cma: accept memory of CMA areas reserved at a fixed address
Date: Fri, 13 Nov 2026 10:47:34 -0500
Message-ID: <20261113153831.811304965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index d829726319d81..f5c9da62aeb57 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -377,6 +377,8 @@ static int __init cma_fixed_reserve(phys_addr_t base, phys_addr_t size)
 		return -EBUSY;
 	}
 
+	accept_memory(base, size);
+
 	return 0;
 }
 
-- 
2.53.0



