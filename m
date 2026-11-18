Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054449;
	b=3POtrXJcTCPGTkucLu21ku33AQHVZDN3HlWe+LzcoTEwTHFHYD69Y3dPuHIdMfbZk/Tx
	 9TL+FkTLzzHHwLEXURrHjPx2lIr6neZ0rAUuo6Lh6Mfpz1fWqhQBEH0oLsff6CzDKJTS+
	 Fy0BYSIkHLX9IvyyfoQFQht+ZdzE4lwGfVgrZXIW+SFUR7zy0gaH2XGRulFFc82y/xdNG
	 QES9x3bmrENzHfMAjDqFH/j1o3aIpyXbDWlzqRdWMTS2iD4ld2ca+nju6S3h4LVSvfWsT
	 laC2tve5sX1qPJNqhIqlFcJs9BKHlduvWsMtJYaOkd4YkZ1GkgN4yVp/p08aCs/PFsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dbxMXk1A1nBgOjWQYy48ckUKMy2+RpJNQl+lqe5DrFA=;
	b=ZjTEdQ2H1UfPtUQVwdwSbsCaTm7abrj3Au4aS//J3mvCKxDCnhtFg+A+nt7JUNm7vxwg
	 r88xc00W0Cgtrtv0Qav1+n3wniSJlCcjk45UEX9MeVx4q36A1CiTfnlz8VlC8VPPwHBDw
	 SvLulbvi/LLBSzNqcQXUeDlHVHcWKeZYffDmzvme43UhsR13uOQfnoSwkE42NUU0PCdGl
	 WnpVTDd6HY/1ZmFI49HaVrnoM9ddTocnU4DVZOc/jX2/FdVLmYhe40PuBo50rdZDNvPyf
	 F8qZ6zxlhWfSeg4GEobCt+FyCdASu4N0GQFZkEE15F86opXBoH5+cR+Tll1rOH9DAIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EMJhDk3x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805F4606A31C;
	Thu, 19 Nov 2026 02:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EMJhDk3x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6BE1F000C4;
	Thu, 19 Nov 2026 02:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054449;
	bh=dbxMXk1A1nBgOjWQYy48ckUKMy2+RpJNQl+lqe5DrFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EMJhDk3xeNXu90mq5nP3Yf12PHp+WcumcfoQF/7t/8zKCkI5rbVnqnxqO3GLcIUPs
	 0qtt/cQtl61Vwvc7xRFlI7siOVgppQVXv8jadtbf6ZdbW8hxW9Cger6q4h96DXZ5Qa
	 XtEl3uPsosqctePuEgLWA3aWK5ibHoPt544X15XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Down <chris@chrisdown.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kairui Song <kasong@tencent.com>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Kelley Nielsen <kelleynnn@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1277/2214] mm: make swapoff interruptible when unusing mms/shmem
Date: Wed, 18 Nov 2026 15:49:13 +0100
Message-ID: <20261118150102.664483211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Down <chris@chrisdown.name>

[ Upstream commit 740128dd1a3f2bd81a80314d079b6b03c39ba3af ]

try_to_unuse() only checks for a pending signal between mms, and
shmem_unuse() doesn't check at all.  That means that once swapoff gets to
a process or a shmem file with a lot swapped out, nothing can interrupt it
until every last page of it has been read back in.

Just as one example of where this can concretely show up, freezing tasks
for suspend or hibernation has to wait for swapoff to notice the freezer's
fake signal, and gives up after freeze_timeout_msecs (20 seconds by
default).

Here's a facetious example where one swaps out 2GiB of one process to a
swap file on ext4, starts swapoff, and half a second later tries to freeze
with pm_test=freezer.  Writing to /sys/power/state then fails with EBUSY
and this in dmesg:

    Freezing user space processes failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
    task:swapoff         state:D stack:0     pid:3175  tgid:3175  ppid:2955   task_flags:0x400100 flags:0x00000419
    Call trace:
     [...]
     io_schedule+0x44/0x70
     folio_wait_bit_common+0x1ec/0x3d0
     __folio_lock+0x24/0x40
     unuse_pte_range+0x2d0/0x348
     unuse_vma+0x158/0x248
     unuse_mm+0xfc/0x150
     try_to_unuse+0x104/0x3f8
     __do_sys_swapoff+0x220/0x5d8
     [...]

The same goes for anything else that wants swapoff to stop, like an admin
hitting ^C in a panic, of course.

Prior to commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
try_to_unuse() was driven by find_next_to_unuse() which checks for a
signal before every entry, so let's restore that behaviour.

Just as an example of the improvements, here's how long freezing takes
in the same test while swapoff is happening on my computer:

                      before                  after
    400MiB anon       8.925s                  0.028s
    400MiB shmem      1.639s                  0.003s
    2GiB anon         failed after 20.003s    0.011s

Link: https://lore.kernel.org/at9kJwdGkHPsWwgG@chrisdown.name
Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
Signed-off-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Ying Huang <huang.ying.caritas@gmail.com>
Cc: Kelley Nielsen <kelleynnn@gmail.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: <stable@vger.kernel.org>
[ sashal: adjusted context for pagevec and frontswap accounting while using the existing retval return path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c    | 4 ++++
 mm/swapfile.c | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index cc5b08d9802cf..04363ece9ecf6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1285,6 +1285,10 @@ static int shmem_unuse_inode(struct inode *inode, unsigned int type,
 			}
 		}
 
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
 		start = indices[pvec.nr - 1];
 	} while (true);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 04f10e9c36c54..b8dcfdad0e7c7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2039,6 +2039,8 @@ static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 	pmd = pmd_offset(pud, addr);
 	do {
 		cond_resched();
+		if (signal_pending(current))
+			return -ERESTARTSYS;
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
 			continue;
@@ -2275,7 +2277,7 @@ int try_to_unuse(unsigned int type, bool frontswap,
 	if (READ_ONCE(si->inuse_pages)) {
 		if (!signal_pending(current))
 			goto retry;
-		retval = -EINTR;
+		retval = -ERESTARTSYS;
 	}
 out:
 	return (retval == FRONTSWAP_PAGES_UNUSED) ? 0 : retval;
-- 
2.53.0



