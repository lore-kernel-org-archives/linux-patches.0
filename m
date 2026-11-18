Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038321;
	b=RD8rbws8edegTmDITznV6fToc/GRxD8Nnax5D8gSnwUhkXjLtCQ8Uz20PaSolZMjRffB
	 gMIRqsxWdaDN2msK41jx8qtJMagzWZbNWzVggYLqtJIbCd23xWHgYbYK2Uid21yPgbd8i
	 ytbqjgh+lPXlWvNTtR9sKfx1yHrHeQ4vSGkiXPOLVAUq/v9mlbKw3pVbJyuZzXyCn94It
	 /al8RRErs0leS7t0TjTMcU+l5cNbsRFWGXfimRlidn+Ph1ALYfUDFvEhNKTGPm7ERe1lP
	 vqkV/S9NM0iOPjtS4XQAIZSP/C1KQ+tkhSt4OTE6fNHUv+nXd3ldT9gNvOXLg7rQFgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5C8Ap5ME2nW94ifVzXtls7fLx3l1/gFuT3qMSPnfH2Q=;
	b=Orf5uatO/UzfYfbq8wWikPs4G6ZB1oSDJI64a6eAsNhmQtnJDXKPwZl/bYxbCE4tv8qQ
	 I6vA2rW+ts5V8S7eP4sRQI01Yrtwrtg+ho+9QAkXHuB5thmQ5XPIp024L5cqIzIYbr8Rt
	 MfAPrMgv/xuNCzQYytGjwN84wSm4hg+N1vBJZxWVSiXxOjm7M3NSYsxNtHyeQeE6sH+fR
	 TsKQvkgmJComBNG88TR1JM6Ejt5zuqgrvtPvzPla5TDADgkJTP0fUytg171Bm5GoXpxsx
	 qvRo0FwDOHyo/niQZtg+bEdzRIH9AgfWtOH7xtG7kl+STGsgX4QXtUh2eXD9rDvBnHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bjP+qM4Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D430606A32A;
	Wed, 18 Nov 2026 21:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bjP+qM4Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8791C1F000C4;
	Wed, 18 Nov 2026 21:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038321;
	bh=5C8Ap5ME2nW94ifVzXtls7fLx3l1/gFuT3qMSPnfH2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjP+qM4ZJ0c32wLTQUUjoQuDfeOVy2eaU80Kd8O0MoVY0N5APCvl4GXgrTC6im3ny
	 HNeBMqxvB2ePXUGuLlMFxqOxcY6qZmLyzKFz615R6KhEhflqu2sSeYX9nOapZtexmp
	 K+tWc544b0qIYV7KMfPUPT2XD5gxPq5OdQaUpDm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	Denis Benato <denis.benato@linux.dev>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1704/3318] platform/x86: asus-wmi: Serialize WMI method evaluations with a mutex
Date: Wed, 18 Nov 2026 15:38:46 +0100
Message-ID: <20261118150412.973999288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Scardovi <scardracs@disroot.org>

[ Upstream commit b9428edaf4109e86a97254228d831767d0acc1f8 ]

Concurrent evaluations of ASUS WMI management methods (from ACPI notify,
HID, userspace daemons, and debugfs) enter the BIOS ACPI/SMM interface
simultaneously, triggering re-entrant SMIs or EC mailbox buffer corruption.

Fix this at the root by introducing a centralized evaluation helper
(asus_wmi_evaluate_method_locked()) protected by a global mutex
(asus_wmi_eval_lock) using guard(mutex). Route all evaluations of
ASUS_WMI_MGMT_GUID (method3, method5, method_buf, and show_call) through
this helper.

A static mutex is required because asus_wmi_evaluate_method() is an
exported symbol used by external modules (such as hid-asus and
asus-armoury) that lack access to struct asus_wmi drvdata, and the
underlying ASUS ACPI/EC management method is a single physical platform
resource.

The mutex is non-recursive: nested ACPI/WMI notify handlers must not call
back into evaluate on the same task (defer via workqueue, as
asus_rfkill_notify already does).

The sysfs-versus-notify race predates the later export of
asus_wmi_evaluate_method(), so Fixes points at the original shared
evaluate helper rather than that export.

Link: https://github.com/OpenGamingCollective/asusctl/issues/328
Fixes: d33da3b68669 ("asus-wmi: factorise wmi_evaluate_method call")
Cc: stable@vger.kernel.org
Signed-off-by: Marco Scardovi <scardracs@disroot.org>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/b6a1981777e63f0c28bd719d8203ebbda57d6957.1789722252.git.scardracs@disroot.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: adjusted patch context for missing debug logging and different header includes ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index a76d43ca647d4..d83d3f4a56aab 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -15,6 +15,7 @@
 
 #include <linux/acpi.h>
 #include <linux/backlight.h>
+#include <linux/cleanup.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
@@ -27,6 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/leds.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include <linux/platform_data/x86/asus-wmi.h>
@@ -316,6 +318,20 @@ struct asus_wmi {
 
 /* WMI ************************************************************************/
 
+/*
+ * Concurrent evaluations of ASUS WMI methods can re-enter firmware
+ * SMI/EC mailbox handling and corrupt the mailbox.
+ */
+static DEFINE_MUTEX(asus_wmi_eval_lock);
+
+static acpi_status asus_wmi_evaluate_method_locked(u32 method_id,
+						   struct acpi_buffer *input,
+						   struct acpi_buffer *output)
+{
+	guard(mutex)(&asus_wmi_eval_lock);
+	return wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 0, method_id, input, output);
+}
+
 static int asus_wmi_evaluate_method3(u32 method_id,
 		u32 arg0, u32 arg1, u32 arg2, u32 *retval)
 {
@@ -330,8 +346,7 @@ static int asus_wmi_evaluate_method3(u32 method_id,
 	union acpi_object *obj;
 	u32 tmp = 0;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 0, method_id,
-				     &input, &output);
+	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -373,8 +388,7 @@ static int asus_wmi_evaluate_method5(u32 method_id,
 	union acpi_object *obj;
 	u32 tmp = 0;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 0, method_id,
-				     &input, &output);
+	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -412,8 +426,7 @@ static int asus_wmi_evaluate_method_buf(u32 method_id,
 	union acpi_object *obj;
 	int err = 0;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 0, method_id,
-				     &input, &output);
+	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -4260,9 +4273,8 @@ static int show_call(struct seq_file *m, void *data)
 	union acpi_object *obj;
 	acpi_status status;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
-				     0, asus->debug.method_id,
-				     &input, &output);
+	status = asus_wmi_evaluate_method_locked(asus->debug.method_id,
+						 &input, &output);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
-- 
2.53.0



