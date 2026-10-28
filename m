Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213266;
	b=lad2lLCyegz3IlG2a1OdCh8LvJZ5ZEMdNVSL56eCslWr7V3hoIEKYZYfZ+e9gIDiawzg
	 JpQr9PPvMYnu+Zwj1zWNDxC6uejikMSiXlBDBgjS84EW5JW+6Th02CuOmaraiFrS0GEZy
	 YFfSmF+AOoB7CPzB/v/VDGCQaFhd1yUvX7nXK9yuw0kJQEDOPdw9h+vcn2ZtvPYwRTyd+
	 1P3jvXDkajgcwCl+QFbPqno1sQUWV1gslmrUi6gjed0ExyzL5cvDb4i1HBX4AET9g57I5
	 6Rvte/Q/OHaYevSQb3pqsbUUouShBZeY3+czD9uDdp+Ys/3690Zgv76MKRuszVlnccg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/XUD/t8XP4Sst3z5UxcGxFlSrfL3hDD3EIm1BTGkbQ8=;
	b=RuqNcCQnEqEbeivbnEF24c5Kyv/iXbvIJ9geNoU96w75W2RG3EDTguePUFByJ2qS6MjC
	 8bNFeJQSdUe7ybr//rV90I2VnU+mseBoA8PQT+DdJls5aJZ8K8s1MiN5QiaET0UgxIk0W
	 2FIS03TjSTxBjMX6M5xTTPojjX18+ZpEIvo/TIZHJwX9mMxqxhR2M/cxt8IED6qclDp9X
	 d8hHcDIcFbWRaT8gQLigqAz/Ge3/vt1xdHxeRQBPF1A6C/za5lGtNyeWFqu5kcdVmCiKW
	 Ns2z1xFmqHPN+GgWgUUdj9wAwPoM43yZpicnM74XIjHT/2bG6bIeEHSxmNjGxpR49iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l7qsifVt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAC4606A31E;
	Wed, 28 Oct 2026 18:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l7qsifVt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8141F01825;
	Wed, 28 Oct 2026 18:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213266;
	bh=/XUD/t8XP4Sst3z5UxcGxFlSrfL3hDD3EIm1BTGkbQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7qsifVt7hXjgBlxadNkqVWSPg2XZe3UaAs7QnCUok7urBd0kJmWJQJo0BWR+IJhM
	 6nmcJJxzyVi160HA++vKm3lHXry8ix+KASMqjXi4Lz/N4FuOSlO8RXxIH2dsQfu9t2
	 nc7JBrET9RmIbAxjQJrTbIiJYUwdyuEotZRj3lpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 0446/1887] selinux: preserve NATIVE_LABELS on already-initialized sb in set_mnt_opts
Date: Wed, 28 Oct 2026 17:42:22 +0100
Message-ID: <20261028170509.380464403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit 28b7260548af3d35773477993ad4e4de41578dd7 upstream.

When an NFSv4 filesystem exported with security_label is mounted a
second time, sget_fc() returns the existing superblock and
nfs_get_root() calls security_sb_set_mnt_opts() again on it. Since the
superblock is already SB_INITIALIZED, selinux_set_mnt_opts() takes an
early exit without setting SECURITY_LSM_NATIVE_LABELS in
*set_kern_flags. nfs_get_root() then sees kflags without
SECURITY_LSM_NATIVE_LABELS set and clears NFS_CAP_SECURITY_LABEL on
the shared nfs_server, silently disabling per-file labeling for both
the new and the original mount.

Commit 3815a245b501 ("security/selinux: fix SECURITY_LSM_NATIVE_LABELS
on reused superblock") fixed the same problem in
selinux_sb_clone_mnt_opts().  The reused-superblock path for a plain
second mount now goes through sb_set_mnt_opts rather than
sb_clone_mnt_opts, so it needs the same treatment: on both
SE_SBINITIALIZED early exits, set SECURITY_LSM_NATIVE_LABELS in
*set_kern_flags when the superblock was already using
SECURITY_FS_USE_NATVE.

Cc: stable@vger.kernel.org
Closes: https://github.com/SELinuxProject/selinux-kernel/issues/69
Closes: https://github.com/SELinuxProject/selinux-kernel/issues/70
Closes: https://github.com/SELinuxProject/selinux-testsuite/issues/91
Closes: https://github.com/SELinuxProject/selinux-testsuite/issues/92
Fixes: eb9ae686507b ("SELinux: Add new labeling type native labels")
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -646,8 +646,12 @@ static int selinux_set_mnt_opts(struct s
 	 * will be used for both mounts)
 	 */
 	if ((sbsec->flags & SE_SBINITIALIZED) && (sb->s_type->fs_flags & FS_BINARY_MOUNTDATA)
-	    && !opts)
+		&& !opts) {
+		if ((kern_flags & SECURITY_LSM_NATIVE_LABELS) &&
+		    sbsec->behavior == SECURITY_FS_USE_NATIVE)
+			*set_kern_flags |= SECURITY_LSM_NATIVE_LABELS;
 		goto out;
+	}
 
 	root_isec = backing_inode_security_novalidate(root);
 
@@ -691,6 +695,9 @@ static int selinux_set_mnt_opts(struct s
 		/* previously mounted with options, but not on this attempt? */
 		if ((sbsec->flags & SE_MNTMASK) && !opts)
 			goto out_double_mount;
+		if ((kern_flags & SECURITY_LSM_NATIVE_LABELS) &&
+		    sbsec->behavior == SECURITY_FS_USE_NATIVE)
+			*set_kern_flags |= SECURITY_LSM_NATIVE_LABELS;
 		rc = 0;
 		goto out;
 	}


