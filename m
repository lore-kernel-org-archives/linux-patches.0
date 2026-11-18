Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023807;
	b=UI02kNEgMVD0ajioj8qWa25381DVx1JFZwuDY0Fts9Wu2769VRCUTpEEvSCM+4ZDVP8I
	 ebP+Mdbk6JEi0iNOiJdeHy4O4oiIB7u4IYUqCRVrnkztH8Lz+z8DBLavpBZxf3G68bcrM
	 YAtaMg0GouLZQkBGcPA9spBjiAAiJ5KRnWEc3zRhTXKirOtJGbqoXTicmnlJmrkPYoWhA
	 xaEyKm59NY5/SQZO6krw/dUnsxc9YIJcAIweCWn8WNWMXVeaSDgqqyQnzeHyEut1EvJuD
	 LwRFch7EAhibSiZGCrLOOVImciQJ+XhjC+kRgjPb6iebvPD/+ol5xL/9Qn+KiFTp2nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZuEckEjW0pqaCziSqgJngeQCuBcFx+336L+Iv7Kq594=;
	b=um0l0PyT3aNhWohsxz7gh2k44EPGudAAhfqnLdLLj0QcVnyZ6U4JyVh3C+sLyOOyD3BH
	 ElMPa4Fr4O/k3fwZstCws8bz3vk2SENTHYDdcibBtWfbV3nRY3v+G4SBo/JTcQDnVLHuC
	 hNUf1Iy1HvPC9UhoovqlWbV4aSbd3AhGPO9J/TynSC/PGKAxQdPA1YdsHDE5IQBkvRKiO
	 5frnauCjw6znKhP6li6Hl2btxCewToK3f6971aEnYU4Vlw+lZ4GSv5IzMJTfCrluZQbsg
	 P/AvOXEFxMaU5YermND61PVPgNxbm/dxNrR/Cq/sLgiNpU3x98dALcL1xqiILzDoAWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nei7ZRXh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C720606A332;
	Wed, 18 Nov 2026 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nei7ZRXh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4841F000C7;
	Wed, 18 Nov 2026 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023807;
	bh=ZuEckEjW0pqaCziSqgJngeQCuBcFx+336L+Iv7Kq594=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nei7ZRXhV7WPk6RlvE7/73ytuRYtV1+dJiIDzHNA2ecaRVuY6U5CUxt+1sc3kOPQA
	 /dI03v4Z9ryLzyVWKbNKqqFKhB3FT5cg4Rb3AQQoWxCsyIGXepIkx9H7lfeDKmEgkM
	 CnoNDA+LbMg4ZC8daO2GNNxC/me64MgGZrSgPxA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0500/2151] accel/amdxdna: Fully initialize map structure before registering notifier
Date: Wed, 18 Nov 2026 15:37:15 +0100
Message-ID: <20261118150140.267449017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 2d2c4b248bff ("accel/amdxdna: Set HMM_PFN_REQ_WRITE for writable BO faults")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 147c4c66be4cb..cad1ecdd26f8e 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -231,6 +231,15 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
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
@@ -241,15 +250,6 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
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
 		abo->mem.userptr = addr;
-- 
2.53.0



