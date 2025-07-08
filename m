Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824151CD1E4;
	Tue,  8 Jul 2025 16:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992298; cv=none; b=oPruUtfof04jkxIM+rWGFCaNmOcRwXD0/75P2q7uogyLc3IX8RSB5bameNJWwyRuTYO6mLZtXp9+gwY1SWx9ZlQW1SaHhn/PkeeU4igRW3k3JtkjDVq4ypDhLfVjWKVvcRoMb/7dOpQDn0RNkT1X1E3puv9FkLGl3pEoRZKCIqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992298; c=relaxed/simple;
	bh=fylyrkFVkXR7a7648c+oMRlx3H+PFI0IOBFohND85Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LsAe/X9HBYLtFXQeuK1ax6zon0AgRy5UaOqVg02JEIUHyRV/N52ql/ABF3/jsDMp0EjOYdWt0TiIkLnwh7yHv7W2nUz5DxsVsRO0w3rJOLG2CNuAwttNVsbAtmVLVD9z2bTtWwPNnHrosWtgFXnZ4LSCCQ9IoDKIQfe+ropvSu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLkj3qJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLkj3qJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F4DC4CEF5;
	Tue,  8 Jul 2025 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992298;
	bh=fylyrkFVkXR7a7648c+oMRlx3H+PFI0IOBFohND85Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLkj3qJ8ABM+eDsQ+0Zou2QpWWRen63R5Pl/ksn3e7vIB7CsS9/4IYhYdondPzBIy
	 vMiUe0v2AMoqNFAT/vavDSu9bYdUm0BbQ1nwym/DPWXI/fk35ld3rHad8xrflnAsio
	 i5O+boYpwGpMHhxuEsRVigY6oFI8iE5t8i09y8dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/132] platform/x86: make fw_attr_class constant
Date: Tue,  8 Jul 2025 18:22:34 +0200
Message-ID: <20250708162231.936537274@linuxfoundation.org>
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

From: Ricardo B. Marliere <ricardo@marliere.net>

[ Upstream commit 5878e5b760b6fcf7bc00dec085ba2b439a929871 ]

Since commit 43a7206b0963 ("driver core: class: make class_register() take
a const *"), the driver core allows for struct class to be in read-only
memory, so move the fw_attr_class structure to be declared at build time
placing it into read-only memory, instead of having to be dynamically
allocated at boot time.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: "Ricardo B. Marliere" <ricardo@marliere.net>
Link: https://lore.kernel.org/r/20240305-class_cleanup-platform-v1-1-9085c97b9355@marliere.net
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 5ff1fbb30597 ("platform/x86: think-lmi: Fix class device unregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c | 2 +-
 drivers/platform/x86/firmware_attributes_class.c   | 4 ++--
 drivers/platform/x86/firmware_attributes_class.h   | 2 +-
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c       | 2 +-
 drivers/platform/x86/think-lmi.c                   | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
index f567d37a64a33..decb3b997d86a 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
@@ -25,7 +25,7 @@ struct wmi_sysman_priv wmi_priv = {
 /* reset bios to defaults */
 static const char * const reset_types[] = {"builtinsafe", "lastknowngood", "factory", "custom"};
 static int reset_option = -1;
-static struct class *fw_attr_class;
+static const struct class *fw_attr_class;
 
 
 /**
diff --git a/drivers/platform/x86/firmware_attributes_class.c b/drivers/platform/x86/firmware_attributes_class.c
index fafe8eaf6e3e4..dd8240009565d 100644
--- a/drivers/platform/x86/firmware_attributes_class.c
+++ b/drivers/platform/x86/firmware_attributes_class.c
@@ -10,11 +10,11 @@
 static DEFINE_MUTEX(fw_attr_lock);
 static int fw_attr_inuse;
 
-static struct class firmware_attributes_class = {
+static const struct class firmware_attributes_class = {
 	.name = "firmware-attributes",
 };
 
-int fw_attributes_class_get(struct class **fw_attr_class)
+int fw_attributes_class_get(const struct class **fw_attr_class)
 {
 	int err;
 
diff --git a/drivers/platform/x86/firmware_attributes_class.h b/drivers/platform/x86/firmware_attributes_class.h
index 486485cb1f54e..363c75f1ac1b8 100644
--- a/drivers/platform/x86/firmware_attributes_class.h
+++ b/drivers/platform/x86/firmware_attributes_class.h
@@ -5,7 +5,7 @@
 #ifndef FW_ATTR_CLASS_H
 #define FW_ATTR_CLASS_H
 
-int fw_attributes_class_get(struct class **fw_attr_class);
+int fw_attributes_class_get(const struct class **fw_attr_class);
 int fw_attributes_class_put(void);
 
 #endif /* FW_ATTR_CLASS_H */
diff --git a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
index 6ddca857cc4d1..b8bac35ebd42b 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -24,7 +24,7 @@ struct bioscfg_priv bioscfg_drv = {
 	.mutex = __MUTEX_INITIALIZER(bioscfg_drv.mutex),
 };
 
-static struct class *fw_attr_class;
+static const struct class *fw_attr_class;
 
 ssize_t display_name_language_code_show(struct kobject *kobj,
 					struct kobj_attribute *attr,
diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 2396decdb3cb3..3a496c615ce6b 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -195,7 +195,7 @@ static const char * const level_options[] = {
 	[TLMI_LEVEL_MASTER] = "master",
 };
 static struct think_lmi tlmi_priv;
-static struct class *fw_attr_class;
+static const struct class *fw_attr_class;
 static DEFINE_MUTEX(tlmi_mutex);
 
 /* ------ Utility functions ------------*/
-- 
2.39.5



