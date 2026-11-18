Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016762;
	b=kghKC/fxppcKo+D/xx/ubKZBzWtW0y8FCxgKXJCgvpC8P6p6MBF/Gtos4eyEhRbzNPCx
	 2v78GT9cgu+eaNJQeSSXR3yuefmVfevo4bk3dDrAqc08Buzu9QZqkKfRcXaK+FuKqrOiP
	 MNtFxp+6hgtxLpHV2VuFa6vm/lgAPKWxytDPcWJDLWR6i8R8nNpDrDuxPeeLd5DwIWeCX
	 omy56rKz5vZWMZjj0uUpRDmqM6d3q7rWIU6UgytAz3yRzsIPBGBRBf685XY5badUAeshW
	 57p62L2D7DZWJxRdLOEjSC5vWd1oLeCVqQpbuVNIM1ZQmGYnS1LaRb6TK5IPu9o6o/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JnKXqjkCDnCjXa0mHZx8kQVDJUPA6UiyPnlijEky7/4=;
	b=Mpi/gfvnNIPBYTzfWPglhO6WY/Uemtid+Ccuq3Ei4pzYv0sHF2edGpKwedMu3FHC7G4C
	 8+YgZOyipafsyoGJxhOtNnRxj757pYxdzxvXmwrfaRxVlFPxGIF4ZiNsgPu72Q9Y10Lsd
	 cazkxMZd6Ui5a/BI7GqSHC+Nxq7MKqUjQ6wvfSXZ7XL9pKGDk6PHbCd3wovc9ThloMVUI
	 8P+pwSdJnqgTDyEVxeRXwH6BrP+ER5+eg1zGxooUBRk5qKC+h+ev232IKb0OpVInag4dS
	 fFJDVbsophKZjif+39mTZz5VlXkFso5hH+a956aojyjJXxLXOzilWXnRn0khnQJ7Fiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dETm9qFD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89D3606A31C;
	Wed, 18 Nov 2026 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dETm9qFD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F741F000C4;
	Wed, 18 Nov 2026 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016762;
	bh=JnKXqjkCDnCjXa0mHZx8kQVDJUPA6UiyPnlijEky7/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dETm9qFDsCO6Cdp9YVvtbPcR6LAjK5JigAkJ2VNUvgwWBsGRItNkGyZiLp+HBlpdW
	 JvTllInarQ+6MMTUOc/IoTcIx0d4weTESohsCyQqCGcD6ICqCiH673M86ElvGtvpFq
	 kkdTSskRgio34FiVIsWuQ0Uzm+aVoOBIqedkX8PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0607/2651] fs/ntfs3: check INDEX_ROOT resident size before use in ntfs_read_mft()
Date: Wed, 18 Nov 2026 15:30:47 +0100
Message-ID: <20261118150309.568632138@linuxfoundation.org>
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

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit d0ac69ce3af4dbae01d4f064b7482f0c5440dbde ]

When ntfs_read_mft() parses an ATTR_ROOT attribute it computes

	root = Add2Ptr(attr, roff);

using the on-disk resident data offset (roff = attr->res.data_off) and
then dereferences root->type and root->rule, and later passes root on to
indx_init(). Unlike the ATTR_STD and ATTR_NAME cases, which validate that
the resident data is large enough (asize >= sizeof(struct X) + roff and
rsize >= sizeof(struct X)) before accessing it, the ATTR_ROOT case has no
such check.

mi_enum_attr() only guarantees data_off + data_size <= attribute size, so
a crafted image can set data_off such that root lands at (or past) the end
of the MFT record's slab allocation while still passing that check (e.g.
data_size == 0). The subsequent read of root->type is then a
slab-out-of-bounds read, reported by KASAN when mounting the image:

  BUG: KASAN: slab-out-of-bounds in ntfs_iget5 (fs/ntfs3/inode.c:283)
  Read of size 4 at addr ffff88800c06a400 by task exploit/142
  Call Trace:
   ...  [KASAN report internals]
   ntfs_iget5 (fs/ntfs3/inode.c:283 fs/ntfs3/inode.c:542)
   ntfs_fill_super (fs/ntfs3/super.c:1690)
   get_tree_bdev_flags (fs/super.c:1634)
   vfs_get_tree (fs/super.c:1694)
   fc_mount (fs/namespace.c:1198)
   path_mount (fs/namespace.c:3765 ...)
   __x64_sys_mount (fs/namespace.c:4174 ...)
   do_syscall_64 (arch/x86/entry/syscall_64.c:63)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  The buggy address is located 0 bytes to the right of
   allocated 1024-byte region [ffff88800c06a000, ffff88800c06a400)
   which belongs to the cache kmalloc-1k of size 1024

Validate the resident data size in the ATTR_ROOT case the same way the
neighbouring cases do, so that a truncated or mis-offset INDEX_ROOT is
rejected before root is dereferenced.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index d86c8fffbe817..70dc0a63c870c 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -285,7 +285,9 @@ static int ntfs_read_mft(struct inode *inode, const struct cpu_str *name,
 		break;
 
 	case ATTR_ROOT:
-		if (attr->non_res)
+		if (attr->non_res ||
+		    asize < sizeof(struct INDEX_ROOT) + roff ||
+		    rsize < sizeof(struct INDEX_ROOT))
 			goto out;
 
 		root = Add2Ptr(attr, roff);
-- 
2.53.0



