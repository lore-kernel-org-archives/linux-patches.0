Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DA21D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FC4C433C7;
	Wed,  4 Oct 2023 18:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442699;
	bh=8Pairt1UJXwm9I5cx1nIXXHIcNKpD3vtEWJyIat1Oso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCQZrl2/zZQ0rP8m+uncM7ZFnup+gBaLkHpBxWqVIm/+6HzplmXLKpAzgRUh1fBcC
	 EMcsHgcxNkwbrpBKRLEiukf0utRJE7yVLcGAJ4int7puiPcDCRal6CGQGageKmCNH6
	 LxvxDKVPdHniA0eQOgKPY0BbPEuMrv2cJiRg2B3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Mattijs Korpershoek <mkorpershoek@baylibre.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/183] Input: i8042 - rename i8042-x86ia64io.h to i8042-acpipnpio.h
Date: Wed,  4 Oct 2023 19:55:09 +0200
Message-ID: <20231004175207.146349497@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 8761b9b580d53162cca7868385069c0d4354c9e0 ]

Now i8042-x86ia64io.h is shared by X86 and IA64, but it can be shared
by more platforms (such as LoongArch) with ACPI firmware on which PNP
typed keyboard and mouse is configured in DSDT. So rename it to i8042-
acpipnpio.h.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/20220917064020.1639709-1-chenhuacai@loongson.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: eb09074bdb05 ("Input: i8042 - add quirk for TUXEDO Gemini 17 Gen1/Clevo PD70PN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../input/serio/{i8042-x86ia64io.h => i8042-acpipnpio.h}    | 6 +++---
 drivers/input/serio/i8042.h                                 | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/input/serio/{i8042-x86ia64io.h => i8042-acpipnpio.h} (99%)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-acpipnpio.h
similarity index 99%
rename from drivers/input/serio/i8042-x86ia64io.h
rename to drivers/input/serio/i8042-acpipnpio.h
index 339e765bcf5ae..ce8ec35e8e06d 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _I8042_X86IA64IO_H
-#define _I8042_X86IA64IO_H
+#ifndef _I8042_ACPIPNPIO_H
+#define _I8042_ACPIPNPIO_H
 
 
 #ifdef CONFIG_X86
@@ -1647,4 +1647,4 @@ static inline void i8042_platform_exit(void)
 	i8042_pnp_exit();
 }
 
-#endif /* _I8042_X86IA64IO_H */
+#endif /* _I8042_ACPIPNPIO_H */
diff --git a/drivers/input/serio/i8042.h b/drivers/input/serio/i8042.h
index 55381783dc82d..bf2592fa9a783 100644
--- a/drivers/input/serio/i8042.h
+++ b/drivers/input/serio/i8042.h
@@ -20,7 +20,7 @@
 #elif defined(CONFIG_SPARC)
 #include "i8042-sparcio.h"
 #elif defined(CONFIG_X86) || defined(CONFIG_IA64)
-#include "i8042-x86ia64io.h"
+#include "i8042-acpipnpio.h"
 #else
 #include "i8042-io.h"
 #endif
-- 
2.40.1



