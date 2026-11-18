Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032845;
	b=WfB8xeRa1KN0KbGKSO4SFAx0FGnHlLhwZ7Xq07WuO5CeFXrgw2yplrGIkhRqKv6UBcmp
	 jloQC3UosG1po3JumiBfnz+WDnn47NzV/tBuKFqmzNHaXSw05of6+IWOtJ+xws9y0AoFV
	 CJXEG+iNBrvMMYAtD2pvkLd7XPoOQkRepJdMyDxpkZtrqcsfer4xQVuVsTlSEFIYDnqLt
	 mPw4CsrxF8AmcxUTf7mgzril5P6Dt4Lb7jj0CYq7em2oce45X7tg3pu4/sn40baENwly6
	 q4rcn6/oQ/0CbIX9KOnk1LnzYhNEBqaXC+AB7qP4qjA+16YO/BN+1KP1l9Y3ylH45Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aM3wMlXYBL1w0cNaws23CXm68Wg/N3XyI9BuodYmAVk=;
	b=I9YEbj3XlN9GyWuDN2xLfdGmOrDQeZg1rmcOSBMUlLETs6PKuT0k8eCDuU0ummLVP6vM
	 j2qSGvN1QDNH8cDoRbPc3JvnUKUwUUj9sW3PwKZEeodnpv/Yf+QTrYxSTZuPKd4csRDTy
	 Aq2scQwuNB7tGd/yUZTO3tmjdlq9SOMOnSI/SHgmrIzbx8o3boZiKQX/GYP73swuI/dtf
	 GA0ecRGeRbXOS2SHTSJTKOo+stk8Wp+FWqGpXAXG+etIvMZCSchlKvdaVrskOckemWPKS
	 UJ0Qgo1FoAFGQoSzMc9TwS+hBs4bRykfT4eBTvnXnvH1cxyL+qkXsbDF2hkse0S5igA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2FkMRl6k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F39B60A5BD0;
	Wed, 18 Nov 2026 20:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2FkMRl6k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE431F000CA;
	Wed, 18 Nov 2026 20:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032844;
	bh=aM3wMlXYBL1w0cNaws23CXm68Wg/N3XyI9BuodYmAVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FkMRl6kMNas/gbbpayUW4AyY43PEx9s1k3/aHns2nY/Q2lj5dGv00WGK7zxEh8Ry
	 Nxd7bjOd2rw3V5GHNbmkuFKwnJyTLyWeQ7psrxVq11JZnCJA3gEu5gl+NfHWHChO0V
	 xCLQMYv3nosBpzAMM6/PbzwXz5pes0eTFodk19I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ren Tamura <ren.tamura.oss@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1554/1756] tools/cgroup: sum shrinker object counts across NUMA nodes
Date: Wed, 18 Nov 2026 16:01:21 +0100
Message-ID: <20261118150111.018112115@linuxfoundation.org>
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



