Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028603;
	b=XrSSbYQBe4Ifr1x/TQlRvJMsXJSzdUzqe7eh4dSS/D1RFs3mknuvhXFWUdP/y+ZPAI6N
	 dhrz6K7fLDK0aOvqhpHob/1V5udSVRmriIpMP4j0LOTzFE9DHH4HMsYPvixgdvmFL4MFI
	 tzbamphMYAixCEN95TB09EeXeETP1rp8CjtPtzKUvwRM3KiY9ltios79vgQVhnNFuGOI6
	 tEGD1w4mBDAbhO5G/dga/AvojDMoSyqL1Gv8cYRL4Gozd/N9r/eQ9Dd07+rso+YkV6EhW
	 kh0ebBiUWS9FwDe2J5gq+DjmCkyLY+aX2Nzqyw6SgeHZFuZGjsn+S4680I6XtEEw8rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xYLhGVq2i0iNloIlBhnjG3cTSVWBBNy8OoWIYZnIIn8=;
	b=Co/t+IgIK8+EuGzv5b/zcSALHXDU1zi3bxGJVUW/CLQdVM3ifj+PZdsPed0vyPRIiLMh
	 ONvltbS4PHtgZMf4Kolyj39Rk6mNIEa9OUkAgiAX9DRfVC9+LowYMiNPVZqQUzfu4r3GH
	 9yx1Bjm8tVxVIJEAVt9IjTUGTiqaP5FGTbQSM2P74O7b1QwQJr1ZpKYL+dy/KPliFlmkO
	 BkujkbWBRrAvOqw0hmGd8Yg70eGGsGnDXJKw3axeVtI80ozxzDch8k3kqmfohoxgW79Dz
	 tJKpn3/KMxPOoMskhp4fNRuJowqRyKpwcNWdYktnwGuAQ/bzGZkQc100RQvu7DuNjKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XM+aBoKx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5568A606A320;
	Wed, 18 Nov 2026 19:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XM+aBoKx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32871F000C4;
	Wed, 18 Nov 2026 19:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028603;
	bh=xYLhGVq2i0iNloIlBhnjG3cTSVWBBNy8OoWIYZnIIn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XM+aBoKxZNrCCMCeYve9PDFmo4o3Ii7aQ9Zns6uhJByM5gBzrC/1tacF9eCrYKg8O
	 MHOcxEgod4CIw8nSLwHrR8IOW2ii0FPxxjnyvQ1XE6/FuNtdx9hQYNRze15+QVQGcp
	 8E1UoBaa89e/e8SlXhDgYa4jy5SAniyE7zf20LCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0053/1756] hugetlbfs: enforce F_SEAL_EXEC in setattr
Date: Wed, 18 Nov 2026 15:36:20 +0100
Message-ID: <20261118150010.491665988@linuxfoundation.org>
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

From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>

[ Upstream commit b7f570e7cea761ec7eb4a3a9557a3a082d14e88c ]

F_SEAL_EXEC is enforced by shmem_setattr(), but hugetlbfs_setattr() does
not check it. As a result, fchmod() can change the execute bits of a
sealed hugetlbfs memfd.

Use memfd_check_seals_mode() in hugetlbfs_setattr() to reject changes
to execute bits when F_SEAL_EXEC is set.

This also fixes the memfd_test hugetlbfs SEAL-EXEC subtest, where
fchmod() incorrectly succeeded after applying F_SEAL_EXEC.

Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
Cc: stable@vger.kernel.org
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Link: https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virtuozzo.com
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
[ david: use common helper; fixup Fixes:; check only regular files ]
Acked-by: Oscar Salvador <osalvador@suse.de>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-5-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Replaced the unavailable memfd_check_seals_mode() helper call with its equivalent inline check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 1a12932b58806..2856c3bbc38d4 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -932,6 +932,12 @@ static int hugetlbfs_setattr(struct mnt_idmap *idmap,
 	if (error)
 		return error;
 
+	if (S_ISREG(inode->i_mode) && (ia_valid & ATTR_MODE)) {
+		if ((info->seals & F_SEAL_EXEC) &&
+		    ((inode->i_mode ^ attr->ia_mode) & 0111))
+			return -EPERM;
+	}
+
 	if (ia_valid & ATTR_SIZE) {
 		loff_t oldsize = inode->i_size;
 		loff_t newsize = attr->ia_size;
-- 
2.53.0



