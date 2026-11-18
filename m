Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038998;
	b=irTGic1a8sYYsylevc6EHXVIzkqXR0xe+4/c3CnRViiRTm8IZzZYxirkcKFBhrLf9Tlx
	 ysgBSpbs8WFTIboUdQ/KxJyBQ2v2WIOLSiEoepqTeLAndRTwZ9+EOB0SXLQ24+H+u3fM6
	 YM50XD+Qbh1gE/GQEOD5++jtnP5KQpM4meYbzOOmmTKWm7+2bjCGnaakXvf9KObXFVltz
	 nEp8v22CtR9/PKe6nytcLGo1DFZh5NEcOWOsN+NTOKdqZIKkiPu8RMzhvfWZhZ6RUw7aN
	 Y+TJp7Otf7aFQQgs73BOgsnk6moqyP/9Gxr6cQZkjsgWnCpLDnWFK4YYzT6a72O7eog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3HPgTLvSNnYE7VC+Eln55tvyWADDkYp09EjnSk/2ZvE=;
	b=PimQowF3qTqn4miqfI4uvg3Ixt33hfwOc9eDMNjxwBsVL2q6sEd//0Sx6da8kcR7TQF2
	 ECo1UvwjsWms0FfY1OvWoSG4R/o4jH1OOkmOM6nFTghwO57anc1JvvDhe0w6XRTvNHKgl
	 Xtzwyc/OOwjhf0sUPCyJ10xC/8rXnD+jtcAzLLWOZBnneCYqJSoPXPJCT5iQ4K8sVPEMN
	 VQ6gOBvccCMq6goOqs+MvY9QgaIT2KDPs/Qb6GsDCrtVhdbw376pw9Gl+LV6JXsd2oMZW
	 7dg6lB4OL3NncZLiua18HbcCHL1XLY/vS12DGRg+nJ1EqrXPVvtzW52nPRMbRqiYW2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=apybwCl6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEDB606A320;
	Wed, 18 Nov 2026 21:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=apybwCl6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289451F000C4;
	Wed, 18 Nov 2026 21:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038998;
	bh=3HPgTLvSNnYE7VC+Eln55tvyWADDkYp09EjnSk/2ZvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apybwCl6/xU0X2uegjPO0YoCZmpDGlWu/7WyDqBFkjoxtThGq+AboC2Cd3TK1lIfT
	 lhvpCZ3NZp6VcNghR8WieH9Cyv9IcYaHSnhxtvz71Ul5EMDQuQCkAMsyTy+KYWn8gu
	 r8hyJLei8sO3IS2yDx2jDPmSWSKBWV4+AsD+zb0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1943/3318] mm/userfaultfd: compare exact registration modes before skipping
Date: Wed, 18 Nov 2026 15:42:45 +0100
Message-ID: <20261118150420.343028767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced upstream bitmap flag helpers with a direct vm_flags mask comparison using __VM_UFFD_FLAGS. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 260d8e5d1724b..ba138f968526f 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1490,7 +1490,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    (vma->vm_flags & vm_flags) == vm_flags)
+		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
 			goto skip;
 
 		if (vma->vm_start > start)
-- 
2.53.0



