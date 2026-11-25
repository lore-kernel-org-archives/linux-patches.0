Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617742;
	b=pxjemahNrlWJfZDLGPLCKKm8Pt2UCevyjqaolSsHp0uVj9q3h6z9NxYh1hjAhJCx4BCW
	 UefYnEk48cjVZhm/o89b7tN363yhlFMEs4DitZPpdX+XBGT8SkX5BzGOT3iQo61f8Au2f
	 BA8kvwE9w4MZYxu1FJ82yqwLEdpvE7YFPH3BQezwj0SeNWoUF+9Htuj0L2ndu/b1t5TXS
	 GLwuKH7d5BaVnOYWctP4XVZ4LicWmTi1XtBoOYwQdM5fDUmyIy8bP7j+hQ/7PD6JIIvCy
	 6eSubJsdowvkznTjWY48qjg23UqvgN/RDPeYl2t2IgUQVsVMvXEL6RVtTKK2PSKq7cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nfl31UY5gw5p1gFPJUTiBEku700+OdBOAqUE/CRgaT8=;
	b=luxKVII0PvUi0b8yTIZ+31j5+ID6/qOamAE4MZoamBS5A/RY9rsoemPRRNHSYe6a5dVj
	 AhH4Z49edR2w+gJUEpPJQbO+NfbaStyE9ZsV3Rl+oAcCknsCGSyYQuhhn0hdvoXmb5M0+
	 IT8hwZ7ex/M7Qh3drugP0BsetBDDEdVS716Jcj0ej1oTVX/anLX7BnMlkQesudUsFFaZW
	 g6djH4qV6wc2Uky2dpcX+frMFhc+vfRNXoXkfmaq8VTIPYOvW6cxLghftM0RNZsgqsV1B
	 fk3AlJ6aDdx+xmWw1tcuQ/fuWq9VLoCNHfTIktpeDoCpkfls4IoS+aTCONjL3+vI1CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9vlabvc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44BF606A31E;
	Wed, 25 Nov 2026 14:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9vlabvc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF651F000D4;
	Wed, 25 Nov 2026 14:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617742;
	bh=nfl31UY5gw5p1gFPJUTiBEku700+OdBOAqUE/CRgaT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9vlabvcg+vToEmMEYZ7Q5UGzyprD0DAQnm1xL3hc+HtzUuT4NgfEAxKU8aQiQIfA
	 Hgfyo12ZPrBzNx/GjBQvZ9FhHYQ//56TfY0vGQOnfnSQ3QHTd+UkbZov9MQKCUOCZ5
	 SFgd2aa54C5ko4iWXE7C+OyH8Rym21hsL9AKwxyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0059/1005] ntfs: initialize VCN when inserting index entries
Date: Wed, 25 Nov 2026 15:23:17 +0100
Message-ID: <20261125143823.124222075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 1f3c5ba3c55c112a0b33c03caa9d5f88bb9e7759 ]

When a leaf index entry is promoted during a split,
ntfs_ih_insert() extends a copied entry with the NODE VCN field.
Initialize that field before copying the new entry into the parent
index. The promoted entry must reference the old child VCN, while
the existing parent entry is updated to reference the newly allocated
right child.

Fixes: 0a8ac0c1fa0b ("ntfs: update directory operations")
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/index.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/index.c b/fs/ntfs/index.c
index 9a23d0786959b..9309e617451e1 100644
--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -1547,9 +1547,9 @@ static int ntfs_ih_insert(struct index_header *ih, struct index_entry *orig_ie,
 	ie_node = ntfs_ie_get_by_pos(ih, pos);
 	old_vcn = ntfs_ie_get_vcn(ie_node);
 	ntfs_ie_set_vcn(ie_node, new_vcn);
+	ntfs_ie_set_vcn(ie, old_vcn);
 
 	ntfs_ie_insert(ih, ie, ie_node);
-	ntfs_ie_set_vcn(ie_node, old_vcn);
 out:
 	kfree(ie);
 	return ret;
-- 
2.53.0



