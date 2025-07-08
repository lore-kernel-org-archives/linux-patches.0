Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4CA2E2F0D;
	Tue,  8 Jul 2025 16:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992851; cv=none; b=eZ9l2GdgqsqO04NoHY1NfniDfTAtEFF+F6aEPyvav0+XcEvRB/CAENba9vqhf0LWRRP7ux29ucZ4uZPeiM3QarDxGx5DCFCB6nAI4zuNDnBHDnvXrRKv9P96264q92e9+HA+sna/uHH5U8BwOR8UzZsdxJyHzn/KpTGNRggZiVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992851; c=relaxed/simple;
	bh=8FqWodATZeij6Xm5nnnqkP4PJizcRO294axsaC/5Aj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jt7ldD9YcQ7D4c0tEyIL4vrsuyahXu5wdXshMk6fvBLhCFinXpdmUA5czywr2A7Zfd8efaaub+iKdFF+yTmb4onuWvzOHou4WBPHup+LOGjlCYb6nPsZIJ/MaepcEj6CDXUjcyV3AHVe91dJGP+AVZOdf4gF9e6trpdc63JB/5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suDmTIFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suDmTIFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EFFC4CEED;
	Tue,  8 Jul 2025 16:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992851;
	bh=8FqWodATZeij6Xm5nnnqkP4PJizcRO294axsaC/5Aj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suDmTIFajCHi3SVBGafdfDOOStTilhWKo3/l7YAgDTEulVWtAy959GD3tpKfCYHL6
	 x9InnRlsIr2FAlWokudH0nRTJ8HW/oPp+QMh9LTXOYJy7O1GRCj+UHCYhLUuTRLyrR
	 qv2Tmds6qEZ1e+1iQbyHWYNhIkdDkmVIyROTic8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Graczyk <jangraczyk@yahoo.ca>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Armin Wolf <W_Armin@gmx.de>,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/232] platform/x86: dell-wmi-sysman: Fix WMI data block retrieval in sysfs callbacks
Date: Tue,  8 Jul 2025 18:20:59 +0200
Message-ID: <20250708162243.111270767@linuxfoundation.org>
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

From: Kurt Borja <kuurtb@gmail.com>

[ Upstream commit eb617dd25ca176f3fee24f873f0fd60010773d67 ]

After retrieving WMI data blocks in sysfs callbacks, check for the
validity of them before dereferencing their content.

Reported-by: Jan Graczyk <jangraczyk@yahoo.ca>
Closes: https://lore.kernel.org/r/CAHk-=wgMiSKXf7SvQrfEnxVtmT=QVQPjJdNjfm3aXS7wc=rzTw@mail.gmail.com/
Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250630-sysman-fix-v2-1-d185674d0a30@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/dell/dell-wmi-sysman/dell-wmi-sysman.h   | 5 +++++
 .../platform/x86/dell/dell-wmi-sysman/enum-attributes.c   | 5 +++--
 .../platform/x86/dell/dell-wmi-sysman/int-attributes.c    | 5 +++--
 .../x86/dell/dell-wmi-sysman/passobj-attributes.c         | 5 +++--
 .../platform/x86/dell/dell-wmi-sysman/string-attributes.c | 5 +++--
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c        | 8 ++++----
 6 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/dell-wmi-sysman.h b/drivers/platform/x86/dell/dell-wmi-sysman/dell-wmi-sysman.h
index 3ad33a094588c..817ee7ba07ca0 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/dell-wmi-sysman.h
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/dell-wmi-sysman.h
@@ -89,6 +89,11 @@ extern struct wmi_sysman_priv wmi_priv;
 
 enum { ENUM, INT, STR, PO };
 
