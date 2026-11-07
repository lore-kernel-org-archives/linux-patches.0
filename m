Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061990;
	b=P1t4/z02tIzg/hKP4tveiE7TnQ5QubOfaw/n5ZSnI3P+IN00BMbu7jibi31s2HnzteB1
	 cC8APQhkscX98vAFsgSbHPIJ3M3O9FOWr31SaIdk1Lw203nIMmXcILVw6Efo4/1sIANqN
	 OVxw654WtcsZX/Umxt0JFmYclhsSsqFVMBhKy6qjhlloeRL+Ijwna6sjH5hbgmbtoff/o
	 i92+Z7rlqWTYLJfN/TjVpdqsIBEVlHwIZRSJL2FQtznd2a6Fg59dYU7CoUO0cHoeQqaYp
	 oaVEO+uitRR0ojFavEA4QfiVj91duCx03OR9IgVY5dtyinUy0IXVKSjm2pxi55704tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=quIFqe4ubEoqRBXg5I+h396bUAZNzLGyhqnQTpdcXhs=;
	b=OwyukkfaOIkUXF/J4iCnzLtZSZS17P5KXlYesJt9Dwbc1ZSL2IXZj9aK312d8rD/uYli
	 zEbtiVEBB/Oo/HtGE6pl4JwVdkk2+Xa0SOYUOF5lEsSRGbzVn+u5AY8VNytQ8A+U9CbO/
	 UaxVVI5lLzK21I/t+6vEYonG3rXe4qUUhHHZNgO3zgshwd1+q//SFqCk/cNl8LAXfbplv
	 2JYDe2CyZUhqEK1QfJHWfiOi9RJhrRVOGycRTDn20Y1V2InFHkrgasWt9+pSS6xBIXKmE
	 XvDItl2jiukuKs3S+4PtzGaWZQ8GlwzuJySbW1F3esz3Hov/0755ffm1d7aW54kmZ/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeXL3hUI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D37606A332;
	Sat,  7 Nov 2026 14:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeXL3hUI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADE81F008A1;
	Sat,  7 Nov 2026 14:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061990;
	bh=quIFqe4ubEoqRBXg5I+h396bUAZNzLGyhqnQTpdcXhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeXL3hUIg60XpNmxxHKj2i7XMt83C7lB3Bfv3rhRa3DNZCzMzoVFpEabMUk7pRjaX
	 J/IfkAV6//nvjfYJu3PnmzaTtSEoDXW6/eOB+uja3obYwhmAnhKLbNbMCGJOkZT2jA
	 RhzyWpkKb8bltcqmxPh5CtJyCtfR0AlsP0MAdYNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0981/1536] dm vdo indexer: validate record page numbers better
Date: Sat,  7 Nov 2026 08:49:57 -0500
Message-ID: <20261107135025.206398533@linuxfoundation.org>
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

From: Matthew Sakai <msakai@redhat.com>

[ Upstream commit e3683a76a313a81f3f7bc7f65e4fc1e61232838b ]

Move the record_page_number validation check into the
chapter index lookup function in order to detect (and
discard) corrupted values on all paths.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-vdo/indexer/chapter-index.c | 15 +++++++++++----
 drivers/md/dm-vdo/indexer/volume.c        |  6 ------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/chapter-index.c b/drivers/md/dm-vdo/indexer/chapter-index.c
index fb1db41c794b3..7a744b2da28f9 100644
--- a/drivers/md/dm-vdo/indexer/chapter-index.c
+++ b/drivers/md/dm-vdo/indexer/chapter-index.c
@@ -284,10 +284,17 @@ int uds_search_chapter_index_page(struct delta_index_page *index_page,
 	if (result != UDS_SUCCESS)
 		return result;
 
-	if (was_entry_found(&entry, address))
-		*record_page_ptr = uds_get_delta_entry_value(&entry);
-	else
+	if (!was_entry_found(&entry, address)) {
 		*record_page_ptr = NO_CHAPTER_INDEX_ENTRY;
+		return UDS_SUCCESS;
+	}
 
-	return UDS_SUCCESS;
+	*record_page_ptr = uds_get_delta_entry_value(&entry);
+	result = VDO_ASSERT(*record_page_ptr < geometry->record_pages_per_chapter,
+			    "0 <= %d < %u", *record_page_ptr,
+			    geometry->record_pages_per_chapter);
+	if (result != VDO_SUCCESS)
+		*record_page_ptr = NO_CHAPTER_INDEX_ENTRY;
+
+	return result;
 }
diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index 425b3a74f4dba..f7de78e0d0dbd 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -891,12 +891,6 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 	if (record_page_number == NO_CHAPTER_INDEX_ENTRY)
 		return UDS_SUCCESS;
 
-	result = VDO_ASSERT(record_page_number < geometry->record_pages_per_chapter,
-			    "0 <= %d < %u", record_page_number,
-			    geometry->record_pages_per_chapter);
-	if (result != VDO_SUCCESS)
-		return result;
-
 	page_number = geometry->index_pages_per_chapter + record_page_number;
 
 	physical_page = map_to_physical_page(volume->geometry, chapter, page_number);
-- 
2.53.0



