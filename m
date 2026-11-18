Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043865;
	b=Pd9SkwdxB/iumucacYzx0RTXOAYd/fc9wypNFej2oqL2cFdO7Amt9QoknOw21injDKbV
	 td0EBT+TWzGMsEmqZc9D9FlWCGjy5EMdjPHDoRZq2nKl68XsHp7CA9TosBQTTXqtVEMhy
	 I8NuQkn2T+M6FR29rqsxA7LC1MN+lMmnlbdDgH13zAelnrkcXTdFLUodXedtahEWjqkoH
	 H6eXroSHqEoIqmGkxntksuYIPUcK9aTWq/6eE+0qBc2pkkk5SCb6FWpxPVviFeagghGlV
	 CLA8JOmm3MdEvhn8KcmwNsbsuyVPRI9PSCFs1/vEWEZFesX+SMrzYcq/mOs6rN/nrpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+7N5NA63e8z2AbAbJ2P6gpObhEZGE0PQaJTal+dCCFg=;
	b=bOUAVD4HuIkolM4HU5OE2HirTdWS1lg2YT+3FTA+Gh9VlOzYq0piVBczwjVulwILbHg0
	 aRaxi8cgm4A7KReZ6+3qNQlnd7x4G8M/x2eDWq+r3H5L4RctdqL9X6n/YemmttPyv/bRV
	 Sz+ABzr5jBY11mOsrPLcOtJ5Ot0QYdnC92lOF6ClKE34dJ+K8hGQXZ7ENrj1EyEftlRjK
	 wTg9oJw4ojJJBFdoA6ZQT5zKzxa3pqKO77vc5+0cRIBWMPvnMK+0Evd9E6cKlsEBUaj9u
	 gfZ6XASEvFtECw8GPrurz9WJ9ZOhN0vDqtFWncDm+Nysj78Pb6s68w6GPw2zHXDRjCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmvI5ewB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23847606A32A;
	Wed, 18 Nov 2026 23:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DmvI5ewB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2571F000C4;
	Wed, 18 Nov 2026 23:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043864;
	bh=+7N5NA63e8z2AbAbJ2P6gpObhEZGE0PQaJTal+dCCFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmvI5ewBGlHd+v/96Jv/+bGt0HFW0PGW8XlO3cCHsSKbhibEzuhd/f59/ojTB0PG7
	 LIBSDuEBlSPyMLS/UjUlFqeOSit3ZvAhkSxPYcCZsRx2MUkaqps1CVNzW/GErg3UJw
	 leZ7U13C19Vd5/imOfjUIsdFzNSQFMKYnIrI5/dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0361/2857] platform/x86: think-lmi: Replace kstrdup() + strreplace() with kstrdup_and_replace()
Date: Wed, 18 Nov 2026 15:23:15 +0100
Message-ID: <20261118150214.432880058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit e621198016e99cddc097d32cd3b56b15cee27d91 ]

Replace open coded functionalify of kstrdup_and_replace() with a call.

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230918135116.1248560-1-andriy.shevchenko@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Backport adaptation: drop the bulk-save check that is absent here, and
make kstrdup_and_replace() return the duplicated string instead of the
end pointer that strreplace() returns in this tree, which would yield an
empty string and an invalid kfree().

