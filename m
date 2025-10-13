Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47DC30DD35;
	Mon, 13 Oct 2025 14:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366924; cv=none; b=h1OXW08hK0oC7jB/eBPkJnQd3xC5lgsT2utqfUWdYDv9a/2//1GST1IiKsThuBmh/fR4CByE52doS2d++s7IRMSpYHw4ktKGuIH33Zj9mdK8rEOFyRDJHBEm04ymmWIBl6THfGicZZ/ugolBe/eFv6AB4rbfLONoyOkFt9iROcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366924; c=relaxed/simple;
	bh=QTianJLxAYV7DXNZLYdOGFXDHPXi87WeFX01GVo77iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5T5vB4n0cXgs9TN5aSReBCoB/vjYfb/AVW7Vn8fOcjHQ8PKJnGl0tDNVIpHvZA/m17lkb6zNEXAFBbboNBtTxOlujcMYB+nzGjSEtfXqVU2zelCxLcgVvTsFmVZ/EMx0u6QpHp2vGlIXbi3riXOwbPoXtuW4hCBUFPaJUS6UaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOBeS2p+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOBeS2p+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9D1C4CEFE;
	Mon, 13 Oct 2025 14:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366924;
	bh=QTianJLxAYV7DXNZLYdOGFXDHPXi87WeFX01GVo77iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOBeS2p+BeskRqj/4MXGAJtVDtwvWZ9s+lYCUlP1L32LxWwfTZULUCdbbyJqPhJEJ
	 3qz19mdc2cG28UQ0ILs+zCbhHu9oOGDTZlgWjv8Eh9wAnK8Pvy158JrcGVbk+xJDmy
	 vuOwm+kMQFKU4sH/SPrFzMiwjFBeEbh9Ua+aqJ4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/196] dm-integrity: limit MAX_TAG_SIZE to 255
Date: Mon, 13 Oct 2025 16:43:25 +0200
Message-ID: <20251013144315.751081962@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 77b8e6fbf9848d651f5cb7508f18ad0971f3ffdb ]

MAX_TAG_SIZE was 0x1a8 and it may be truncated in the "bi->metadata_size
= ic->tag_size" assignment. We need to limit it to 255.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index fc9cb626ca917..19a0b1919a096 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -128,7 +128,7 @@ struct journal_sector {
 	commit_id_t commit_id;
 };
 
-#define MAX_TAG_SIZE			(JOURNAL_SECTOR_DATA - JOURNAL_MAC_PER_SECTOR - offsetof(struct journal_entry, last_bytes[MAX_SECTORS_PER_BLOCK]))
+#define MAX_TAG_SIZE			255
 
 #define METADATA_PADDING_SECTORS	8
 
-- 
2.51.0



