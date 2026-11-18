Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042523;
	b=FLTsdYgyOuQ2oJdiGko0bbypv6sbEdK/sVW/fAqNRoKTT0cQosn2b2PgEpWj80nn3UT1
	 tb/ZBbfqzGGUWtij881w+VZD++1gMmQ0c4OEvyQcDs6xDNW10uWNHhqi9cM1XX5ZYMt4V
	 UfukRGZnUxqeKLR9t/5RRQ/Xy59Zt9yNIP8CCJEjaobX63060IqWDtAJx38aAKHmqlEAy
	 7gkNwRCErK6niIh6bi1hE6pOEt8HkxsSsAGXWY9P7pQBvN06RNvQk9gfglX9FgZHPjc5d
	 Sd3HO5AZUmOmsvHKRy4++vcFJ2JPXgVWqFWh+uJrTrjx5tDCCijyHSEcWj96HEmGFwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KORcXoQV7h890f5jH2C+fHOOXt1DP9E+O9s3KbpoiNA=;
	b=BbS1sCbzOgd0dL6vBC0eqEx84m9CsuORUjylj/x0FONwmaOyMYWTqCzYsV6bBlERKYAR
	 g93JK7crAY2maG77ivxoMc/1eE99Dl9vX613ntvbGKd02SLBJIwQ8F0OSrQBxbvA9tCiT
	 kCjdPvpn711xL8UYHxfsmrDtDXWG4u+hMX5jpT/80SDMVuFqeQtrslpLUCzseshsWqacb
	 DwTQbyKED87SkVuFr734JGX3XdYm4XvkVqBXgdww76Tr5pT45uMR6rxITfQDar10vmkjU
	 nZWZ5BtqTPFOZV+UNxyYaQb+OzwOSWoZ1LrlFVK2c188YWCkx/GeKhvBIiiYs9p/DXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DZ2T1QbO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB51C606A32C;
	Wed, 18 Nov 2026 22:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DZ2T1QbO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375621F000C4;
	Wed, 18 Nov 2026 22:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042523;
	bh=KORcXoQV7h890f5jH2C+fHOOXt1DP9E+O9s3KbpoiNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZ2T1QbOsj23K8Ivg0K3qyXbd/DONutjl+lIyQJlAU2JI+j9u23sfOT3WlFAvrRmJ
	 b1BwxIY1I8PDRJadbSm5BKSbKhtepf3nuhkRaRmcv79hjr1MWcWX4yIwQkggSiQVsu
	 bhiMXl08rnjdUJVpPtnWBW/UQWEPUobRM7FsU+9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ren Tamura <ren.tamura.oss@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3161/3318] tools/cgroup: sum shrinker object counts across NUMA nodes
Date: Wed, 18 Nov 2026 16:03:03 +0100
Message-ID: <20261118150454.683770219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



