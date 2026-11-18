Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021177;
	b=YrAsTuLYReFKGhyyIfSjbrTucTOGeg56FxqWjmNUiknJeqNHl1D1hMV1H3XiwGxYQvg2
	 1SV447iQEn2q9rALV0hQO6VzGzkfM2xxX+OfRWQiUKpAs2YPCfp3zGnxX88ecgFGnfqqe
	 8FooGour6hoS1UyRGxVshu0bwuzoiIcpln1pikeNkk1qEIdRVqZmjV/aRmqHyMbNlAALw
	 g7sLculc89tFcladgEMsvSizyFhVzbjswl/xYGD3YBZi4I2eA0ijiPUHW7zEBZP2IeYsW
	 7zt8HcW7yEgxvYQpz1rQ6BbG6px01qWyUW/84kX0wxPZ+MQUyhNlghjJtzpP4UMefvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PbdDe7yfSO220EtkaJzhhh81+/cQeBncWKVYKl+JDZo=;
	b=vY36L8uY1FEmzgds7zT+pIbQxtGjZ7GPRYDde3sebpaGaNBnmfQ2tx7yN/Hq35G7z0Fx
	 EN6dT60o9fYVCOVLwLRS5eV8xXV3bQMuoIN2SVS7ZYvitTOUUQwqi4K8IRXkcXFtCTt3R
	 H99oxJzmBLjUWwK/ghrLniCOYSGz+a15hwwJ5DsTvqaTiL9dGcuypEfXOpgkA9zXGHQge
	 INO9XeA/JMLknatif2istZczPoqqn45RX0aSBns1XMLjFTq0aLckCEUFragf0WAdEtIIy
	 LEGNaLvoPiDd8KKMrAZ0X4I8O+m1Lz/s9pqSDuBBX5YJAnBpgIAegp2EFtuWRfNYjUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RYBXFwmY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5973A606A320;
	Wed, 18 Nov 2026 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RYBXFwmY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605E71F000C7;
	Wed, 18 Nov 2026 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021176;
	bh=PbdDe7yfSO220EtkaJzhhh81+/cQeBncWKVYKl+JDZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYBXFwmYsfvXAD6rF4N/Mh5Vq31scZ3k+oDReQ7uFuIf1IQIt4Xo1p56zAC93RaG8
	 hYGCiNro609KxyhDqjmSbT0He1vZ8T/nMZDPWoPIOjhr5vnQOaPbvhkYQ+Ee0+/b4P
	 OThI4C9vXENmHMcowu5kFXtyzZC1HrQ0KSe3LnvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2213/2651] ntfs: accept standard sparse compression unit
Date: Wed, 18 Nov 2026 15:57:33 +0100
Message-ID: <20261118150405.304676915@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 87a548005f7a56e4171ff5d2050c591547b5449f ]

Windows native sparse-file inspection shows that a non-resident $DATA
attribute can be marked sparse and record the standard compression unit
(4) even when the file is not compressed.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 302089f7f83a4..71b364e2ca73f 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1148,14 +1148,21 @@ static int ntfs_read_locked_inode(struct inode *vi)
 					goto unm_err_out;
 				}
 
+				/*
+				 * Windows stores the standard compression unit in
+				 * sparse attributes even when the data is not compressed.
+				 */
 				if (NInoSparse(ni) &&
 				    a->data.non_resident.compression_unit &&
 				    a->data.non_resident.compression_unit !=
-				     vol->sparse_compression_unit) {
+				     vol->sparse_compression_unit &&
+				    a->data.non_resident.compression_unit !=
+				     STANDARD_COMPRESSION_UNIT) {
 					ntfs_error(vi->i_sb,
-						   "Found non-standard compression unit (%u instead of 0 or %d).  Cannot handle this.",
+						   "Found non-standard compression unit (%u instead of 0, %d, or %d).  Cannot handle this.",
 						   a->data.non_resident.compression_unit,
-						   vol->sparse_compression_unit);
+						   vol->sparse_compression_unit,
+						   STANDARD_COMPRESSION_UNIT);
 					err = -EOPNOTSUPP;
 					goto unm_err_out;
 				}
-- 
2.53.0



