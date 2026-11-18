Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051435;
	b=lSdG9Zj9/RVknWBCdp/OZTvVIqn5u3fLc1aduEIKduFmD5oov8+yg6CMt3tvMngJbJXG
	 jFF+31jVLcifSQo1ESnmZ9NiniDaH2LALjsSEEJVOGXtwU6QxU2jjt/JV02uLDwLSp+Cz
	 OwASVZ7AC4Hy6qRvm9g/7Oiyv1tf6vm0uJ36xJhW0wb/XNKVNZnrSqmt+z9Yjp2ieGWVK
	 Rx20DGhRU6FwylFAkyH6FYO21xJbG4BXtLMelK/2u5q4hUMNEV11ioT7xrow6VeMBb1ie
	 n4KMs9M6SE4QOTxjYN9JkWcNWCcn7mTi7Lnrq7i9U6Si4IRWNQ/jI2Dd6MXWArXJc4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t/u39wHQ9Qzrv4B9M9mkOeWJHETeP2GFTRSThcZgW+g=;
	b=YTQ33UmNPHpHH34XdwwFOfLe83iNbOCm/IEWYQ2RHffpcp2RLjDby39eQVYQCrhEUELD
	 at0Ys9S+WPBSHPD0Ac4IJ1LydzqsonBvycIvRHaZHYgPHEAMekVT1znj+/agFMgLebmE4
	 DkIqM7P76vLelnEgf582Kcufkb12GiuPQJFr4XIPSUHz3yD0c3J1fiqCLXko2YRXWXnWL
	 IJSYzb8+LKpbsaQjlnhH6o1yH9oFdgNY7WJGPrM8pC08Kd3KEyNuWKV5XhVbOb2JCGs9d
	 vgJKmUc+mVXGYe181DaRyb+2WQIkea4Et7OGpIkOhixCcmUy92IMYKplHoAlQ1Yo31g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGon2FnX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC6A606A31C;
	Thu, 19 Nov 2026 01:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGon2FnX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42651F000C4;
	Thu, 19 Nov 2026 01:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051435;
	bh=t/u39wHQ9Qzrv4B9M9mkOeWJHETeP2GFTRSThcZgW+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGon2FnXvtkXhaZHF7YESxs1amsXSM0mgAqMRC03mGqBy85wxUAoyBWsEshpcciq0
	 acHb21MqDYy8+dfCk3gR2f8F/RP+FzQJLyOTHkEIf5W+TDkOOPV4ulZHbGjXDkVXM0
	 JC0AR6rJSWWvNBE8GKX2njHdgN/G+Ol+S1RBKXrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wen <anmuxixixi@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0206/2214] exfat: keep FITRIM within the requested range
Date: Wed, 18 Nov 2026 15:31:22 +0100
Message-ID: <20261118150018.449181277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 26808f0d3e9ff..0ebbfa55caca6 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -297,14 +297,27 @@ int exfat_trim_fs(struct inode *inode, struct fstrim_range *range)
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
@@ -325,17 +338,11 @@ int exfat_trim_fs(struct inode *inode, struct fstrim_range *range)
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



