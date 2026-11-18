Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015157;
	b=NDSzHfHbdP1N78mLLQ7y/1FdW9Wc/ftUD52nYMJb5W8sgqg7dyGYjfDzWyvkgO28XA15
	 G7NEhiEjrLYYeeMpHzq+6TjeD4N2OdGowYiztLDflfeapkrMior0DeNl22vOfyxK65Y3x
	 S+F2rqsYuGX+J6cSOUgRm0ekXyc+Cijc5F0FdmdbI9NPAM16OsBranSm0V14QImZXkn1R
	 FipTB6gACxr8yLFwuIfF3xLLFut0I7XWAGKLiEPqJbMyjpVuqthBwVRdKzQ73LSPLIoAH
	 n0TfYawkzGgUhJNMn5JQZ2g8P26LFP0d2+8xD4ru8iYwS+k+TmRy+/J2dr8BBzZK2Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q7mwfN3I/s6Cmhia2ZVuEHDBNm9jO7kJrfJ++3CfTcY=;
	b=KAYOPUHL8jJLeZxbUn3iD98uRpWi2t5dEfYSIU2ssNSXEuhQ9HAW8cyoldUdLBi09TLC
	 RnZqzwU1xWk8bwrQtkikcJZSaXPFPTIcAFv14JqiaYDNYxY3IITYTWg8RdyjzMBnzQMio
	 lNYBUJ9khR/QRp6TLmCtLJlMwjwrEIlqh4jIcntJp2h5BFNuuQTW9htAy3CyKRPPAHbHz
	 /YCGOsXj41EsTCCBiCAKWv9qtU95DhrTTxsdulksF/8SQa4G4zaRohQCyhl23U7jo/7K/
	 h4vKvZToppsN7ML3TVBm7CgScIN93+X5vSb4/h1CTE4h2rcm21jTqLlwfaAHF4FieHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmZNjFQ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763AD606A338;
	Wed, 18 Nov 2026 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmZNjFQ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16BA1F000C6;
	Wed, 18 Nov 2026 15:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015157;
	bh=q7mwfN3I/s6Cmhia2ZVuEHDBNm9jO7kJrfJ++3CfTcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmZNjFQ6lJplW4vMiwSF2Q8S2OU19whUltj9W1ea7PWu0T/aGk62QQnp6WjyLRJPB
	 YMdXEDWy30SVhA/aThthjUZSh+DxqaAscmhdbabNiqnoOb7o1QuUoPa0yEbWi1Y/8X
	 8E/vVyf4I92jFSio7xfSicwfdYrMuoYjAPIrtFAM=
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
Subject: [PATCH 7.3 0031/2651] hugetlbfs: enforce F_SEAL_EXEC in setattr
Date: Wed, 18 Nov 2026 15:21:11 +0100
Message-ID: <20261118150249.096701513@linuxfoundation.org>
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
[ sashal: Replaced the unavailable memfd_check_seals_mode() helper with an equivalent inline check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7611a8470ea26..2eca1855e0973 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -841,6 +841,11 @@ static int hugetlbfs_setattr(struct mnt_idmap *idmap,
 	if (error)
 		return error;
 
+	if (S_ISREG(inode->i_mode) && (ia_valid & ATTR_MODE) &&
+	    (info->seals & F_SEAL_EXEC) &&
+	    ((inode->i_mode ^ attr->ia_mode) & 0111))
+		return -EPERM;
+
 	trace_hugetlbfs_setattr(inode, dentry, attr);
 
 	if (ia_valid & ATTR_SIZE) {
-- 
2.53.0



