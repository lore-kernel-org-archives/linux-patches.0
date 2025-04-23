Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194E32BE0E1;
	Wed, 23 Apr 2025 15:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422386; cv=none; b=PISFiVZGOzlkMQtk3rciLsq8rPpLiURVh+DeHKvcQ5jHL88kuP2129aOOutFp3mYnfwt5suZ7EhnVw5jZFEFwO6luf6Lp5W9mnzOkrg9mkEwR8F5x66XWmBrRsfN+JClTPtZnldlVxbRtDej/ro6drB/hy+Axk+a3NlUBtsenBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422386; c=relaxed/simple;
	bh=8e1Fa+1Y8SUbxF9xSDm8i6gMBIoOVGxHsDY3E0y0E4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gPQ6Y85f4dRavq6/Llwbb5f2/2v+8+tdMhcV5EfbKXZ4e/pACqVZATsHxEw2WwW0sSB0rP21hvC1So2/xa9eOMya99nxJ5ngjpYPpgey/H5bFYaWtbm+s85aK1fdu/iFzH+YN0lbOcRH4iNCjOx+DxRtvWrBRINAozQswicXKC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AasYk0Hx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AasYk0Hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F428C4CEE8;
	Wed, 23 Apr 2025 15:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422386;
	bh=8e1Fa+1Y8SUbxF9xSDm8i6gMBIoOVGxHsDY3E0y0E4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AasYk0HxADul7gu70Qn5L/3v6p1XKNsade9nl6/3spd5ssN0XWrQB+dHIki2bCukq
	 vpf1s9278go4LyC75JmT8VHtnvZviKwTkxKwa2/r64wgqAl5DVTM8XgjBGugJJ+thv
	 OVa2wVt0rhBCJKgFzJkJSX5dL2h62fXk38GpmudI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 290/291] MIPS: cevt-ds1287: Add missing ds1287.h include
Date: Wed, 23 Apr 2025 16:44:39 +0200
Message-ID: <20250423142636.280770256@linuxfoundation.org>
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

commit f3be225f338a578851a7b607a409f476354a8deb upstream.

Address the issue of cevt-ds1287.c not including the ds1287.h header
file.

Fix follow errors with gcc-14 when -Werror:

arch/mips/kernel/cevt-ds1287.c:15:5: error: no previous prototype for ‘ds1287_timer_state’ [-Werror=missing-prototypes]
   15 | int ds1287_timer_state(void)
      |     ^~~~~~~~~~~~~~~~~~
arch/mips/kernel/cevt-ds1287.c:20:5: error: no previous prototype for ‘ds1287_set_base_clock’ [-Werror=missing-prototypes]
   20 | int ds1287_set_base_clock(unsigned int hz)
      |     ^~~~~~~~~~~~~~~~~~~~~
arch/mips/kernel/cevt-ds1287.c:103:12: error: no previous prototype for ‘ds1287_clockevent_init’ [-Werror=missing-prototypes]
  103 | int __init ds1287_clockevent_init(int irq)
      |            ^~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[7]: *** [scripts/Makefile.build:207: arch/mips/kernel/cevt-ds1287.o] Error 1
make[7]: *** Waiting for unfinished jobs....
make[6]: *** [scripts/Makefile.build:465: arch/mips/kernel] Error 2
make[6]: *** Waiting for unfinished jobs....

Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/cevt-ds1287.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/kernel/cevt-ds1287.c
+++ b/arch/mips/kernel/cevt-ds1287.c
@@ -10,6 +10,7 @@
 #include <linux/mc146818rtc.h>
 #include <linux/irq.h>
 
+#include <asm/ds1287.h>
 #include <asm/time.h>
 
 int ds1287_timer_state(void)


