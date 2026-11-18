Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044606;
	b=EkqjDmauKscbD2lxli46C08wnkwswL+SyQHIuuzdEFKByfyKqKsfvxm/x24+1e7Mw6ao
	 F1zgWjKD1Yq7grqsGwyZvOoFSpJveSXnUs+6yqlYOOvYpFm48yFOvWk/BlW05d1MN5PGG
	 d4+UJh158lU+eg8jwFQR5pyMCYv6Fe4JBgf+S/m+5HD+mrAm6iKc2Viv+DMChdTJ/o6u9
	 x+ibjHJ7OiJrb+06UhSYBZBefPpBmdpW8E5kip79n1LMADU8A1md11XVj/bbTikRMcZYl
	 2KJgTEKTHoRr2Y1mR/5/onIM5btRfWmAZp0wu0jPoAm+vK+T85gzf8hODKj+XeKb+CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dxnkPiHl4VVjgk7+nJRsduUnYo3xrbaVqEdhcJgsbWg=;
	b=DA6KbNbm6Yems8tOU04+QY8b+l9o6SMeV9vswt/nJyZNSMtS8soqduJ7AFzr49oqaAEJ
	 gDtmkTbNpLq8PS4doDpBpUOeVkfetBvYXldXpxRZKkmWjXZSrh7sNb0ACFNUR1qVtXDhd
	 Ne8IOX6FfyNZ/LbPAzY21BOQ2HFZGThSAbTsA/JGWDsvJJ7Tu5hlit9sJoW/f1NQW3ODU
	 dN2Ti5FPT9i6ONISqNhEUHd7qJuRZ0tlaJ8VAEFOirpP7fVrzKIOveB/8WnoEXpJlxBvV
	 Zg58UYYa113KnhG1bMYTQpJve541BYmec1NomVyUnctLSbKZW8dsvC5tI1p9AUzjpgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zh/D2uW2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79025606A31C;
	Wed, 18 Nov 2026 23:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zh/D2uW2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD201F000C4;
	Wed, 18 Nov 2026 23:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044606;
	bh=dxnkPiHl4VVjgk7+nJRsduUnYo3xrbaVqEdhcJgsbWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zh/D2uW2f91jQ4REnqLb/G/6G7kDsh/v8gBThmUY5rVecFGR39TTm+esuS9GSNyiF
	 R28tAzA2rwj259c8bLpYZ6qOiKeRgOcyGA/5vUYz/pU7rMYSxNHPQ3iYwYIvq6mzyO
	 TjyoEXVRrBf9EL3b/Jb+euH2wwW1kb3opvqiiFEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 0577/2857] ovl: do not copy up an xattr value that was never read
Date: Wed, 18 Nov 2026 15:26:51 +0100
Message-ID: <20261118150222.261716959@linuxfoundation.org>
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
@@ -95,8 +95,12 @@ int ovl_copy_xattr(struct super_block *s
 		}
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


