Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035418;
	b=L3FdGPPs1YtDa9DzyQo83wn4SHKklN2BBtJETCciXZItZAGgSkmSMaHZvVf0+SlmW3nj
	 Jm6D/GAechTzzxAr+y2asXXO4FdzVi9Aq/JqpbvLbnwkAVD+IsJCeqjRhuFJ3rf7U60NH
	 WTm1xpt2Wj3YTKE/cuc8MLWrZiPTpGGPO5DUUPdNC2clzaCO2q8t8bFmUjIUJ06S/cogJ
	 kXBePUTPl4a2kngc6/w4lQslS824Uz97injcCLudiVg4rbEgLpnXJSMtgDXyhpKuOPj2k
	 S3zSiuIq+sintHrFl/eEC6vCt6MQ+VibuvOtFnMFsTMFEkQ2kCO//vWI+TtZLxrBnTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RdaoLK31rATlMebSW2OJHKuSSlP+c5ukJRlEtPoS8zg=;
	b=rx/HTT8fCnyD7pQLfiUz/p/qzhYl7q5zutaCLBqiRP/p3nP9T9u+74vIxGHiMILN7u8R
	 WMQkIypfrPfOq2hhLJoCu+Q4Wpg3qXrkZXWGpxbugWT2eDBlR2G7nJAawL8ObkVGFM49I
	 fQvV2KySWFpoDX+BvSE+4eP3Jygg/6qF7nv/lkfL+r1dyDX4jhkMGwekIu6dd9yuohYGm
	 CWRGLjhpGZ73dkCWsYhqlvJBbOSGorD9Oz2qKOSWHr5kpx2zVB6aL2d1HUcQ7ByXeD42H
	 0q5LfKBeuvhIx9b3UjuYTXLKKbgmZW9VYVjCiUXP/Bp5oA5bdLV4s7fkJUvhA7jygxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYTof92e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6724C606A325;
	Wed, 18 Nov 2026 20:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYTof92e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CE71F000C4;
	Wed, 18 Nov 2026 20:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035418;
	bh=RdaoLK31rATlMebSW2OJHKuSSlP+c5ukJRlEtPoS8zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYTof92eRhlMUqNhhhp+oPJ6DGutk3vKjv344/n9idVhqgyKEa8M0zQ72qSyLE2kE
	 zsjGT/s//cWAsb/kMt7V3+DxvoUxgg561NnZ8H2+BBfBu2OVs1h7Y3bRZdktmenpCb
	 Yft/HMxXac4HQE0goiFOGmqLrzVJnNzpOaSq2xTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.6 0648/3318] ovl: do not copy up an xattr value that was never read
Date: Wed, 18 Nov 2026 15:21:10 +0100
Message-ID: <20261118150337.437482259@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

commit 755b5c5c9277be251a51623d6065abab948c61bc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -132,8 +132,12 @@ int ovl_copy_xattr(struct super_block *s
 
 retry:
 		size = ovl_do_getxattr(oldpath, name, value, value_size);
-		if (size == -ERANGE)
+		if (size == -ERANGE) {
 			size = ovl_do_getxattr(oldpath, name, NULL, 0);
+			/* Nothing was read into value, so it must not be used */
+			if (size >= 0 && size <= value_size)
+				size = -EIO;
+		}
 
 		if (size < 0) {
 			error = size;


