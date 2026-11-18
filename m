Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034188;
	b=IgXJ91woFFhBOaedWNG+pnDc2pZupwCJC3X41mLvGkyWMS76b7QJi6NCyn/1uq3LdaeZ
	 +bnTehMEDAlifa0eWIjUoGj9McqqabDS2nl6NOM7iEQtT91JBU05cfaNsrK3sLNYnuJ1W
	 UG7x1A04ml8W242om8iBXUQrXejFVLvZlkjKxms1RE4UCF9TX+MxWERQCRSu1XFuoqNu/
	 5tkxLiHqWh3cMi+WNr660Cot7jur34XOAadE5amL/RVYTEmHoG561PErPl4hyzHFjQppE
	 mmLZWMsUgrRf0uDBKp4E3iitb86bJ4xRrPbbLg6uAtQ8cBhAK/91vlqVo5a/x8DqS6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMkUBe+WqEOxjyoPFKARBonVrM2FRmkI6uEQgPgSqcE=;
	b=Ka3krVNVDyLu71rLYaNpjUYIzAuK51p3t04qwlpxHDwH4v4UV/4S6LjAUwsz5v9UOM6o
	 0hGpW8DKcyhFyu8ulAgpBvkIrAf0aXBXzs8c/BMEzHRMxEFhojaqQlVjysMcSHqKkAWrC
	 naQ3BSD9Wp9W9xCVa2NNeNIfIGSWP3O5/I2PZycR2uFCpC+p/v4XA+BZ9foeZzT4o02ZC
	 Sw8uHRI9Bxz8MZlXSOSjpos9MN7ftEi+JYJ8D3jwHczTnT/QQPjYq2PU96t7logYpORyw
	 ehRTCUgiLpGrjj7mJst4RgjIJ32eDY58dvI+FBpSUzL3VK5fAbRxsUiyN8ZtthI/nmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sgem+Siw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B0B606A336;
	Wed, 18 Nov 2026 20:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sgem+Siw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935251F000C6;
	Wed, 18 Nov 2026 20:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034188;
	bh=EMkUBe+WqEOxjyoPFKARBonVrM2FRmkI6uEQgPgSqcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sgem+SiwS4dmOfHsA2yQk+1m2HUdUmjxzLgehV5sLzUtjVGSm/ZhP1917FCAFVqlF
	 StS2h3GKA//+x0RqSJj68pRtrChD1sMVti6s1OpJGd5AHFH5Us7M5hzCIuJChrMvp4
	 utq2ZhPu9wXAW/VefFowsnrtcHzJzCoMfMnuN37o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wen <anmuxixixi@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0280/3318] exfat: keep FITRIM within the requested range
Date: Wed, 18 Nov 2026 15:15:02 +0100
Message-ID: <20261118150323.920141822@linuxfoundation.org>
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
index 2d4fe3d754bbc..3f014daa5ecfd 100644
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



