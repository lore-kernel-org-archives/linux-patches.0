Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037251;
	b=NDjZ+6YrJ+jG2lnK1856JPfeoi/Ap/EJX/brz5i9QH1BeW3onfPfn/27dAhQCax1wMz6
	 76JcH1wrBIOLhkL6Nf9pdki3HBzR2xtmQQULZTnkTplndQzX3HD0p5mJpx/uwOGZM8dad
	 5jbW3Cr7lYqueyoFErSfRC81KXmL++Lg+t0/7adrwCT7ILNTdW4KxJIWHFQoFMbEc5VMQ
	 EY9Ildgimrief3epsSwLQVIqsWVsalNIhjWKU9vl7o/q9sA6iGhlHYIY1kxYTtDXIJdg2
	 B43CxDs9PsZX1N5rs6PoXQ67u39UymZkvAdUKlXEVDoFhGNugw6Cf9HanLQAe+QA9qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zTQDGR+t9V1c0oWsrjWCU831R+sD4pT3EzXJv/xDBB8=;
	b=W4RA/dZxOC3zFi4IcVVLJSoqqHWF0Ebd2+UheaJzjHi6dd0lekph7+v6n+yrXCANTqM6
	 s4qvtcmPuWAYLV2MU6LsowpIBb0G+4HBCPze2HToHVCKNa1IQa+CK66FXSM8medKp8Zvg
	 nMICtTUDvzj9Nwgme47akxbf+sAz4a0lHRp53D5LSZnLyPco1NR4OEPymKpNMDBGnW+yc
	 CPwAO7TcOzIQzMD4LqKWsyg1Gve61yXQKV7BzADAPf/wnTET3MXmhkOlvnNxjVUq+hf3b
	 Sosu0O3zQUCiXw49lJ8EsQWZ2UcLOL/hUcrHWmjv25WXYCOJqp5ruV3o8Q3efafZqmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gw6luKpU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46221606A33E;
	Wed, 18 Nov 2026 21:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gw6luKpU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FDD1F000C4;
	Wed, 18 Nov 2026 21:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037251;
	bh=zTQDGR+t9V1c0oWsrjWCU831R+sD4pT3EzXJv/xDBB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gw6luKpUSwIdVIeYVCivIh4dvUcRLN/yykfhVWOCS4d5hHrN8sIkhR/rw5tTa5eYy
	 BYuI52xvmUDIyjrPKVMseisYai3RTOgFM8YM4b71QiWk9UWjctJahqoTawVdDAi4ff
	 JWjQIqGmM/gq7YROb460M8OQzxCGUVFNe00fSKrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1344/3318] fsverity: Explicitly require FMODE_READ to retrieve hashes
Date: Wed, 18 Nov 2026 15:32:46 +0100
Message-ID: <20261118150400.701224569@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 1acb4fd2d011c4bd6cc961095ae17361c71ff61a upstream.

The comment in fsverity_ioctl_read_metadata(), which justifies not
checking for FMODE_READ, doesn't consider that the nonstandard access
mode 3 (ioctl-only) exists.

Opening an ioctl-only fd generally requires read (and write) permission.
However, there are gaps with certain LSMs: an ioctl-only fd requests
read (and write) permission via security_inode_permission, but not
security_file_open.  With certain LSMs relying on the latter, such as
Landlock and AppArmor, an ioctl-only fd can be opened without the LSM
granting read (and write) permission.

Since FS_IOC_READ_VERITY_METADATA returns hashes of file contents
blocks, it should require read permission.  This also applies to
FS_IOC_MEASURE_VERITY, which returns a hash for the whole file.

Meanwhile, ioctl-only fds are a rarely-used feature, not known to be
used with either ioctl.

Therefore, just disallow these ioctls on ioctl-only file descriptors,
similar to what was already done with FS_IOC_ENABLE_VERITY.

More specifically, explicitly check for FMODE_READ.  This also covers
write-only fds to non-verity files which otherwise would have failed
with ENODATA.  This change in error code for write-only fds should be
fine too, as these ioctls cannot be usefully used with write-only fds
anyway, but it's worth noting as another technicality.

