Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039904;
	b=zh9gdCwBIkS9yxLzPkp7Aw+f9IuVCKV+/xM/FqSH/nlr+3p6xD2gjvNt4o2ulnR1GybL
	 Y+0wBwVCvxPSxOdch+NEplvEJ9K1nq/tUcoJxjaowvN2GyJz8tjY21iGtnbbtQYrc04dN
	 E3dtBTZWc6gdMZkbIBf4LlqHRl60upwsokXSU7LLrIm9K2bteJAnfG+ZhpXjOsP+JGJHi
	 aN53B/D+8SS8iTlhEhsSMcEbmB/cZI+lY/P+OpWOErubVsamf6G3VxF+tKA7QjnlpEgE9
	 +7Wh8F78PeBfSxwRaq2RCcLaWf5INMw2rHXURyeMLX3aCLbRt3S5AVJ6TY4EzKbLTjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1MagEXOyutKiLNO/Qmp83ZDD7/2cxvE0RduhdrVXmNI=;
	b=JPRtKl5gjRiy3Jb4a6Ujj1VWpofJdRV2uAuY6ipmqFH7T9JZx3EsG5VMVeuZOjF5wVtZ
	 82USwwCKl8Fd+Cx8nL6Ty5J+6jnxoB/urILoEMU0d3X/qSQpdu1SmF4I/wWNHafWeIlUI
	 xfx/T+IHJC0J7gTZbfs9lddBnswQh7bwajvAp656r6tczYH4ijjOG2xi/dcYpNnG8NDcd
	 VEpqjMAYG6w6ZccTaZfvJ9o2gsH6XxmSvPNUE6QwnEJ0phKCK+eETQVwgZga/RGYnSV3o
	 SQD8mSPSR0KCLVmD76n0evyWHhglz9tyPG1yJHdL7HY9VI72OpjgIWGXpEK6AJal/Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDD6fs4x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE70606A31C;
	Wed, 18 Nov 2026 22:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDD6fs4x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D6F1F000C4;
	Wed, 18 Nov 2026 22:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039904;
	bh=1MagEXOyutKiLNO/Qmp83ZDD7/2cxvE0RduhdrVXmNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDD6fs4xi+xKTdxbwpSiJXold0M7w7/h/0WmY8Nvuv+DitLpKPGwZ0Irnh3WirF+2
	 Ayr1J7Oo6AbyzV/DozYbqH0L5HZd5roOdKoQ+3qkJ6Wg7djMTCEzJC+w3nudAa0tvO
	 OwzgWf6nnCwpP1c3mH0dYIRBJD6WLVnSVs3VxPuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2230/3318] mm/gup_test: reject wrapped user ranges
Date: Wed, 18 Nov 2026 15:47:32 +0100
Message-ID: <20261118150428.776813738@linuxfoundation.org>
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

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit e8ae6fd67021fafa9205330b3b248c9fc7216e0b ]

gup_test accepts an address and size from the debugfs ioctl and repeatedly
compares against addr + size.  If that addition wraps, the loop can be
skipped and the ioctl returns success with size rewritten to zero.

Compute the end address once with overflow checking and use that checked
end for the loop bounds.

Assisted-by: Codex:gpt-5.5-cyber-preview
Link: https://lore.kernel.org/20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 44817a536aaa ("mm/gup_test: safely calculate GUP batch size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup_test.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index eeb3f4d87c510..c9e7c1cf5b080 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -104,11 +104,15 @@ static int __gup_test_ioctl(unsigned int cmd,
 	unsigned long i, nr_pages, addr, next;
 	long nr;
 	struct page **pages;
+	unsigned long end;
 	int ret = 0;
 	bool needs_mmap_lock =
 		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
-	if (gup->size > ULONG_MAX)
+	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+		return -EINVAL;
+	if (check_add_overflow((unsigned long)gup->addr,
+			       (unsigned long)gup->size, &end))
 		return -EINVAL;
 
 	nr_pages = gup->size / PAGE_SIZE;
@@ -124,13 +128,13 @@ static int __gup_test_ioctl(unsigned int cmd,
 	i = 0;
 	nr = gup->nr_pages_per_call;
 	start_time = ktime_get();
-	for (addr = gup->addr; addr < gup->addr + gup->size; addr = next) {
+	for (addr = gup->addr; addr < end; addr = next) {
 		if (nr != gup->nr_pages_per_call)
 			break;
 
 		next = addr + nr * PAGE_SIZE;
-		if (next > gup->addr + gup->size) {
-			next = gup->addr + gup->size;
+		if (next > end) {
+			next = end;
 			nr = (next - addr) / PAGE_SIZE;
 		}
 
-- 
2.53.0



