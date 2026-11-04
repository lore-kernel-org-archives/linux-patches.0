Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831714;
	b=4LFA/qAA2+e6hgxL6UNTAAZ4kC1mBJBUm3htivdaovQ+Kbx1BhG4a6TokkIIpEsbF8qA
	 erfN3pMQs30B6i9O4vl4Pm8rbDIbkdKouAI+XfynYJSB90vrq31jZAzy6BSemU0j0vB3m
	 05TjjpI9kCfVnJ2/Cg1iHHi+6zMYBN/vwhgNLFnmS5eF+vQznUowXp6ckvczbrEbNWUW3
	 7upLbD5pJdAJVJ86dmDkI7sfL+MocGzPWTdux0u5MJkJUHjHGAasr7eHPJDrRu+t0kXvb
	 0/78hgE4CPfU0NT67mVLF0z4Do4vj6p2wKw1cPEnVsUhPoQL9DYtlasPjNBYAY2BV7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9E8D/i0q9l8Nz93MJrbv/L8iF8UTYPCv5J1zLF0zpnc=;
	b=R3M97RGZhQV0zL6UEz2ZnWVPF2hR8dWoEgfp3aS93r1P7ZX0vEX+nhK1WX0Jelag8Ov5
	 QNsuDP1U+uFa7us1VRC3itIbOCBe0oo8Yh/Qv8zXLJ80JcCf/a8PuZzaLzUbzJwuWasO3
	 Elb3UC4og2gyLGLuas/JgSLPgddjD4ucHB+tJ1wHQkU5QlP2oRogAT/qEZGspcGJfFvDG
	 WCXwC3BbC0mHHBHxjMgmAzy1d+99khLMhI99Gd4s3OA2QbrzPXXFSkHZ7aWrlrWt5wkNU
	 UOVXkS6jF6mZiE7nbhdorWDDyp0U6nUaK3xWVlmccI9rynO3YV45NrrYv++oCX9kpCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lzFKnhr+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B75B606A337;
	Wed,  4 Nov 2026 22:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lzFKnhr+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C411F000C1;
	Wed,  4 Nov 2026 22:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831713;
	bh=9E8D/i0q9l8Nz93MJrbv/L8iF8UTYPCv5J1zLF0zpnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzFKnhr+wzMfdQF1V+rfFB/fzktoN+YU91dLcg/SLBXkHlIpUc/osXG8eIEFwnC7Y
	 oitc3/aGd8SsSU5fiX30xsNX/cSgq5YDAttIWXPfbBQ7/DMt8KxGSVGg3ybT8Bl4+9
	 kazM83+Qz0UPFtcdIK+SR1Rw04tGfgXcaQQQHTwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Liu <bird@lzu.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>
Subject: [PATCH 6.18 0868/1005] smb: client: fix buffer overflow in SMB2_tcon()
Date: Wed,  4 Nov 2026 16:10:01 -0500
Message-ID: <20261104211107.582637249@linuxfoundation.org>
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

From: Luxiao Xu <rakukuip@gmail.com>

commit 73cc469b0ff7551f8537ea919709973e6dc4f514 upstream.

In SMB2_tcon(), unc_path is allocated with a fixed buffer size of
MAX_SHARENAME_LENGTH * 2 bytes (672 bytes). However, the user-controlled
UNC path (tree) length is passed to cifs_strtoUTF16(), which assumes the
destination buffer is large enough and writes strlen(tree) + 1 UTF-16 code
units.

Commit 62a1a439e0fd ("cifs: clean up handling of unc= option") removed the
length check on UNC mount options, allowing mount paths to exceed
MAX_SHARENAME_LENGTH while retaining the fixed-size buffer allocation in
SMB2_tcon(). Consequently, an oversized UNC string causes cifs_strtoUTF16()
to write past the end of the heap object, resulting in a slab-out-of-bounds
write. Furthermore, if a tree exceeds MAX_TREE_SIZE characters, strscpy()
truncates it in cifs_tcon::tree_name, causing subsequent reconnects or
failovers to fail.

Fix this by first verifying that the length of tree does not exceed
MAX_TREE_SIZE, returning -EINVAL if it does. Then, dynamically allocate
unc_path based on the length of tree so that it safely accommodates all
UTF-16 code units for paths within MAX_TREE_SIZE.

Fixes: 62a1a439e0fd ("cifs: clean up handling of unc= option")
Cc: stable@vger.kernel.org
Reported-by: Xin Liu <bird@lzu.edu.cn>
Closes: https://bugtracker.nebusec.ai/f/3292
Assisted-by: LLM
Suggested-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
[pc: remove unused MAX_SHARENAME_LENGTH]
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2017,8 +2017,6 @@ static inline void cifs_stats_fail_inc(s
 	cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_failed[code]);
 }
 
-#define MAX_SHARENAME_LENGTH (255 /* server */ + 80 /* share */ + 1 /* NULL */)
-
 /* These are similar values to what Windows uses */
 static inline void init_copy_chunk_defaults(struct cifs_tcon *tcon)
 {
@@ -2049,7 +2047,15 @@ SMB2_tcon(const unsigned int xid, struct
 	if (!server || !tree)
 		return -EIO;
 
-	unc_path = kmalloc(MAX_SHARENAME_LENGTH * 2, GFP_KERNEL);
+	total_len = strlen(tree);
+	if (total_len > MAX_TREE_SIZE) {
+		cifs_server_dbg(VFS | ONCE,
+				"%s: tree name exceeded %u characters\n",
+				__func__, MAX_TREE_SIZE);
+		return -EINVAL;
+	}
+
+	unc_path = kmalloc((total_len + 1) * sizeof(*unc_path), GFP_KERNEL);
 	if (unc_path == NULL)
 		return -ENOMEM;
 


