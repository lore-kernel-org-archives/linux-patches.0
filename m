Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E9724C067;
	Tue, 29 Apr 2025 17:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946026; cv=none; b=Q9hWTOUimWwAXouCFgg7SF3u99mbQzyMtCKj/k1IIFubMaUQ69xfwL2PpLCySnMKDLuldc4IycerJr5nDhLFIXXocWgZzZ4/9HNWTwlOc7oOdcWoflrYA4NmNjlWQ18AABj3HqXOXX2dFdF4wLtkIFTlN7XgE81lixD9tnBDH7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946026; c=relaxed/simple;
	bh=lRgNcphxLm2o7XY6mWbdaGfj3LykZ0AY4HIU3HA1ReQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWcR6/re6QfaLXnXQpThJsZECqglzyt1tP07pI+F26vEj2xrLuxX+PfYM9Bqx8a9y4O4W2lOjdHQ4SHOThzvaEstCPZIu0eDXv4qc36XJWxp0/2TRBw9jFLQvCWAXZ3vjo6U9s2R2T67kZ7jamMNeZyZmyGsVr8h05HUbmXtu4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jaLQL89E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jaLQL89E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADDCC4CEE3;
	Tue, 29 Apr 2025 17:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946026;
	bh=lRgNcphxLm2o7XY6mWbdaGfj3LykZ0AY4HIU3HA1ReQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaLQL89EdXeQ+73PcK7YIymnXOfmr80UFdrMhOVecod4Km5ltcTl4hkupISPup+aq
	 wyg1hu6G0pgFNN3BQWfaApIyGQcQTivZLPN3olLU2d+VTtSKjfTSOJCH4hjrpHioka
	 JZw4tI/+4wGahH32vtZplxf6ypCzQ8uJPCBTeG0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Petr Tesarik <ptesarik@suse.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 130/311] LoongArch: Remove a bogus reference to ZONE_DMA
Date: Tue, 29 Apr 2025 18:39:27 +0200
Message-ID: <20250429161126.367045541@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -65,9 +65,6 @@ void __init paging_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
-#ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
-#endif
 #ifdef CONFIG_ZONE_DMA32
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 #endif


