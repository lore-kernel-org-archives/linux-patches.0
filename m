Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061347;
	b=Eh/X6/dtlBoYYkzzt0Njczfz6So5ViBJfD12wBn1sk5NB7GiLr7VrWz26Cs9ODgzZzLB
	 G+uiyPC3acp+6VpKPtrdoFghJggQG/66G9rlCkq0V50RAl7iTbll8uwLMF8NhTFxgWQIl
	 xv7/U9X2lR7FCcYhPz/ToXHQa40AA2w+g7e37haD8zVIrpft3w+ZajTjdAOoUq3jI/FH2
	 K0ZfA2nUjVycVp30INjqMvIByxtUsTTLFsQc10wiOJc4X7Yd8+HpJde38/Atg/VxzOp1L
	 D04Z7UjVCYCCjLzzxbRagsh0hbweZ5B4dFmbqK1GrXwal5FyPm5YOCOIRfBxTou8AGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HbX8UOGx8AJ+mI66TRFXIAUXioHP/gxSHQfoS3zbTZA=;
	b=EYQDsZAkoFPPK1pOlKwcwqfzf8KW9K2e9MWCoWM6XwPjdL5gWtM/gI1FaJO/M5b+5+Zm
	 8tVYs792jT+aetPQqJeJLvV9mVRehEfuy4e0BDsek3FGBZhdHP7QBz9d6kmZR90/bBeTA
	 QwZZ4/x4tjLCSGlmyoIyQz+7pfNcgB4dcif8HDbkVeCI5v1uKRN1fRX1TUZFZyY+/hD4z
	 FhtShC8i+DS8EuZONEP6mhfsvboGqDxJqlJw/Ub2RArsKJ4+BnOQVJ12kKSGxC+oDK9kJ
	 3Ksd5fmr6pBsG5wrn/+F0H7PQJq7fJSp9k1BlzW5dMIRInkq5ds/wrUZ/YWRcrAfWRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gD+2einQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1582606A326;
	Sat,  7 Nov 2026 14:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gD+2einQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621F21F0089F;
	Sat,  7 Nov 2026 14:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061346;
	bh=HbX8UOGx8AJ+mI66TRFXIAUXioHP/gxSHQfoS3zbTZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gD+2einQJleA9OBzN9ZVpt1uxOpYiFoNCu0wLAhAurAlmdSJygylHkgr6PPSYtz/F
	 JoHv9VNWF8IDVHvhCxNw+enlb18B+D5ajBSznNSQ0la6sSTI7EmrN1PFJsz0yy33ms
	 PNe1l8Urj2W1CI/oIQFBsBLdFCeM+zN7CVF9vQbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0475/1536] mm: memcg-v1: fix wrong linux-mm list address in deprecation warnings
Date: Sat,  7 Nov 2026 08:41:31 -0500
Message-ID: <20261107135010.841528424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

[ Upstream commit 45b1ec4887bdcc58af885540d9fefa8b67d17d57 ]

The deprecation warnings for memory.oom_control and memory.pressure_level
use linux-mm-@kvack.org instead of the linux-mm mailing list address.
Remove the extra hyphen.

Link: https://lore.kernel.org/20260713085756.2973549-1-guopeng.zhang@linux.dev
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol-v1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index afc9660c9f945..6e4e39a367e57 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2019,13 +2019,13 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 		event->unregister_event = mem_cgroup_usage_unregister_event;
 	} else if (!strcmp(name, "memory.oom_control")) {
 		pr_warn_once("oom_control is deprecated and will be removed. "
-			     "Please report your usecase to linux-mm-@kvack.org"
+			     "Please report your usecase to linux-mm@kvack.org"
 			     " if you depend on this functionality.\n");
 		event->register_event = mem_cgroup_oom_register_event;
 		event->unregister_event = mem_cgroup_oom_unregister_event;
 	} else if (!strcmp(name, "memory.pressure_level")) {
 		pr_warn_once("pressure_level is deprecated and will be removed. "
-			     "Please report your usecase to linux-mm-@kvack.org "
+			     "Please report your usecase to linux-mm@kvack.org "
 			     "if you depend on this functionality.\n");
 		event->register_event = vmpressure_register_event;
 		event->unregister_event = vmpressure_unregister_event;
@@ -2883,7 +2883,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
 	pr_warn_once("oom_control is deprecated and will be removed. "
-		     "Please report your usecase to linux-mm-@kvack.org if you "
+		     "Please report your usecase to linux-mm@kvack.org if you "
 		     "depend on this functionality.\n");
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
-- 
2.53.0



