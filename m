Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622556;
	b=RM651LSCSy35HcZOEnCAcWKWLwdrb2zUuJ4qkKXusp8QIc3Cf1P9tQQ4sVB1XDx3jzuI
	 9BUfBdzVUl2LG4wuV13cIqROBI4SNhttQTH52b6V4RWT1PepPsqYgoDIFdMNQ2aGZZ/Lm
	 1ME2Q+7UwasHEa6zRxlpu6KITvGvvL7djW5wyMTs1bhCyvjXXaPUiqKI20boHmO401YeS
	 QxesAK1PNIcvQsf6MbIS6JOPQ1WAIwrxwLHoHKZLw7xUbtMjgCnPTBuuWOKhLfIxTl2Ah
	 34mgvrCYl4QPu/YTQYLoJ5VOdgsijoGnasSJHvxhMTNUEt3uofQ+gSy2wrMImYCpEgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Xxx0U+nHXc9bTWQc+3QhgwNg7rlsYRnNyNUXXHadnQ=;
	b=d50pSTAz85fWpHPrFGspcmAUyL1J2Fu5nWvdMNB3jDnMO7iUJf6rZWXqRR/9pxsCmQnq
	 H0x3/GoBI0JOSZ7CdkUGJo0si5qaZmKG6IXlqqNN6hp90yRNlJIFt/Zm2s3dDU6O4FPDi
	 /RcEzpJyfANezt6qVJAg3lqjuM3YJZXJ2tPhTYA66GRyMAo/BoNYm/Gi9bYppmVmrnJbb
	 pTNwTsMCMV87z3GFFMgmw0a1l3UJ8t6cpAf9NtR2tR+zIhrkPQOQvWDtEfHT4OHkkyJma
	 ISHOqmzUtAlovuA4DO57+l78ksNeDDgejtI+DkbtrJFCEmmIt2YDmAgYEWwGVDpn3KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QQrfELcP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34771606A31E;
	Wed, 25 Nov 2026 16:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QQrfELcP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFFA1F000C6;
	Wed, 25 Nov 2026 16:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622555;
	bh=3Xxx0U+nHXc9bTWQc+3QhgwNg7rlsYRnNyNUXXHadnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQrfELcPxDZxsKqqTjQOK74sP8jd/Nr8W45SoJCwU4yte+DC3u+LwdmMQNG0gOEM3
	 hBBBAY7rFNr2o0vpqe0XxNpaPaNxzShgqVOL0sJJU0npc2F2Omg4A1xmNRhkRIrDcr
	 Ue/EUnqGgeF64D8MfNo9rLx4bZa55uWmYohatU8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Morgun <d.morgun@ispras.ru>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 574/990] fs/ntfs3: check return values in indx_delete_entry()
Date: Wed, 25 Nov 2026 15:32:21 +0100
Message-ID: <20261125143835.536032734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: added the missing NULL argument to both attr_set_size() calls to match this branch's older function prototype. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 97cbe176a83e5..88a5f336d9040 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -2691,18 +2691,28 @@ int indx_delete_entry(struct ntfs_index *indx, struct ntfs_inode *ni,
 
 		err = attr_set_size(ni, ATTR_ALLOC, in->name, in->name_len,
 				    &indx->alloc_run, 0, NULL, false, NULL);
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
 				    &indx->bitmap_run, 0, NULL, false, NULL);
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



