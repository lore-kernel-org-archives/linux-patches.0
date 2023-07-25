Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E8D1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE3AC433C7;
	Tue, 25 Jul 2023 11:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284140;
	bh=gbepNwzUiPT8KkoIjbwymTet91H+gx3Nw+PekQtK9vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmB4kvWGeP9M+ifUwCSOl9YVID6BVluhAJHE/o0UUiVqn5lLBTYHvbOPauzFCgOip
	 hnLJxSHThDxVdq94hOVNraBAIQ3TxKnd4dHa4/Qw4onqFocRs6i4zz2bR3b1fydNJH
	 KB23OXGyL+0PO7WGr7/R1cg/xuc11CdRSGT9os2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Landley <rob@landley.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/509] sh: j2: Use ioremap() to translate device tree address into kernel memory
Date: Tue, 25 Jul 2023 12:42:39 +0200
Message-ID: <20230725104603.827289228@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>

[ Upstream commit bc9d1f0cecd2407cfb2364a7d4be2f52d1d46a9d ]

Addresses the following warning when building j2_defconfig:

arch/sh/kernel/cpu/sh2/probe.c: In function 'scan_cache':
arch/sh/kernel/cpu/sh2/probe.c:24:16: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   24 |  j2_ccr_base = (u32 __iomem *)of_flat_dt_translate_address(node);
      |

Fixes: 5a846abad07f ("sh: add support for J-Core J2 processor")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Rob Landley <rob@landley.net>
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/20230503125746.331835-1-glaubitz@physik.fu-berlin.de
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/kernel/cpu/sh2/probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/kernel/cpu/sh2/probe.c b/arch/sh/kernel/cpu/sh2/probe.c
index d342ea08843f6..70a07f4f2142f 100644
--- a/arch/sh/kernel/cpu/sh2/probe.c
+++ b/arch/sh/kernel/cpu/sh2/probe.c
@@ -21,7 +21,7 @@ static int __init scan_cache(unsigned long node, const char *uname,
 	if (!of_flat_dt_is_compatible(node, "jcore,cache"))
 		return 0;
 
-	j2_ccr_base = (u32 __iomem *)of_flat_dt_translate_address(node);
+	j2_ccr_base = ioremap(of_flat_dt_translate_address(node), 4);
 
 	return 1;
 }
-- 
2.39.2



