Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016497;
	b=jpVUzCXFKGrJg6UIKZsVeZJ6GLOPTPQfwwuwYlrD8YSxNERgCnTipCOSueziWRLBUb2m
	 qwlU2x6iVIr9bk6UbkFlgBwsUWAuCiV3lLVUGJuEG1Getv1evs25V3QGoENVxs1c02uaJ
	 wI5Rfxk5esM6K1UmRtSuNa1wqXEYmie7UaRcJmNxApjKrgLb4tYzYfeGG/NFGxhGyVGOr
	 xzj4z2BHNGxX8da/qtUkwceWASJUUJkscdEQW60jZYL3o1IC8Z22hozSH6iZi/dUTHGEm
	 F2/mo8V66XtSvlzbo3iYSJ1SO393VC4EhKzts7T5zqaEksls3grWpZ6+lDk3jF3+G5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JuPhjYQ/lBeyRcDAkhLK5Pr2Q3algxVwqoRy3S86Zf8=;
	b=XULq3OfJFJTB4Zyj3m3PgDB0BQMmYIW927HOyjyGcnGUsCYQtwVSjLu8pUKyqQAslwPk
	 jcGBxkp2zS9YvWlhX/VqXzKMKBOqZMSYn8ruRNRauxV7bfpUtIqwoPaX49WYylCSbwS5S
	 uTgLCoWgDAyyYhX5LkjwiPU69WLhd/Kt9fG7NhGVm8w8Z07bVsoxYlDkJ3Jh7VajPrgYp
	 FjJFG+ywkC8MCrv+OzpRYm9SFwNwie4x/OpNy2ENr6cv82QnKMEA+7L7aFCTd0SOqQBWs
	 VoXw6LwMKJJinBRh3rs/c7PINf5+lBho1fRC9Ia+U9Q/nPecqyxzOMTXdMEkolTqn4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxFbh5u3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5FD606A32C;
	Wed, 18 Nov 2026 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxFbh5u3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B131F000C4;
	Wed, 18 Nov 2026 15:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016497;
	bh=JuPhjYQ/lBeyRcDAkhLK5Pr2Q3algxVwqoRy3S86Zf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxFbh5u3iclbvzQ8wygZ68cGFlFjWz+g1V8ZKGF6KULdn5c2Gf56EiMKtGXH9Odl5
	 pvETVTipx2uBW3p45SfPPj2vsm+PYAZaJqaCilW4zNnonvLF7zWKiFQ/xVi86Hq0U6
	 Sibh/EW8DicyrLpsyWMBF8RIsJFkz4lcw8R+v4LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0549/2651] accel/amdxdna: Fully initialize map structure before registering notifier
Date: Wed, 18 Nov 2026 15:29:49 +0100
Message-ID: <20261118150307.514181459@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 5eee433b5c97821979e7de58476dc245ee168d89 ]

The map structure is currently only partially initialized when the
notifier is registered. Although holding mmap_write_lock() prevents
the notifier callback from running before the remaining initialization
is complete, the ordering can be confusing during code review.

Fully initialize the map structure before registering the notifier so
that the structure is completely constructed before it is published.

Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260911163907.1193852-1-lizhi.hou@amd.com
Stable-dep-of: ac18f34f5927 ("accel/amdxdna: Fix race between unmap and free BO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 5a1a2ee261b76..e861db6f93693 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -415,6 +415,15 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 		goto free_map;
 	}
 
+	mapp->range.notifier = &mapp->notifier;
+	mapp->range.start = vma->vm_start;
+	mapp->range.end = vma->vm_end;
+	mapp->range.default_flags = HMM_PFN_REQ_FAULT;
+	mapp->abo = abo;
+	kref_init(&mapp->refcnt);
+
+	INIT_WORK(&mapp->hmm_unreg_work, amdxdna_hmm_unreg_work);
+
 	ret = mmu_interval_notifier_insert_locked(&mapp->notifier,
 						  current->mm,
 						  addr,
@@ -425,15 +434,6 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 		goto free_pfns;
 	}
 
-	mapp->range.notifier = &mapp->notifier;
-	mapp->range.start = vma->vm_start;
-	mapp->range.end = vma->vm_end;
-	mapp->range.default_flags = HMM_PFN_REQ_FAULT;
-	mapp->abo = abo;
-	kref_init(&mapp->refcnt);
-
-	INIT_WORK(&mapp->hmm_unreg_work, amdxdna_hmm_unreg_work);
-
 	down_write(&xdna->notifier_lock);
 	if (list_empty(&abo->mem.umap_list))
 		abo->mem.uva = addr;
-- 
2.53.0



