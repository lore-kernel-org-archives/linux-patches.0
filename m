Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048423;
	b=S6Yv668CARlPRyzOlDsFl5mY/hL8XGIFZ0dBvM0sEVZgBdRoqs+XGciCmZGIohOWoGxK
	 xBswq33vf3jb6hoOH381wgjSFfnORiEJh9I/17jpU+QhSodaV7e5MaD6y16Y/skI+l2rc
	 Z9k9DBZtjKMLiSCBV1ht8nTNDrTN+Zg1w09ESJeuznJVI1/IQK0dqWH14ogiuQos/mXXJ
	 vWWL++thoKFSGBPMiteYsY6IxcvyiCrs15Vk9pI0TFjcCMY+l6qTB87Dz7BrDXmOZjKZl
	 mepR56/2tTlmaJfcX7AZQPSw3Gi04yAla8RmcYS3AfPrhw2wQqID+b8/YarvmuIPO/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xlX3ffAoDT1x4oeYsvs8I85mF8o5xnMe+PkuIZ1V72g=;
	b=zGDIlFIknM5N1NfRP1rhaz5ZT7wyRqCJx6zMdQIEZPQoIgduqcPwLO4lswrtPy3MLWlD
	 FxhM0HpOhpyZMADNGSaEzjQ/gh5fCWR0hySQr27kbl0ks+As5W3V1oMS3F97EBPX4qeDk
	 PxfL1u50uLP+NKaO0BT9pXZuBtyYshM4ZfosdvA967Suo8EJYDaJBLvKTclnI9XJqWX+R
	 Rey5al+CynOaMRAqri5hcgGxUqVJ79VAhrnioBbvY8MFo8sA4WMrEhiw/teid5Ylr4a3H
	 h7Xq3F9QEy8hP6chgC6mUPCgw2z5+rXcimLIF50pWAvXORC7a5849w9eDkMVUhnH5Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wlBWSbX0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23989606A325;
	Thu, 19 Nov 2026 00:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wlBWSbX0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B49A1F000C4;
	Thu, 19 Nov 2026 00:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048423;
	bh=xlX3ffAoDT1x4oeYsvs8I85mF8o5xnMe+PkuIZ1V72g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wlBWSbX0SUbnFTwFSkK/VFnRrPtIGUGmEhDd9ApVe8Ctr4t2PGF4s60NSnQxX8t/4
	 kYP59t1fnMU5Ru2wd/myQ2Bq/3RG5NLTfD8t/IXwyyT9wwlqK2iTHwP1+k3Su+n6hl
	 aayLa35qoQgYN+8Ahf/zxf3EHV2mecsmCARPkBlw=
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
Subject: [PATCH 6.1 1948/2857] mm/gup_test: reject wrapped user ranges
Date: Wed, 18 Nov 2026 15:49:42 +0100
Message-ID: <20261118150311.511975336@linuxfoundation.org>
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
index 12b0a91767d3c..2a8082ae55d68 100644
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