+#define ENUM_MIN_ELEMENTS		8
+#define INT_MIN_ELEMENTS		9
+#define STR_MIN_ELEMENTS		8
+#define PO_MIN_ELEMENTS			4
+
 enum {
 	ATTR_NAME,
 	DISPL_NAME_LANG_CODE,
diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/enum-attributes.c b/drivers/platform/x86/dell/dell-wmi-sysman/enum-attributes.c
index 8cc212c852668..fc2f58b4cbc6e 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/enum-attributes.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/enum-attributes.c
@@ -23,9 +23,10 @@ static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *a
 	obj = get_wmiobj_pointer(instance_id, DELL_WMI_BIOS_ENUMERATION_ATTRIBUTE_GUID);
 	if (!obj)
 		return -EIO;
-	if (obj->package.elements[CURRENT_VAL].type != ACPI_TYPE_STRING) {
+	if (obj->type != ACPI_TYPE_PACKAGE || obj->package.count < ENUM_MIN_ELEMENTS ||
+	    obj->package.elements[CURRENT_VAL].type != ACPI_TYPE_STRING) {
 		kfree(obj);
-		return -EINVAL;
+		return -EIO;
 	}
 	ret = snprintf(buf, PAGE_SIZE, "%s\n", obj->package.elements[CURRENT_VAL].string.pointer);
 	kfree(obj);
diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/int-attributes.c b/drivers/platform/x86/dell/dell-wmi-sysman/int-attributes.c
index 951e75b538fad..7352480642391 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/int-attributes.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/int-attributes.c
@@ -25,9 +25,10 @@ static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *a
 	obj = get_wmiobj_pointer(instance_id, DELL_WMI_BIOS_INTEGER_ATTRIBUTE_GUID);
 	if (!obj)
 		return -EIO;
-	if (obj->package.elements[CURRENT_VAL].type != ACPI_TYPE_INTEGER) {
+	if (obj->type != ACPI_TYPE_PACKAGE || obj->package.count < INT_MIN_ELEMENTS ||
+	    obj->package.elements[CURRENT_VAL].type != ACPI_TYPE_INTEGER) {
 		kfree(obj);
-		return -EINVAL;
+		return -EIO;
 	}
 	ret = snprintf(buf, PAGE_SIZE, "%lld\n", obj->package.elements[CURRENT_VAL].integer.value);
 	kfree(obj);
diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/passobj-attributes.c b/drivers/platform/x86/dell/dell-wmi-sysman/passobj-attributes.c
index d8f1bf5e58a0f..3167e06d416ed 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/passobj-attributes.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/passobj-attributes.c
@@ -26,9 +26,10 @@ static ssize_t is_enabled_show(struct kobject *kobj, struct kobj_attribute *attr
 	obj = get_wmiobj_pointer(instance_id, DELL_WMI_BIOS_PASSOBJ_ATTRIBUTE_GUID);
 	if (!obj)
 		return -EIO;
-	if (obj->package.elements[IS_PASS_SET].type != ACPI_TYPE_INTEGER) {
+	if (obj->type != ACPI_TYPE_PACKAGE || obj->package.count < PO_MIN_ELEMENTS ||
+	    obj->package.elements[IS_PASS_SET].type != ACPI_TYPE_INTEGER) {
 		kfree(obj);
-		return -EINVAL;
+		return -EIO;
 	}
 	ret = snprintf(buf, PAGE_SIZE, "%lld\n", obj->package.elements[IS_PASS_SET].integer.value);
 	kfree(obj);
diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/string-attributes.c b/drivers/platform/x86/dell/dell-wmi-sysman/string-attributes.c
index c392f0ecf8b55..0d2c74f8d1aad 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/string-attributes.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/string-attributes.c
@@ -25,9 +25,10 @@ static ssize_t current_value_show(struct kobject *kobj, struct kobj_attribute *a
 	obj = get_wmiobj_pointer(instance_id, DELL_WMI_BIOS_STRING_ATTRIBUTE_GUID);
 	if (!obj)
 		return -EIO;
-	if (obj->package.elements[CURRENT_VAL].type != ACPI_TYPE_STRING) {
+	if (obj->type != ACPI_TYPE_PACKAGE || obj->package.count < STR_MIN_ELEMENTS ||
+	    obj->package.elements[CURRENT_VAL].type != ACPI_TYPE_STRING) {
 		kfree(obj);
-		return -EINVAL;
+		return -EIO;
 	}
 	ret = snprintf(buf, PAGE_SIZE, "%s\n", obj->package.elements[CURRENT_VAL].string.pointer);
 	kfree(obj);
diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
index 40ddc6eb75624..decb3b997d86a 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/sysman.c
@@ -408,10 +408,10 @@ static int init_bios_attributes(int attr_type, const char *guid)
 		return retval;
 
 	switch (attr_type) {
-	case ENUM:	min_elements = 8;	break;
-	case INT:	min_elements = 9;	break;
-	case STR:	min_elements = 8;	break;
-	case PO:	min_elements = 4;	break;
+	case ENUM:	min_elements = ENUM_MIN_ELEMENTS;	break;
+	case INT:	min_elements = INT_MIN_ELEMENTS;	break;
+	case STR:	min_elements = STR_MIN_ELEMENTS;	break;
+	case PO:	min_elements = PO_MIN_ELEMENTS;		break;
 	default:
 		pr_err("Error: Unknown attr_type: %d\n", attr_type);
 		return -EINVAL;
-- 
2.39.5



