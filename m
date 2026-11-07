Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064679;
	b=GyP1K2PHaCTtZV5v/sm3gwJKUpdgqa2krt4idsYWmo7RRAYwcXkCOn7n1Z23ehOPYinh
	 S6uQwNZP2nJvjP0BE8qdGcF74Zpx0rnVCOpZXThlzXokyZzQiJi5Mu/0ELRR3awPj+HqP
	 7W2MDmkajL0F8vHnDjpKYZYWi+GY3dzunULhDqM2U6Vus/PjtpERRRvTp6ue6L3DdgiYW
	 hhgiOgIZ8xOHPp+2tRnAH7I7s3TgACIpaO4pkqMMhT2vqtBTTFHFVf+PsHkucwPLl/qhl
	 hjN4jLIyHXcsD/9d2ktTrSf+9LqNRKyZ2FDOaC77CUtoIta0hk6KPnstvrBqA6QWyLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dOz0L1PqbUYMprle8GnQiX9kdMFocAUbBwk/uQmw/AI=;
	b=00YfnNA8g5Y8QYcZFBjgK8Iue0Ru6V+k7YeIaZ/Me7G1tbNG0b9J136/74yLkph6uB0d
	 sGvGHfhft8jNSDohnLpGgVRR5cjFXhCDGebvemM0ploB9IubgLnVFBm6I+QZRTskT2kx2
	 feD9tHQ2w6PBam1DPJnRG8gbrsRHGyTfFm1jH83ssDvBVAxXv2RXH8/kQnYXf6JZVy8+S
	 JHLn/dIZBYCPi+wk0lBuJD5x6EVSmnGP9PQug5VDbxPId4HHyPdXs80nH4CV4rthB1vTa
	 esO3pqZJKYs3OAK4YNgdQ8jIUhNrwXArfsQYyfyaAFEHtwFMVBO1jPGvh0vR7tqpsMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EK5dWz4u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE50606A32C;
	Sat,  7 Nov 2026 15:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EK5dWz4u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69F81F008A2;
	Sat,  7 Nov 2026 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064679;
	bh=dOz0L1PqbUYMprle8GnQiX9kdMFocAUbBwk/uQmw/AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EK5dWz4uGUtKwmur2OHtNsK+23zGKPcQl1sz/ajXBv2Ma3i8tewrF+VHq+lmEJOV3
	 GmhUzxkMHZ2KmuXMHMX+rR0VmjQPLbIYe7PLnDsshv1aMMbvTcxee1/+jy5W5amKr2
	 WkRO90HRWHzhK6MevdjS6GLuNYItdgsY61mS5Oqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	Denis Benato <denis.benato@linux.dev>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0675/1257] platform/x86: asus-wmi: Serialize WMI method evaluations with a mutex
Date: Sat,  7 Nov 2026 08:49:31 -0500
Message-ID: <20261107134957.904326359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 3cc0b96baeb34..84859646d7acd 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -16,6 +16,7 @@
 #include <linux/acpi.h>
 #include <linux/backlight.h>
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
@@ -28,6 +29,7 @@
 #include <linux/leds.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include <linux/platform_data/x86/asus-wmi.h>
@@ -353,6 +355,20 @@ static void asus_wmi_show_deprecated(void)
 
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
@@ -367,8 +383,7 @@ static int asus_wmi_evaluate_method3(u32 method_id,
 	union acpi_object *obj;
 	u32 tmp = 0;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 0, method_id,
-				     &input, &output);
+	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
 
 	pr_debug("%s called (0x%08x) with args: 0x%08x, 0x%08x, 0x%08x\n",
 		__func__, method_id, arg0, arg1, arg2);
@@ -419,8 +434,7 @@ static int asus_wmi_evaluate_method5(u32 method_id,
 	union acpi_object *obj;
 	u32 tmp = 0;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 0, method_id,
-				     &input, &output);
+	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
 
 	pr_debug("%s called (0x%08x) with args: 0x%08x, 0x%08x, 0x%08x, 0x%08x, 0x%08x\n",
 		__func__, method_id, arg0, arg1, arg2, arg3, arg4);
@@ -467,8 +481,7 @@ static int asus_wmi_evaluate_method_buf(u32 method_id,
 	union acpi_object *obj;
 	int err = 0;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 0, method_id,
-				     &input, &output);
+	status = asus_wmi_evaluate_method_locked(method_id, &input, &output);
 
 	pr_debug("%s called (0x%08x) with args: 0x%08x, 0x%08x\n",
 		__func__, method_id, arg0, arg1);
@@ -5052,9 +5065,8 @@ static int show_call(struct seq_file *m, void *data)
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



