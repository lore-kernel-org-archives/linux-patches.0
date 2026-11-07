Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061032;
	b=zK3CWMD0RylmUxC+aTdLcxehMoWNh5iBfaPK/iSxrniXAOdPCSKXzju9TrRrV+GwOTU3
	 g1w1Dplgcbysi1foHP1aIHIXroI/KytHZx3KhOEGbH5FJPvls6eTh4lCUQjz9YlLjcjD0
	 cY2pPmVwpJBSAgqmlkTALe/eQ+3tp7UxyvR+eiJjfhzEUBkI1z6Wt/o16HIu6WWx5HLy5
	 UICcLFnRTVdn6TMhJ2USy21aoLxPjFAxyDUn7OH7gLlePIo7e9SHIkAuh84rO5aLWBQQX
	 43ggg8opAKGeqKHIl/uV+wPnxSSZP9gTY5CQKEoL5lq1mFCzf/g4uJtiqrMPDK4UNKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uC9+y2lxwg6GnixBYwxOoYJ2GSwkslr62RgQCQiPNO8=;
	b=nb8SosbP3ZKKjpXVwLpIxdsV6rdEDu8f++/sGMl0AL+bnd0pG9+HTdhqKJKyjIGcKIzY
	 PP0zrf21IqWr7GMFjF3+JKbKDRIQybrgtn2mJiUU/PIxSGimvNAhYvl+UljFkQkGjT2GA
	 0xFTzAOP57qBjp8Eyd6sUb1A3H5rAa5XEsIZcI4JkskcHCpNgHFvYps4yh/QcqAVA8DwM
	 MLMnbui1LAYnm46OA3q/ex/r8hzc/jIDNpRmG2nX9cEnMtEBdG1UhspqPaxOoSfnp6ZEk
	 ewUgkX+5YPJ2KH3cytg1LFytEaeInM7/uoTkwKWODRpv3TTeH3kvGLXb7CEOv01FyhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSbH0Lpf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A9A6082BF2;
	Sat,  7 Nov 2026 14:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSbH0Lpf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00471F008AB;
	Sat,  7 Nov 2026 14:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061032;
	bh=uC9+y2lxwg6GnixBYwxOoYJ2GSwkslr62RgQCQiPNO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSbH0LpfNl2noYbs3b5O+WB95Hjj4441ogEbAbMatrwBQUhuUN6I97ywqcapWXJbV
	 NuZjJw6NE4y9mBWxjwoS8tcfm7LpYidUOLxUxD0eiDmgPPP458Y6oY4l4yMY2G5b5Z
	 /f9zDET8jyx2q5GXpzXmVqhzVPD6+bywAZzzWOJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wen <anmuxixixi@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0331/1536] exfat: keep FITRIM within the requested range
Date: Sat,  7 Nov 2026 08:39:07 -0500
Message-ID: <20261107135006.998010837@linuxfoundation.org>
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
index b2b55ad76b7fd..d5e0db81f7991 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -328,14 +328,27 @@ int exfat_trim_fs(struct inode *inode, struct fstrim_range *range)
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
@@ -356,17 +369,11 @@ int exfat_trim_fs(struct inode *inode, struct fstrim_range *range)
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