Fixes: 4dd893d832cf ("fs-verity: implement FS_IOC_MEASURE_VERITY ioctl")
Fixes: e17fe6579de0 ("fs-verity: add FS_IOC_READ_VERITY_METADATA ioctl")
Cc: stable@vger.kernel.org
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Link: https://patch.msgid.link/20261022211522.1489943-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/fsverity.rst |  3 +++
 fs/verity/measure.c                    | 10 ++++++++++
 fs/verity/read_metadata.c              | 14 ++++++++++----
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 13e4b18e5dbbb..dab77d92e5903 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -160,6 +160,7 @@ fatal signal), no changes are made to the file.
 FS_IOC_ENABLE_VERITY can fail with the following errors:
 
 - ``EACCES``: the process does not have write access to the file
+- ``EBADF``: the file descriptor is not open for reading
 - ``EBADMSG``: the builtin signature is malformed
 - ``EBUSY``: this ioctl is already running on the file
 - ``EEXIST``: the file already has verity enabled
@@ -223,6 +224,7 @@ regardless of the size of the file.
 
 FS_IOC_MEASURE_VERITY can fail with the following errors:
 
+- ``EBADF``: the file descriptor is not open for reading
 - ``EFAULT``: the caller provided inaccessible memory
 - ``ENODATA``: the file is not a verity file
 - ``ENOTTY``: this type of filesystem does not implement fs-verity
@@ -295,6 +297,7 @@ blocks from disk without actually verifying the path to the root node.
 
 FS_IOC_READ_VERITY_METADATA can fail with the following errors:
 
+- ``EBADF``: the file descriptor is not open for reading
 - ``EFAULT``: the caller provided inaccessible memory
 - ``EINTR``: the ioctl was interrupted before any data was read
 - ``EINVAL``: reserved fields were set, or ``offset + length``
diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index eec5956141da2..6b61ec273f070 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -28,6 +28,16 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
 	const struct fsverity_hash_alg *hash_alg;
 	struct fsverity_digest arg;
 
+	/*
+	 * This ioctl returns a hash of the file contents, so it should require
+	 * read permission.  Disallow it on ioctl-only (i.e., nonstandard access
+	 * mode 3) fds, which can in some cases be acquired without passing all
+	 * LSM read-permission checks.  Also disallow write-only fds, which can
+	 * refer only to non-verity files which would fail with ENODATA anyway.
+	 */
+	if (!(filp->f_mode & FMODE_READ))
+		return -EBADF;
+
 	vi = fsverity_get_info(inode);
 	if (!vi)
 		return -ENODATA; /* not a verity file */
diff --git a/fs/verity/read_metadata.c b/fs/verity/read_metadata.c
index f58432772d9ea..680792701ba29 100644
--- a/fs/verity/read_metadata.c
+++ b/fs/verity/read_metadata.c
@@ -156,13 +156,19 @@ int fsverity_ioctl_read_metadata(struct file *filp, const void __user *uarg)
 	int length;
 	void __user *buf;
 
+	/*
+	 * This ioctl returns file contents block hashes, so it should require
+	 * read permission.  Disallow it on ioctl-only (i.e., nonstandard access
+	 * mode 3) fds, which can in some cases be acquired without passing all
+	 * LSM read-permission checks.  Also disallow write-only fds, which can
+	 * refer only to non-verity files which would fail with ENODATA anyway.
+	 */
+	if (!(filp->f_mode & FMODE_READ))
+		return -EBADF;
+
 	vi = fsverity_get_info(inode);
 	if (!vi)
 		return -ENODATA; /* not a verity file */
-	/*
-	 * Note that we don't have to explicitly check that the file is open for
-	 * reading, since verity files can only be opened for reading.
-	 */
 
 	if (copy_from_user(&arg, uarg, sizeof(arg)))
 		return -EFAULT;
-- 
2.53.0



