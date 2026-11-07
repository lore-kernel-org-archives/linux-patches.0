Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063976;
	b=zKMZm0NoiVI60aAQfWiNDx34Hd/53GEq0MMiqpmWJ19ViYcLX0l3SCLmmoCOF0lbJ5q8
	 H/pQCBigKYB+4Joq7BVQcuazJGiguAX3ytRbEHpLRk8v+uIKYKCi4ASkVMEUMzHojFIcP
	 xxxrzJhDHaxGX7/t1qJOnLVH4b77oXaHyQtOegv9IgbF4PCHANZfPHwBY9wElzX9WeyuZ
	 fInP5P5gx/hLBEMRpHw163Hp5qQbCtTvrQbZ9QMYYfyL3fUAFxtHbQDx9K6q9O9GRYgUV
	 ZbqY83erFcwrVt1ZeYeVuuWtyfNhAoL63x8ItxxBWojZx+J4u9MXatmjw7qsVWoOJTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HdW/iv5xce+Ar2CKQ/kFvVpABk9zOKQc56Ehqn9Xo74=;
	b=Y7zGsMUu2C1mWaxjRTe65Z43pVQN6u7lDd+02ie/FJ0ZfrNZ/SXPp4lmfhQM3OsDGgtD
	 I1o97LoC97lNhXE9ZSYd11v6WY33P6jsFg8M7pEh3RNiMAnwxHiJVQiVP3t+Hi6T8iAJt
	 9EiNoJ1mWXli0c60E9zfZ7P9B82j3rhiac9j8Vw5gaqeJgYL3nqW6GZO4OvBwiYle8MJF
	 d8tI4I/hMNsTk3pp1Ee/6vvHJFG+WshTYRFvvHW9xhdJcaDJb4tnQMCyi4hm6FjFEYyhv
	 qvsgEuyewyKa5QKvb4yUK7fy10IyQH3UpP1IW90dv8pvvd54U3k0+p+jhQbq2GO4FCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oIFTpxzZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00CF608362B;
	Sat,  7 Nov 2026 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oIFTpxzZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D531F008A1;
	Sat,  7 Nov 2026 15:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063975;
	bh=HdW/iv5xce+Ar2CKQ/kFvVpABk9zOKQc56Ehqn9Xo74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oIFTpxzZghqkZgfuwJbOrVyZ3wZ0KZcJNZ+UPNB6RhAT1nt4inXC0y7YYxxUktel7
	 jHt/qm7MqVDCjvjA4jnZk4xD7DZS3sZzxUvlnUTQtja7yJnh2Y1BZojk+f6GVexYxK
	 +Zfec1w7vypwb2ep5q7gppkHW2dY/iBRsBBMm7Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0159/1257] dm vdo indexer: validate record page numbers better
Date: Sat,  7 Nov 2026 08:40:55 -0500
Message-ID: <20261107134943.717600571@linuxfoundation.org>
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
index bb3b0ab5d50dc..9fb9e59238d4c 100644
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
index 78c3729f1f65e..38e51fa1cbd05 100644
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
 
 	physical_page = map_to_physical_page(&volume->geometry, chapter, page_number);
-- 
2.53.0



