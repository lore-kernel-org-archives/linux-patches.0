Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034999;
	b=iVSRH7IRTNoN4oiwxqmZLAw4wo7rIm2BAfVpmReSn7tNgIqvhZzDEmeTZKWCZEZQhqh+
	 4+OPSozFZa+W2EXDVSfxLoffLqCfhLvnCAFQrfXNHR8aS1NRwd+myyXlvGE1kVqmCVL3U
	 SyLOKJNlp279Sr6zIsnvuuo72V7XIBZXgg5ioKG+EAWTbprzIAl2S8xRMsOB0oSTSyNPO
	 WDkN/uDyk1sgzo25clu0QDU26Sxr74hyu7HvOmAhrBDkAkC2QpPnQXE9nQuzbq15Ute/y
	 wSk5QjR/8ltdc1hOYwchwFIczFOGzxJwJKUFW65lnI22xsIldzf0EURvMRQre8qLM0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DWOrAUkMsAF2/JzvBvp7y/ggZve9XkG6Z/89MkP7/Kw=;
	b=vTAH9fl6t8stDrwUxx3Lz5MK/Xcmn0cF7rOqFv8tXPCOVTR0Z5neIQT0HPyFONXij7SK
	 CGtGCsaLjFB+LOEIQ3xFjtN4sgu6jKWSJiv2MEnLCIugfuM+z8d5iy81J96uGjm8ddeNt
	 1WCfgYXD5edmGS+B4xw+VNf0NnZ5+tkeyvf6SFR5fKSn2229JQr6gzChUp2+Cgk7YXcT0
	 dfIdatkQqBq924fgY8INH4GRvRbcf+O9rAuJbCK/4WrkGS7i8BktbrVqfHSGFgK77K2zJ
	 jGWW8uHnvNGLiJFOhqCTqnvcshDkdw5EZWI4ytU4XOvdiUfBnXWXa6Ch3F3i2xqnfrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Klu9Q3Ey;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D026606A31C;
	Wed, 18 Nov 2026 20:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Klu9Q3Ey
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D190C1F000C4;
	Wed, 18 Nov 2026 20:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034999;
	bh=DWOrAUkMsAF2/JzvBvp7y/ggZve9XkG6Z/89MkP7/Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Klu9Q3EypK/nW6F62KOPqpnG37rm5ssZrqR6kIKNSRkcy25LCf7Rh3mW2aj0+sken
	 PPLYokTndLq/RuGqXEzL65IIVPw1/od5ceYqy3S2NioBOhDQkyq08RQSHYPabtMFNB
	 Fj9mErMcmq3A3xY0frsetk1ljzy1wjUL/pxxkHCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 0568/3318] ksmbd: avoid restoring only in-memory EOF after allocation change
Date: Wed, 18 Nov 2026 15:19:50 +0100
Message-ID: <20261118150334.450900271@linuxfoundation.org>
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
@@ -6467,24 +6467,17 @@ static int set_file_allocation_info(stru
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


