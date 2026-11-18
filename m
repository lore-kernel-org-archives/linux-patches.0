Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043955;
	b=aRTnqrQ0Y3G5xESsXDtdV7t8qE1diACo6fCPFFSaB5LPwm1o7LYiQMCQ2a9IyjvLlRSK
	 Qd+STjVyjCiezBb/kO1YIb5Fifpkq+VKwAXTrOtFjt1xYM3hvUxXKvu1LR51g/slMlHNb
	 OmpVAmttpBxA/kpnoT0Sh1MocktXWxmQFX8Lo15+QnbaLyWkar6Z4DWXuizv9zgMpzQsZ
	 TazGeeITDctC/tSgHIRruxhSN4ZCKfZ3gRPIzlaPpST8V58LlB/7qPhkclXSm2Wjq5DZ6
	 4qHegVa/vhVQLrbUnT7DeZZ2+rSRKlMzLAFVVWBPuZphXOoiwSa2XTXNqGx1VLoq68Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wQDRf3p7M1bR+LeMSsdbRttnu6YQQtw42GHGHuW+td8=;
	b=lykvHqi6Bf1CY5Gt8BmkS7tDK8iUTR0Fbek9C4iQ9y9gui+nQ37DelSyjjc8yeIY1AY6
	 MXB13/ggddJlObpTNkDg8a1iKewZfmU5JUin5K0b7RxdwQS4yu/8EsmXHyP29deYTGeAI
	 tQoPqHRondcfX9y7W6l6OW3j+4wj0+AEBcIBS6g/2j7lrkoxJyf2+wHRTQjkZLy7RTb/b
	 ywo5Hrnx2lE44ijC6q/psWgNKCHE6+NbRONcl0EZiZhxChjZDDG+qRYl1Ewwi5+mEJ+VO
	 cZShJ4A9k4RGwi5CGatPWLlmKmHfgwqf3CZvbxuUrhenTGpPeqEirJ+9zcV0I0l9gFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UM73E+EI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9776E606A31C;
	Wed, 18 Nov 2026 23:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UM73E+EI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CB61F000C4;
	Wed, 18 Nov 2026 23:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043955;
	bh=wQDRf3p7M1bR+LeMSsdbRttnu6YQQtw42GHGHuW+td8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UM73E+EIPaJs9YpRgUwL53TARcTF273xeNZpvrG9T0fVPN57KsmaUtb+lGeCCtjPh
	 o00XlgdxFa6UJPIY3AlRgXt4bgR4pv2JwokZLmdWNjWz7gioRG8UMhYBNRF030tpJh
	 9wmMZ42IHgxu0C0ibMqPVGjugZVoqtvCVY/lLMw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <kasong@tencent.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0394/2857] memcg: make the v1 soft limit knob inert
Date: Wed, 18 Nov 2026 15:23:48 +0100
Message-ID: <20261118150215.580668313@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

[ Upstream commit a3417097fb107cea3358b19bcbb4eb655fd67f8c ]

The v1 soft limit has been deprecated since v6.12 and nobody has reported
depending on it.  Start the removal by decoupling the interface from the
implementation: keep memory.soft_limit_in_bytes, but ignore writes to it
and always report the maximum value on read similar to what
memory.kmem.limit_in_bytes already does.

Writes are still parsed, so malformed input keeps returning -EINVAL.  The
knob now also behaves the same everywhere: it used to return -EOPNOTSUPP
on PREEMPT_RT, where soft limit reclaim has always been disabled.

This also fixes the syzbot report linked below.  Soft limit reclaim is the
only caller that runs shrink_lruvec() from kswapd against a specific
memcg, so it is the only way to reach lru_gen_shrink_lruvec() and in turn
set_mm_walk(), which warns when called from kswapd.

Link: https://lore.kernel.org/20260811203203.3456029-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ sashal: Applied the upstream soft-limit changes to mm/memcontrol.c, since memcontrol-v1.c doesn't exist here, and took the upstream doc wording over the older text. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/cgroup-v1/memory.rst          | 46 +++----------------
 mm/memcontrol.c                               | 40 ++++++++++------
 2 files changed, 32 insertions(+), 54 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 40164f2881e17..e186b4e200a94 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -47,7 +47,6 @@ Features:
  - pages are linked to per-memcg LRU exclusively, and there is no global LRU.
  - optionally, memory+swap usage can be accounted and limited.
  - hierarchical accounting
- - soft limit
  - moving (recharging) account at moving a task is selectable.
  - usage threshold notifier
  - memory pressure notifier
@@ -75,8 +74,9 @@ Brief summary of control files.
  memory.memsw.failcnt		     show the number of memory+Swap hits limits
  memory.max_usage_in_bytes	     show max memory usage recorded
  memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
