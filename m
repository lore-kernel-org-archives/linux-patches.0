Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9C533E3
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89624C433D2;
	Mon,  8 May 2023 11:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545340;
	bh=eW60ZPeDAo2K/gdp1icDzLlbYiLJ1t0cpuJ8cKZtxXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1Zif/NmBlRRmzeWM4YSliLOdrED1Yax7010xlVAO5xld3WyqFa/4RFRls94KcVuu
	 sG/2+Xol7rDnkM9CQsLMKa1HqQuE46e693iT1pbkwrV+g8JwxoJOWGzcqG0NGFFgK0
	 pDoI/xkhJFdIXJySqjr0SBsUx0uz2HHucOm1OVI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Kravetz <mike.kravetz@oracle.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.3 675/694] ia64: fix an addr to taddr in huge_pte_offset()
Date: Mon,  8 May 2023 11:48:30 +0200
Message-Id: <20230508094458.104684496@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hugh Dickins <hughd@google.com>

commit 3647ebcfbfca384840231fe13fae665453238a61 upstream.

I know nothing of ia64 htlbpage_to_page(), but guess that the p4d
line should be using taddr rather than addr, like everywhere else.

Link: https://lkml.kernel.org/r/732eae88-3beb-246-2c72-281de786740@google.com
Fixes: c03ab9e32a2c ("ia64: add support for folded p4d page tables")
Signed-off-by: Hugh Dickins <hughd@google.com
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/mm/hugetlbpage.c
+++ b/arch/ia64/mm/hugetlbpage.c
@@ -58,7 +58,7 @@ huge_pte_offset (struct mm_struct *mm, u
 
 	pgd = pgd_offset(mm, taddr);
 	if (pgd_present(*pgd)) {
-		p4d = p4d_offset(pgd, addr);
+		p4d = p4d_offset(pgd, taddr);
 		if (p4d_present(*p4d)) {
 			pud = pud_offset(p4d, taddr);
 			if (pud_present(*pud)) {


