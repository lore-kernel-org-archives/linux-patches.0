Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019202;
	b=H3QGiejYlxSo2YpfXt4DZBuWgflJ5S5oIKlhq/gt+Nm5d1n9VMfRfMYzxuO958IeESX5
	 R8elKQGube+wuFiFbLvyMYyZcMeJp5ijx0x0wwuMdrp9BYw0ir/V2yxCQSmutYaYdhb4x
	 g9qhWizUlscW1mbDgb2l20onGHYZToND+c303kXYCOzEc83/LjODClWlkgKlemHLCNHT/
	 aFQMkWFrqtfUcU+05TSNGa74PRQZ6bnJHMocnRGzhDHWvg9Qq4JJEGDgT5Uz30wAf3cyD
	 gwHz9G4kUoUIvNZdcgDzKhkjjkTuKKZC5CGfZ7WYzj7+MssSXODEK0RCLrvScSBDP7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KUSx7ee/GQIHgWSe9kvM5EIFGd7eB5SmR2OYCB7TJLA=;
	b=mBdbTr9vEvhQ4zTHL6Pd+iVGGAvZ1PdpQDlCJ5Lh2+Wz+DCC4QvHI8TXiH4oIIB0V9eQ
	 Jy8L1LBah3r1HqNHRliYkZV0oHzsLtowdxl7xfvGX+z1fwjXNCp7uhXOE0tgPwJ7uUG5U
	 DvRaTxcVlWRXtEGCZ6FB6BjoGibU8AxsaSJD/ShChe+WtqQe5okqeg+4Cme9KP7lGBYyV
	 0aSqU5c4DiKYpYcDQN9pWxcQ7j+V2DuM0pOO5jOLTksWGCGxQJRER8Ww+Bmbz69NZwjB1
	 JJEhD8w+RXlLZ9HAmFMqxx3kU9hLQGDnUYwnmY5be8q6uDmf9388M/2mhjkf9HMEpUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dz6qEDKt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64826606A325;
	Wed, 18 Nov 2026 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dz6qEDKt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D121F000C4;
	Wed, 18 Nov 2026 16:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019202;
	bh=KUSx7ee/GQIHgWSe9kvM5EIFGd7eB5SmR2OYCB7TJLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dz6qEDKt+td68wQLmSu0tiR952sMLQ5S2TBFwDqm3ypgbQD1VJ8r7tFpbLxoq37Tl
	 uKRyuNohBMNifIc088gUxao32G5IIOnX471EWVAd56RymBuMm7wRyfPYPxFWNd8yjj
	 THXinjZHkvotXNjpWLD5PZ1h5LOoRfpx5y0XF6BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Morgun <d.morgun@ispras.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1511/2651] fs/ntfs3: check return values in indx_delete_entry()
Date: Wed, 18 Nov 2026 15:45:51 +0100
Message-ID: <20261118150342.398968752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Morgun <d.morgun@ispras.ru>

[ Upstream commit 131f7d7abf0f10edc6ea6b032f8a3908bdb13ce8 ]

When the index tree collapses down to an empty root,
indx_delete_entry() calls attr_set_size() and ni_remove_attr() for
both ATTR_ALLOC and ATTR_BITMAP, but their return values are
overwritten by the following call without being checked.

In most other call sites of these functions the return value is
checked, so add the same checks here in case an error at this point
is meaningful.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Signed-off-by: Dmitry Morgun <d.morgun@ispras.ru>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 37e3e16b1f841..bfc6d1f6d2fc1 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -2711,18 +2711,28 @@ int indx_delete_entry(struct ntfs_index *indx, struct ntfs_inode *ni,
 
 		err = attr_set_size(ni, ATTR_ALLOC, in->name, in->name_len,
 				    &indx->alloc_run, 0, NULL, false);
+		if (err)
+			goto out;
+
 		if (in->name == I30_NAME)
 			i_size_write(&ni->vfs_inode, 0);
 
 		err = ni_remove_attr(ni, ATTR_ALLOC, in->name, in->name_len,
 				     false, NULL);
 		run_close(&indx->alloc_run);
+		if (err)
+			goto out;
 
 		err = attr_set_size(ni, ATTR_BITMAP, in->name, in->name_len,
 				    &indx->bitmap_run, 0, NULL, false);
+		if (err)
+			goto out;
+
 		err = ni_remove_attr(ni, ATTR_BITMAP, in->name, in->name_len,
 				     false, NULL);
 		run_close(&indx->bitmap_run);
+		if (err)
+			goto out;
 
 		root = indx_get_root(indx, ni, &attr, &mi);
 		if (!root) {
-- 
2.53.0



