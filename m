Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EEE10960
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5529C4339A;
	Mon, 19 Jun 2023 10:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172272;
	bh=eivSQtkr+2paRjV5sgsPYGofNDLGz0p5xGd/q3YjDbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RprO+Tt2FWH6JRs7YiUqvA6QzpkrcVS1Gqa5wv114b7rFqcxhCvjKtdohw/p6R74y
	 3JtTjJIhmGUHKd+ru/m8wKCnid/1Afhy5tMWMdx+NVmIloUr8rx4neHSK0OIMxLdx0
	 5eLyCP0wa2IthdXLo9bcAXxAYrluSGqR7Zjhb5sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/107] test_firmware: Use kstrtobool() instead of strtobool()
Date: Mon, 19 Jun 2023 12:29:45 +0200
Message-ID: <20230619102141.609155993@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f7d85515bd21902b218370a1a6301f76e4e636ff ]

strtobool() is the same as kstrtobool().
However, the latter is more used within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/34f04735d20e0138695dd4070651bd860a36b81c.1673688120.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4acfe3dfde68 ("test_firmware: prevent race conditions by a correct implementation of locking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_firmware.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index e337773585b9e..0b4e3de3f1748 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/delay.h>
+#include <linux/kstrtox.h>
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
 #include <linux/efi_embedded_fw.h>
@@ -326,7 +327,7 @@ static int test_dev_config_update_bool(const char *buf, size_t size,
 	int ret;
 
 	mutex_lock(&test_fw_mutex);
-	if (strtobool(buf, cfg) < 0)
+	if (kstrtobool(buf, cfg) < 0)
 		ret = -EINVAL;
 	else
 		ret = size;
-- 
2.39.2



