Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061611;
	b=tWHIrn8f5rzg6g3loFhxrcOACZm6tPuM++VxDWERIptXz2ZeaRWapJetQE4AJeusV5pg
	 OkkCibbztWjZLSgbUw3hVcPpo0xtrSnJ3ADUrC8t61FHKQszoWEf4eHyTz9rjD94RCyPl
	 6Mwo6kvZSjaE6FyK0CjNSgL6LVd0PujL3BBL61jhGn1PkWA/W9DWH/bbmEskMMJRgKSQg
	 wMmbsFP6P1Hignbq6ynKdCJpM68QLnRuzOgTqQmlIYnEjCXjFb8rMOqufchJYgrg67r/t
	 e7Ql12+UWOWfzCA/tZGZ8Vz2eXqojV5yXh+tvMdaiJTAhA5MK8DHa5vZW23JXR6MaNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+e1L83lV+8Pu+aBfD29RA39IH2EoQMI8vSg0aOMOO6E=;
	b=C8sAKvW9iSq2FvNmco1cG+pIBwE6OJcvXF/CphMB4XamLgmVGD7xYDx5zKwiqZI4E4Mo
	 jt32oywUvs8Q9ChPQGoz7mrgnEWuFteiurqJMN1XJjNEwuDlRiMbJLK0CBcVtWLll2Y0s
	 5XZRFeEGNpURw73l4poZcEeM7/fWiAKk+Y2kiU2TJO4KjBJWPq5ZvwQKup89M2BfeDNZI
	 NhjZ2wrlYDeX9IAH9b2V4iJmdD/cpQzDcPLa/d4H+mTbOb0h/Yko+xnXTgmgxzWvYhrXh
	 RW8ELsQirX2X9VAUhSDKa1mZtx1vw664d29ykcwrocEhg0ocnmjtesAuk+CEWjh9JrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDQpVVek;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC1B606A326;
	Sat,  7 Nov 2026 14:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDQpVVek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6BB1F0089F;
	Sat,  7 Nov 2026 14:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061610;
	bh=+e1L83lV+8Pu+aBfD29RA39IH2EoQMI8vSg0aOMOO6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDQpVVekt/60wv/hAbDyZxIGlPWXiDeZ3xTOrH4TW/3sD27vWyPV/o6EEX8wQ3u3x
	 KZgGWcif7zjCmrLV3xMB3CDrGj3PDaGVwJterrleE7HNSj+rWpPx/H0lj8FlJT2Akt
	 43J7drCZw9LU06MrXnNA5kGlVHKYc9K/kR5L3C1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 0681/1536] ovl: do not copy up an xattr value that was never read
Date: Sat,  7 Nov 2026 08:44:57 -0500
Message-ID: <20261107135016.612889260@linuxfoundation.org>
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


