Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043524;
	b=LCaDo/p43xR9ki3p93toGES+iRcd/3NfOTpdYL/VY2OVmXM8pUkoJXzN0UZIRSkLBUqm
	 oMDAOMsHCgcgOcY23Kz0rr43q5JYqCD4FDWdypkcVnT9HtT4aibD8x/4ppBrpoRkOpOGk
	 bXRe6AMjkUm3katWPb9Up0J0RPNirLwcOF32Mo5gJBANiMfYsoxnr+UzELXh4TH422c2i
	 QzTmsv5lZrjB0CXwaxLl+63mbp+65UwzMGpc27b3lri5ylzwFZa8eVH5mjJ+yApzgtal0
	 ptJv/guOssoFzr22sdfx3COus0epjRLuNWZ0uSyiQSL8nHDperFjc5SJVuchfMsqvGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l2ExemfTt1B9Q2I1atgVWXd9RQqFXyQueI3HLCCCHmk=;
	b=Wqhs39ebTbpblwzhHjr8k0NcV3VLHA9hDEdm3ADhSujpYyzr6x3wV+fJNY/0I/f/h9p4
	 v02wSwV+u2+cbTQIjW/eUEi4jFIdic02XnQwrPjBK9xM3eaHxerOcTpRQ2hXSexbn5J3i
	 iGbJlFmbsm4YJ7zILYoNnjFEYerm3+EDakjpsc6dNekrmOoHBtp/58XTAEWGqcwNCetRR
	 X+3i3JTi81TqPShIPEICAHxU3fItiDmK8yxnjobySvMzkV5eenJNzv42jNUe8Y5Ze4YoZ
	 gpGIw8c2etYUZoPC46ewr2ttxZZ6l7tdzx/nx7QnLACwYc02Ie3bsIDdJ8k1hQWoyfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pP0kDjRt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9862B606A31C;
	Wed, 18 Nov 2026 23:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pP0kDjRt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D221F000C4;
	Wed, 18 Nov 2026 23:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043524;
	bh=l2ExemfTt1B9Q2I1atgVWXd9RQqFXyQueI3HLCCCHmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pP0kDjRt+7KCyzzPuQBiOR+ofLKg/5UTulxLPj8G7nRSMMAplAD17fMI5mVFx4cxp
	 XSRWMH/TB9F51k8MSLvOyABraYMWwvBp9MceCni3hDX28xkE88PoON3cZDopddT24b
	 DZA10qBOO9d0Kp+Hz9aJGr9CSdz0papyOrM3jHVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wen <anmuxixixi@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0242/2857] exfat: keep FITRIM within the requested range
Date: Wed, 18 Nov 2026 15:21:16 +0100
Message-ID: <20261118150210.161628626@linuxfoundation.org>
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



