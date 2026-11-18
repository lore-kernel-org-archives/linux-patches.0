Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016334;
	b=xk5IuuMjrJ5DnGnX1M0zUxIxkxtN1pDo7YzCj7R5OnWiEGI1Hoc7LLnfQpGvbIE6htX3
	 HnOyF3reBC/7uiITe9o6zeneUWbfzT6lYM6i9kDzauZBQEGfB39jENbs+pRANtMDVFqdo
	 2tVLZgASb9c/TRtR+SA1mE+vzpsTK5n9lrJwcE3eYvRXMgzzMYuN1VFuKGGhEIdZMR8Oe
	 91rOBXy6mu4JXKRw2YgF+DSrA0+oWxaFjo3jlDY5AzOzdvP8qFy6Fd/JGDIIsLhoSKX6x
	 g98E1/A63WCDKSOVd0vdikIYjPxpnQ+fBzDc8m8S5rK9RVAlRB6QvAEFe83m3p+VX/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x7HLx2FjCNzv3YoCGMknCbvUTuUzpbL3in9V+bSjrzM=;
	b=BvYygQsFAeQUuGprTI5uAyUB5g5Gr69IQSxuIVoqqQP16fZQ2NL3ErGxUk2Kqf+pQ74Z
	 HZl1ddGn/nW0SvooHU2aBZufyp3n2qdIptulrQRO5VpgiuLRFk8WyrXWo8PooPtK/lj5/
	 yktRa9XFt+M7Qf/gg4AM4ftWmMIKYtqGbHy6yRdG7eFzUyZ1RsyLHhp07xMFBDb0BrvlV
	 rFTLwBxV6g3aNbEpmQ3Allyct53cZZZhdJLg84Xs0GRQg0Zp8AmVYlcvW7Rozkf23Hd5j
	 zlhExCc8fMoyNskLzO1B6nMVOg8GW71qYyFyHrzkLwunF1JPF9NlAnk26haK4VSC8fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjWNROfN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AEF606A339;
	Wed, 18 Nov 2026 15:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gjWNROfN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E622D1F000C5;
	Wed, 18 Nov 2026 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016334;
	bh=x7HLx2FjCNzv3YoCGMknCbvUTuUzpbL3in9V+bSjrzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gjWNROfNMMNoxckmVOQ/7aXUrYXSUpRTWedwCV2Lm9knFS4MdfroariUymUp+NxRj
	 APN6DutFPDndvh3nAdnS/7c0oNXHIlCjX9zQSI5WWsBCUUXNz4gZcOTFJvRry4W7nv
	 L636O272cNH0NT/4S3Ryb7rGVLgvqwfPciTaydLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0492/2651] mm/gup_test: safely calculate GUP batch size
Date: Wed, 18 Nov 2026 15:28:52 +0100
Message-ID: <20261118150305.491512187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 44c1cdfb9c371..5bb940371a1e1 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -116,7 +116,8 @@ static int __gup_test_ioctl(unsigned int cmd,
 	bool needs_mmap_lock =
 		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
-	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX || !gup->size ||
+	    !gup->nr_pages_per_call || !PAGE_ALIGNED(gup->size))
 		return -EINVAL;
 	if (check_add_overflow((unsigned long)gup->addr,
 			       (unsigned long)gup->size, &end))
@@ -139,11 +140,9 @@ static int __gup_test_ioctl(unsigned int cmd,
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



