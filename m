Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023698;
	b=plpVR+yE+UgUxEe63YtmErtu/5K0rm7vWEZfFPSSZvNtf+/xyCLn44S3tKycFGxyAzL8
	 6tkGnxyNE1rUWLONhf+OrsnzoKm6MpP/tttGXKAB7cYbsADHEDeHRblJkqClpsds0k6Yf
	 9L6SVvhR020qYjuY1b3Nfz6eWhEXdCEnxew2zLjnxQJYVNzFFaKG2+aj0USd6wI/moor8
	 TMKD8uvCaNXqkdu8txMvuNEucwsEYTwvrm8F/OE5wanvW+VQYph1El/1cP1Aoed1wZDvO
	 XGLZCO1ydGNZ3hBbcBnGWTST/XUEVMo1Hh8kHFzCs0RVuDOjoLC+DrFpbP8dLo09qZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zLWz1jc9A+odNk49gzonSy6a1bxX77nAQWlf3Vt9vHk=;
	b=f0p9pkhnuIk8ZkxmvknuemmgYv9isRtdHoO1azAKke/Cn0gQON30hbCzSjiaZL1pop0Z
	 GsfVDCz64ZN6Yh3x6agzqoGOfiYvvVBH5DO2t+G3h1j4oCEygZB25/M2FNc+r2osKyGX7
	 XxE2nLM6LE2aV17BJT2p+f/W6RGpQYKJNYRcRv6ZRaTMx3+TnMMfCQJoPuuqcAiXI9kRg
	 dm2/pbsh7WidUXiYhj0xtfVK2E1r5Oee3M/+DzYaOmkUKW8cO6NmV98tkY1ekg1o0tx7b
	 tBP7GdYm+Z7J2UwgHNQy61azFF7h0W5s89IJavCN0JTIhfAGGwjGeCBA7jgnogfDTVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Dl/NwPpG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776E0606A320;
	Wed, 18 Nov 2026 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dl/NwPpG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39121F000C4;
	Wed, 18 Nov 2026 17:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023698;
	bh=zLWz1jc9A+odNk49gzonSy6a1bxX77nAQWlf3Vt9vHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dl/NwPpGzxnyq3+ujEvbQawD1xx9RYOqtCjQN42X3QHLwgyYdefmx3OCp5+yvBzsQ
	 rlF11+Fgw94jjVdtN2cXszumwY8mqQ58z7JRAU0LVZC3q3HsXVGYL0Mnvrkd7Iof7P
	 xAKkrnkM6zXe3F1to96MarhqJH+y7EZSh+RbCYEM=
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
Subject: [PATCH 6.18 0461/2151] mm/gup_test: reject wrapped user ranges
Date: Wed, 18 Nov 2026 15:36:36 +0100
Message-ID: <20261118150138.817816711@linuxfoundation.org>
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



