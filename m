Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F9415C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A654C4347C;
	Mon,  5 Dec 2022 19:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268161;
	bh=J9ytkmt0aDs0PRsYNxaPyLbK6dU3PFHYq+1koA8bbJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4hcCLehMSSH+TxiHwj0kAW/j54g06ehbZs7obDAIwU0lu15Ce5EC5SUNokZaeKFI
	 jx1cTpUrQdE22IkNsCmUzgZjEtFvAsq6MeVBQmRwFdCiaDM0P7h/Ql7BRoVaEGA8rR
	 wcP/DDssXYUYvg6VsrZMkglGGM3y8a4FfWpV6Xyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Chris Zankel <chris@zankel.net>,
	David Laight <David.Laight@ACULAB.COM>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/105] xtensa: increase size of gcc stack frame check
Date: Mon,  5 Dec 2022 20:10:07 +0100
Message-Id: <20221205190806.328319187@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 867050247e295cf20fce046a92a7e6491fcfe066 ]

xtensa frame size is larger than the frame size for almost all other
architectures.  This results in more than 50 "the frame size of <n> is
larger than 1024 bytes" errors when trying to build xtensa:allmodconfig.

Increase frame size for xtensa to 1536 bytes to avoid compile errors due
to frame size limits.

Link: https://lkml.kernel.org/r/20210912025235.3514761-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 152fe65f300e ("Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 556aae95d69b..12fc801811d3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -224,7 +224,7 @@ config FRAME_WARN
 	range 0 8192
 	default 3072 if KASAN_EXTRA
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1536 if (!64BIT && PARISC)
+	default 1536 if (!64BIT && (PARISC || XTENSA))
 	default 1024 if (!64BIT && !PARISC)
 	default 2048 if 64BIT
 	help
-- 
2.35.1



