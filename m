Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060091;
	b=QhDhTKAG2PJH+YZozmEdMe/cQZa/A2LqjDAp+7XcZFEcwVJLuWmpHYTmSEOm2jOgwCYB
	 WFy7yxunmc9VJzRs4Je46m2QOfjR8JWdqka7s8WVhKZgGzCZ8wfFwgfRf7pbBbrOqObGY
	 VnnVlW0/xSq/7gF2oKSpr2kUMmMzTSjdqN62vE9jyC0njiA6pPfihJjLWwBWuAc+GQhj5
	 YeWe9BP6gEatlZp7cE72VSRP74c4DECj1unn77leDkxPszFjqdMO7PBNyHlCp+ZwOowGm
	 6vXG0pcNYUw9zE4j82nRSyOQYdWQXdDwUFL+tP69UvkbfrYk02AcjW68kDd4zAHg4Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E414nUUn4lm1Qy5BRZeoEYA2Gv0Z51cnNTgJCe13GPY=;
	b=2+VnHmeMs0CaEdfv721E4ZTQa29ieXKu61YeYuJiD0fhz3VZFEzZ+dfCKxgkr2yPZoB7
	 rLL6gw1OD1OUz6n9BJ3CiMwsPYj6bU6XF+7ChHUXqvOCRLfJKadx7/4cBgvUpNBAYb6z0
	 bqy9E/eIwoBTytAPeuh/CwTAUxYyV20l1n6QuigQfST9OtbxTJxBqq9bwAf7LzboBIb2Z
	 /B4a2u3vBD8F5SNZ/1y2cJlfjbdbLl+4S7a3EUDElcvSfRmiKn1PgmO5RKm36/mrt+Qhk
	 JbA/bINQWRF9rTbquJ0NcUAdIug+S72R1/LntiKziNOt/9aSSZbrGlBOSmPTavDEbrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fy7oIgD2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4654606A32C;
	Thu, 19 Nov 2026 03:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fy7oIgD2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365BD1F000C4;
	Thu, 19 Nov 2026 03:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060091;
	bh=E414nUUn4lm1Qy5BRZeoEYA2Gv0Z51cnNTgJCe13GPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fy7oIgD2ubN73hkfhmQvSZ8nLdXt86TRIsJqZuGEBZmiClO6en0hXtgOLItMuCFyd
	 g+oOvBJ+1iBRCCMCJ2VDLIRBJbepB6QU050Mgxl1A5B6RdsXXyj/DQlqxqx25SSign
	 S50z4sXakbrKqOrUZRkTeUAx4G6oWCTQMyi0ZA/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1076/1848] mm/userfaultfd: compare exact registration modes before skipping
Date: Wed, 18 Nov 2026 15:51:54 +0100
Message-ID: <20261118150003.145262218@linuxfoundation.org>
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
[ sashal: Replaced newer VMA bitmap helpers with an inline integer flag comparison using the VM_UFFD_MISSING | VM_UFFD_WP mask. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 21c32d941f4a9..23230321c7756 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1409,7 +1409,8 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    (vma->vm_flags & vm_flags) == vm_flags)
+		    (vma->vm_flags & (VM_UFFD_MISSING | VM_UFFD_WP)) ==
+		    vm_flags)
 			goto skip;
 
 		if (vma->vm_start > start)
-- 
2.53.0



