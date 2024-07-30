Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02D61A76A5;
	Tue, 30 Jul 2024 17:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359505; cv=none; b=q3fPRvumCG67yWcgG8TfVaSQBLgtZ8fwMTTQmpDrY8i8gUJ0Ey+S+UAxE2TsS/r2mHwrsQ5MVJlFYn43B0KENcUk2RK8z/h2r18j2hAJ1bJHb4R8P8jQmfXThnAlengNkAuaSBhWDE/YcPGSRY3ASp6Ye+wDcRzI3NDWsTzxjk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359505; c=relaxed/simple;
	bh=SKKjL67C5F/MSGzN5siVqPmW8o1thyQlsTnwG4M92QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TiS9sAsjJWR6PFm6W9it93Lv6gxKxhfv/AVHEmkE1CGDbUJYk5X8UxrXqva9yS71OTOlhv52DMP969yh0A2OwCgoGlulunjb89XFOTzFnRMjTylSsronGxw0PrnXnR9EpgmrM9tUn9q95SG0MFMCPsPRawQeKBmpDH8oeOvNS6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MS57zwjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MS57zwjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4926C32782;
	Tue, 30 Jul 2024 17:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359505;
	bh=SKKjL67C5F/MSGzN5siVqPmW8o1thyQlsTnwG4M92QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MS57zwjLIZo6v45V5Wx4uWrq7r63t2j5L9cLPHVEkWzHaX+6QTj1U49vdaDwXh+Ty
	 gDJLspCfvZA6X31JGX14ySLEFN97r8XLP8AOetCSBLkwG5oau8nkcX7ukAM/NBO0lp
	 xXU0ADxLS0WaiR5Rwl/ZMQdoLWHLqXY498EXGrPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 494/568] MIPS: ip30: ip30-console: Add missing include
Date: Tue, 30 Jul 2024 17:50:01 +0200
Message-ID: <20240730151659.336969323@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 8de4ed75bd14ed197119ac509c6902a8561e0c1c upstream.

Include linux/processor.h to fix build error:

arch/mips/sgi-ip30/ip30-console.c: In function ‘prom_putchar’:
arch/mips/sgi-ip30/ip30-console.c:21:17: error: implicit declaration of function ‘cpu_relax’ [-Werror=implicit-function-declaration]
   21 |                 cpu_relax();

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/sgi-ip30/ip30-console.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/sgi-ip30/ip30-console.c
+++ b/arch/mips/sgi-ip30/ip30-console.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/io.h>
+#include <linux/processor.h>
 
 #include <asm/sn/ioc3.h>
 


