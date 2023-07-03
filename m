Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5FC259D
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD40BC433C8;
	Mon,  3 Jul 2023 18:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410534;
	bh=U+zrfBrt8DsUfOvAkGbp27QkVfQbtYbQJaadquieJNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjaTsmR0QddbFqO6tBDK3/5J4S0gdG73gC59lmwyOEh9IDQ4acF7UeD3mdoxc11pY
	 sFouJTSozr96v5JZYBJCT6H1OIMndjteLI7x3VqyuWbVQ/xpLgTuqbBurLXIEPpR1i
	 0RAKFg3xmAfRvNqGKofnDC7ic1+oMoRwBYR9juFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 6.4 02/13] tools/nolibc: x86_64: disable stack protector for _start
Date: Mon,  3 Jul 2023 20:54:03 +0200
Message-ID: <20230703184519.337832727@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184519.261119397@linuxfoundation.org>
References: <20230703184519.261119397@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <linux@weissschuh.net>

commit 7a9b2345202a14dfec9081994486156f7a691513 upstream.

This was forgotten in the original submission.

It is unknown why it worked for x86_64 on some compiler without this
attribute.

Reported-by: Willy Tarreau <w@1wt.eu>
Closes: https://lore.kernel.org/lkml/20230520133237.GA27501@1wt.eu/
Fixes: 0d8c461adbc4 ("tools/nolibc: x86_64: add stackprotector support")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/nolibc/arch-x86_64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/arch-x86_64.h b/tools/include/nolibc/arch-x86_64.h
index d98f6c89d143..e201af15e142 100644
--- a/tools/include/nolibc/arch-x86_64.h
+++ b/tools/include/nolibc/arch-x86_64.h
@@ -190,7 +190,7 @@ const unsigned long *_auxv __attribute__((weak));
  * 2) The deepest stack frame should be zero (the %rbp).
  *
  */
-void __attribute__((weak,noreturn,optimize("omit-frame-pointer"))) _start(void)
+void __attribute__((weak,noreturn,optimize("omit-frame-pointer"),no_stack_protector)) _start(void)
 {
 	__asm__ volatile (
 #ifdef NOLIBC_STACKPROTECTOR
-- 
2.41.0



