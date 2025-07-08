Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1B72E5413;
	Tue,  8 Jul 2025 16:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992825; cv=none; b=igzATNLJJlMeXCY/2zdW4hJmL11XozjsNgu4xBmAsDR/JxD1vrN0jrPnZJkQggQ+LgOHuYjsB4caoSBMhVXEWvzSG/dz+oUo8pTWs0e0Bbn7viELHl+LYo3l3XZdMLgjSF1s/XGwRM6vKJdzZjoqJwhKbqm7/2p9aohgQ89Z/Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992825; c=relaxed/simple;
	bh=fHuARlY3yiTFr01ZjDWx49QMkfD9b5kSh3Yga8pBmeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dtjP6cy7uPpcWlGC8CjA1tLBMieIUV6Rc0erdmbxvenCgGz9QxLK2PA2EuMz2G2afe1oUOAtyAz8BqoFbZEv+Okt+Y0bcVmOdAtj7rTotIuYWSwxaFwayCkdD2sk+hfmJssd0W2UK5Gbu1WPF91WzZZDCqN1p37IfdOPkQW3XOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMRZlnfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMRZlnfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248C0C4CEED;
	Tue,  8 Jul 2025 16:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992825;
	bh=fHuARlY3yiTFr01ZjDWx49QMkfD9b5kSh3Yga8pBmeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMRZlnfeYUX8ZtyXRy6JW0fbGQVGyb1+qvJ1xMfGMhJVgn2e9gpnyj/RI3Dwjus5B
	 akli2pMBS9WFXa0ZJ3f7VqnAyqn4GPVJYyFnRYb+8dXlqsYrE+QoBwos3QHXy2mdFw
	 CVB3x7qIorfOZOUCa4pprj6AtPNCGzbIujy3nXac=
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
Subject: [PATCH 6.12 066/232] platform/x86: firmware_attributes_class: Move include linux/device/class.h
Date: Tue,  8 Jul 2025 18:21:02 +0200
Message-ID: <20250708162243.190232306@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 182a07d8ae3df..cbc56e5db5928 100644
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



