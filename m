Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061845;
	b=acPe9xHCLF43E39RLdjnCwiTmJgYvvpURAbt2spuHesAvXV4THqws/RVkKzAS2KdC6iV
	 OGVgEkGBtxcHNp70r7DZoMSyFqDeLts5KQG07+dx/Fn76os4pfdGAyMET7lcUUeg4GlUD
	 eEM1RIhwWo1BxldUJMSnPJZ/BfFjPsmq2f0gPopK3xfLaP2U2xsOIsjbFWrr4VU8CvxII
	 yfg/BsMA7AHGc0kCDzA3YPFt6aMqJ3LApDUepCVjgqH/mo1e1fUGP/lTmZSOM2pXHSbxq
	 NZ+hzbSgVAKL4hyF56aF7CmXEfMb9jI17sTPFTHsOryviNZYKy9CdAV4koUoZMz74lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RX37w+9lj6lDBgewaE7GrNETzmio+7aPRS9dlXXwNPc=;
	b=ZQdCFjZgXatRf03xwDjaCcx0CBIMol8x9FGGK6h2f/vm7sREqj8xl50tw4Sv4v7cWN+u
	 eSEfxeuRRJOGHoVMnULvL/yQuAl2Wd+cTjuL90MyRKRGzrb3ynwY3FxCKCdrJ5DGP0VRa
	 9KNpl9LddHkHYITAdu9GbgxTPNOoaG+RQW5o0fW8jYiEqZ2amq4Gq78j+0RQ99m0yz0wm
	 qfkw14z0TYr7fSxpaVP341poL/xJfv5ufV/XoOLE8P4TrxGsznyYXwm8w5fx1Tgi4Owg9
	 w8ig0JkBlhOfiwEqZZrqSeKoEmu1nUx/su9psn+B64YqiIWx6jogwn+wZWur+Xc8uLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQUF8jDn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F916606A326;
	Sat,  7 Nov 2026 14:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQUF8jDn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A91C1F0089F;
	Sat,  7 Nov 2026 14:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061845;
	bh=RX37w+9lj6lDBgewaE7GrNETzmio+7aPRS9dlXXwNPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQUF8jDnj5BOH8kzn8GTy2iDGPwiMVoZhadGRJlot0F6lrTvvIgZmk7rUxU8w1iDG
	 dfTu7ZqtNWucBf+hx0Y9wNPoDuUpM/POz3jdyFOySalNOHbclSdxtklA3tXCfAQAlW
	 mXbEhLdbjZjvBVvApXsXxXHsNL3laJjHDDJZY1o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0863/1536] ovl: do not copy up a dentry that was removed
Date: Sat,  7 Nov 2026 08:47:59 -0500
Message-ID: <20261107135021.789138431@linuxfoundation.org>
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

commit f635192ad223d2009ee640b63adf5ce3198aa338 upstream.

A change to a removed file through an open descriptor replaces whatever
has its old name in the upper layer.

Copy up must only create a name in the upper directory, never replace
one. After an unlink, an rmdir or a rename over a lower dentry, a
dentry that an open file keeps alive still has its old parent and name,
but in the upper directory that name is now a whiteout or a new object.
ovl_copy_up_workdir() renames the copy over it, which brings back the
removed object and destroys whatever took its name.

An unprivileged user opened a lower FIFO and unlinked it, root created
a file at that name, and fchmod on the old descriptor replaced the file
of root with the FIFO.

Fix this by looking up the target name of the rename in
ovl_copy_up_workdir() with LOOKUP_EXCL, so that copy up fails with
-EEXIST if the name is taken, as copy up with O_TMPFILE already does
when it links the copy to the name.

Fixes: e9be9d5e76e3 ("overlay filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: use LOOKUP_EXCL instead of relying on d_unhashed()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no start_renaming_dentry() and LOOKUP_EXCL, fail with -EEXIST if
 the target of ovl_lookup_upper() is positive]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index db128e1f2eb05..913e8adc9ea4e 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -831,6 +831,13 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	if (IS_ERR(upper))
 		goto cleanup;
 
+	/* The name may have been taken since lookup, never replace it */
+	err = -EEXIST;
+	if (d_is_positive(upper)) {
+		dput(upper);
+		goto cleanup;
+	}
+
 	err = ovl_do_rename(ofs, wdir, temp, udir, upper, 0);
 	dput(upper);
 	if (err)
-- 
2.53.0



