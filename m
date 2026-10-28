Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215652;
	b=BANvAUdmGBpl6MdKYWjgBSUomTk4o0bMqUUt4fEdaNhRPRFxRPiqjgW0TKlFBZ5H2F0N
	 rlq5P2ikZp+VSDEmA3q9s55m3uo4mtrhLa2lkY/QKXws3iSzFZcLCMjgWM3GTgrh0k5xg
	 3am9olHGlmpejMHGW8uCZYsVTIqqBZh1p1UmdaHxYi3Skrfhz05yWEwoOZahYGQ+q04S0
	 bHewxbkvVzcC6QFelx7PdCtFKTcrzqG7wobvz3rNXFZAsQKDQwK4gDrTMJXb6xxWl9NYW
	 Fd9rw6/X4UJMS9gw6IDBLulOPegSa6EPxYxTgrXPPbeJwVGOu7VZcBkJVTSHMP0lXTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dyXYvrh+8fsSLwmdVq9x9cgSvOTf9uB01HJyxEfMITo=;
	b=aD2BAivDT7DfvhZ5TZyxd4byd/xE+kP/+xe8iQDusYcsAxfdXZvKU7FDJIRNBLpuiese
	 tyKarEUcXdxI4EWJMLu38orZw94Q3btNlSi0Xs9YUKP7ocFLi+02/CQkZFOENfZel3shQ
	 Q7FGhcyIegVGzNNXCRAGkrzUFK560CDgrbsXVet0eQcV4F1hYhYDXcZTVeSb4SllzkUe8
	 G4CY2qGRCPBzsNXx9+/c+5rkjj1ZUpW3JuENflphqinHSD1zx2UvEVULBDOlJQoqTp3yl
	 dlv8UyYgFk1X/DxAvlith2Jpk6thmzqiEzV88BxPJWxMPEjYgBt+gJ/vz7kQmdNm3Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M1ZJLpXc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7945606A31C;
	Wed, 28 Oct 2026 19:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M1ZJLpXc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B951F01825;
	Wed, 28 Oct 2026 19:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215651;
	bh=dyXYvrh+8fsSLwmdVq9x9cgSvOTf9uB01HJyxEfMITo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1ZJLpXcH2RKqGSzA6IlLzoocDNISpx/Q6wsXFNh5A7dxbclDdQfMCAqv/uBlEmzT
	 NDz3OkISedLa+/eiwdtL1SnfErujjZLS4iP7lCVMsLfc87+yyjciPo/FMzwh5extEy
	 UclILGgpqG/mYTg9feY8lhwo6UiP4J/SNBCjSX/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Vega <vega@nebusec.ai>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1286/1887] mm/page_table_check: skip special zero mappings
Date: Wed, 28 Oct 2026 17:56:22 +0100
Message-ID: <20261028170528.691854561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 8db4bab826ccc9ec10fa41736a48031cd338d392 ]

page_table_check_set() and page_table_check_clear() account mappings based
on PageAnon().  Shared zero-page PTEs and huge zero PMDs are special
mappings, but page_table_check can still account them as file-backed
pages.

An unprivileged process can populate enough zero mappings to overflow
file_map_count and hit the existing BUG_ON().  The PTE path can do this
with the shared zero page, and the PMD path can do the same with huge zero
mappings.

Skip special zero mappings in the user page-table accounting paths.  Keep
the PTE-side pte_special() check, and identify huge zero PMDs from the
mapped folio instead of pmd_special().  That covers architectures where
pmd_special() is a no-op without adding huge_zero_pfn checks to the
generic counter helpers.

Link: https://lore.kernel.org/cover.1784717203.git.zhilinz@nebusec.ai
Link: https://lore.kernel.org/e94478e4fb7912fb7e8ebebed5ce85d00dc9a69d.1784717203.git.zhilinz@nebusec.ai
Fixes: df4e817b7108 ("mm: page table check")
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Reported-by: Vega <vega@nebusec.ai>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Assisted-by: Codex:gpt-5.4
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_table_check.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 9392544d4754e..451114bdc3401 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -164,20 +164,31 @@ void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
 	if (&init_mm == mm)
 		return;
 
-	if (pte_user_accessible_page(pte)) {
+	if (pte_user_accessible_page(pte) && !pte_special(pte)) {
 		page_table_check_clear(mm, addr, pte_pfn(pte),
 				       PAGE_SIZE >> PAGE_SHIFT);
 	}
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
 
+static inline bool page_table_check_huge_zero_pmd(pmd_t pmd)
+{
+	unsigned long pfn = pmd_pfn(pmd);
+
+	if (!pfn_valid(pfn))
+		return false;
+
+	return is_huge_zero_page(pfn_to_page(pfn));
+}
+
 void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 				  pmd_t pmd)
 {
 	if (&init_mm == mm)
 		return;
 
-	if (pmd_user_accessible_page(pmd)) {
+	if (pmd_user_accessible_page(pmd) &&
+	    !page_table_check_huge_zero_pmd(pmd)) {
 		page_table_check_clear(mm, addr, pmd_pfn(pmd),
 				       PMD_SIZE >> PAGE_SHIFT);
 	}
@@ -204,7 +215,7 @@ void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
 		return;
 
 	__page_table_check_pte_clear(mm, addr, *ptep);
-	if (pte_user_accessible_page(pte)) {
+	if (pte_user_accessible_page(pte) && !pte_special(pte)) {
 		page_table_check_set(mm, addr, pte_pfn(pte),
 				     PAGE_SIZE >> PAGE_SHIFT,
 				     pte_write(pte));
@@ -219,7 +230,8 @@ void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
 		return;
 
 	__page_table_check_pmd_clear(mm, addr, *pmdp);
-	if (pmd_user_accessible_page(pmd)) {
+	if (pmd_user_accessible_page(pmd) &&
+	    !page_table_check_huge_zero_pmd(pmd)) {
 		page_table_check_set(mm, addr, pmd_pfn(pmd),
 				     PMD_SIZE >> PAGE_SHIFT,
 				     pmd_write(pmd));
-- 
2.53.0



