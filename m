Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483386FE1A;
	Mon,  8 Apr 2024 13:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581621; cv=none; b=nJV8rfWs9dAOeluGNr8jynfJnXzIiz8kObf1PMZbqKSLwpwoVEksmekchXCyGX9IJV5UpF2gZ8nJc8gVDI83xG5MV0bgzps+mY2++fBY2Akw5Mf44iqaOUkTciXTY93JWig4dJL/mcgVv3/DMLVxkEkhfNpG2hFLsClH2xxUoZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581621; c=relaxed/simple;
	bh=VyBE7zcguLspWAK3mHTJUbU6oVJKtsks621M62fFLK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcTdtBuYEOAa7HYtzDojDfp/Yx9HaSXVYw5Ark4mwlEJV36hcFxsSFX7iEBdNob3prqKCs03WiyfgYk9ZT8SKRacLblmFXgZyiWP1aFWwxVZWOKJY5deBgPawMMTOCC3Se5OUPLvp8UcQ12gT7VL7WfJWUQOTuXOcwMVAtzNDrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfNS6oX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfNS6oX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91670C433C7;
	Mon,  8 Apr 2024 13:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581621;
	bh=VyBE7zcguLspWAK3mHTJUbU6oVJKtsks621M62fFLK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfNS6oX/9uKlAMdXBd3Fi/mzNB1Y6SA1IRUR0ImHsQkKLXPEkBUwLrOfOER+drCTK
	 Gg0sc21yK+FCaxZTbqkVBKfm2VvV9Owx/BBPlhJ8VoIN3igj3HvFoNw+lJGBH3I0Bs
	 0IOvqML29TrW60+vUbYcfhqu1vA59SYtQAQRE4Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Huang, Ying" <ying.huang@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	"Chris Li (Google)" <chrisl@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Minchan Kim <minchan@kernel.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Yang Shi <shy828301@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/690] swap: comments get_swap_device() with usage rule
Date: Mon,  8 Apr 2024 14:48:54 +0200
Message-ID: <20240408125401.988153985@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Ying <ying.huang@intel.com>

[ Upstream commit a95722a047724ef75567381976a36f0e44230bd9 ]

The general rule to use a swap entry is as follows.

When we get a swap entry, if there aren't some other ways to prevent
swapoff, such as the folio in swap cache is locked, page table lock is
held, etc., the swap entry may become invalid because of swapoff.
Then, we need to enclose all swap related functions with
get_swap_device() and put_swap_device(), unless the swap functions
call get/put_swap_device() by themselves.

Add the rule as comments of get_swap_device().

Link: https://lkml.kernel.org/r/20230529061355.125791-6-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chris Li (Google) <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 82b1c07a0af6 ("mm: swap: fix race between free_swap_and_cache() and swapoff()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swapfile.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b7e1620adee62..8789d27bd90ca 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1236,6 +1236,13 @@ static unsigned char __swap_entry_free_locked(struct swap_info_struct *p,
 }
 
 /*
+ * When we get a swap entry, if there aren't some other ways to
+ * prevent swapoff, such as the folio in swap cache is locked, page
+ * table lock is held, etc., the swap entry may become invalid because
+ * of swapoff.  Then, we need to enclose all swap related functions
+ * with get_swap_device() and put_swap_device(), unless the swap
+ * functions call get/put_swap_device() by themselves.
+ *
  * Check whether swap entry is valid in the swap device.  If so,
  * return pointer to swap_info_struct, and keep the swap entry valid
  * via preventing the swap device from being swapoff, until
@@ -1244,9 +1251,8 @@ static unsigned char __swap_entry_free_locked(struct swap_info_struct *p,
  * Notice that swapoff or swapoff+swapon can still happen before the
  * percpu_ref_tryget_live() in get_swap_device() or after the
  * percpu_ref_put() in put_swap_device() if there isn't any other way
- * to prevent swapoff, such as page lock, page table lock, etc.  The
- * caller must be prepared for that.  For example, the following
- * situation is possible.
+ * to prevent swapoff.  The caller must be prepared for that.  For
+ * example, the following situation is possible.
  *
  *   CPU1				CPU2
  *   do_swap_page()
-- 
2.43.0



