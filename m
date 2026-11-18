Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028793;
	b=hE2uY5AusWj+5SMSV7JS4q0UKZku9sik3BZJ5GIGM48eXSec9i5mLU3o1ufJqJ921vL+
	 7NIeqztpXzI5U+ZBko/1aNJxXZmhg6RRXOv19Qc6LeVnsmQwftYeF1Ea8rZBmqnxccIei
	 EJINLTAsfvEDgVNAN51MkBGykTZLLYlVDhkX0X3ObswAkJrj2KCmwR5fbvqhQrrYc6Odb
	 I4uaGig43ha4hns/jOQWW8ML9rs0VxD/QMBcddXXoqTrQQGv1r4RB4B4MYhGVyUqyanit
	 nF3Gqabq/CqXTPjhM+6f4taho4Jr1S/LWXaloRTD46CWhecXKJcyM0gKOHJRmJ9Wi6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z62x1yM/DeQwjaTKvW2xxw8s6rCwqVdem1YsnBjbxTU=;
	b=kdP83kGGza8/W4Q0vHVBO8q/27hpNLfjdK34uhYg9wnHCDWr9JyMT4BWQgpG74vE5YOl
	 f2RDE20WTtQLv5AyAAn0LdUpUNT7Mzl/WHhyuwTB2aYybbCNvIn2SSLxkely5UlmL5i1q
	 ZPeXjMhRKsSXPWx5FeSyV6kMIoTvCA3poNXYkXUjJLJ1IgFo+79J0OkS7+vBqpDntUNaI
	 sZpA5gtRKzKigDOke0/AzAk9dQsCAVCjCYTquEIuPkdMZ5JUozL02NSA2+2wrtuyNfmwO
	 aa9oEN05uk1JwBl2xwUzdWHGwaPXIMj/8Rgg5k3JkrY1sMZBWWYuPynyW7HIhbGhTxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1L+IA5b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B49606A334;
	Wed, 18 Nov 2026 19:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1L+IA5b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D4C1F000C4;
	Wed, 18 Nov 2026 19:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028793;
	bh=z62x1yM/DeQwjaTKvW2xxw8s6rCwqVdem1YsnBjbxTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1L+IA5bBnOJ8aGwd5eSA4e9vE6UZ6LlF4q9Q5ix0RUNlYzRzP+UL8/AvuYTBghze
	 lNJJrkNLWMVKqeZftAJOhe1Lg8W3+AUwrphLh6JNeOAtNruKX10SI+UC+uZBezXq/1
	 smpbu6kx4O3YXMslKt1zGwG2jbsg2D/OJ4Dk9tZQ=
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
Subject: [PATCH 6.12 0122/1756] mm/cma: accept memory of CMA areas reserved at a fixed address
Date: Wed, 18 Nov 2026 15:37:29 +0100
Message-ID: <20261118150013.032102750@linuxfoundation.org>
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
[ sashal: placed accept_memory() directly in cma_declare_contiguous_nid() because cma_fixed_reserve() is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/cma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 2d9fae9392835..4a0616bb12b77 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -313,6 +313,8 @@ int __init cma_declare_contiguous_nid(phys_addr_t base,
 			ret = -EBUSY;
 			goto err;
 		}
+
+		accept_memory(base, size);
 	} else {
 		phys_addr_t addr = 0;
 
-- 
2.53.0



