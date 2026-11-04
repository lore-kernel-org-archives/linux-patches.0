Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831332;
	b=4N6suInqAh3DeGnd14G6/8/n4Ww3uRQ4iEzOV3UsYss0EKn9ez0L9D9TAR6PfdLDo+LW
	 saYKsYTLgkjLiSfXe2B29q8aR8eLWYK3/W6PTAOOCx3t8dMqWijI5bZN8uNpgTemS/H2W
	 rWae+ytsiv1CT6TPKpPqVedewO6UGzo1k/ocmlzV7XhI/NsZ/ijx/FRmWmOrv/I+gYCOY
	 g+5JnLkP5TtsksfUexqVSKNH+FH+Ujeb7f9vTbyXds2DmXw/xuKHIFXrtqy3pFfwStYsY
	 2iyxJe7cIXXzFusAXX1KDyVb4mKz0uJ2xVj2EYxYv6gprk0eEQBd+ilVE4/628qeUUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rtmJC9PtY1stKYoAgM3BoqGR9BRB4G400IRnmaEFQUE=;
	b=TER8z1fPNAmzhl00czwNYdEhJF07xpFVe87RGxqbpVXQhFqb/LlfRhPeNKQsn3D4G8H1
	 H7FMkmSvjrNNbzpEOagwJ9qmlB34Y4Z/bWt3q0j4lolvoy/kZcW8MR+1KWXsX5jtaj0/O
	 d8XMumeFsDDOUS20atSG/RuQn9NWdVVQga3Q4YD26GdNgRMxjPf3RwBSLEihP5+lWIG8x
	 uWX2xUMMN6nEl+42WwvRU1AXt0Iv50xoYI7b0ABBiElB6O0PGKHYzpu8HN/Adxg9tgKMh
	 X9U5QmhiQdoPWCxak2ibR5CaCwvCKMR/j2ILQsyC+OdpCOEeXbNbXKm+PsNruXupOaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZmbSJUkX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A2F606D82E;
	Wed,  4 Nov 2026 22:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZmbSJUkX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC65A1F000C1;
	Wed,  4 Nov 2026 22:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831332;
	bh=rtmJC9PtY1stKYoAgM3BoqGR9BRB4G400IRnmaEFQUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmbSJUkXPffDMrzhHNcajsNrh8JNVLbhuPMFXuohKGU4VNz6gMhL9PjwXX2H3GD+A
	 3ix4uwZLjf+ErVGW3MnGGQxrxocKy2uvQi4/WyhJV62d+H9DsONNvK3Uh7RbNp5QHO
	 lzwf6ozlB1c5ZKTMtxM/YS3vU3HXPB/IkyQ4ax5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 0641/1005] ksmbd: avoid restoring only in-memory EOF after allocation change
Date: Wed,  4 Nov 2026 16:06:14 -0500
Message-ID: <20261104211101.712614400@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

commit 9455e920aebe41217cabff3f81e90da4c407fdb6 upstream.

When SetAllocation requests a size below the allocated block count but
above EOF, ksmbd truncates the file to that size and restores only the
in-memory i_size. The larger EOF remains on disk and reappears after a
reboot. A 3-byte file preallocated to 64 KiB can acquire a 4 KiB EOF
after reducing its allocation to 4 KiB. Extending EOF this way is not
a reliable way to reclaim the preallocation beyond the old EOF either.

Only use this truncate path when the requested allocation is at or below
the observed EOF. A truncate to the existing EOF still lets filesystems
release preallocated blocks beyond EOF. Remove the in-memory-only i_size
restoration. The size check still precedes vfs_truncate() taking the
inode lock, so a concurrent shrink can make the truncate extend EOF;
that race also existed in the original path.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6516,24 +6516,17 @@ static int set_file_allocation_info(stru
 			pr_err("vfs_fallocate is failed : %d\n", rc);
 			return rc;
 		}
-	} else if (alloc_blks < stat.blocks) {
-		loff_t size;
-
+	} else if (alloc_blks < stat.blocks &&
+		   alloc_blks * 512 <= i_size_read(inode)) {
 		/*
-		 * Allocation size could be smaller than original one
-		 * which means allocated blocks in file should be
-		 * deallocated. use truncate to cut out it, but inode
-		 * size is also updated with truncate offset.
-		 * inode size is retained by backup inode size.
+		 * Truncate at or below EOF to discard excess allocation.
+		 * Truncating above EOF would extend the file on disk.
 		 */
-		size = i_size_read(inode);
 		rc = ksmbd_vfs_truncate(work, fp, alloc_blks * 512);
 		if (rc) {
 			pr_err("truncate failed!, err %d\n", rc);
 			return rc;
 		}
-		if (size < alloc_blks * 512)
-			i_size_write(inode, size);
 	}
 	return 0;
 }


