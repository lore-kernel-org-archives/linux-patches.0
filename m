Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060609;
	b=Cwz9kKZYPhGp3w7SXMlmne5tYl5vv/Uv1h9x3cOQNPqRHvvU6bkmT2iG3kMEtNwHSKnH
	 9VeZuJrXsOdCUqOfYRsj24H87+GSnJF4jdWCoCuWaBQfetfAwgxMwiAzbUiGn296sLDzK
	 zZBg6XQ82uwS+syAnOmMmkD9REj4ZNnX2o3WzBaLR3SXm8ZF4QZB0UWf+AiyxZ7zzOJDY
	 Eq1xJhzue3P20uQX7aq9nCs4k2Brw9udknCMHy6cl9+XCvhuJPRZVda4A3AzS5I/RJ3Rh
	 LkUU6mlyQcyedNK0MMI2PIbRCsycZ93c6XoBHjvOLEjPoLrOtTUqZwtqSFGJAhn8zJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D9ewG1KJaqj4ZZOyOcc2xbUe62xwljy09Q9K5L+I/jQ=;
	b=scRp+WLW5nTZ0oIRJ4nHHxoYdB4xJOuf/EqpceJUoFkW//GLfMPmRruQPRtNFmPypQk7
	 fTD/JBJtZzg0VKmaTFcHJ1L42VCAuXPqKTARnlBeLAVT0lZ+j8m/4yijK21CjTE14uF9A
	 FckOX25A79iJUx4yioKHKiLHoAEc9Yne7jfcXPmQRySQd95YIdAcHhJ9sDuuy5CVokrTP
	 eENwktXFHMGYP3J/tYT33S6e4COS3paQIe5J3bh5z5SqlckSPLaVNmmZFNrvCQHjL8Y/m
	 1x6s11Iv1mm4xrZdeGC4p2ly1QlWRrbQMdRBi83S0QjteZODCZe1iXCujXGT3znH/Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GTEht3SH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4458D606A325;
	Thu, 19 Nov 2026 03:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GTEht3SH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719691F000C4;
	Thu, 19 Nov 2026 03:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060608;
	bh=D9ewG1KJaqj4ZZOyOcc2xbUe62xwljy09Q9K5L+I/jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTEht3SHhWQqFritC92HmQOy95fDYPbZUFrbC9HjxbcxluxtVLdVJrIAdKRIkCP4H
	 uPA4hCYO2qPcQYO43yGfyjls02IaWXHYQFT2lmUwhxroaZli0W6960Kaxw0X74xPOy
	 N7PtB9WaRhRuE0VZY/CHb2z+9Rrvf7xgD/l3Gye0=
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
Subject: [PATCH 5.10 1260/1848] mm/gup_test: reject wrapped user ranges
Date: Wed, 18 Nov 2026 15:54:58 +0100
Message-ID: <20261118150012.473006595@linuxfoundation.org>
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
index 59472ea6aa394..340fc9bb6d0f9 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -71,11 +71,15 @@ static int __gup_test_ioctl(unsigned int cmd,
 	unsigned long i, nr_pages, addr, next;
 	int nr;
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
@@ -91,13 +95,13 @@ static int __gup_test_ioctl(unsigned int cmd,
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



