Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027875;
	b=s1hTYbk+FsR5q8tExvTnBr4ZnorMqmZ+WqcUEPUAiozNABzOlCNmmJu8tFaTbX3tdN+z
	 2N99j0rqFKaDtw8SrfeO3A0EAc4TjTr73FprxfVaL4p/OaGN75pGVbHkbLa+9WmeV6Fj2
	 r33d/PjmTNP0IecR5eZodFi4tayleT6qWI6N025+AAx+ECnZpsSoZd19cgZmG9ITrzPAi
	 nGVCUiB0XuKfmFGVV0PeNBxSnghEZ7N9rnx7vEA6q9eHxRuC/GnxY0YKDE5y7J/7P+wHA
	 rv/MJxbbvKyKwxGyJArjuLbsAsbieP63t/jafD7Ok9jHWmbvK4oWjrDk4REgLd1qfXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g0cNwv5BzCcawW7i49UbOzJS5qukAn1AoecVtipKAXs=;
	b=eStUO0u6iLtW/gcfp1geAOoXH+VJCzMcv7yuSHrP8kJJbkzSYVuj+Co6T6mSt5aeA4gC
	 lO7jk4uFrDgkpZ1d4U6CFVSHZ1LXvh9KfxCRcezFyV/hd8m68ERfzQuZtCXZpk8TUN92L
	 SEcL20BZjmaMJCWJPdcf1j8oEOG5h/LUXaE9u2E0InLvtNwNpL4Zj14SjhOiRLQKI6S4n
	 fodnbRolKs3nVkBL8Y9Ot04x2BvN9Vk/Yjrrg3Uo1N/W9YDaXaVV8cePhfI3aavKmOYfc
	 +zj+DNol3/RApNMh7P67RUyIOZ5npfENtIQQE/QjqXHB4ksQOqg3GQSSo0hhxT5d1CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wk7RdBYC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD6B606A335;
	Wed, 18 Nov 2026 18:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wk7RdBYC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18001F000C4;
	Wed, 18 Nov 2026 18:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027875;
	bh=g0cNwv5BzCcawW7i49UbOzJS5qukAn1AoecVtipKAXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wk7RdBYCjtAlZprdPtpn54titVWvm4ImvWccBMOqVmNrZJ9HG7NueHhk2/XXaKqZ9
	 J4ILrU6XV7eYYzzDMUdE/oxLekiGdzx4O9jUF4qyu+6krF15L7xIgWpvHw9UL8xtgV
	 HuSYGzaz1Np6vrw7bocpoaZavRkFBNEtN/S51Xlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ren Tamura <ren.tamura.oss@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1943/2151] tools/cgroup: sum shrinker object counts across NUMA nodes
Date: Wed, 18 Nov 2026 16:01:18 +0100
Message-ID: <20261118150232.548721722@linuxfoundation.org>
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

From: Ren Tamura <ren.tamura.oss@gmail.com>

[ Upstream commit ae2514c95518b39b36fa463d855c74f29c91d064 ]

Each row of a memcg-aware shrinker's debugfs count file contains the
cgroup ID followed by one object count per NUMA node.  memcg_shrinker.py
uses only the first count when sorting and displaying entries.

This undercounts objects on NUMA systems.  An entry with counts of 0 and
23 is treated as zero and omitted from the output, even though its total
is 23.

Sum all count fields after the cgroup ID so that the displayed totals and
sort order account for every node.  Single-node input retains the same
result.

Link: https://lore.kernel.org/179074810112.139422.9274126921568167859@gmail.com
Fixes: d261ea23533b ("tools: add memcg_shrinker.py")
Signed-off-by: Ren Tamura <ren.tamura.oss@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/cgroup/memcg_shrinker.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/cgroup/memcg_shrinker.py b/tools/cgroup/memcg_shrinker.py
index e81c3017ada96..714772449c6ba 100644
--- a/tools/cgroup/memcg_shrinker.py
+++ b/tools/cgroup/memcg_shrinker.py
@@ -31,7 +31,7 @@ def scan_shrinkers(shrinker_debugfs):
                     items = line.split(' ')
                     ino = int(items[0])
                     # (count, shrinker, memcg ino)
-                    shrinkers.append((int(items[1]), shrinker, ino))
+                    shrinkers.append((sum(map(int, items[1:])), shrinker, ino))
     return shrinkers
 
 
-- 
2.53.0



