Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055216;
	b=RtD3Nz9lRBQv5gbZa/8s9AdyEf9OEOTT3CxUihlRjIvw9a4x8WU9gkRJSl8F5oo3e0UJ
	 DKVMSoRMfVyo8Cn4ZhhGYVofPv3uPl+s4RHI/w2vk5n4JMYoC+41mhtrHPHkq6C7sboD3
	 WSfLQQbGNk1YBMxl7d0TD3cFI8BpNOwpL9JIvC20WUCpd43mnpZMp8FWO1RluUL/jt3v5
	 qk4A8OTIN5EFpCyUgUBAfQbq98mjePhZf1IYaFVvdszwEWKgx1XrtwXGufBDnWYp+kd3g
	 ftfz6XCFx9sMo17NSnM1jAkDhsXkOanYdfobVnCW97KbV7FXBTSOMnHjHqG0upWpHhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wp8NQIQ3F4ZVFv6ep81eNKj2t42uYhrTu2DjjY97gm8=;
	b=P2MV+Bt5lw/SPkFxV47GbPN1Dg+QxZ3QKXVbhp7bySUDL7C8MkfkLrIHmiQEf1VXyeQO
	 BQpSYkfTf4fC9CX9x5Ze+giIlNt1j6Wvhob1GqMBgTp/pHbyMwVifaubps/4hRIqrwkZI
	 hqB9tXxY4w95EQ7naMAjYdjx7/o1Qnzifc3pEb3XBFCxogHU+3bGRTYka1JvkLyb5ERxr
	 lFGdWrFJ1kX3PmQQnjG/6Bv5lgpg139OGlRfC/B7nd/0OwcyG+oxPithgMIbqoAPtZXau
	 zXWPHWJC6ex3Lp15DFH9lhOq2KpmAZ59SaFJK2D7bx2SIqABTPsJXUqeqIN//lZyq7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qid78hF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C2E606A32A;
	Thu, 19 Nov 2026 02:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qid78hF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CB91F000C4;
	Thu, 19 Nov 2026 02:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055216;
	bh=Wp8NQIQ3F4ZVFv6ep81eNKj2t42uYhrTu2DjjY97gm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qid78hF3191Sf9PEK429xflN1mbGSLzkH3Jvpd2NN02jdI8+utkIEqXsTxPm4p4LQ
	 gqrXsY9niX80XbPC4nhnpzWjbgpDFWPzPZe9mc24utiWk+zq7bp9ts8Ei5xs7Kd+AM
	 fjBZ2QkgKV7og4t+DBO7cr9TP0tqc8l3kFBWsBrs=
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
Subject: [PATCH 5.15 1511/2214] mm/gup_test: reject wrapped user ranges
Date: Wed, 18 Nov 2026 15:53:07 +0100
Message-ID: <20261118150112.466885819@linuxfoundation.org>
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
index d974dec19e1ca..15074dc772468 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -102,11 +102,15 @@ static int __gup_test_ioctl(unsigned int cmd,
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
@@ -122,13 +126,13 @@ static int __gup_test_ioctl(unsigned int cmd,
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



