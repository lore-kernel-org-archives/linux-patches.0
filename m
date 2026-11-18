Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038902;
	b=yTNl/BrCc0BnSf7TGEyi/d/Vjk3qTtgVRnSbyVnySgTDxyiUDBEP2FjP6koWCaDBBcPI
	 e9KPHLri70e6x3+OLGL7vFY8mN9It1RNsBqhqGBCeuMCPD3U6QM/SAI8libdMif1VBFjH
	 thDkhvyMRXGjcpsNE11WnfB8Q24qIg0/JSryGhXaLoK9h5sWdD72WnISA4FXHK1nv1NlF
	 5iUAVAMGnpxJg3MKAKlZOvuwn+KrX6qRNLHaja7NU+9/eLlUSUxL4QV5t9EtpYNvYijGd
	 CdPfpZto6v4KCS2yd1FfZISSnIstuOe1X1QQ3lMDL829oRRGHadIltIXtjQtjpFpPFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XqFKLHm5PL+ker5ClraibJtI1R0p/3F+wK+kFnnduTE=;
	b=Ao+gjtly8wC3pKaQVCpBH7+MsOQw+fY1+bvOHqfVp2tE5VJbXpfa2K3/kqdlCJ3ySTIZ
	 VB8acy0C3ccQoAJuotkkDC25R8okugq1ivv/BnKUgSrMSfevgyH9e4PmyTcA1Tj+xBh+J
	 JhEFb490pKDHPE1wana/58KMZmI7Vv9q6Y3uL0v1zjEPbEBOLwjTnnyV+U9p+kuhE5k/g
	 stb8J/QNkfkhtZ/x//fkPlqkrEQ4kG49xCtSNALrPP0QKgJfymvI0FEqxOsOEgd0c8dhN
	 QNjB26mPnLk2fUttUAQEhjuvubtdTQrlcUXI9SrU2jkeWPB+u4OZ+5qWPH8JCyc2m3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oWqPZ1vC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0071A606A31C;
	Wed, 18 Nov 2026 21:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oWqPZ1vC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5743B1F000C4;
	Wed, 18 Nov 2026 21:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038901;
	bh=XqFKLHm5PL+ker5ClraibJtI1R0p/3F+wK+kFnnduTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWqPZ1vCUMpnDP9GJa6vBNstDdUuWz2g3fqEq2u8GcZ0Fee38XujRfysOpfRminMC
	 i3v3nqwJlELAfqqs0nAa0WwXdiVxEaz9skxfGEHOG/Y+XEE4PGsXSNrf6oNO5GfwKV
	 NV4XeIDVeUjtRIpKk7y9fhs6/s6bCX6sSdo4IT3c=
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
Subject: [PATCH 6.6 1907/3318] hugetlbfs: enforce F_SEAL_EXEC in setattr
Date: Wed, 18 Nov 2026 15:42:09 +0100
Message-ID: <20261118150419.218393862@linuxfoundation.org>
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
[ sashal: replaced memfd_check_seals_mode() with an inline F_SEAL_EXEC and execute-bit check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 9bc9f04e4b7a6..96ba81081ed42 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -964,6 +964,12 @@ static int hugetlbfs_setattr(struct mnt_idmap *idmap,
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



