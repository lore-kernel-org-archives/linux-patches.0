Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064795;
	b=q1AfqVRF0Ar4HfGTxgWjo05UEehLUhjaliOEh0NXfc7OcBAcXxT0IItrRtrWWXdBOGWF
	 zi+41owFBmrCG9AJC6AeE2ZL4Zk6B1obUV4L5nJJKS1F4r+vjvhU7HozmZDgyMwbgLTDQ
	 PozJBAnZ67/jfZWZepiHqHW+TEv8hkk08SrojXOQbwJaS1IF7qw+k8qjkL542nxlPW0zk
	 wN5p3V4LiJ/u0+FTLmZkDGVTEh7DH7R3mw3cmr+GiwbQqF6fSNi07HiqfACVvjfu80AAy
	 RuAkjZCaNifFgE+IldKy6uU45r3VVsjWGG+p5iaTyXL8/dZAtCqf3VhF2ACOMZN0GgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rBO3dKZyDmE6UlHkUY+gnLAJSU/rF8YYFl93jbl/BAQ=;
	b=vJ/UggnlbQMmiIUP8SBTmy0knWxwh+1Ol7A49rVvOnqK+uLLQxOc5p93moKqSKuGomnS
	 02GhF8Qgn2fTMEHIbAqdUt1LCeksi6CAc4+I6D1vwsqLV6XnzunQsJXI7qTVSjHUZ0Die
	 kcWlW1Q3FnNVZYcsZKeFL4uIB1LmPWkXqEC03u4u4T11rCPwenV2nx1M8RcISEbfa/CJJ
	 ax65Ivi62a8PBGMXxwV4qx/yxs610lq70CBtSoE1owF0pBNmHg3JTx2i5IAlaPYDVYBSQ
	 CHN7+4qmhQJjZIOwTczVQuMptsltF05FHA5RZcvOYjMn1yO4816J8UGD+f9SCt1uG+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKh0gjbL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22EA606A9D5;
	Sat,  7 Nov 2026 15:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKh0gjbL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D41B1F0089F;
	Sat,  7 Nov 2026 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064794;
	bh=rBO3dKZyDmE6UlHkUY+gnLAJSU/rF8YYFl93jbl/BAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKh0gjbL2B4H9X2c5antkm447IMBfXAxz1v3T57ykTOWj34egDIHu/rQofVlInmv6
	 9Jv1tDEihhJ08dDxXgll62CvVY6eF0MMVclLowQN2RrjlaE2MM2UAHnSqW5VYuhxG2
	 JF06zdsnIzrEgvVozziDoDsocFLZNiH4L9uprP2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0738/1257] ocfs2: update xattr count before moving bucket entries
Date: Sat,  7 Nov 2026 08:50:34 -0500
Message-ID: <20261107134959.665068554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Su Yue <glass.su@suse.com>

[ Upstream commit cd6920b6f3e5c6402d49e1128d0e53ee1c7c9b55 ]

Since commit 2f26f58df041 ("ocfs2: annotate flexible array members with
__counted_by_le()"), the xh_entries array is annotated with
__counted_by_le(xh_count), so FORTIFY uses xh_count to determine its
bounds.  When inserting an entry into a bucket,
ocfs2_xa_bucket_add_entry() shifts existing entries before incrementing
xh_count.  The destination therefore extends one entry past the bounds
described by the old count.

With CONFIG_CC_HAS_COUNTED_BY and CONFIG_FORTIFY_SOURCE enabled,
ocfs2-test: single_run-WIP.sh -t reflink triggers the following failure
while adding an extended attribute:

[  150.156484] memmove: detected buffer overflow: 352 byte write of buffer size 336
[  150.156487] WARNING: lib/string_helpers.c:1036 at __fortify_report+0x3d/0x50, CPU#15: reflink_test/2336
[  150.160496] RIP: 0010:__fortify_report+0x40/0x50
[  150.164031] Call Trace:
[  150.164141]  <TASK>
[  150.164232]  __fortify_panic+0x9/0xb
[  150.164383]  ocfs2_xa_bucket_add_entry.cold+0x17/0x28 [ocfs2]
[  150.164661]  ocfs2_xa_set+0x8fb/0xf40 [ocfs2]

Increment xh_count before memmove() so the destination bounds include the
new entry.  Keep the local count unchanged to calculate the insertion
position and move length from the original number of entries.  The caller
has already checked that there is enough space for the new entry.

Link: https://lore.kernel.org/20260916024750.9450-1-glass.su@suse.com
Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
Signed-off-by: Su Yue <glass.su@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index bfafe059bedff..8933d0f301199 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2073,12 +2073,17 @@ static void ocfs2_xa_bucket_add_entry(struct ocfs2_xa_loc *loc, u32 name_hash)
 		}
 	}
 
+	/*
+	 * Increment xh_count before memmove() so __counted_by_le(xh_count)
+	 * includes the new entry in the destination bounds.
+	 */
+	le16_add_cpu(&xh->xh_count, 1);
+
 	if (low != count)
 		memmove(&xh->xh_entries[low + 1],
 			&xh->xh_entries[low],
 			((count - low) * sizeof(struct ocfs2_xattr_entry)));
 
-	le16_add_cpu(&xh->xh_count, 1);
 	loc->xl_entry = &xh->xh_entries[low];
 	memset(loc->xl_entry, 0, sizeof(struct ocfs2_xattr_entry));
 }
-- 
2.53.0



