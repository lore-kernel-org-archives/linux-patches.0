Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E551624DF;
	Sat, 30 May 2026 17:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162269; cv=none; b=H+H33zJ+uiRdeNTmB9mdnQNpBpib3DXqg6JtCs+QGQR/LXDZn/hfBNFURaxd/5RCnw5WvM8wLyZ7skp2RONEgm4kCyBBUhxrnOtuREOHj5otH8l9KLVyLv6IPPGFaBL0+y3BUynpB0uZ3KFp2CW0dggA9++bk7VovEN2Q3osa6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162269; c=relaxed/simple;
	bh=3nYQYzzIDq2Ubz1YCsLOBYd4NhLcVzv5m+MmiADk2L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4Y91kmP17+LHk23EEh7Q/+7A4duZm47WQ2Ld+2lxGbcJ6T1hTXmVXs3qPLtNNYMMSj2mUtgn3Fw7/e9oAlpjsWW2tYmJcApRnvdGEzhYU5taxsX6XLZfgOKCxsZja4wK1w6VwXvi86Y9l1Bv5sx1H3bbsePqhIUQ17leiTNTpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/AMYw0P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/AMYw0P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386251F00893;
	Sat, 30 May 2026 17:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162268;
	bh=zFuwGjiCW8i01zX6g4bqPXrQBnlol+L8EoGys2S/85w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/AMYw0P3zfIhMC9W0N0hHjBC9tx8RZWWSgqnDs5bB8nV80KuE7AJlZc+LTXy9zo2
	 ogVGAR9V7zCTAXeKCopKY2dYY1r+Bz+AvUrwVSPP+XOVz8sY6guz4aMqV/dTC0OuoZ
	 x5d34mYnLS2v5d6DJ1aTVmWO2rCMZYlUcOv2NVhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 872/969] LoongArch: Remove unused code to avoid build warning
Date: Sat, 30 May 2026 18:06:36 +0200
Message-ID: <20260530160324.763266162@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 0ccc9d47cf020994097ff51827cebd04aa2b0bf4 upstream.

After commit feee6b2989165631b1 ("mm/memory_hotplug: shrink zones when
offlining memory"), __remove_pages() doesn't need the "zone" parameter
so the "page" variable is also unused. Remove the unused code to avoid
such build warning:

arch/loongarch/mm/init.c: In function 'arch_remove_memory':
arch/loongarch/mm/init.c:134:22: warning: variable 'page' set but not used [-Wunused-but-set-variable=]
  134 |         struct page *page = pfn_to_page(start_pfn);

Cc: <stable@vger.kernel.org>
Reviewed-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/init.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -132,11 +132,7 @@ void arch_remove_memory(u64 start, u64 s
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct page *page = pfn_to_page(start_pfn);
 
-	/* With altmap the first mapped page is offset from @start */
-	if (altmap)
-		page += vmem_altmap_offset(altmap);
 	__remove_pages(start_pfn, nr_pages, altmap);
 }
 


