Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061536;
	b=xBWX2c8QHqxD22+nf7dRX+b//7Ey7YZrvYPSP/Bh6OQXCQl0k+xB6wRmP+yx7idCiShi
	 Tla0EZwvejvPWaINB6LMP/ToR1KUTD/hrATpwRv9Nj9hbf0mtYBhuDMkgtxN9x8nxWZyR
	 qScu68QcCZlPCkjIKFzzCp9qIFR0krVEpTPCUwGHHCPzKyoCjOK+uwucolasKPCYN7Z7g
	 Kk0DxZg8htm77R6MLX7DYdcj5YylSNZiNLCVqGvwl19tfmiTu5JyFZCQr0KHB5k44ZV1y
	 KrpswdSJuAWUlwyHj3bQncvFzL/r9Umgb9f52OrlGkGuRHTMBZu0I2dKuw88aJ6uVGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rz5YMrZkfS98lCPcSvYJ1wVEMJrbgwfrOvWQuubxzUg=;
	b=Rgu5tsB2ZDcS2BPXSATtpUdGBGB+GzFQWbhrWlpzPo3P85SK2lUpMDzyIdK6g9vdCfcR
	 hRvy3zMXFnDK8/59y2PP1yRbxKseRIDgkZNtMdwD5QhqQy65gQHh/30AEFC1xtOoXkL7c
	 nN6IoWe8nc9d/E4fqHa11FeTWCR8fWErPABg0cRODzkcSYJ+zztCQ0RgxRvLr3+Jq6KQb
	 DfctkiUIqiJ1PeCzpZmDbPYRKJI3D+VGVPCAOsirpg0spnxDG7EeFOBCPXnnsHBVvwGTy
	 5ATT9L/ZoGlWrhs2elXPdmr9UBkRqtCYKUIYsT9su+xvt+l3UO/7KGrPlQApCNFYgrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIBBlU1f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC738606A326;
	Sat,  7 Nov 2026 14:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIBBlU1f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2931F0089F;
	Sat,  7 Nov 2026 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061535;
	bh=rz5YMrZkfS98lCPcSvYJ1wVEMJrbgwfrOvWQuubxzUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIBBlU1fP6NWCcjmI0HlmHUbXErbj+XFhzdVUP7CkZRK2vetMIXrwlbOW0EESs0QE
	 lJUpEwMrgbrBYsrDGnB/CZeXeqf7q+pWsWZXVir5gh8K3JtM55GdIbqa/KvXUJlhvu
	 GVfC6gVhPvkha7T9NbiNaNELGOvXPKbC4wZnkc2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0583/1536] ksmbd: avoid restoring only in-memory EOF after allocation change
Date: Sat,  7 Nov 2026 08:43:19 -0500
Message-ID: <20261107135013.920636717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6495,24 +6495,17 @@ static int set_file_allocation_info(stru
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


