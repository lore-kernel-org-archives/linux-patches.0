Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585958;
	b=p+QQLIrcNbF/SoguoW7Wvt5BwEc4KZce1vVygJcltInJ/a+h/E2VEonNauvYEhF9P3q0
	 szS6zSfb+KbNTxKJON4pVWRxDNEOQbuGJDyvwoGgnheZfUs/KugjPSStAKsi0AEz8Pqsy
	 urZfwrNS4VrH7Pr3vvD87GLuHuMSJpaUoyEaVOiBSS3JM0woFfRDuNqbYUH/PJCRqsZSW
	 +TxsZmgRYqLkdHp3m+NjmGFLZWApgxeQhtKWfGR+Iawu0vf8NbhpHYgZo/X3o/CmLhjFZ
	 fHCw0+oEpCEr0mhcNLi4umfaTNF4qg1OdmRKF4FDVKgk/SvVbR4xZsBbtMbGDTJE+sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wH6lVbKiHffGPreG8jpwK9SihWpwTl/yYhBsS/4FKCI=;
	b=5coLHGac8TKIRclEoty6koa+UDPKAidCxnUVsegGGvmSVV6rV9Q23tyCJZoWW7hfZ0NW
	 6zP9mL2ShEC53dJ/7++wC1CowEbIrEFFY9RZLY1vKl6w+ctTEfXiA3V/2uBHUXfwBUIrK
	 RPHbrYObDL0yHW1AXGKYwNege4D6yfAAd3s0vT1tTDPcn/hN2y4vCaeKQTDYGtMToS6M6
	 7llieYGjbk5zOSHIpOB2sEsmnXPbIVORtwf64hsGKpIuUNqHKzkFai2YcEMvxmJZbJvAs
	 oFCQSRH2GlNiPfT7QqcKe0GZw4K+WpQhbdrFSsui468HUbmB6Olfor/OLTLZLs9kKhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bwsZnrTk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1632606A89D;
	Fri, 13 Nov 2026 16:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bwsZnrTk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC731F000C6;
	Fri, 13 Nov 2026 16:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585957;
	bh=wH6lVbKiHffGPreG8jpwK9SihWpwTl/yYhBsS/4FKCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bwsZnrTkp0F11ph6zJDH3dcjSFrW70Xq49AIXVxOre4SIlPENaVEuyEpuePzSZ4Po
	 RQlIrAlIAT5sUGFIPJbf5iZlNv3OuMAx7YTGwu/iP3ahp6L8Aljy65yYtTBQdpMPjg
	 ZZgml3nrHsMS+/S6F5JYS4BgISiuIlBw6m0qtbpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 503/507] f2fs: expose resizable_tail feature via sysfs
Date: Fri, 13 Nov 2026 10:53:27 -0500
Message-ID: <20261113153814.171552570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 714f97f477fe2834ac9e9e66979ae52824b9f914 ]

Userspace has no way to know whether the kernel supports the
resizable_tail_secno mount option before mounting. Passing it to a
kernel without the support fails the mount with -EINVAL, and checking
/sys/fs/f2fs/<disk>/pinned_area_max_secno requires an f2fs instance
to be mounted already.

Export /sys/fs/f2fs/features/resizable_tail so that userspace can check
the support before formatting or mounting a filesystem that relies on
resizable_tail_secno, e.g. a filesystem whose tail is going to be shrunk
online later.

Cc: stable@vger.kernel.org
Fixes: c966d29e01bb ("f2fs: support resizable tail section and unify pinned allocation")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Placed resizable_tail entries after fserror because metadata_cache is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs | 2 +-
 fs/f2fs/sysfs.c                         | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 0cebc89799dd1..4f3915948176f 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -271,7 +271,7 @@ Description:	Shows all enabled kernel features.
 		inode_crtime, lost_found, verity, sb_checksum,
 		casefold, readonly, compression, test_dummy_encryption_v2,
 		atomic_write, pin_file, encrypted_casefold, linear_lookup,
-		fserror.
+		fserror, resizable_tail.
 
 What:		/sys/fs/f2fs/<disk>/inject_rate
 Date:		May 2016
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 811e350a14302..5ee12547171cc 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -1404,6 +1404,7 @@ F2FS_FEATURE_RO_ATTR(linear_lookup);
 #endif
 F2FS_FEATURE_RO_ATTR(packed_ssa);
 F2FS_FEATURE_RO_ATTR(fserror);
+F2FS_FEATURE_RO_ATTR(resizable_tail);
 
 #define ATTR_LIST(name) (&f2fs_attr_##name.attr)
 static struct attribute *f2fs_attrs[] = {
@@ -1574,6 +1575,7 @@ static struct attribute *f2fs_feat_attrs[] = {
 #endif
 	BASE_ATTR_LIST(packed_ssa),
 	BASE_ATTR_LIST(fserror),
+	BASE_ATTR_LIST(resizable_tail),
 	NULL,
 };
 ATTRIBUTE_GROUPS(f2fs_feat);
-- 
2.53.0



