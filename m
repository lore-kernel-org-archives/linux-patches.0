Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214267;
	b=4NmPxbhKsnv+qxwnBXv7tb2RGkXyPn1FIfcaqge/gDC0nP7QkEuCbEWN6iRJCnwXwuah
	 yM2V26+tM7ZZva2Ua1+fvKJvTHQyDcp7iqQPtcXlgnpTG5g2cPKZ3xufds6yjM2sCXAZu
	 NE9kk84r+mynQt7ps+eUhjgEP9VULJaoeERBQrOnIWb2W4cXk2Ly+7l+smjt1VY5OEwEs
	 WZTmq/EYtU5L6VgOp6oJYKmWanLBPO3CWrGri+KLQ4FuUZyxQDtZH42ov1SnB6VX/AVUo
	 h+WAFH/PMUdcRU3JMqXv1ePyQBoechPgxKfPzdG8UaPIVvdAIzybmS6g/iiHyNJz+Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZJxxpq17b1TjqbJ993h9RjJa3LOQoe4IFqFj8m/2WJo=;
	b=xRzj1hJ3Z6d1jOcl9IYN14T6yNuwwys6rekSI7TIzhpZmDN1Zoc8TdvIvJZ0lEEZ9ry2
	 n5jO2dap7lYx6oz4+43lRvQBKTfcwxmbVXT5uNp5D95ULGpKE8x/3mSMQ83QS2D1Ljfi8
	 2bC67NJpz2exUDTxlzmS+mftE0Pyf9COUl7bw7Qqob+R2dZ9ymnDqaMwzviQfgUAvtrWd
	 s3wBGTwUuMPK0E8R/X0IBsb6hVMJFxeVTZv2sLkLPGwYf1xKeFUbF2Hvgdfc5bOmSqsjD
	 1vMaTp3rd1P95t8ct2+q4GLGeJh5MKMlzIo24gVcIRYK6HjRbP/z7oCeUtWfi/DoQ2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=See30CrJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060F560A383E;
	Wed, 28 Oct 2026 19:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=See30CrJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4CD1F01825;
	Wed, 28 Oct 2026 19:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214266;
	bh=ZJxxpq17b1TjqbJ993h9RjJa3LOQoe4IFqFj8m/2WJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=See30CrJG034pIf1MSTuXySZmR2qrb1EXS2ZFNTLF6S4K8sno8s39jEGvtFY+XFLy
	 0otDiUlLAnGDj+BkIhRsGpkQhaoHhnd22phBxZy86Jcx1/uvSfwPnSEcI39peYcWyP
	 WSN1pqn0VpEgefS4ADUMOFC0a+pcUDhdTnLW0okE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0797/1887] LoongArch: Fix panic caused by NULL-PMD in huge_pte_offset()
Date: Wed, 28 Oct 2026 17:48:13 +0100
Message-ID: <20261028170517.566318181@linuxfoundation.org>
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

From: Tianyang Zhang <zhangtianyang@loongson.cn>

[ Upstream commit ee084fa96123ede8b0563a1b5a9b23adc43cd50d ]

ERROR INFO:

CPU 25 Unable to handle kernel paging request at virtual address 0x0
         ...
 Call Trace:
 [<900000000023c30c>] huge_pte_offset+0x3c/0x58
 [<900000000057fd4c>] hugetlb_follow_page_mask+0x74/0x438
 [<900000000051fee8>] __get_user_pages+0xe0/0x4c8
 [<9000000000522414>] faultin_page_range+0x84/0x380
 [<9000000000564e8c>] madvise_vma_behavior+0x534/0xa48
 [<900000000056689c>] do_madvise+0x1bc/0x3e8
 [<9000000000566df4>] sys_madvise+0x24/0x38
 [<90000000015b9e88>] do_syscall+0x78/0x98
 [<9000000000221f18>] handle_syscall+0xb8/0x158

In some cases, pmd may be NULL and rely on NULL as the return value for
processing, so it is necessary to determine this situation here.

Cc: stable@vger.kernel.org
Fixes: bd51834d1cf6 ("LoongArch: Return NULL from huge_pte_offset() for invalid PMD")
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/mm/hugetlbpage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/mm/hugetlbpage.c b/arch/loongarch/mm/hugetlbpage.c
index 70b4a51885c24..9bc1ac6ad762a 100644
--- a/arch/loongarch/mm/hugetlbpage.c
+++ b/arch/loongarch/mm/hugetlbpage.c
@@ -47,7 +47,8 @@ pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr,
 				pmd = pmd_offset(pud, addr);
 		}
 	}
-	return pmd_none(*pmd) ? NULL : (pte_t *) pmd;
+
+	return (!pmd || pmd_none(*pmd)) ? NULL : (pte_t *) pmd;
 }
 
 /*
-- 
2.53.0



