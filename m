Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6E81DFFB;
	Thu, 15 Aug 2024 14:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732438; cv=none; b=e/R8b7Aib1Rs1QmeLsovPJFrD5QWXZenUQndWBPaYKN4nysoCRivUz1HYUQ/g59Zsi4uEU+cfiv2+2AzvD6CATJB5ZRNhTkyoevtezYvpDw3fAPLclvHYNAXmLZPjSHJZrNb/bxXRn6yqNY+XORqzKq8EiaLbOCZmqvGI/o5AyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732438; c=relaxed/simple;
	bh=JcpE7iV+i0k7ZKueEBeW4SLgh3O1DOwxDm3rNhbVc5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o351yyoVBczR564rDGpxrzeSDmPnb5j/DLio6NeVcQNN2xGP8Qihkkbbcxj3wqsEsoiJ1jgQTNI4t28gpZmjo+scHqbucdAyLNgTxD0sFWG0H6Fa8twAT5W3tMFCKzIAkTxg3X3FhktPwfS4xsQLEa3BhYM9AeyocAkF59pbo6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyYsN/6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyYsN/6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADA3C4AF0C;
	Thu, 15 Aug 2024 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732438;
	bh=JcpE7iV+i0k7ZKueEBeW4SLgh3O1DOwxDm3rNhbVc5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyYsN/6GzX8gyHa9BdPVrNxAoHVtlb4vbaksGp0OvZhoyoknlPd6DMBNG+VkEC0vR
	 wStq3V+MuOD1gNpFveGnsLIbNez+S0oFNSzmcryUln+ljVc3t7xu+w5t6ljsHafWS9
	 yL5P+z8rVgZgm+5cALG+xIFzY+DDU/UIB3+LS1yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 178/352] MIPS: ip30: ip30-console: Add missing include
Date: Thu, 15 Aug 2024 15:24:04 +0200
Message-ID: <20240815131926.158269010@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


