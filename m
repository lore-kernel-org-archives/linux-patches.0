Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621336;
	b=Ig7DhQRGg0IQrA1XQ2RenQQ6YRbXIYrRqJ+D/S1pai4BZdsnzvk/C8FGP71aAarKZVEs
	 7vX2M9LrDQhFTqNbyHPQapRfHxlSs3qfo23RkaVWA7rW31MOm0fbD42PjahuvorbNJan8
	 63AcY7uY4J8IHIc0t/vFPZjsq2F+//VAejiFcv4TPq6ZVmMmWt3kbASq++4NEKJ0VphRq
	 j9gNi4wVqQOAgtJqbvBIa5dll+i7SW8Ix4b7BTAa3XqmfEtYHv4Iegubzy1dHHMbiAwHk
	 rU8aEXCOQIobd7GWxZ0j/bhSFz38Yg37MytUhG3tRNrSdKd87RI65wENvWdWEApsVvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2vzOKn4Z4ruizF7q/hl99DOL0dcaGjmPkK0V9aogoV4=;
	b=TywJUoNABIDS7cvY8a8pOeqc954muXptmJBkVL/gMBY7vOLW809GVILuIpPQdGuy5Far
	 4kXnEDC3mxfCQG1lWtuZTNsHBpJ8xkOnwl8x2osBCIT88ICEClFUGv1pn/de36uji0HBE
	 K2NyDdvcUEPJqfnaeiNl0/Vszxbzj3VUy1Ef4rQrnMj2r43R1CE/cpfhpyC53HxWuW7hJ
	 83Qfaae++wBsH5aa92uy97TZIot5SpR8vm2QuEyxBab12w+YNXKR2aYJ3LqmGBBD0K76h
	 bU7govNZMYQ6PYmLTPs2RD5Qnv9E+h9GF3CVdJ9d2wIN9eG8TYQKyx7MAdxI9mWi9Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o7NWqgsQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5114606A31E;
	Wed, 25 Nov 2026 15:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o7NWqgsQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752471F000EF;
	Wed, 25 Nov 2026 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621336;
	bh=2vzOKn4Z4ruizF7q/hl99DOL0dcaGjmPkK0V9aogoV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7NWqgsQJATNlHNjn+f0D+ms7rmLuych/2VDxJ+Sr49us2LqCQR8hwDkM9iig2XRu
	 NcC0psLlZsH0lTczAkZPi4cSKVieicvvYO+w1dE6R6j/FYFD4+wCw78T+ywlG2r9QF
	 01xSwYLNO2qMdt6rEGHXp1jpV6S5QzNMqWfco7fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 193/990] selftests/mm: merge: keep the far mremap() targets in the carveout
Date: Wed, 25 Nov 2026 15:26:00 +0100
Message-ID: <20261125143826.614468455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 332c1bd17422c1aa59e18513042e56ea5aac4051 ]

The merge tests map their areas at fixed addresses within a 30-page
PROT_NONE carveout. Several mremap() tests move an area 1000 or 2000
pages away to separate it from the others, but those targets are outside
the carveout, and MREMAP_FIXED unmaps whatever is mapped there.

Under virtme-ng, the shared libraries are packed right above the
carveout and the dynamic linker starts about 4 MiB above it. The moves
then replace part of its text with an anonymous mapping, and the test
crashes in its next lazily bound call:

  merge[6980]: segfault at 7f7ebb3c1e60 ip 00007f7ebb3c1e60 sp 00007ffd35fbaec8 error 14

Two to four of the mremap() tests then fail with "Test terminated
unexpectedly by signal 11", depending on the exact layout. On a host
where libc is mapped at a 2 MiB aligned address, the targets happen to
land above the dynamic linker and the tests pass.

Since the areas are all within the first 30 pages, moving one by 30
pages is enough to keep it apart from the others. Add FAR_PAGES for
that distance, move areas by FAR_PAGES or 2 * FAR_PAGES pages, and make
the carveout 3 * FAR_PAGES pages so that it covers every target.

Link: https://lore.kernel.org/20261022121837.28723-1-danishkhateeb03@gmail.com
Fixes: 4e25f85b9f85 ("tools/testing/selftests: add mremap() unfaulted/faulted test cases")
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 33 ++++++++++++++++--------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 10b686102b79d..65c30632795ec 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -22,9 +22,12 @@ FIXTURE(merge)
 	struct procmap_fd procmap;
 };
 
+#define FAR_PAGES	30
+#define CARVEOUT_PAGES	(3 * FAR_PAGES)
+
 static char *map_carveout(unsigned int page_size)
 {
-	return mmap(NULL, 30 * page_size, PROT_NONE,
+	return mmap(NULL, CARVEOUT_PAGES * page_size, PROT_NONE,
 		    MAP_ANON | MAP_PRIVATE, -1, 0);
 }
 
@@ -60,7 +63,7 @@ FIXTURE_SETUP(merge)
 
 FIXTURE_TEARDOWN(merge)
 {
-	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
+	ASSERT_EQ(munmap(self->carveout, CARVEOUT_PAGES * self->page_size), 0);
 	/* May fail for parent of forked process. */
 	close_procmap(&self->procmap);
 	/*
@@ -102,7 +105,7 @@ FIXTURE_SETUP(merge_with_fork)
 
 FIXTURE_TEARDOWN(merge_with_fork)
 {
-	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
+	ASSERT_EQ(munmap(self->carveout, CARVEOUT_PAGES * self->page_size), 0);
 	ASSERT_EQ(close_procmap(&self->procmap), 0);
 	/* See above. */
 	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
@@ -647,7 +650,7 @@ TEST_F(merge, mremap_unfaulted_to_faulted)
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -708,7 +711,7 @@ TEST_F(merge, mremap_unfaulted_behind_faulted)
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -772,12 +775,12 @@ TEST_F(merge, mremap_unfaulted_between_faulted)
 
 	/* Offset ptr3 further away. */
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -857,13 +860,13 @@ TEST_F(merge, mremap_unfaulted_between_faulted_unfaulted)
 
 	/* Offset ptr3 further away. */
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 
 
 	/* Offset ptr2 further away. */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -1022,11 +1025,11 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 */
 	ptr3 = &ptr[10 * page_size];
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 	ptr2 = &ptr[5 * page_size];
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -1062,7 +1065,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *                  ptr2      \       ptr       \       ptr3
 	 */
 	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
-			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + page_size * 1000);
+			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + FAR_PAGES * page_size);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	/*
@@ -1097,7 +1100,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *                  ptr2      \       ptr       \       ptr3
 	 */
 	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
-			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + page_size * 1000);
+			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + FAR_PAGES * page_size);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	/*
@@ -1155,7 +1158,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *      ptr                     ptr3      \       ptr2
 	 */
 	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr2, MAP_FAILED);
 
 	/*
@@ -1190,7 +1193,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	 *            ptr                         \       ptr3
 	 */
 	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
-			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 1000);
+			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + FAR_PAGES * page_size);
 	ASSERT_NE(ptr3, MAP_FAILED);
 
 	/*
-- 
2.53.0



