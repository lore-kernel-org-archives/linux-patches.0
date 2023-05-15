Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B645FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA85C433EF;
	Mon, 15 May 2023 17:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171784;
	bh=FtIGOI305kwy/6FOj8mlpzgLrPNp4dN8LNtHBq5MSRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7rV1dnLEtGUh/wS8yISpKo5qlZN9pjqV4apmU9G81qxtCRau9AAMPVwQVdnx62Vs
	 G6SVR+eS5orIUExbMIgelcERcN5m7kt6cm6Xy4MgDMGMDrpyLK9FeZwR6WtkcpQZ4F
	 vQVoyvUAxuzUDic8YBa9ko+fF/pkyq7jhIfZrbyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5.15 076/134] sh: mcount.S: fix build error when PRINTK is not enabled
Date: Mon, 15 May 2023 18:29:13 +0200
Message-Id: <20230515161705.708758312@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

commit c2bd1e18c6f85c0027da2e5e7753b9bfd9f8e6dc upstream.

Fix a build error in mcount.S when CONFIG_PRINTK is not enabled.
Fixes this build error:

sh2-linux-ld: arch/sh/lib/mcount.o: in function `stack_panic':
(.text+0xec): undefined reference to `dump_stack'

Fixes: e460ab27b6c3 ("sh: Fix up stack overflow check with ftrace disabled.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/20230306040037.20350-8-rdunlap@infradead.org
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sh/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/Kconfig.debug
+++ b/arch/sh/Kconfig.debug
@@ -15,7 +15,7 @@ config SH_STANDARD_BIOS
 
 config STACK_DEBUG
 	bool "Check for stack overflows"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && PRINTK
 	help
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit. Saying Y here will add overhead to


