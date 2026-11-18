Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058875;
	b=zg8lPaYhUpsRjRe2FnUxxhzZYDTAjYVHlEJgRBlBAarYLKZlliWhegvHDNcfUI+RYLTK
	 h6vsYnDMknYvAMA3ampTUZa++2Z0XL2toLnFlPyAKI0cXPwkhHTUuBREJAegx16AjtF/M
	 m5tmDBspHfBkPgZ7VEvEtUpozSPkcvjpJCQ/iinFlaMXLLBgAFH3M2knFEVLHIqlahEr1
	 mKBrEJA3z0gcdKgDLay53xsJZCHp9revgxspvscyO02lrsYwGzHQs1f91VyeOlZ4ZBTeF
	 ZvDINVFN1DS9Iya3g4Aiz4e8S9dXQebBqoGptgZG1CQ9deIS8b+LrePzBNpXGaYAWgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7fe5Y9UT2hdQ0yghWGmbh6sJaJz/bt6UmROwndCRz3w=;
	b=G6Yx/Sjq5Ev+yBL2TyingyihGe/tv/fPRpoCx8Th7cIwbkdmNEhPM2dxGzmzDiV95nO6
	 NBt1YQwvSZlIro/9/dgIOB2Ww6tNyOE4sk8ZKS94B6zms8oDbp3oEzFf0cbA7SYnWGMxJ
	 1qAIX6xNfFG9g0+VLKaljMpwL0wnPLfAu4fqiWUnlexF3pQsveMCzQRMvk/esSN8UgrZz
	 au7j4LYGo1yWUgtdqbyGl0BKbeEdtCzBtAv3IoCA56x5Zt0Bpy3H01Atlro9rHEYgV6AC
	 kPHTJcugG4jMHoZys/gU02rMi4YIDGe5Tmup9frYcsZictOfgiSjDhTOaVfbtHEpHMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMB2OcjE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44736606A336;
	Thu, 19 Nov 2026 03:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMB2OcjE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9864B1F000C5;
	Thu, 19 Nov 2026 03:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058875;
	bh=7fe5Y9UT2hdQ0yghWGmbh6sJaJz/bt6UmROwndCRz3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMB2OcjEumCyMl6aevY3LNV75AL8o4qRtdVQ8wDw+sOuy1YOypFiKx0XB6tdOEDDv
	 KF2idB3RnQOY1Dphq2ytF+VcRqxZfEvoQNL/f1WMPDiyIROB0cXpnfuqINvSbSbX9Q
	 b24ir9YQGpV7bdKjqnkGAZfgjy3VA3l8UdG/FYFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0642/1848] fsverity: Explicitly require FMODE_READ to retrieve hashes
Date: Wed, 18 Nov 2026 15:44:40 +0100
Message-ID: <20261118145942.637601871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
(5.10: dropped the FS_IOC_READ_VERITY_METADATA changes, since that ioctl
 does not exist in this version)
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/fsverity.rst |  2 ++
 fs/verity/measure.c                    | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 895e9711ed881..4bd6f25e1a4b3 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -146,6 +146,7 @@ fatal signal), no changes are made to the file.
 FS_IOC_ENABLE_VERITY can fail with the following errors:
 
 - ``EACCES``: the process does not have write access to the file
+- ``EBADF``: the file descriptor is not open for reading
 - ``EBADMSG``: the signature is malformed
 - ``EBUSY``: this ioctl is already running on the file
 - ``EEXIST``: the file already has verity enabled
@@ -207,6 +208,7 @@ regardless of the size of the file.
 
 FS_IOC_MEASURE_VERITY can fail with the following errors:
 
+- ``EBADF``: the file descriptor is not open for reading
 - ``EFAULT``: the caller provided inaccessible memory
 - ``ENODATA``: the file is not a verity file
 - ``ENOTTY``: this type of filesystem does not implement fs-verity
diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index df409a5682edf..be3628f9e557f 100644
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
-- 
2.53.0



