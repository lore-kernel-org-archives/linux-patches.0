Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831539;
	b=z3quvckeYbKAjmU36IrZPjFjamRDjw0fy/5b0pM1WYf6PtXPYgbGbd5PtgmtiN9BS37s
	 +4wPtE/+5YeFHWOCCKUWhYmr4/aVt+kRa0btgfXQuaXCLTs52ZaJe78P5oABpjL0P3Uf5
	 oojzMkaNGB0GKa/nA1jXIXZMQqfJ3z+NCNEBLMHbA3Iv57zgvBkSsr24UeOPtyD7eFK2U
	 WgkY9dz5hQ1cZJlojvWE4lYWSUC04vmuLgo+67WKVlOH1cXt8W3MGlPgHOtR+wi3FM9mc
	 XiE4ZfE342bG+qpP0WvUL5e1ss/urywfoPl2oGw7612vFWY9rmrtDcKsyfTFLSOQWrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rerrs5uyAerDdgcHpwU0EvyJuR+Bjg5mBmA2axKB9xo=;
	b=CKepzGS5mReSDF5FECpcrTT29YQEQBHi/egR6QX8MnFirfMQv6sJ6JRfjeuND3GAuKo8
	 cPCYquv+Uu82jWAwGk5ciwwyZdRfnie3bugRNexyrAwLwjF291HK8/XOW0stDpxPOkce+
	 fv0HInAA14BBaVgMrTwuLYRbtEYjrak4ZEC9L3p5efqZOZZmWwdbYojQXE+F4agRJe4zE
	 RPYuhssc4z0uJeAlEV9LdEdBcJyAcu7aY86IyJH+L2J/WUkoPFW87/G72WCTT2uI1F07p
	 pIHV6kAvVknsVZf2+FeHQMzGW5lR6EF1SYxSRm+06KnybI+ETn0KUpVfPS9dv09aVWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1BhZNEN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A58606A332;
	Wed,  4 Nov 2026 22:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1BhZNEN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489181F000C1;
	Wed,  4 Nov 2026 22:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831538;
	bh=rerrs5uyAerDdgcHpwU0EvyJuR+Bjg5mBmA2axKB9xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1BhZNENbeN7QnoWJ1xEmbVi958XSPLP/F8gSHCpBsMI+KJumryh1C6HJErmOWn/0
	 6d0JfQ1bEKwvYbGw6GX/MQN0VAzYEky0sS1Fk+B4nRQJkMjDQqQRovrg1nOtFO2FVz
	 LU+P73yeo1UnC9f7DdpgppuRPiJpTOEqZlPH49iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0766/1005] ovl: do not copy up an xattr value that was never read
Date: Wed,  4 Nov 2026 16:08:19 -0500
Message-ID: <20261104211104.863755193@linuxfoundation.org>
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
@@ -131,8 +131,12 @@ int ovl_copy_xattr(struct super_block *s
 
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


