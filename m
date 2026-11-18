Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058827;
	b=OQoCDmk3JKTsPKq5E4t5RzrYpza+JxykrLaetsAjNp2K3zJL/fBiADh25tg7mG0jqQ0H
	 nVxQ4MF8KEn9Z7vuJyYiCrBfwzb423Q1A33SoXVOZtqlCg2NqLDtnI5pt6x9ms/+5Zj3Z
	 7Erx+ugDqNrCT46IPKPn7Mtd9e3nfoDJ0ecrJaiojFQxjZhmkdZYDZLO9OLMsGmWLSlp0
	 DkqebQG4W8MWUQAiOFvMvdtn8Ic40lvFzSrNC4owk6pq03aUybF+ztgfgS9sc03duxSKS
	 41DTvqIOUZ3pVx5cu2i8oSW0xlot534vLUn3QAPF1jMhM3wlRpHPyjogMNST0LYNYtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jh0yKujBVueMHbPsZKcpU8pIwCZ16ckEY2RMZWyvhEQ=;
	b=1sO5h7D+L+19GJq6I48jc4RjS0DMFBF0vobKRv6pRj8RwhYJYJdGxgqKjYD81pGZ1k1W
	 93oHh9aBxzUQat+oyRO9VxbF+aqzdH0ZiwF0q0vEYBlEfKgoCpO5C2IVeO2Iik96zCPCl
	 HhtzGmX6MHMDhsT3IJO1T/gUCyCkCCjxZk1iNbmroCn39qb1Gg69AINZou7M8T2to3vGK
	 uIca8aOTxa6+DbaC99/OzJgtMDE34PjoCOHBzYZtslVGosATe20k1t+a0LEnBIJX5znVs
	 Hen1gCHKmEnFOmpMRlrJdjFOWLuJkyk38wkwZ0E4lx3r4BabJ0lz+bUlyoBT1vKNacA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cb03deln;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A217A606A31C;
	Thu, 19 Nov 2026 03:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cb03deln
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07ED81F000C4;
	Thu, 19 Nov 2026 03:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058827;
	bh=jh0yKujBVueMHbPsZKcpU8pIwCZ16ckEY2RMZWyvhEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cb03delnHhW4ScroIEjgWrDLnFuO7bic3NzrZE5V1KTx2vM/mGenhnL0U53XPlLxk
	 NvGonzzqjeKKnFVhOc8usQsNbnhSuc+Q87MjDWtMHC6sxkprdgenfeezGZUvz+YcCJ
	 C9u2PQ+g9lGRwZnDrAdPtpOSFwBf6ogXx/2FaixY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0618/1848] ovl: do not copy up an xattr value that was never read
Date: Wed, 18 Nov 2026 15:44:16 +0100
Message-ID: <20261118145941.141271371@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 755b5c5c9277be251a51623d6065abab948c61bc ]

Copy-up stores uninitialized kernel memory in an xattr of the upper
file, where the user can read it.

ovl_copy_xattr() may only pass bytes to ovl_do_setxattr() that
ovl_do_getxattr() has read. When the read fails with -ERANGE the
function asks for the size again, and if the new size fits the buffer
it stores the buffer although nothing was read into it. The buffer
comes from kvmalloc(), or it still holds the value of the previous
xattr.

A FUSE lower layer that answers every sized GETXATTR with -ERANGE made
copy-up store 4096 bytes that the server never sent, with a kernel
pointer in them, as an xattr of the upper file.

Fix this by failing the copy-up with -EIO when the size that follows
-ERANGE fits the buffer.

Reported-by: Fahad Alharbi <fahad@codepure.com>
Closes: https://lore.kernel.org/linux-fsdevel/CAOQ4uxjhfpNVvoVrTayj46H2CViTOc3oxzM6xdb8+E7ikE2CSA@mail.gmail.com/
Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: Adjusted context to retain vfs_getxattr(old, ...) calls instead of upstream ovl_do_getxattr(oldpath, ...). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 01baaa941b5f1..d1a1b86262798 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -94,8 +94,12 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 		}
 retry:
 		size = vfs_getxattr(old, name, value, value_size);
-		if (size == -ERANGE)
+		if (size == -ERANGE) {
 			size = vfs_getxattr(old, name, NULL, 0);
+			/* Nothing was read into value, so it must not be used */
+			if (size >= 0 && size <= value_size)
+				size = -EIO;
+		}
 
 		if (size < 0) {
 			error = size;
-- 
2.53.0



