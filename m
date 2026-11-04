Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831561;
	b=eBFmuF7bpW/R1l1aavc6/z6IIsMA14R1J4kEo9qmG4f6t9aFusdVB0If+4SCpJJkaYLw
	 uMr5IkoiE8ZEal1Ytdoe9MYKemBCKgy+U81TFhWmVLdCNEN8eYpbhFyznBtln/ESCCrJP
	 5vJhMSUFOjE4yPsfKXJPNX8Ol0T5ENJ/+8iugBW4c0AQS8HWtLsn2KGCQII3vWksxcUHI
	 ZM3nT95N25SJcM6rt3jboKMwXUwwSKXii1JknjV+Z9j6/DbHSLi6esHg+TLqwh8aTusSq
	 fs6LUH4OSL6KMi0EosZmTAKOHcAcVnts+dpkFhrqqM1ukjNax3Fn/6aO7hGbxUP3W7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WI+bVFNko951wkBK2SGcDMURi+ye0XBnCkrMlWLxxgA=;
	b=vNTAOoxlVchKhoeCwRnjDTtyqdWZJ1wOmR8B8/TSnK9HYE9L7op3naKOe/OOm2mmDuSR
	 wfNg51aYrw8uGieUgV6cnGx0BtovaltoorPODOfLX/E02pUs5nBzQ0xfAQjfRLLqt1+S3
	 dspi0wBsSAgK+Xs9hmGOnCOT4QkOXKVQwLeNdA3r+0A/TFBivnCRG6TKCLkzOPrN4C6Pk
	 WE8VFZFK6tmFZEo3gmCLpLPR3aqJE1Yz1+9gCCejY9qFa/i/RNu7tLA0YdmBV1ftaG0Bx
	 bUGZh3aTPDgJlRWgz4teIttHmI5EqZJPizB6Jp3GFppmZLDk6UlqLyxVGlaxLML2H7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bjF7HzVB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC144606A844;
	Wed,  4 Nov 2026 22:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bjF7HzVB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0671A1F00919;
	Wed,  4 Nov 2026 22:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831560;
	bh=WI+bVFNko951wkBK2SGcDMURi+ye0XBnCkrMlWLxxgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjF7HzVBviP07EgvwkWsTZKBVFD9aDuN9DcCsOF9bhIt0F8jykyI2stP/Ote+fDmI
	 PrPjhJUa8oxEGptue02GvhhnvWLVuXYrhMuMlhNhxgFYySfDhKlTUxZakE04ICzJOF
	 7DA5MfoUmhDBYOl3HH0OI3Awjzmf2oPmPG5FT+W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dgc@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0776/1005] xfs: fix ondisk symlink target validation in xrep_dinode_check_dfork
Date: Wed,  4 Nov 2026 16:08:29 -0500
Message-ID: <20261104211105.113294450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit aafe21c23ad8263251085291019d8860ddc51da9 upstream.

LOLLM noticed that online repair of a broken symlink file could fail
unnecessarily if a local-format symlink target isn't null terminated.
The ondisk target isn't required to be null terminated, but repair
enforces that anyway because it uses the validator for the incore
symlink target.  (The incore buffer is always null-terminated).  Fix
this by reverting the changes to xfs_symlink_shortform_verify and adding
an ondisk-specific helper in inode_repair.c.

Cc: stable@vger.kernel.org # v6.8
Fixes: e744cef2060559 ("xfs: zap broken inode forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dgc@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c     |    4 +---
 fs/xfs/libxfs/xfs_symlink_remote.c |    8 ++++++--
 fs/xfs/libxfs/xfs_symlink_remote.h |    2 +-
 fs/xfs/scrub/inode_repair.c        |   26 +++++++++++++++++++++++++-
 4 files changed, 33 insertions(+), 7 deletions(-)

--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -683,9 +683,7 @@ xfs_ifork_verify_local_data(
 		break;
 	}
 	case S_IFLNK: {
-		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
-
-		fa = xfs_symlink_shortform_verify(ifp->if_data, ifp->if_bytes);
+		fa = xfs_symlink_shortform_verify(ip);
 		break;
 	}
 	default:
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -208,11 +208,15 @@ xfs_symlink_local_to_remote(
  */
 xfs_failaddr_t
 xfs_symlink_shortform_verify(
-	void			*sfp,
-	int64_t			size)
+	struct xfs_inode	*ip)
 {
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	char			*sfp = (char *)ifp->if_data;
+	int			size = ifp->if_bytes;
 	char			*endp = sfp + size;
 
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
+
 	/*
 	 * Zero length symlinks should never occur in memory as they are
 	 * never allowed to exist on disk.
--- a/fs/xfs/libxfs/xfs_symlink_remote.h
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
@@ -18,7 +18,7 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, u
 void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp,
 				 void *priv);
-xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
+xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
 int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
 int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_ino_t owner, const char *target_path, int pathlen,
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1024,6 +1024,30 @@ xrep_dinode_bad_metabt_fork(
 	return false;
 }
 
+static xfs_failaddr_t
+xrep_symlink_shortform_verify(
+	void			*sfp,
+	int64_t			size)
+{
+	/*
+	 * Zero length symlinks should never occur in memory as they are
+	 * never allowed to exist on disk.
+	 */
+	if (!size)
+		return __this_address;
+
+	/* No negative sizes or overly long symlink targets. */
+	if (size < 0 || size > XFS_SYMLINK_MAXLEN)
+		return __this_address;
+
+	/* No NULLs in the target either. */
+	if (memchr(sfp, 0, size))
+		return __this_address;
+
+	/* ondisk symlink target isn't null terminated, unlike incore */
+	return NULL;
+}
+
 /*
  * Check the data fork for things that will fail the ifork verifiers or the
  * ifork formatters.
@@ -1099,7 +1123,7 @@ xrep_dinode_check_dfork(
 			return true;
 		/* symlink structure must pass verification. */
 		if (S_ISLNK(mode) &&
-		    xfs_symlink_shortform_verify(dfork_ptr, data_size) != NULL)
+		    xrep_symlink_shortform_verify(dfork_ptr, data_size) != NULL)
 			return true;
 		break;
 	case XFS_DINODE_FMT_EXTENTS:


