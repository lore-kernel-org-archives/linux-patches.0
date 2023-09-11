Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E309011710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C508C433C9;
	Mon, 11 Sep 2023 15:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446072;
	bh=3qHW9Z7P//enYTqQoEu+Jx8ZwR2CYis/p6tLa9p+6VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkpLeXvasBK76mLgVSo+jzQpQNBJOJMiLvWtCfpC3R9IcaHwGmOz++0dUvtJj5igH
	 U19vJS2N60apuYKdtg1Yr6s1Zq8PRdqMJjCm5LcKLrjp02OMhbpeIw7Y4Hnqa0/cUJ
	 TmNNeb7KsKQ/PNGXnDIv1wfeqr3zsQI0Ge2jjc7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Hongchen Zhang <zhanghongchen@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 543/600] LoongArch: mm: Add p?d_leaf() definitions
Date: Mon, 11 Sep 2023 15:49:36 +0200
Message-ID: <20230911134649.648747560@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hongchen Zhang <zhanghongchen@loongson.cn>

commit 303be4b33562a5b689261ced1616bf16ad49efa7 upstream.

When I do LTP test, LTP test case ksm06 caused panic at
	break_ksm_pmd_entry
	  -> pmd_leaf (Huge page table but False)
	  -> pte_present (panic)

The reason is pmd_leaf() is not defined, So like commit 501b81046701
("mips: mm: add p?d_leaf() definitions") add p?d_leaf() definition for
LoongArch.

Fixes: 09cfefb7fa70 ("LoongArch: Add memory management")
Cc: stable@vger.kernel.org
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -560,6 +560,9 @@ static inline long pmd_protnone(pmd_t pm
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
+#define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
+#define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
+
 /*
  * We provide our own get_unmapped area to cope with the virtual aliasing
  * constraints placed on us by the cache architecture.


