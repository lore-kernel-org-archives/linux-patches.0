Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585739;
	b=iNN2X3/oVrVuDrmmwpgS3B2DFD+PSU3TdnuAA0Sk5nXvAuWr7QwumDr897Xro1lh1D1P
	 0f8ocg4bM7D/MNMQD0sVLt9kyRw/Ckbj/UuM/k+Q/2mlpE9I6+s2sRcrkZ8o7FtTrJhHR
	 kUYaVxckNyokEQgyug4w8pswyrsr422yv/D+LZR8lXOR5g4M3RhaxSIlkJmFnhbOfAPNf
	 Ln2xL6siDpT7ZRSWZeUVz2Gv1TQl9zOVbHMz0SpDs34RAgbusO5V2FqLOyn3Qj9jgJUTw
	 raBD1+niW4E3+HiO5zqg95vLIc2GJcNdw4pU1JSQhDYj8zcuxa8pgiJq0m5BtqFLlMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5imtaSRs59VJPCsj2AIe40bifqJ7ZI24cOT3DMubV/U=;
	b=vEx4ZtOuCU8kic/PBkTAKKMMXDxTkRZT5fvHEhCrJ6evFJvwQJKAu9pgKr+CwR0P5tqR
	 sotBpQxJq5v+E5YNP466Qc6rGUycHQJRi4sAjolpbF3LHwoYtZN14HYPrfUQoqFOuEqNd
	 1SYoxiF3IAdIaMufFId/FkmdFxlr6fK56UUu5QZ1bvdmyVC0P4nDnrz+9zOlOyUl7VoAG
	 Z/YnOMy6K7GpUPt0DFRt8h6Ym+BiBPpWEy3OmJrdc3kjT8+i5PuRlSncV78/UqdaWliVl
	 g7WFpldfiHi79gsoZIftmvLVN8mQLUM9KIU4cP3OOZMde90xrYFEhaS0StwH9ncT6dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/WubNdm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4C606A336;
	Fri, 13 Nov 2026 16:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/WubNdm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921701F000C6;
	Fri, 13 Nov 2026 16:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585738;
	bh=5imtaSRs59VJPCsj2AIe40bifqJ7ZI24cOT3DMubV/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/WubNdmttpY7wa3ZMCIkdHR77YuOjXAdPCDGKbdYZF25rzH/vRLvqr27R3JoKmNe
	 5B9a/Pfw14Jv4j/YJk1HQUceincl+pErzkeG6vNRdB5Cf2LOCUXsGFSm9ei1Nsr7qD
	 xzuEcg3dupOoGh55nQZ3UXttfvtupH0UjMGiTEqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 338/507] ovl: do not let chattr change the casefold flag
Date: Fri, 13 Nov 2026 10:50:42 -0500
Message-ID: <20261113153806.863481444@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 83b351c3ade542bbfa1073e8c2d919826628252a ]

chattr +F or -F on an overlay directory can make the directory, or the
whole mount, unusable. Lookups of the directory, and lookups in it, then
fail. From code inspection, the caller only needs to own the directory.
The upper filesystem must support casefolding: ext4 or f2fs with the
casefold feature, or tmpfs with the casefold option.

chattr +F and -F set and clear FS_CASEFOLD_FL, the casefold flag of a
directory. The flag enables casefolding (case-insensitive name lookup)
for the directory. All directories of an overlay must match the casefold
state that was recorded at mount time, and ovl_lookup_single() enforces
this:

- A lookup in a directory that does not match fails with -ESTALE.
- A lookup of the directory itself fails with -EREMOTE.

ovl_fileattr_set() copies the directory up, which creates it in the
upper layer if it only existed in a lower layer. It then passes
FS_CASEFOLD_FL on to the upper filesystem. The upper filesystem accepts
the change if the upper directory is empty, regardless of what the
merged directory contains. The merged directory is the one that the user
sees, with the names from the upper and the lower directories.

After the change the upper directory no longer matches the mount. If the
directory is the root of the overlay, the whole mount is affected.

The flag can also change without chattr +F or -F. chattr reads all flags
of a directory, changes one and writes all of them back. For a directory
that only exists in a lower layer, overlayfs reads the flags from the
lower filesystem. xfs with the ascii-ci feature reports FS_CASEFOLD_FL
on every inode, but never sets S_CASEFOLD, the inode flag that overlayfs
compares with the mount. So its directories count as not casefolded.
With a lower layer on such an xfs and an upper layer on ext4 with the
casefold feature, chattr +A on a lower-only directory therefore sets
FS_CASEFOLD_FL on the new, empty upper directory.

Reproduced as root on tmpfs and on ext4 with chattr +F or -F on an
overlay directory whose upper directory was empty. Afterwards lookups
below it failed with ESTALE, and lookups of the directory itself failed
with EREMOTE. The chattr +A case was seen once, on a kernel with an
earlier form of this patch that still passed the caller's flag on:
lookups of the directory failed with EREMOTE.

Fix this by returning -EOPNOTSUPP if FS_IOC_SETFLAGS, the only call that
can change the flag, asks for a casefold flag on a directory that does
not agree with the casefold state of the mount. This also refuses the
chattr +A case above.

Fixes: 083957f9614a ("ovl: support layers on case-folding capable filesystems")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[amir: check the flag against the casefold state of the mount instead of
 reading back the flags]
Tested-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7e1ac70c5d97b..e3aa0931bea9f 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -658,6 +658,14 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
 	unsigned int flags;
 	int err;
 
+	/*
+	 * Lookup refuses a directory that does not agree with the casefold
+	 * state of the mount. Only FS_IOC_SETFLAGS can ask for a change.
+	 */
+	if (S_ISDIR(inode->i_mode) && fa->flags_valid &&
+	    !!(fa->flags & FS_CASEFOLD_FL) != OVL_FS(inode->i_sb)->casefold)
+		return -EOPNOTSUPP;
+
 	err = ovl_copy_up(dentry);
 	if (!err) {
 		ovl_path_real(dentry, &upperpath);
-- 
2.53.0



