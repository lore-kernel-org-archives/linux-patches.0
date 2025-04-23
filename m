Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEB028B4FB;
	Wed, 23 Apr 2025 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422391; cv=none; b=WdlPmrUx5xpK8qS/0PNilm2qFxDKiF2WJaR90VE/voS6sQ1XTwVEXoaAmRKwmhC2lNVuAh/s4Wq5HSf7a5qngl1i1ug1Y3MxqFtB1/o1rbodpBAMkmYThzjPZZxurnox5lkhmH3wC4GRWuVWBVJ0PO3ZpxetuwT6YbZ65avxybk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422391; c=relaxed/simple;
	bh=62WJSADdndERgmOLSUKqqrBhA59/MY421eP/59e6Am8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l9eVTCZfSFx9PbRFZB2t36/GAbemujY1A94ERxCOIoBjRuv1L+g5xl7JryjjmBP1YLpg9cm/jFJToaBcEYuzXqcd1H13aFW2EtjWmwHOOyR3AdQpgH5Jq6bC/hm2pfDdq/zFgdtCmQp1906BQuMSx5KrJsA5foY60GcHvY2a5gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOmMVs7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOmMVs7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D792EC4CEE3;
	Wed, 23 Apr 2025 15:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422391;
	bh=62WJSADdndERgmOLSUKqqrBhA59/MY421eP/59e6Am8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SOmMVs7ar/x9KuvAI9GyHctNPLyBj68mN8R9WdI5uE0CiJu0/DEKYfBlgw9SbCmUO
	 0YVUnoCGCGfDcESOZp/slfgPVLifFrGkAgnPfhS5tNyotxh7Emz/f7phnjJOSvKot9
	 D59VbUQ8miRxGK5xfHt6SevhW6Nq+d3EP81rAP1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 291/291] MIPS: ds1287: Match ds1287_set_base_clock() function types
Date: Wed, 23 Apr 2025 16:44:40 +0200
Message-ID: <20250423142636.320487366@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit a759109b234385b74d2f5f4c86b5f59b3201ec12 upstream.

Synchronize the declaration of ds1287_set_base_clock() between
cevt-ds1287.c and ds1287.h.

Fix follow error with gcc-14 when -Werror:

arch/mips/kernel/cevt-ds1287.c:21:5: error: conflicting types for ‘ds1287_set_base_clock’; have ‘int(unsigned int)’
   21 | int ds1287_set_base_clock(unsigned int hz)
      |     ^~~~~~~~~~~~~~~~~~~~~
In file included from arch/mips/kernel/cevt-ds1287.c:13:
./arch/mips/include/asm/ds1287.h:11:13: note: previous declaration of ‘ds1287_set_base_clock’ with type ‘void(unsigned int)’
   11 | extern void ds1287_set_base_clock(unsigned int clock);
      |             ^~~~~~~~~~~~~~~~~~~~~
make[7]: *** [scripts/Makefile.build:207: arch/mips/kernel/cevt-ds1287.o] Error 1
make[6]: *** [scripts/Makefile.build:465: arch/mips/kernel] Error 2
make[6]: *** Waiting for unfinished jobs....

Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/ds1287.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/ds1287.h
+++ b/arch/mips/include/asm/ds1287.h
@@ -8,7 +8,7 @@
 #define __ASM_DS1287_H
 
 extern int ds1287_timer_state(void);
-extern void ds1287_set_base_clock(unsigned int clock);
+extern int ds1287_set_base_clock(unsigned int hz);
 extern int ds1287_clockevent_init(int irq);
 
 #endif


