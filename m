Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8186033EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08085C433EF;
	Mon, 16 Jan 2023 15:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884584;
	bh=xy853GZ+uSF3kWyNad2eAe+PqaZWqXI420T7olelXSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHp7EqKjh+Jcscy/Rsd1paCfjmiIPIpz0bmmaQEBSnB4DfD8ZUGNgeiuIdUqUx83B
	 uZuR/ArtqLXHaQBYkyEhOHnaduqjESdyVGlnjDs0gu9dlu3rD6OGVCJYY75HBAfDHR
	 DzpclmFcmdkYRsMEQHb7XKyalqvtrPmGgdlrziJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH 6.1 061/183] arm64/mm: add pud_user_exec() check in pud_user_accessible_page()
Date: Mon, 16 Jan 2023 16:49:44 +0100
Message-Id: <20230116154805.929330586@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Shixin <liushixin2@huawei.com>

commit 730a11f982e61aaef758ab552dfb7c30de79e99b upstream.

Add check for the executable case in pud_user_accessible_page() too
like what we did for pte and pmd.

Fixes: 42b2547137f5 ("arm64/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Link: https://lore.kernel.org/r/20221122123137.429686-1-liushixin2@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -682,7 +682,7 @@ static inline unsigned long pmd_page_vad
 #define pud_leaf(pud)		(pud_present(pud) && !pud_table(pud))
 #define pud_valid(pud)		pte_valid(pud_pte(pud))
 #define pud_user(pud)		pte_user(pud_pte(pud))
-
+#define pud_user_exec(pud)	pte_user_exec(pud_pte(pud))
 
 static inline void set_pud(pud_t *pudp, pud_t pud)
 {
@@ -868,7 +868,7 @@ static inline bool pmd_user_accessible_p
 
 static inline bool pud_user_accessible_page(pud_t pud)
 {
-	return pud_leaf(pud) && pud_user(pud);
+	return pud_leaf(pud) && (pud_user(pud) || pud_user_exec(pud));
 }
 #endif
 


