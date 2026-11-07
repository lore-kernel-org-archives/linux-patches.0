Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064293;
	b=RGku4W5yTL8oS5+SxhSSTwnL5dZ/PdlxwvALRQ74nwwDkE0iegC4aH7i3kh/mxK0xK+y
	 7g6vYz7RyzI1aEuSmJroxxB2lUogHGcv69wuoEWmPuAj9h07v9a98dT3Hl77YY/6T/irN
	 xzzqOnnWXIuUUvHJIRPBVGouQGCeBWKHlsuoidTqgvDAESVPLP0HO+K+cJbWNes4ZjAvY
	 Z9bb97uTFVJjBmAJafam3hQIR9nJ5nrm+hEO8hjjvM325BpRXPSiYv8CsuFCbhmOciocl
	 MMFJESPn/rIbeFKgzt5mjixl2aFJ437sTUNLQCaUgo15QqS/rCVUPkTnQfEQkNeb/Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HS+vrenvi4zngz7dg3CzNtH+vfBiZTiNFObcbIXHNbA=;
	b=bpET3oZUOxg73tHgwTboJaWsRCHh6zsIvYQaZdT8XY0d/W5KkuV18ci0dKIBGk3NgGmv
	 eHjIis0taYQH1cmbixz6BL50x9atzlCHHevdMPbqP/09ZCOb7X/5FHDixL1RmTtS5F5ab
	 BDJot9WLFTqopAZOsqEGn9ZGYbLGXdJPaSyvh14Hcm2FVDo3DAZIVeCw3wJuZFvYUGI7Y
	 gyUll1gXQHifd360NLemPVSijwWk7p5arAYbNcTpmHvdf+D6HHxS0i/xdIQCcfDTvsF5J
	 wJ/p35vWfoAe4T8weN9CjoVL3IVdvJqoDG4wk6ikOEw/Kqy8oT8JXqAaJ3udjhM8Lrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWZrIjZe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF44A606A9D4;
	Sat,  7 Nov 2026 15:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWZrIjZe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEE81F0089F;
	Sat,  7 Nov 2026 15:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064292;
	bh=HS+vrenvi4zngz7dg3CzNtH+vfBiZTiNFObcbIXHNbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWZrIjZe/bhQeFsg4ls4aO7nddatDVpOnm0oj/alT4cPp+fngTMfCqcEG9SqaI2A5
	 c/+tbhAdMOestyDkyxPArDojnwmfSCWk+48y28oGeE71BH0XAaIXHLNJ6TJkzOZKvz
	 BXDz5n8Ufab8aVFEH1OCGD28aTIXc2pFLu7hU9RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0387/1257] nilfs2: clear dirty flag on bdev buffers on log write failure
Date: Sat,  7 Nov 2026 08:44:43 -0500
Message-ID: <20261107134950.239004268@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 6faad04a002603d800134398fcd042b403b32d35 ]

Since the commit referenced in the Fixes tag stopped directly calling
inode_attach_wb(), a dirty flag is set on buffers (with
mark_buffer_dirty()) allocated to the backing device for segment
summaries and the super root block during log writes.

While this dirty flag is cleared upon a successful log write, it remains
uncleared if the log write fails.

Consequently, when a log write fails, these backing device buffers are
left in an inconsistent state where their uptodate flag and the dirty
flag of the containing page/folio are cleared, but the buffer's dirty
flag remains as stale garbage.

Particularly when the block size is smaller than the page size, if other
buffers on the same page/folio become dirty, this buffer unexpectedly
becomes a target for writeback again.  As a result, if the block is
later reused for other data or metadata, that contents risks being
corrupted.

Fix this issue by calling clear_buffer_dirty() for the backing device
buffers when aborting log writes in nilfs_abort_logs().

Fixes: 68142cb628f7 ("nilfs2: do not call inode_attach_wb() directly")
Cc: stable@vger.kernel.org
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/segment.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 829573cb61316..2f0e59847d026 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1829,6 +1829,7 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 	list_for_each_entry(segbuf, logs, sb_list) {
 		list_for_each_entry(bh, &segbuf->sb_segsum_buffers,
 				    b_assoc_buffers) {
+			clear_buffer_dirty(bh);
 			clear_buffer_uptodate(bh);
 			if (bh->b_folio != bd_folio) {
 				if (bd_folio)
@@ -1840,6 +1841,7 @@ static void nilfs_abort_logs(struct list_head *logs, int err)
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
 			if (bh == segbuf->sb_super_root) {
+				clear_buffer_dirty(bh);
 				clear_buffer_uptodate(bh);
 				if (bh->b_folio != bd_folio) {
 					folio_end_writeback(bd_folio);
-- 
2.53.0



