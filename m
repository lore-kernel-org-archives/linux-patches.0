Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36455813C;
	Thu, 30 Nov 2023 22:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nummLDBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E940FC433CB;
	Thu, 30 Nov 2023 22:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701385105;
	bh=4urMtjGT8KJWiWp5vGb23AkjFy/esF9DB24lgcFzCWU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nummLDBuBgRyUGV0kuVDIko8HoMnRjlLMiMZmac2W++LRG/+Sx1pAwvyVCbwcjcxc
	 kJEURVTt1h2ec5NVrukB5fZzCVbISk+mRP5fdOEuII3dbOwex2XlY4EvP485MiA/KB
	 5nYTLa30c5ZM9eEHlWc9mS1nIR4jduSFtwWuou+/dhsGDDBHdCFpTzZ+bxhv5lF1tx
	 6sR/V4EqLcq+i6sMfrDPpcCO0LQUXoyGCftu4T3iCHXIulXcbO+4K2ZQsKfP0PzTz5
	 AUZje+Fpyu3j4CY31eg2jRZ8RqUd322RoedLYxy8/ArK7ewKpmhp5XkQ1WZE++EqWv
	 zM0FZCFTwmLyQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 30 Nov 2023 15:58:15 -0700
Subject: [PATCH 02/19] hexagon: mm: Mark paging_init() as static
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231130-hexagon-missing-prototypes-v1-2-5c34714afe9e@kernel.org>
References: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
In-Reply-To: <20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org>
To: bcain@quicinc.com, akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-hexagon@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1083; i=nathan@kernel.org;
 h=from:subject:message-id; bh=4urMtjGT8KJWiWp5vGb23AkjFy/esF9DB24lgcFzCWU=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmZwr13//3/vsRkgc63LcKnJlosPfh2T+TdXsMMfkuWr
 aZbXpa+7ihlYRDjYpAVU2Spfqx63NBwzlnGG6cmwcxhZQIZwsDFKQATmc7AyHDxjFwwl83i/Yd0
 Q290XFi69O45M+VuloNz0s+9W13kmvGVkeHxtnfrp53oPXxiu4k5e66Lxp9bbKHM6qu8Ww4md95
 g8WEAAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns:

  arch/hexagon/mm/init.c:89:13: warning: no previous prototype for function 'paging_init' [-Wmissing-prototypes]
     89 | void __init paging_init(void)
        |             ^
  arch/hexagon/mm/init.c:89:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     89 | void __init paging_init(void)
        | ^
        | static

This function is only used within this translation unit, so mark it
static as suggested.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/mm/init.c b/arch/hexagon/mm/init.c
index 146115c9de61..f164b377b93b 100644
--- a/arch/hexagon/mm/init.c
+++ b/arch/hexagon/mm/init.c
@@ -86,7 +86,7 @@ void sync_icache_dcache(pte_t pte)
  * In this mode, we only have one pg_data_t
  * structure: contig_mem_data.
  */
-void __init paging_init(void)
+static void __init paging_init(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = {0, };
 

-- 
2.43.0

