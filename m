Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210000;
	b=XG/0vvpcSec4Zba321UjAcsPfZqqrpV+ijlAXBFS9/QiWxI6+l+68q7u9YQRjn2tEpOd
	 tzxcwwembI5846AqCvugDFRIKqWMw/SlLH5XyiMo9mMuLUt29X0A+PjbP9B+rmT3zL+eG
	 yrRTWauZ4zs27RlVb6HUnOW4mFHpo1phMktXKxbfZYzf97irvXjx0fnOw9YOo6CYOAR97
	 EIB68Z5yeJy9qKBYwbMwlWjYOKPaJjy17it4Gv+4sIwJBCSA2yJs/gaf2/oNuhkyhB+nP
	 KDVI5xsSBnKq3YwV8VzFeC8vwUpvQ75v5hxT39HALhoME3P/B4iKJV2fI2lW1FYM2kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VVqC6Tmw/UZTSwgjDGsXmVz7R0xSaWZnSO+0imHvK44=;
	b=Rcz9kcDSBeeicyYPTNiWk3/ZfLEx7KAtKrGPdtYotlbC4EDSj1TpCqgZa+hlHr8ntqas
	 CkiPFTqsZP7NP4z7iWaT7h4xAgMBtaSqp4Qx+QbObGNi6Ohm6IdQ7zCS7H0ES1sgzno3B
	 xpVd50XEI0pIIaRBOxY4xMcRebkbpN2KUDLFQPsGoue39fMCbZRNWK3EPSrj1KmSTr/Pn
	 w+a0War3YTjNNllZD7AE6blDddbFbkZK4/QE9FybZOFbfzh4OVCb7y+DoK/yKs/2yy79n
	 4/HmLAlZPYPdvxiSx57NZHsJSXHCccbiKIPdlGR8jZJryGCt+dugNKi6CO+zxDno0xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4Nscmo8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76C0606A31A;
	Wed, 28 Oct 2026 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4Nscmo8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051EB1F01825;
	Wed, 28 Oct 2026 17:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209999;
	bh=VVqC6Tmw/UZTSwgjDGsXmVz7R0xSaWZnSO+0imHvK44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4Nscmo8BDUq7Y6rnBFxA2Q1NxuhmlFiCnJRV6viPXIUeHuVXe4l+eX9H7HKjED2a
	 yD1iFEe0XMrHtaSpOxr6BepYOeyCDRmKMcfaBI3WfZoS3j6CfoKOtYhY8HiHHYsOW2
	 6QgwFg39ChGOPKNC4SVpnR9pYwA5A4GSyQomNyFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/168] ext4: fallback to complex scan if aligned scan doesnt work
Date: Wed, 28 Oct 2026 17:59:00 +0100
Message-ID: <20261028165943.198849420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

[ Upstream commit 1f6bc02f18489b9c9ea39b068d0695fb0e4567e9 ]

Currently in case the goal length is a multiple of stripe size we use
ext4_mb_scan_aligned() to find the stripe size aligned physical blocks.
In case we are not able to find any, we again go back to calling
ext4_mb_choose_next_group() to search for a different suitable block
group. However, since the linear search always begins from the start,
most of the times we end up with the same BG and the cycle continues.

With large fliesystems, the CPU can be stuck in this loop for hours
which can slow down the whole system. Hence, until we figure out a
better way to continue the search (rather than starting from beginning)
in ext4_mb_choose_next_group(), lets just fallback to
ext4_mb_complex_scan_group() in case aligned scan fails, as it is much
more likely to find the needed blocks.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/ee033f6dfa0a7f2934437008a909c3788233950f.1702455010.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Fixes: 83e80a6e3543 ("ext4: use buckets for cr 1 block scan instead of rbtree")
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4ec4388932eaf..646f55ba0dd1b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2954,14 +2954,19 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 			ac->ac_groups_scanned++;
 			if (cr == CR_POWER2_ALIGNED)
 				ext4_mb_simple_scan_group(ac, &e4b);
-			else if ((cr == CR_GOAL_LEN_FAST ||
-				 cr == CR_BEST_AVAIL_LEN) &&
-				 sbi->s_stripe &&
-				 !(ac->ac_g_ex.fe_len %
-				 EXT4_B2C(sbi, sbi->s_stripe)))
-				ext4_mb_scan_aligned(ac, &e4b);
-			else
-				ext4_mb_complex_scan_group(ac, &e4b);
+			else {
+				bool is_stripe_aligned = sbi->s_stripe &&
+					!(ac->ac_g_ex.fe_len %
+					  EXT4_B2C(sbi, sbi->s_stripe));
+
+				if ((cr == CR_GOAL_LEN_FAST ||
+				     cr == CR_BEST_AVAIL_LEN) &&
+				    is_stripe_aligned)
+					ext4_mb_scan_aligned(ac, &e4b);
+
+				if (ac->ac_status == AC_STATUS_CONTINUE)
+					ext4_mb_complex_scan_group(ac, &e4b);
+			}
 
 			ext4_unlock_group(sb, group);
 			ext4_mb_unload_buddy(&e4b);
-- 
2.53.0



