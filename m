Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029641;
	b=WrbcJn2pE0zN5VKg3RDgpMiOOaGLchj4ZtDkEPFO0W0AooZW3g1pRHQ7xpCfrl4hdEHJ
	 0R9kvr9PE2m1aWHnZwLD7ottHOy5XsmI2/GYNk/YS1CYlSsD2l+I4vkmf8Jwo18za2tSF
	 y0+pqVaoiuP8iznsahA53DbAbwjdREU1j6SZwPVqNrOS291Aw8IqxfT1RgYbCvK71AX71
	 rx0kA3ZYDozxH1aKB5Tbeowys7Uh7q6/xiOPb/CD6HGxXHJgb+WOBVe414/Y4oUHULMbP
	 5wL0gt3DVl3c/KsvgkKiWequqWhhU/nI0oT+EMcJ8zVtdq4Hpu9TXY0K35CuCQgHRFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AM556WglmscVsHSAZLtpi2Kd7xkAs52EYGyjDExaT/c=;
	b=dXvsmJY2qp7D7Cjg5PpMcr5ucChInihNb29thiezfhk7AdqvyJJOUl0acCUEtCxtcF5l
	 bvgjxsXfwsQvPYm1x5Gjf2AVCWpGLFIH+MvfYd5MFDehY3wBfbNJb8xKq0dXm4mj/2nl2
	 6FBk1p0MjNF3HPTBzvoYH1E7/Z9fUzTsLtmLhKGlhV8IbcAjH46XnieuCGtSny5hSGOIe
	 s6hFL/CayVVERhv7R+m9EfV82RbqfDP0zJbHmCaq5xjVCKPGUR03STb+MZA6ta1aqJtdI
	 CzgxGXB+7fEGksJtZn3knl3GCTwqK37VN2Z32c4wdQ1UfJSqswEI509xK+ZnNRJB9/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flnJ8UR9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91951606A332;
	Wed, 18 Nov 2026 19:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=flnJ8UR9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3481F000C6;
	Wed, 18 Nov 2026 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029641;
	bh=AM556WglmscVsHSAZLtpi2Kd7xkAs52EYGyjDExaT/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flnJ8UR9O0PE+jIFr/bhIcsdv2BJkH777R7Dkv3AezF3LVhtPK8MTc2a9npxpUMwo
	 oLCxffpBhpYNJvSxDo2jh+Nx2XQi7uFXFxGjnv5l7lyKXxOo6e/N6jRi3yuto3OxFz
	 jok0xhpLK4V7lEVQVqsJomIeB2TviMNXwjx/pXwI=
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
Subject: [PATCH 6.12 0420/1756] mm/gup_test: reject wrapped user ranges
Date: Wed, 18 Nov 2026 15:42:27 +0100
Message-ID: <20261118150025.489059494@linuxfoundation.org>
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



