Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060086;
	b=BDltesghs/4n6k2H5sq/ApC8akPSYm3TnVTUAYOoZJ81/iTQ+PNsxnds1gtfvHfef5hh
	 0FSm/BwZ2STaV1GXMpYirNpdjoEdFkWYNaU0evhbI0lzfP+bzKAnynxB9TFI2JMZoY6KC
	 0Zz+nQxY0UqJ1FtsjW9B7HAIGHYXRNGdKmAMyHownw8ZzkMBWzZcFg+0t1aEl+EYkexEp
	 NnNAqYl3WQfjgv+wvhAoO/yWseDOfxX3KpYWREWoWulUUwTuwF556uJTRv/zWMhTbVgup
	 hE7cr5LKPLYHBmNRfqP9Mbdj6S30YeZ/D2j2imVucq8VWKbozAVc/Gw791k95PgsQ4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qkKq4m3B8m6D1dIQSCJxR0/Wkb25gm8H6BFV1a4Av5s=;
	b=u2UpQpyYkIvvClGjzZpHLopoITJAXlpQC7A1ORKmXPqMa78H43xKh4H7L+qi/zJHQT9Z
	 Ls5GIqUV9BzXgaoqIdQtMmu96EX0uDe0HkFOdTjfFrYV563ndK6xO7S0bgz2KjjS0bgNX
	 /hyBdfhFn2m1ywWY9p4aM0oQJiNlDB4UhXqJD0oWsFix2+aZEp5jZMmkMZLx3y2e1s5oG
	 CCz3OHGr/dlP0aaitQCodFp0eNnrKzv+js5qMmZrjC7pUZdcL0y6CNdbSWGew/T+DW0Um
	 L4MXJhlB406YMvJ/jvmnb+DE9uIpvTmHYlFi87/B0E6Q/v2tBGsoxMTiAr+ds6rT5jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VDecP6jO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A66606A326;
	Thu, 19 Nov 2026 03:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VDecP6jO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FFC1F000C4;
	Thu, 19 Nov 2026 03:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060086;
	bh=qkKq4m3B8m6D1dIQSCJxR0/Wkb25gm8H6BFV1a4Av5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDecP6jOdqvYjvI2tLBKR03jebj35ICpsUg/BCzTtscSkjwSrazboPx2DsTxVGMKb
	 Fq5Qg2BDdDKf+BjHWYy8BbzcQhCrDdZSXejMwHoUYz1T0AbdnVXPj7zWQZfopVu/B8
	 VZ3j7Kp0lo1zAiRs6CstTM6osivB2VI8Z3AH5b6s=
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
Subject: [PATCH 5.10 1074/1848] mm: make swapoff interruptible when unusing mms/shmem
Date: Wed, 18 Nov 2026 15:51:52 +0100
Message-ID: <20261118150003.006838077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted folio-batch context to page vectors while preserving frontswap accounting and the shared retval return path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c    | 4 ++++
 mm/swapfile.c | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6f2e267aa092f..8858db132090c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1305,6 +1305,10 @@ static int shmem_unuse_inode(struct inode *inode, unsigned int type,
 			}
 		}
 
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
 		start = indices[pvec.nr - 1];
 	} while (true);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9c32c0055cbb1..79b3f0d034a42 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2048,6 +2048,8 @@ static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 	pmd = pmd_offset(pud, addr);
 	do {
 		cond_resched();
+		if (signal_pending(current))
+			return -ERESTARTSYS;
 		next = pmd_addr_end(addr, end);
 		if (pmd_none_or_trans_huge_or_clear_bad(pmd))
 			continue;
@@ -2284,7 +2286,7 @@ int try_to_unuse(unsigned int type, bool frontswap,
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



