Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028727;
	b=i6aNPO6QmXclhKFaUKunrd7GAbo46NJNesQlsRwBRYRhNOXeFh1DwKQqK0hVNJDtaN69
	 aNGeDleSxm4BhXP+1qIP6fsOyYCALcekDI83KJ9Knb1OOSeVUoynX6a2CbkO2j1s8L8cO
	 WMXiFhTWQZxupBufl5MmZDWpsE4PfwmuMgN96kQhrsta6PVtocHOdY2czBpjxEr8a4O0e
	 QWZ9zrr4t1xZZEmyoPhE5ZALL9bf1bOKtL0tEpTtepIpEEQs3SisevMQmERkFZLb4uKFB
	 quCdtMovFAvv1Qnwm/c+gogsjX+RBswUysVnt3o2s+Zevie1JADPN5kdWkS4wAYclsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=888bw9YG83AmxaL/PhFgFZc3nsvDaEZGFliQkNDp6n0=;
	b=lqZflf+6DQfwTauaNZ4c6ehPXj4jhJOBYwcK3lmjM684d8CP7oeE6z/WpEjaOmjNd08P
	 ZWs4dJp7O47dT5FeFGvFpKYBGjQeZBrDUwHjKRv+8J70cLwKxCyv5EzkU5kWdbQ/VS7Nq
	 lHB8h21Yfvs9lef3zdSA3DKT0UESR8W9vpSwz9YMJjK+DzEXGusRUYlSuSKP92TsjNNCW
	 IWiYFhzXErNrdB/R+/ehGoZT5Kc3g0u7Ttyr7kuoU3pxY1OvwJLajX1m0znm1Env3N4eY
	 XgP8NOmgRMovNQ0BdbHbZ+rshQOzzlaarzO5Xn4B6OGWVsp4Xnat9ChCMIfwt1CXi5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ifl+aiVs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79197606A33B;
	Wed, 18 Nov 2026 19:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ifl+aiVs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A141F000C4;
	Wed, 18 Nov 2026 19:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028727;
	bh=888bw9YG83AmxaL/PhFgFZc3nsvDaEZGFliQkNDp6n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ifl+aiVsfNzbg4vixd+a9/WwqfIRRknQr9sAkzpdawGM/NTG2GYLvXaD9IfMh4fRy
	 HxnN4Qbi246d+q/yKYJskj2JG6eXhZ7iIrvn6xlv59+gBs1THH+0NSYWbzzGCpdHym
	 FcG6DP9Z00XAuqbYlflYjNbY+5BDD4pxgNa4sqOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0097/1756] mm/userfaultfd: compare exact registration modes before skipping
Date: Wed, 18 Nov 2026 15:37:04 +0100
Message-ID: <20261118150012.103252681@linuxfoundation.org>
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
[ sashal: replaced vma_flags_t helpers with a direct vm_flags bitmask comparison ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 10685c46f0866..6a575335bc6f0 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1979,7 +1979,7 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    (vma->vm_flags & vm_flags) == vm_flags)
+		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
 			goto skip;
 
 		if (vma->vm_start > start)
-- 
2.53.0



