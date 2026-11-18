Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015002;
	b=r52HXJ4uSSr1/Xjbh2R5UzZJfMESFSWzL9mFUIyGoiPZNcA+xqAQTr7Q71mTxq1UENzi
	 AT+aBEmmA/7DD353HcqOB9Rm0bb3gqcUyC8SdQxy1WOE3fyYcdUhZ5zZSC0ST09zj+koX
	 uF55UlIz+PmqhyBd+u8Z4BNN0w8BrvChhV6c8CGMPLsrsEM9P3MbyszSkrJ+5nZl5Z6H4
	 QT5i6t35Ko1Cpg2A93RmOnRFIxDlFujKL+fWx904OBt7PNysMOAiRBdvlizbuX9MrBbCI
	 upvI2vw0XriKO/gBZVE9Ykifo4HsH9W/S82EbnhMldwXUCWi7jfPgoXdR7J2MZ9m79w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N0xjbX6/e7Z4CaPc3jDA+9cwxVOK3AGFv5rX+nUH5G8=;
	b=k1o3NCoAdHTzPRG0myyHxv7wcrLFL9dxdAySsBUhfwJizrEtmkF6HcEHydgU4aRstK+r
	 J+/YFce1NT9z9tWCMiHVxpObCUG5H2lnMC5faGIBFW3qzEt4ume8VcaVoG7Xzp4le6Aof
	 nKtep3SC/Tl/XcMfBVc5S84YYhk1qcdJvVOCxc7bq5aJod6IjSevIYyyab2pl3aObX2+L
	 pbG2kOY0wOjt0VTDW4OgPpzJtF3TNjf+tqdXbWebJDtcuxjkToUInvntIm/jgHBaxRjq9
	 0ogt17R8KAkUHCqmDwgeyehzsik4kyWkSYkLEHxu8mCXlyK0uQfVdTz6w4sPofrSrxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xwnqj3P0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE9C606A32A;
	Wed, 18 Nov 2026 15:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xwnqj3P0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E581E1F000C5;
	Wed, 18 Nov 2026 15:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015002;
	bh=N0xjbX6/e7Z4CaPc3jDA+9cwxVOK3AGFv5rX+nUH5G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xwnqj3P04Lw54+jGRrBYT63MTaDVV70sz6Y6IbWt3Sz+Pk1KN0f+KZNezkXSGZK6r
	 qW4ZEbXYWnk0OBcwjUVszDNagfHzpYGQWYbdDEaElWOA3r0wemv+vkPHGRsPM3xQKy
	 6yLfxGJcRz30bafHwcYljBgHy67z2z4Ngx5pJvIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0018/2651] mm/userfaultfd: compare exact registration modes before skipping
Date: Wed, 18 Nov 2026 15:20:58 +0100
Message-ID: <20261118150248.648358520@linuxfoundation.org>
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

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 05f64f211a25f7d9771d4fde109aad97174a1cf3 ]

Changing registration from MISSING|WP to WP returns success but leaves
MISSING enabled. The no-op check sees that WP is already set and skips
the update, so later accesses to missing pages still wait for userspace.

Skip the update only when the current and requested UFFD modes match
exactly.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: apply fixup from Lorenzo ]
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-26-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/userfaultfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2307,6 +2307,7 @@ static int userfaultfd_register_range(st
 
 	for_each_vma_range(vmi, vma, end) {
 		const bool any_mode_removed = vma->vm_flags & __VM_UFFD_FLAGS & ~vm_flags;
+		const vma_flags_t curr_vma_flags = vma_flags_and_mask(&vma->flags, __VMA_UFFD_FLAGS);
 
 		cond_resched();
 
@@ -2320,7 +2321,7 @@ static int userfaultfd_register_range(st
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    vma_test_all_mask(vma, vma_flags))
+		    vma_flags_same_pair(&curr_vma_flags, &vma_flags))
 			goto skip;
 
 		/*


