Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028716;
	b=SXsEcWgIifIXTL3MGsS+Up9K4ZiKoH7JzhfJXEk0FTRrjOuO4b6Y9j0+jVjjAYI18woX
	 n11Qm9x+6SkDxZxl470ZOhKKY75jbF73kFtSwPAKbp9zUAwXANAYRyOi9nB5fO+J/eorQ
	 Rh3Dl1eBP/D5R7zYDbMIEg0l1M8GmHYbzQzx7YdWYV52qctRRWUd+vN5KSaxrp8UsDXJy
	 E10zWc8hrg9JInUUusAhyb3cXyIiZRl15NQADVA/OgjgVkDFuAyP5UeCP1QNps77YKmey
	 wyPjjLR3MYXN9A2ZSpYLzPivxRGRbeL04W9xe1vcJizKUWdO8FTAOoi78d8EPb2i0bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VLDDYoeankZyFa0cNBrNfac2wCHM/Dgej35VMEujuQY=;
	b=TzWQ25ydC5bdwAY9S8hdtz3NlTnEC7EVaUXWHZOBYD1HhRRYjWge3hQaC8SGUbWSK/OF
	 6WNj6MfUslI4/v8WveUdjQcI5R+L5k6tHH5zeAPQ7U74HP9QaL7nnMvSm4Dzt0WeutSrH
	 mFMbASO2eThley7QsdA7+hXj/KTMBqyVO/s7rvhTLs9fe10p8L+odinh9hcyTVNuKqUSS
	 R12SVbiTmuaf7vmPhWPHrc4E30a8fazHdA8y4mSfA8bobwMHl8rSO0QDWhYi/V+BpMS0k
	 XLyEL3L9QflmfQIDO2OXewYNwdq6VvGsP5EKs3jXrT9VRBd+GFdkfgHvU3hAr69Y0Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMBg+Qwu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1974E606A325;
	Wed, 18 Nov 2026 19:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMBg+Qwu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9B91F000C5;
	Wed, 18 Nov 2026 19:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028716;
	bh=VLDDYoeankZyFa0cNBrNfac2wCHM/Dgej35VMEujuQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMBg+Qwu7MYbeAd9Jhz+fSjK5f5eMT34WCSDjfBW/n3aJ63BxwmrSco2fyL8LlOL4
	 /6WyN0qbmoAgnKbjvMOw6nTLPFT5CHpETYjch/XCwb9vsrt1DQ85B7O4LZxKmj0/Sy
	 OFCuLt9BxPCAGDJ/KwPE6igk1PYhgJummedUkXkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubham Antil <shubham@octane.security>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0094/1756] vhost-scsi: zero misaligned I/O bounce pages
Date: Wed, 18 Nov 2026 15:37:01 +0100
Message-ID: <20261118150011.990744430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Shubham Antil <shubham@octane.security>

[ Upstream commit 01c3a5fa6d641c93c7cef4fb25c5f12938316e18 ]

The misaligned I/O fallback copies the full bounce scatterlist to the
request buffer during completion.  If a data-in command transfers less
than requested, part of a newly allocated bounce page can remain unwritten.

Allocate bounce pages with __GFP_ZERO so all bytes copied during completion
have a defined value.  This path is already the slow fallback for
misaligned I/O, so the added initialization cost is acceptable.

Found during an LLM-assisted source audit and validated with a QEMU/KVM
vhost-scsi target using misaligned data-in commands.

Fixes: 5ced58bfa132 ("vhost-scsi: Fix alignment handling with windows")
Cc: stable@vger.kernel.org
Assisted-by: LLM (OpenAI Codex, gpt-5.6-sol)
Signed-off-by: Shubham Antil <shubham@octane.security>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261020105503.75904-1-shubham@octane.security>
[ sashal: Adjusted context to retain the existing indexed scatterlist loop in place of for_each_sgtable_sg(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4e1b5184cf36b..5a904241f6311 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -771,7 +771,12 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	}
 
 	for (i = 0; i < sg_count; i++) {
-		page = alloc_page(GFP_KERNEL);
+		/*
+		 * Completion copies the full bounce buffer, including bytes the
+		 * target did not write. This is already the slow fallback for
+		 * misaligned I/O, so zeroing is acceptable here.
+		 */
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!page) {
 			i--;
 			ret = -ENOMEM;
-- 
2.53.0



