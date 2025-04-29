Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C724367;
	Tue, 29 Apr 2025 18:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950390; cv=none; b=rrDqAgdW5gQmH7QPYBsd8IZiiQVir0IYvGbcC2vkDQ74wM/pcf9xbWsIBG3NJPKYdme1VwmF83MuHd0m+m+6wVPbjmG01Mkse8BL/WRcH7GGqh9omxXHCKUPJu08kWhc2yk56+mZ6R81sEVR7QIAb2NwZKgpYP1u0lluenxS4sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950390; c=relaxed/simple;
	bh=SFy9aLAlmt5Q8nDrKaQu/JYkHlap+vihtEvDDUHh6rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0jgR4RApdthqBoLMBoWWibCcUQkaRNkAn+45mKfviW+ztgrZ2EixGW5z5SQ6gQlu9PuU1s4JtOOiQuU+B2zQJUjklcM0Cya37Cdh4ZXKEMjDew2dn/9/8GC1W48tlVmsJhIU1ISnN1BB2xyVlYavmPnb1AaBJ5iXfzrw8DTgQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2yAHEaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2yAHEaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D682AC4CEE3;
	Tue, 29 Apr 2025 18:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950390;
	bh=SFy9aLAlmt5Q8nDrKaQu/JYkHlap+vihtEvDDUHh6rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2yAHEaBkyFxrcp7yJp9FAMmFFNyHhTAgsB5WPd9SeQV/wpuOLFezbmQs5nrTGG8u
	 BF+js5GrBoa/epn3iKWFsuDPy9PpWA1beOVFj9c7f4ICPsAEhKt4hEI4SeJxQGX4Ry
	 MmcYkwGWGBtTioBTzkbsKuwMzvD/Nnpyshcih538=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Petr Tesarik <ptesarik@suse.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 081/204] LoongArch: Remove a bogus reference to ZONE_DMA
Date: Tue, 29 Apr 2025 18:42:49 +0200
Message-ID: <20250429161102.733124385@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Tesarik <ptesarik@suse.com>

commit c37325cbd91abe3bfab280b3b09947155abe8e07 upstream.

Remove dead code. LoongArch does not have a DMA memory zone (24bit DMA).
The architecture does not even define MAX_DMA_PFN.

Cc: stable@vger.kernel.org
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/init.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -64,9 +64,6 @@ void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
-#ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
-#endif
 #ifdef CONFIG_ZONE_DMA32
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 #endif


