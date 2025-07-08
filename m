Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA091548C;
	Tue,  8 Jul 2025 16:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992414; cv=none; b=IhJGpNB2XlNoG8EH8WYbxUid7tN66JM4yquUaoPmGSb+lfvh8MHMr3aJLfN+FBOdolAOqYnzG93b7rVA4RhNWIrLMcdP/LTOrbatmY5ihTGdv4XnyTa/s3UQ2N6FxR2tgwk2IJmZVJoXOHQDHPWDYGkdnRbxVipzlMpx2TGsi4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992414; c=relaxed/simple;
	bh=0IXJ6JKxAXkwUtmgHj19FzryRFSjhv/miaA5dyypql4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJdATxbDRKzkzIMsnwQuSPZw/95fI7NU3ySfHUTUhH7b0mH/67679leQdiuusOmt47kMPlP8rw1qGQ7M3hGCY7i5thrWdrd86GPR/h7uJKuTi/AS5WIbnOeHGH0KuZ+dNU34j+Takz9DmlipiIMvUl1zZ/sK6b8kbJn55YnuOgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gv8Zdlr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gv8Zdlr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF5CC4CEED;
	Tue,  8 Jul 2025 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992414;
	bh=0IXJ6JKxAXkwUtmgHj19FzryRFSjhv/miaA5dyypql4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gv8Zdlr0QlOEtU8gxAPXqH3faGq1OaiSp9l1QFRqOs6BLRbUzXrr1CZtrukOTRg7+
	 pK9h7f4U8Z0HCuWAClZ60dfzhPqHYD8BgWS6byRuKxW+wyWg4GL4dGSt4KNwReqJ9V
	 STN4xxm60JcEcEf6EgQ9EWsiVHiAB3CMlbbZdbG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Armin Wolf <W_Armin@gmx.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/132] platform/x86: firmware_attributes_class: Move include linux/device/class.h
Date: Tue,  8 Jul 2025 18:22:35 +0200
Message-ID: <20250708162231.963027072@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit d0eee1be379204d2ee6cdb09bd98b3fd0165b6d3 ]

The header firmware_attributes_class.h uses 'struct class'. It should
also include the necessary dependency header.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20250104-firmware-attributes-simplify-v1-1-949f9709e405@weissschuh.net
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 5ff1fbb30597 ("platform/x86: think-lmi: Fix class device unregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/firmware_attributes_class.c | 1 -
 drivers/platform/x86/firmware_attributes_class.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/firmware_attributes_class.c b/drivers/platform/x86/firmware_attributes_class.c
index dd8240009565d..4801f9f44aaa6 100644
--- a/drivers/platform/x86/firmware_attributes_class.c
+++ b/drivers/platform/x86/firmware_attributes_class.c
@@ -3,7 +3,6 @@
 /* Firmware attributes class helper module */
 
 #include <linux/mutex.h>
-#include <linux/device/class.h>
 #include <linux/module.h>
 #include "firmware_attributes_class.h"
 
diff --git a/drivers/platform/x86/firmware_attributes_class.h b/drivers/platform/x86/firmware_attributes_class.h
index 363c75f1ac1b8..8e0f47cfdf92e 100644
--- a/drivers/platform/x86/firmware_attributes_class.h
+++ b/drivers/platform/x86/firmware_attributes_class.h
@@ -5,6 +5,8 @@
 #ifndef FW_ATTR_CLASS_H
 #define FW_ATTR_CLASS_H
 
+#include <linux/device/class.h>
+
 int fw_attributes_class_get(const struct class **fw_attr_class);
 int fw_attributes_class_put(void);
 
-- 
2.39.5