Stable-dep-of: 54745d563114 ("platform/x86: think-lmi: Fix current password length check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 43 +++++++++++---------------------
 lib/string_helpers.c             |  4 ++-
 2 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 035cce8db9eff..a0338c8ec7be7 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -15,7 +15,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/mutex.h>
-#include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <linux/types.h>
 #include <linux/dmi.h>
 #include <linux/wmi.h>
@@ -432,13 +432,11 @@ static ssize_t new_password_store(struct kobject *kobj,
 	if (!tlmi_priv.can_set_bios_password)
 		return -EOPNOTSUPP;
 
-	new_pwd = kstrdup(buf, GFP_KERNEL);
+	/* Strip out CR if one is present, setting password won't work if it is present */
+	new_pwd = kstrdup_and_replace(buf, '\n', '\0', GFP_KERNEL);
 	if (!new_pwd)
 		return -ENOMEM;
 
-	/* Strip out CR if one is present, setting password won't work if it is present */
-	strip_cr(new_pwd);
-
 	/* Use lock in case multiple WMI operations needed */
 	mutex_lock(&tlmi_mutex);
 
@@ -722,13 +720,11 @@ static ssize_t cert_to_password_store(struct kobject *kobj,
 	if (!setting->signature || !setting->signature[0])
 		return -EACCES;
 
-	passwd = kstrdup(buf, GFP_KERNEL);
+	/* Strip out CR if one is present */
+	passwd = kstrdup_and_replace(buf, '\n', '\0', GFP_KERNEL);
 	if (!passwd)
 		return -ENOMEM;
 
-	/* Strip out CR if one is present */
-	strip_cr(passwd);
-
 	/* Format: 'Password,Signature' */
 	auth_str = kasprintf(GFP_KERNEL, "%s,%s", passwd, setting->signature);
 	if (!auth_str) {
@@ -778,11 +774,10 @@ static ssize_t certificate_store(struct kobject *kobj,
 		return ret ?: count;
 	}
 
-	new_cert = kstrdup(buf, GFP_KERNEL);
+	/* Strip out CR if one is present */
+	new_cert = kstrdup_and_replace(buf, '\n', '\0', GFP_KERNEL);
 	if (!new_cert)
 		return -ENOMEM;
-	/* Strip out CR if one is present */
-	strip_cr(new_cert);
 
 	if (setting->cert_installed) {
 		/* Certificate is installed so this is an update */
@@ -830,13 +825,11 @@ static ssize_t signature_store(struct kobject *kobj,
 	if (!tlmi_priv.certificate_support)
 		return -EOPNOTSUPP;
 
-	new_signature = kstrdup(buf, GFP_KERNEL);
+	/* Strip out CR if one is present */
+	new_signature = kstrdup_and_replace(buf, '\n', '\0', GFP_KERNEL);
 	if (!new_signature)
 		return -ENOMEM;
 
-	/* Strip out CR if one is present */
-	strip_cr(new_signature);
-
 	/* Free any previous signature */
 	kfree(setting->signature);
 	setting->signature = new_signature;
@@ -859,13 +852,11 @@ static ssize_t save_signature_store(struct kobject *kobj,
 	if (!tlmi_priv.certificate_support)
 		return -EOPNOTSUPP;
 
-	new_signature = kstrdup(buf, GFP_KERNEL);
+	/* Strip out CR if one is present */
+	new_signature = kstrdup_and_replace(buf, '\n', '\0', GFP_KERNEL);
 	if (!new_signature)
 		return -ENOMEM;
 
-	/* Strip out CR if one is present */
-	strip_cr(new_signature);
-
 	/* Free any previous signature */
 	kfree(setting->save_signature);
 	setting->save_signature = new_signature;
@@ -994,13 +985,11 @@ static ssize_t current_value_store(struct kobject *kobj,
 	if (!tlmi_priv.can_set_bios_settings)
 		return -EOPNOTSUPP;
 
-	new_setting = kstrdup(buf, GFP_KERNEL);
+	/* Strip out CR if one is present */
+	new_setting = kstrdup_and_replace(buf, '\n', '\0', GFP_KERNEL);
 	if (!new_setting)
 		return -ENOMEM;
 
-	/* Strip out CR if one is present */
-	strip_cr(new_setting);
-
 	/* Use lock in case multiple WMI operations needed */
 	mutex_lock(&tlmi_mutex);
 
@@ -1173,13 +1162,11 @@ static ssize_t debug_cmd_store(struct kobject *kobj, struct kobj_attribute *attr
 	if (!tlmi_priv.can_debug_cmd)
 		return -EOPNOTSUPP;
 
-	new_setting = kstrdup(buf, GFP_KERNEL);
+	/* Strip out CR if one is present */
+	new_setting = kstrdup_and_replace(buf, '\n', '\0', GFP_KERNEL);
 	if (!new_setting)
 		return -ENOMEM;
 
-	/* Strip out CR if one is present */
-	strip_cr(new_setting);
-
 	if (tlmi_priv.pwd_admin->valid && tlmi_priv.pwd_admin->password[0]) {
 		auth_str = kasprintf(GFP_KERNEL, "%s,%s,%s;",
 				tlmi_priv.pwd_admin->password,
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 2f975395b49e5..3214fee5a3196 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -730,7 +730,9 @@ char *kstrdup_and_replace(const char *src, char old, char new, gfp_t gfp)
 	if (!dst)
 		return NULL;
 
-	return strreplace(dst, old, new);
+	strreplace(dst, old, new);
+
+	return dst;
 }
 EXPORT_SYMBOL_GPL(kstrdup_and_replace);
 
-- 
2.53.0



