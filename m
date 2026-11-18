Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029785;
	b=VUPqU58LheETF/zqYL2+F+xmX1LCy8JjxS06BOXFg4dmxVCl7kVKH2oBLSWc0xyIqNwI
	 lAcX7vnQIDWtNMARE/+tUagFMBEnMFYcIufN/KgS7WHZIO6knRHzWzJ2H52x1ZofVOB+G
	 JSkTB7uhIqrmw5fGQyraAqnWEu3mo7Bz6aFwujkG726HrDxus7rtz/3jedz5rY8zjAjI5
	 Ras1Rx0HWoxmhRQczorIcb6zh3hRheH14k1HWqhCcdNH59VlAnuStu1qNkUbtlVcAmI4e
	 bnKIxaHCa6xPKCzO/ypKMQ0ndZ9bkuiQg35ZZDBI47osaMPvPgtnSSnw1wEZJ+hoWoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZOIf7SRa7LQ0rw00idGiZDc9umEYkfVyQkmnqYjD+XM=;
	b=YOwjtypg/+Y7aY4CgMmKoA8QHRsYCkQr44Dil+q3ZLWbIZO3erQ3y8uJcyN4b4zcLxP7
	 n+hCY8f5kMvmBFebEuQzfLybNoE2WUPmitRDPWxjSusk2eoUyRapNSSOymE4Jg9jIY8l6
	 by3PDzQzFfQA1yb4p1OmTfapHZvm8g3dFVJ6k52v2oNZ1YdSb8VBwUFT+x85ABxAN+TjO
	 ALBe/NCioMx/vxp3I3y/nbm0G/gTpIfk62eR7jG3xGUjOn9+JyQCiGQgyB3U44HbYMh6l
	 KhMdWJaXkCAywz3ngmG9v0884VCnhdyjZEEzUkwo49c7Y5rWRrEetQVRTGAxKeO4VlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d6PHzCUQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61D5606A31C;
	Wed, 18 Nov 2026 19:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d6PHzCUQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460D81F000C4;
	Wed, 18 Nov 2026 19:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029784;
	bh=ZOIf7SRa7LQ0rw00idGiZDc9umEYkfVyQkmnqYjD+XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6PHzCUQEufUjZxiVxEyFL8+5NoUH+1AyNfgGM2jvJUS1wXDkKvT4TlvZmlwnPyXw
	 zONMfQfccHIfhwQxpegzTGEkJrVoIOhBJW+6H6Q2t/ZjUsm917mwp5K0KAGiH9K6sS
	 ndQqUEVpoSgvMy6dzNihy45UuaMiQGigJ+G860qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0421/1756] mm/gup_test: safely calculate GUP batch size
Date: Wed, 18 Nov 2026 15:42:28 +0100
Message-ID: <20261118150025.528988337@linuxfoundation.org>
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

From: Sarthak Sharma <sarthak.sharma@arm.com>

[ Upstream commit 44817a536aaa5bfac0d316242e93e489d0a69d5f ]

__gup_test_ioctl() calculates the end of a GUP batch using:

next = addr + nr * PAGE_SIZE;

If nr is too large, it can cause next to overflow and wrap around.
If it wraps, the next > end check is bypassed and a large value
of nr is passed to the GUP call, even though the pages array was
allocated according to gup->size. This can lead to out of bounds writes.

Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
contains zero pages. The code still calls GUP functions with pages + i,
which can point past the allocated array.

Calculate nr by taking the minimum of the number of pages per call and
the pages remaining in the address range. Reject zero sized and non
page aligned gup->size values and zero nr_pages_per_call value.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Link: https://patch.msgid.link/20260915102524.125758-1-sarthak.sharma@arm.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup_test.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index c9e7c1cf5b080..6de8064090ea1 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -109,7 +109,8 @@ static int __gup_test_ioctl(unsigned int cmd,
 	bool needs_mmap_lock =
 		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
-	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX || !gup->size ||
+	    !gup->nr_pages_per_call || !PAGE_ALIGNED(gup->size))
 		return -EINVAL;
 	if (check_add_overflow((unsigned long)gup->addr,
 			       (unsigned long)gup->size, &end))
@@ -132,11 +133,9 @@ static int __gup_test_ioctl(unsigned int cmd,
 		if (nr != gup->nr_pages_per_call)
 			break;
 
+		nr = min_t(unsigned long, nr, (end - addr) / PAGE_SIZE);
+
 		next = addr + nr * PAGE_SIZE;
-		if (next > end) {
-			next = end;
-			nr = (next - addr) / PAGE_SIZE;
-		}
 
 		switch (cmd) {
 		case GUP_FAST_BENCHMARK:
-- 
2.53.0



