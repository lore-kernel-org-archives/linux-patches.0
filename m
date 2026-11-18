Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022576;
	b=PbOgyWOPICcM54C5sAhMvUdXhqiEao5mbgT2ADU45OpTselwIomATTHoC40LQmauRGbE
	 WvUDp4QI6XUkJiagxM1DfPA2BGJgMHYANGjGCWrPQi3L7/43idLG4/okjcUXNLdone9xN
	 kzPnQvLtgn8nwT308O5Oi9ilxWmtqwL15utHd2LyDNkxkvA8FPpqXzZFhfJ6tb9u+wmQ5
	 JaF1nP5MdVsRkQKCjFTAMpT53Ai2eYoaWiBMtzClJXGMdAquW0zqG66UaADB+e18SnpHn
	 7ehBckw5W6FR/RCBpIzyrgtNnHnZI2hE2Vf/iPzpg54a1ABqma2/Pi47El01UDVBF+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EsgWlpTobCjFnEejbf9NNO2aQYcDpwMiKu/Po52e7RA=;
	b=q/dcPXEao4dy9vqBHgTVQTI4+RYD+Ed/Md+fPxbLNTfy/tvx71BDls4ZczmPCMloMslY
	 cShGXaKA7RAUOnFWw8KLkV1/cbpbLtv3r0yn2voOXcTywRb/HtsMEH6vhmznNzGJPLQ+3
	 nH3nbVfOiHw926vmAJlKCkN0FZnu0fMtchcN6CoUAd3f4p82iHZqRwWppAmHPqJD3O/WL
	 Yf8DKEic76MXdHCuDi3W6eGvoxFQTYQWUdBTsv74BU3TJBUGBSOPstrL0jLR998P1xW2c
	 OtLu4rY7Ovz/ZhdHlS4wgA8WT+YZqsjDXnv01IjH0+fes8P+cbILk3j30fOiXeu9kwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N49mHm/V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C68606A32A;
	Wed, 18 Nov 2026 17:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N49mHm/V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1466D1F000C4;
	Wed, 18 Nov 2026 17:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022575;
	bh=EsgWlpTobCjFnEejbf9NNO2aQYcDpwMiKu/Po52e7RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N49mHm/VBPnNzCxrciVkNmqE7Z5w4OYMGCFPLLWI3ddCGIJOrq95BikBijj317rYG
	 +MrDk9qUa1SAnSVpvXC/K8TD5B0Tmv+4Es+LfVc+PJrQd86v6vqUVrYgzo9JefXUQE
	 jTd8fynXhyRMBWF8MU5nHCsOL0a/DGr4PWIxiP3M=
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
Subject: [PATCH 6.18 0063/2151] hugetlbfs: enforce F_SEAL_EXEC in setattr
Date: Wed, 18 Nov 2026 15:29:58 +0100
Message-ID: <20261118150124.054932919@linuxfoundation.org>
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
[ sashal: Replaced the unavailable memfd_check_seals_mode() helper with its equivalent inline condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 34ed9966f2ea8..f866dbe4c198f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -854,6 +854,12 @@ static int hugetlbfs_setattr(struct mnt_idmap *idmap,
 	if (error)
 		return error;
 
+	if (S_ISREG(inode->i_mode) && (ia_valid & ATTR_MODE)) {
+		if ((info->seals & F_SEAL_EXEC) &&
+		    ((inode->i_mode ^ attr->ia_mode) & 0111))
+			return -EPERM;
+	}
+
 	trace_hugetlbfs_setattr(inode, dentry, attr);
 
 	if (ia_valid & ATTR_SIZE) {
-- 
2.53.0



