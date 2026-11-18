Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053224;
	b=e81X2N3tWSbXcvLPciL7bOlq86yTFIHmv3qD8IjWcnElT+tuUzIBjVgJsWU7BMrZN24P
	 oJ5+0fXlGwiEyJHQxsDO4ckRv7uAG9l6XHgodiuWmhRaKx4W4G71ahzq+fXfF7p2u8n5L
	 EKL5tDM5QE4EEgzM8sKgu0PEg3nENdoUQ/OQU7PyGwKkPxGjYDyjlS5JV59I5G0dMFy9z
	 La3TqYOKbtrSfZuwn1gcMMz2Y7OFU6q4V7gqdU6OLvDMI8V5MCjCGopQk505VDiQ9BhkP
	 MgAJqketiBvf8uOk/ndETmsMzpl3kVklZefGML9DCEHZqNpwSn3OXRLfH84yGYx2xbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oWN8//br9C72MjkjjnZ1efPaoCARbAYpB7pP6mKVjog=;
	b=L9EPI5wMbuj3SXNfc6NLboqgAcY9GZjp51vwzwWjAS0u73bQX2wLh+3bkIjR15j9Zw5Q
	 hMHPL1j2UFD0wwzaRyH4iQC7cHrelPW1l3iZQkr/Bd6LCY2lhmRUTdX2TZ1WprFhROlgJ
	 Vaa8tnbYEReBRnYOVpzCfYcnThmCfyJNmhdOO4ouZx3m3nbU2NrIGsLtNwgLwDU1OINcT
	 wXeoKhe3spXddShlRkzJWiPyoJBPeiMXxYtJ/0zPzX96aqi85B083baUB34EBE/fI7KB6
	 dTeFDOaY9Qz0hB0XSRov8wieAvWOWzMEulLHVpgFi8wEDafymUc4Q8tZV+zLdZB8+SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8No78Sa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6FC606A320;
	Thu, 19 Nov 2026 01:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8No78Sa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9E51F000C4;
	Thu, 19 Nov 2026 01:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053223;
	bh=oWN8//br9C72MjkjjnZ1efPaoCARbAYpB7pP6mKVjog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8No78SaOuK8XtU+/lj1/s66Tr9jCJe98Dti3vdtkLCKJsULeA3wQHIyqmW9+kFCQ
	 X8EydcbUkJfXZxY30J6lDOlAkauZCDZzI3ugmoRFstw4yRQPWRpeYwdxFGtNDPASZ5
	 8Dpv6hHPlg6zctxt21uPUSzmQ69aU4ePgIG1P+YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0794/2214] fsverity: Explicitly require FMODE_READ to retrieve hashes
Date: Wed, 18 Nov 2026 15:41:10 +0100
Message-ID: <20261118150043.303042343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1d831e3cbcb33..073bb57334c45 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -146,6 +146,7 @@ fatal signal), no changes are made to the file.
 FS_IOC_ENABLE_VERITY can fail with the following errors:
 
 - ``EACCES``: the process does not have write access to the file
+- ``EBADF``: the file descriptor is not open for reading
 - ``EBADMSG``: the signature is malformed
 - ``EBUSY``: this ioctl is already running on the file
 - ``EEXIST``: the file already has verity enabled
@@ -208,6 +209,7 @@ regardless of the size of the file.
 
 FS_IOC_MEASURE_VERITY can fail with the following errors:
 
+- ``EBADF``: the file descriptor is not open for reading
 - ``EFAULT``: the caller provided inaccessible memory
 - ``ENODATA``: the file is not a verity file
 - ``ENOTTY``: this type of filesystem does not implement fs-verity
@@ -280,6 +282,7 @@ blocks from disk without actually verifying the path to the root node.
 
 FS_IOC_READ_VERITY_METADATA can fail with the following errors:
 
+- ``EBADF``: the file descriptor is not open for reading
 - ``EFAULT``: the caller provided inaccessible memory
 - ``EINTR``: the ioctl was interrupted before any data was read
 - ``EINVAL``: reserved fields were set, or ``offset + length``
diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index f0d7b30c62db2..f0eaef6bea4a1 100644
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
index 7e2d0c7bdf0de..ea8044164508a 100644
--- a/fs/verity/read_metadata.c
+++ b/fs/verity/read_metadata.c
@@ -157,13 +157,19 @@ int fsverity_ioctl_read_metadata(struct file *filp, const void __user *uarg)
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



