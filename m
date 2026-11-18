Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048398;
	b=uqYWQnhlB5QynDEG/J5Wgox+Y8qrzTOTNHCZGRoUIc7qWIeVEZcPDSnbLZ8MolEoj2Cn
	 tQvvspsdoVg3VoUi8G8Kn+Xs+7cU0R32/6V3tEpw/txa/J7hkwsa5CsWpgZxgV7u9wia+
	 JPBSoZx+XDNpnXJ8e/jLyl9kuB672nlm24p7GO3jeO6MoObn03AyV4OKYM+B+k18Rx8Dw
	 efzCg/N+DlDFeykMVnPjlTLXB59OMWDr69gnN5OvYPI5l+5NUQXV7jYepwf5lJsLqFHd8
	 ZGwQCHq+YbE5ze5E9M7zVXI/68DZePdgfSOe2KdXqb0NFy/1aIZk+DlkoIsrRz0/mVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rZDRYqCV6l5KYUnujPS6cbEpmadAT/bCkh/ye+20rBM=;
	b=48EvUEI4hNeC21fLD9u2UXkq74+AEoy8uZkPKz6M/O9N83wrnPuUreMJFEkglN0CCcJH
	 aIIAmrImOdBVEh42g+mj7UPbMuTr6rSxvFwCacKCYvSBc+IT9G/vP1ZVKIaEGXcMm3AaX
	 CHNP7ToJo0M3UXC56rCKawJ8DLyuJ5PDxnTKza6+nZm9b9z0V37F+lFYl9TRsOYFQ4rA/
	 0HifYk5VmGDAoW0ZMvgAchcG/cK7vReROOS4hDvJzATzVwEFIuwjZyQapZUh+E88i21GH
	 L/5oaitci1Uj6oPoIxz1UXxf+UvvKq0uW2FQQqoAP+gXtvT1xrSUP2WVB+sYJa4Gb/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dnq8QXkR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B9D606A338;
	Thu, 19 Nov 2026 00:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dnq8QXkR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8831F000C5;
	Thu, 19 Nov 2026 00:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048397;
	bh=rZDRYqCV6l5KYUnujPS6cbEpmadAT/bCkh/ye+20rBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dnq8QXkRZajvCHcAQy0pkSrSrxmiunBHU9DjSlvgzg3H/SS/sY+PKVyVYT38jpAGL
	 RgV8lY9EE5Rz5+Mtp9p471xpO7WxaXUdjl1zZn9oJFcRGSbClb0rOCgC0c0YeNCyfs
	 JGoylk64gAJABLuu9L94Wm5Y6LO5UvhLRZcQCqFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1979/2857] fs/ntfs3: check INDEX_ROOT resident size before use in ntfs_read_mft()
Date: Wed, 18 Nov 2026 15:50:13 +0100
Message-ID: <20261118150312.642309809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 26861fb47469f..a1f44524cd9a3 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -273,7 +273,9 @@ static struct inode *ntfs_read_mft(struct inode *inode,
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