- memory.soft_limit_in_bytes	     set/show soft limit of memory usage
-				     This knob is not available on CONFIG_PREEMPT_RT systems.
+ memory.soft_limit_in_bytes	     This knob is deprecated and has no effect.
+                                     Writes are ignored and reads always
+                                     return the maximum value.
  memory.stat			     show various statistics
  memory.use_hierarchy		     set/show hierarchical account enabled
                                      This knob is deprecated and shouldn't be
@@ -326,9 +326,6 @@ memory.kmem.usage_in_bytes, or in a separate counter when it makes sense.
 The main "kmem" counter is fed into the main counter, so kmem charges will
 also be visible from the user counter.
 
-Currently no soft limit is implemented for kernel memory. It is future work
-to trigger slab reclaim when those limits are reached.
-
 2.7.1 Current Kernel Memory resources accounted
 -----------------------------------------------
 
@@ -687,41 +684,10 @@ For compatibility reasons writing 1 to memory.use_hierarchy will always pass::
 7. Soft limits
 ==============
 
-Soft limits allow for greater sharing of memory. The idea behind soft limits
-is to allow control groups to use as much of the memory as needed, provided
-
-a. There is no memory contention
-b. They do not exceed their hard limit
-
-When the system detects memory contention or low memory, control groups
-are pushed back to their soft limits. If the soft limit of each control
-group is very high, they are pushed back as much as possible to make
-sure that one control group does not starve the others of memory.
-
-Please note that soft limits is a best-effort feature; it comes with
-no guarantees, but it does its best to make sure that when memory is
-heavily contended for, memory is allocated based on the soft limit
-hints/setup. Currently soft limit based reclaim is set up such that
-it gets invoked from balance_pgdat (kswapd).
-
-7.1 Interface
--------------
-
-Soft limits can be setup by using the following commands (in this example we
-assume a soft limit of 256 MiB)::
-
-	# echo 256M > memory.soft_limit_in_bytes
-
-If we want to change this to 1G, we can at any time use::
-
-	# echo 1G > memory.soft_limit_in_bytes
+Writing to memory.soft_limit_in_bytes has no effect and reading it will
+always return the maximum value.
 
-NOTE1:
-       Soft limits take effect over a long period of time, since they involve
-       reclaiming memory for balancing between memory cgroups
-NOTE2:
-       It is recommended to set the soft limit always below the hard limit,
-       otherwise the hard limit will take precedence.
+Use memory.low and memory.min in cgroup v2 instead.
 
 8. Move charges at task migration (DEPRECATED!)
 ===============================================
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f3ae313fa8645..478c153749139 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3689,9 +3689,32 @@ enum {
 	RES_LIMIT,
 	RES_MAX_USAGE,
 	RES_FAILCNT,
-	RES_SOFT_LIMIT,
 };
 
+static u64 mem_cgroup_soft_limit_read(struct cgroup_subsys_state *css,
+				      struct cftype *cft)
+{
+	return (u64)PAGE_COUNTER_MAX * PAGE_SIZE;
+}
+
+static ssize_t mem_cgroup_soft_limit_write(struct kernfs_open_file *of,
+					   char *buf, size_t nbytes, loff_t off)
+{
+	unsigned long nr_pages;
+	int ret;
+
+	ret = page_counter_memparse(strstrip(buf), "-1", &nr_pages);
+	if (ret)
+		return ret;
+
+	pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
+		     "Writing any value to this file has no effect. "
+		     "Please report your usecase to linux-mm@kvack.org if you "
+		     "depend on this functionality.\n");
+
+	return nbytes;
+}
+
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
 {
@@ -3728,8 +3751,6 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 		return (u64)counter->watermark * PAGE_SIZE;
 	case RES_FAILCNT:
 		return counter->failcnt;
-	case RES_SOFT_LIMIT:
-		return (u64)memcg->soft_limit * PAGE_SIZE;
 	default:
 		BUG();
 	}
@@ -3870,14 +3891,6 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 			break;
 		}
 		break;
-	case RES_SOFT_LIMIT:
-		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
-			ret = -EOPNOTSUPP;
-		} else {
-			memcg->soft_limit = nr_pages;
-			ret = 0;
-		}
-		break;
 	}
 	return ret ?: nbytes;
 }
@@ -5026,9 +5039,8 @@ static struct cftype mem_cgroup_legacy_files[] = {
 	},
 	{
 		.name = "soft_limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
-		.write = mem_cgroup_write,
-		.read_u64 = mem_cgroup_read_u64,
+		.write = mem_cgroup_soft_limit_write,
+		.read_u64 = mem_cgroup_soft_limit_read,
 	},
 	{
 		.name = "failcnt",
-- 
2.53.0



