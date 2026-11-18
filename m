Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046913;
	b=mCtv+xOL79gCyYggyXXww0+7Ob/bQwlNO2Qbq2I/ocKgZrpp1rAP5ce2KkmbWhLnVlIU
	 02i8QsLl9gaab4ZFytrer7UOUksehoVgUNTRg+QhUJO9mbRJUTmzFV1aQlleLLCx1vSOC
	 kTr7Kx9aF3wnX6+YnuCSYOTFlo1foEfDo77E8vixfPSLDs5CH6l44gylYxPPa0Xhefmqh
	 Mued1yj1HAQh0UrmQHEJCGazmqL2FRls0ebxUSnVNuIxXcyIbl8Lo7/SMJTTvo0u5JoG7
	 qtfhlNiB10u1530QFMN0mgbO9D5tbPiAOXx64F/dWTSVyALw/YoFQPb9Ot7kFLzarCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3/jCRoCVxOr3QcNXi4Wz92Cdkm1lzyaV5Wroj+u80KE=;
	b=LYChObk0jMWrngivxS9i0jpmp3EfLYT1Krg0O7xMaiCRX8Z66hMQUulGm+3c2y4uj9kl
	 oBWtRkaJ3VXA0EejyL+VOyyXvLX+XCTCaBtbuHahcfwfTBRNTCDR6CBnG0uJtWbBGIIBD
	 k47Xx3jAWnJ66uJSheLFdg03AB/1nQU2OwY4akvuNH1nDkCR0YLiC0Jg5/wZdRTaqlXli
	 rahre7xx8OSbHe3I4XTFRfigN9dHrHNrf9MGrsBVqXEfTyE4A5N1gcw3txuKpAOFts/T9
	 xC0wC+u3NrZMNosg4MUDBKrVWXSqWMW8E1q4Ym6mKBn12Qa+MUPwIAYBZlSwWdfVRzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wBjRMxbx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2506A606A31C;
	Thu, 19 Nov 2026 00:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wBjRMxbx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448251F000C4;
	Thu, 19 Nov 2026 00:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046912;
	bh=3/jCRoCVxOr3QcNXi4Wz92Cdkm1lzyaV5Wroj+u80KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBjRMxbxrHLTTXE8s8uawPFKT7ZR2UqXinaNdJK1CUzjYsuDQ4HNj4fOZ5dGtVvD3
	 7NH7PKnbd+vuzlvbg1DgF9GwMb2ZLwgzPOLynLF3jH8TOd9YEw8H65wX6ulAn6NEI3
	 XBSMBimvwsE+KEs8uHut9x5meJO9GfbgAE+AtiI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	Denis Benato <denis.benato@linux.dev>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1450/2857] platform/x86: asus-wmi: Serialize WMI method evaluations with a mutex
Date: Wed, 18 Nov 2026 15:41:24 +0100
Message-ID: <20261118150253.520273616@linuxfoundation.org>
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
[ sashal: adjusted context for differing includes and WMI evaluation helpers without debug logging ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 8814b258caa55..e1ea260046c3c 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -15,6 +15,7 @@
 
 #include <linux/acpi.h>
 #include <linux/backlight.h>
+#include <linux/cleanup.h>
 #include <linux/debugfs.h>
 #include <linux/dmi.h>
 #include <linux/fb.h>
@@ -26,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/leds.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include <linux/platform_data/x86/asus-wmi.h>
@@ -274,6 +276,20 @@ struct asus_wmi {
 
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
@@ -288,8 +304,7 @@ static int asus_wmi_evaluate_method3(u32 method_id,
 	union acpi_object *obj;
 	u32 tmp = 0;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 0, method_id,
-				     &input, &output);
+	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -331,8 +346,7 @@ static int asus_wmi_evaluate_method5(u32 method_id,
 	union acpi_object *obj;
 	u32 tmp = 0;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 0, method_id,
-				     &input, &output);
+	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -370,8 +384,7 @@ static int asus_wmi_evaluate_method_buf(u32 method_id,
 	union acpi_object *obj;
 	int err = 0;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 0, method_id,
-				     &input, &output);
+	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -3660,9 +3673,8 @@ static int show_call(struct seq_file *m, void *data)
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



