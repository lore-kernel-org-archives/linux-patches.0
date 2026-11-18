Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044286;
	b=wod/6xn0eKCxTppehuuXc+Hg8yqMDxZljplo1bAZDYMtWHbI4x8uGflMK53YkpZ2F/Vq
	 c0lC41xfsa0dEDxQn0RnvZcqlCNKKT9bWotfLKlp0nBw9oPy6SW0yi/Ys2PkPPqX4kIij
	 hBD2gEg4b9vsZL9wbExyO2jO8k0ojTf4m3bzmpCEGOVLJ8YvPSH50IdF3KFVwArbrZKJu
	 n1Z8wrTt/ua6QpRDpmRV0776/yxArbzyIrC3zN+xgZY7pgtyEdoblanupzFMeptlvk/MC
	 k6PcyhvJR2se6G3amiZKrk4Gtj7TTuDOo6a3gGcxSWtdFcVLICg+hpxMBxilSVV7XTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZJb5AG79qFZc7AuUd+5EAlNskMA13cJQ9ESuZRlLVDI=;
	b=iXokSabFAb+ORT0/xNpuaTIL+qTV7kcozK5RQXPNb8ZMSa42EWvbebBNz4PpczK8dPox
	 KQzVs5YLvcW2NwzXnULlKm2TU01Sc32t+XYtcQZiY6EuUlO1Zxu9gKgb6ZtFm5hwJoCeQ
	 mz4tLCxpu5eCbCDQtqjO8m5RuFEywMQ6OjNw+/dLWMZ3Bdtqrrv7ahTxYd6X4GsS32wGW
	 KewqBaboGLyFdc15nVDG0+zZN+DPx6ljgZx3qkdpShCnFmTi2OV45uh4AoCAq+BtIaCHg
	 bQAgTB2Jq4nvoy/b5RHd6g8Mvk0XeKqxyJ9QqL3txCisxG+/WlqoA3ItNMh2g16/dtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=us30JQxm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A19606A325;
	Wed, 18 Nov 2026 23:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=us30JQxm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2AA1F000C4;
	Wed, 18 Nov 2026 23:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044286;
	bh=ZJb5AG79qFZc7AuUd+5EAlNskMA13cJQ9ESuZRlLVDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=us30JQxma2/+yIuUlXAw6XNWlR3l7AJsS4D7o/wvlQndtZzP5inT4Fz9amPKlEnDW
	 o5zEP2TEcvMJlBrHOCiNbeQlNIZcJhvnjEDFbArAFtTXiYi/blChOdM9K3sTrBvadd
	 lai6kQmUJcc4GF9WKSKXlxXWkNf+CUdmH1amFUwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 0511/2857] ksmbd: avoid restoring only in-memory EOF after allocation change
Date: Wed, 18 Nov 2026 15:25:45 +0100
Message-ID: <20261118150219.860067231@linuxfoundation.org>
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
@@ -6010,24 +6010,17 @@ static int set_file_allocation_info(stru
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


