Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050487;
	b=xeHj3qyvdwE26U2nos5EhM/6WrdXQj/UzbuBcJChexB6SJ9W5UnMObgQML8KLE3cn9HS
	 OgoAhIbpt4DDlTBcM6SbHBF8KHly3LprGxZ+CTFUMgL09I1/5E6AuFIWanqfyr87qRZ5V
	 Y48bNfLpWgA1k65cbGDpOICGh7TjDrQOQJ8wQEHZzRx00y90acGJi/duRpsVNR4WMvlSl
	 3wDQ+HplS/s8KfRqcLvKlL2VK4IBc560h5obsWTBvrX6jTCftJfDDyWDzgww54UkLd8fh
	 bBcbxTEpJcrUN/WmBMV0wZ6eIdBQ4SkiweGTXg3SvlSH3z/y37n/VopmtAuENf7jd4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cxh9ibQn0nz4iOGWE76Tanhu+EewYkYMlFJjcvvuUnM=;
	b=mzA/rQhFDOXS+ooDfdC0v3KMkGSg+da/Wn/GLglgHRaRQ+9LmzIFAeMxKT9RhowNquDL
	 +O0o7pugkR5kTKDh4Po/nRqUcYt6OjzJslH13BoIOW2Mk6nA16ysuoeTRouQ3Qr+rtwkx
	 y4QYNzxwHTeAvAVTsPbJSGEy/wupeKwq35JZG2x2nM0zpchnMhp9dQHMrg1LsSLrRq19o
	 D5J185qi+AS15JrTKJ4IBXiku5c6xYPRq+Sm8l1fPxCLhzmc+irWw9RO5HUXenjLHRa7a
	 By17cTRpyhB2IZql+HNSwDl5C8HFb3dRWAyO4ioJy4U6aBHzMTpRXj+izWNeaGTiytQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3dvMbDi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC56606A325;
	Thu, 19 Nov 2026 01:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I3dvMbDi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7721E1F000C4;
	Thu, 19 Nov 2026 01:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050487;
	bh=Cxh9ibQn0nz4iOGWE76Tanhu+EewYkYMlFJjcvvuUnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3dvMbDiKiJMuTydVkl6CLdMHIiahTEouiaHp+JevHsgzIg9QERVCnaQHX6kyg/t8
	 WDdFks3fupa7tEEmwrWF6j4djkGRwBG+5i5h9Y9UFK4TtpnXMLzM1W6p9UNMFd6plN
	 L8VtuUj1LNeir6AsBua+Q2QHsTTP1/vIXdx3Ol1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ren Tamura <ren.tamura.oss@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2726/2857] tools/cgroup: sum shrinker object counts across NUMA nodes
Date: Wed, 18 Nov 2026 16:02:40 +0100
Message-ID: <20261118150339.774008726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 706ab27666a43..1d634a35e0959 100644
--- a/tools/cgroup/memcg_shrinker.py
+++ b/tools/cgroup/memcg_shrinker.py
@@ -32,7 +32,7 @@ def scan_shrinkers(shrinker_debugfs):
                     items = line.split(' ')
                     ino = int(items[0])
                     # (count, shrinker, memcg ino)
-                    shrinkers.append((int(items[1]), shrinker, ino))
+                    shrinkers.append((sum(map(int, items[1:])), shrinker, ino))
     return shrinkers
 
 
-- 
2.53.0



