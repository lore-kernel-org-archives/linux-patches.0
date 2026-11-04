Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830910;
	b=jHF5ehLz6wyFnEeKkE3V2Vu4sGDo5RKz3OQhHKcJkNWUWNd46mKIxPRvIOScI0XVjZkc
	 Bw2lrIaETiYmpGNjGHc4fk+m6wNGxzm0UkQzGiDOI12roW9Lf4tnzTksryUDJsxR1+3Iv
	 ItsWXd4CMwjQ54k8IeEbXj4BBifSPBahDi0k1ebt8cZVW+R8stPfNCtYqh14WL417uLNc
	 43KVrstrnvXAHY5ihpkkvnHbZYezoKB+ogKWKr1AykqKgjl8V3mX78nXDrJxNkQSCmBGi
	 VdqCzaOSG8yl9fi+euzs0rWWFHgPvUbbxtaJ0e0EkEblxgc8bEbTBioBHXlT1CeOoHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R8gWVRvlLiHCCudyhjTJm6xHhwNPW3UKRNZTU0d5/ec=;
	b=Doxi6mLMcj6w+/KkDn0Mxf/ED6eGPYsdCcuTj6t/+JqelVRDLtCUdGlirbPVtDI/cbt3
	 sUiCE2ziXzZULBlBTbi9O+oYdluWjCH/KsXtQ8ssNrxDnfJOSoPnpyJEApVZRBKmKbXkP
	 f7WsgeGm6Wz1tLVZGoayX+OaSL+9UbQgBkjKOqQ2+qoVPi8E2Lgi0/OOmA7EkM8Hscq9q
	 7XOPVhFrWkVjzSxU6JBk4Sa17vbA+an69Zd65mB9+FwPEr1SfhDkHDB6Un1VDrcSxPPIk
	 owCjt0EpsuKfVpwqmWYs8i1yPyzw+DzMJtp3z8LFbvkp+OExtgc/YMnT4l64jon0bmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFii2BIs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C9A606A841;
	Wed,  4 Nov 2026 22:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFii2BIs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76D01F000C1;
	Wed,  4 Nov 2026 22:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830910;
	bh=R8gWVRvlLiHCCudyhjTJm6xHhwNPW3UKRNZTU0d5/ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFii2BIstNrjRMK/3D1kc8GWogwQiRRLJPYCU/EIxWtYmiGLVr/LfVdCdtZkW8RAu
	 iaOP97GI+ttDZfOnCj3TIBx/dOYjgx+E1brujyHeooN200CqLt0VLSntQ0UMHkpcqS
	 4e7KZ3ACeHjHDqCq1DuVZnkvJi93RJwRCMLH8SGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wen <anmuxixixi@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0397/1005] exfat: keep FITRIM within the requested range
Date: Wed,  4 Nov 2026 16:02:10 -0500
Message-ID: <20261104211055.189880466@linuxfoundation.org>
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

From: Yang Wen <anmuxixixi@gmail.com>

[ Upstream commit 2de727471b3b13409466a4af4f8824a86073bf4b ]

exfat_find_free_bitmap() searches the entire allocation bitmap and may
wrap around to its beginning. exfat_trim_fs() does not verify that the
returned cluster is still within the requested FITRIM range.

As a result, a partial FITRIM operation may discard free clusters outside
the user-specified range and report a trimmed length larger than the
requested length.

Validate each returned cluster against the requested range and stop the
search when it wraps around or passes the range end.

Signed-off-by: Yang Wen <anmuxixixi@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/balloc.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
index 0b6466b3490a0..4013034375dbe 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -327,14 +327,27 @@ int exfat_trim_fs(struct inode *inode, struct fstrim_range *range)
 	mutex_lock(&sbi->bitmap_lock);
 
 	trim_begin = trim_end = exfat_find_free_bitmap(sb, clu_start);
-	if (trim_begin == EXFAT_EOF_CLUSTER)
+	/*
+	 * exfat_find_free_bitmap() may wrap around to the beginning of
+	 * the bitmap. Reject a cluster outside the requested range.
+	 */
+	if (trim_begin == EXFAT_EOF_CLUSTER ||
+		trim_begin < clu_start || trim_begin > clu_end)
 		goto unlock;
 
-	next_free_clu = exfat_find_free_bitmap(sb, trim_end + 1);
-	if (next_free_clu == EXFAT_EOF_CLUSTER)
-		goto unlock;
+	for (;;) {
+		if (trim_end >= clu_end)
+			break;
+
+		next_free_clu = exfat_find_free_bitmap(sb, trim_end + 1);
+		/*
+		 * Stop if the search wrapped around or moved beyond the requested
+		 * FITRIM range.
+		 */
+		if (next_free_clu == EXFAT_EOF_CLUSTER ||
+			next_free_clu <= trim_end || next_free_clu > clu_end)
+			break;
 
-	do {
 		if (next_free_clu == trim_end + 1) {
 			/* extend trim range for continuous free cluster */
 			trim_end++;
@@ -355,17 +368,11 @@ int exfat_trim_fs(struct inode *inode, struct fstrim_range *range)
 			trim_begin = trim_end = next_free_clu;
 		}
 
-		if (next_free_clu >= clu_end)
-			break;
-
 		if (fatal_signal_pending(current)) {
 			err = -ERESTARTSYS;
 			goto unlock;
 		}
-
-		next_free_clu = exfat_find_free_bitmap(sb, next_free_clu + 1);
-	} while (next_free_clu != EXFAT_EOF_CLUSTER &&
-			next_free_clu > trim_end);
+	}
 
 	/* try to trim remainder */
 	count = trim_end - trim_begin + 1;
-- 
2.53.0



