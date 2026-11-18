Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028710;
	b=S0vMgJU4pK+oLrNwgmRL086PLiW5vV2dcLus6Pp+vE47bIErAGwRtXxEbAHBQ+ZVgvCj
	 P7iKMF/u0ipPcDT9Ace2h6tIADiVSzFwntMhAsslzJWR9V4st6vAtU8s7VM34XNmiszHW
	 iNjDZQxrcOaWctWRsPJTBm/baSB3E8Gu9sgfEJZNtdhx5JEeA9QSCkxMbEY2T9WvPA4od
	 R5civ1C7q8jJHywo+789tKXXGegVIfJj2U8WvGKIASiBETQjiD+li6LT7KvAWXYcqpo66
	 ZQutNkdFAdWQEWWQsOfHoxWLgi/102IZfJ12tvxrFkXlR8TZA6KdpSVscJ3MeOs2hPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+6G9NqaonXkHhsOtCIfN4zBSgtv6WrTnSwQMbMemIl4=;
	b=euBvKNIbstFK+MmdNBX/GPG6oLUplBeCT3jT6XfrEaF6FWY7EA6avrqV9n1iiJHdRdze
	 jmrIDo3av2ba58KQpFC+na3+OXvAvB6vgwpIv+IXg4yBlT33i5Dd1/8FaJyaCkBOIXCCd
	 INPqaEdbcmJPF+x+cUuJU8VeLAly95TQpqD0oaNcUydPScaP9F+5oDxUcV95R0O+UUVUp
	 vXt26vJh52lNOQv50ebd/+hCuTQ8KfW7oRG6O4CE/NqMHkOwDd688Y5zbiYpUNzMMKBVD
	 dKuhNQ9mpSc2AbJlEHN9l6mamwL3d/u+VdcKc1qs7lrw0GeXk15uIBI8aJDrqQO/J/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fs8dXPlc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2D1606A31C;
	Wed, 18 Nov 2026 19:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fs8dXPlc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2ED01F000C5;
	Wed, 18 Nov 2026 19:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028710;
	bh=+6G9NqaonXkHhsOtCIfN4zBSgtv6WrTnSwQMbMemIl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fs8dXPlcl+O2wnx0/RrYzYRXvKAyM4VBaXk2WSmdNnEVtVdka/D5e454UiX+pOb6Z
	 qUWAAvg+mGmZVGwbnZ5MOagZsaOJC3TATmhV75NMP+ZaPE2dO+QI8dHZ8S/nHBAwG5
	 opDlx9bBYOInmPKIeieyPG3Rxg2gznvfTeXE+7fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Dev Jain <dev.jain@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0092/1756] mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
Date: Wed, 18 Nov 2026 15:36:59 +0100
Message-ID: <20261118150011.915636427@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit b4417d08034a7b4a3083e0e2d95429d4542524f2 ]

move_huge_pud() reads the old PUD and clears it in separate operations.
Hardware accessed or dirty updates between those operations can be lost
when the saved entry is installed at the new address.

The raw pud_clear() also bypasses page_table_check_pud_clear(), while
set_pud_at() accounts for the destination mapping. This leaves the
checker counts unbalanced for mappings tracked by page table checking.

To fix it, simply use pudp_huge_get_and_clear().

Fixes: 7d846db7d0e2 ("mm/mremap: convert huge PUD move to separate helper")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-30-d6437171ecc3@kernel.org
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Replaced pmc->old_addr with the existing old_addr argument in move_huge_pud(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mremap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 6731efdcd21bc..d697a684b141c 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -400,8 +400,7 @@ static bool move_huge_pud(struct vm_area_struct *vma, unsigned long old_addr,
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
 	/* Clear the pud */
-	pud = *old_pud;
-	pud_clear(old_pud);
+	pud = pudp_huge_get_and_clear(mm, old_addr, old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 
-- 
2.53.0



