Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059614;
	b=eq35P7r9IVA0ttUvlT/xuN9cggUFAEQ0j6mbH4E4SQnyfCwUfk885F5jLClLiNUo9khF
	 tmtCfP3k5phl5hSXxvnbIYaos2rP6JbAxNsnVjyUzidqQkzCBX2SHr+5XXY/qZPBoEcKl
	 LQsy6cFeS+tt2owqxyJPRQrE0QVthrVasoih6QtDuxoq3DTJ45xwsmYgjBprIq6Wjp68C
	 liZTJeSZrLqd72bWhSk3eH4pmdLs3wVybUfKwrpKc/EzyCdAEDDFCeAqYTz1wm+3hRXpp
	 2K9J1c1BMXIYvsRLaqZuBYuDonrpDPGDdkdIY0XpwAPnlGozJ/fbaMj1V88YH9yrViw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=N3jVc1W/+vdsiVN5zFXzvo6R/fHa54sUprrLjLUnhuA=;
	b=xZtGsLPInFk6zQzuwfi7LjssVurGuHoBpm10nPeJvos9vST1dRsd9iEHMDNWDOr4qG8S
	 RjhtbEjk6pU/XwMuzaQssgxp8GYzhNP2Zkd5qT7+sMWQcwtZGDagZy8VL4lMSXB0PMvqO
	 9YPixLYkmoQDZE2yHM6Ngguryi6gOqF4+NUqrN7UO73Ef9kCF3NJBs2f9vU17LBLbQhqo
	 LpL5uYMEs60JG5SqkZOTzn/cpB/WTssrykHDptaQ40rr45OSKR9NqUOGcZmfFsROn0SNF
	 ZHMBzl2oTjirQBfR0qbpWO6djrPhYxK14f1Mq7pwklZN1J4RTRalDJxw0Bvc8vG+/Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IrGbYv6z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FEB60A2635;
	Thu, 19 Nov 2026 03:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IrGbYv6z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA481F000C7;
	Thu, 19 Nov 2026 03:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059614;
	bh=N3jVc1W/+vdsiVN5zFXzvo6R/fHa54sUprrLjLUnhuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrGbYv6zRRwissj+VAflmYG3aObdF3at+KSMYWAk9dC/Holdtq+J3hz1B93PwQK+y
	 LGiBB00mKYK1lgGCZUjmanL87xyFOzt+zuD71fNEkoNbc+7t404f7Ir0H6UNORfate
	 G4lu4/D1Ts8H3FB/m4rDg8xgYzA2Ct+ddSw8Y9x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Scardovi <scardracs@disroot.org>,
	Denis Benato <denis.benato@linux.dev>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0887/1848] platform/x86: asus-wmi: Serialize WMI method evaluations with a mutex
Date: Wed, 18 Nov 2026 15:48:45 +0100
Message-ID: <20261118145953.636694898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced the guard(mutex) wrapper with explicit mutex_lock() and mutex_unlock() calls at existing call sites ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 4f56f853b756b..9256d6edca5b4 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -15,6 +15,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -236,6 +237,12 @@ struct asus_wmi {
 
 /* WMI ************************************************************************/
 
+/*
+ * Concurrent evaluations of ASUS WMI methods can re-enter firmware
+ * SMI/EC mailbox handling and corrupt the mailbox.
+ */
+static DEFINE_MUTEX(asus_wmi_eval_lock);
+
 static int asus_wmi_evaluate_method3(u32 method_id,
 		u32 arg0, u32 arg1, u32 arg2, u32 *retval)
 {
@@ -250,8 +257,10 @@ static int asus_wmi_evaluate_method3(u32 method_id,
 	union acpi_object *obj;
 	u32 tmp = 0;
 
+	mutex_lock(&asus_wmi_eval_lock);
 	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 0, method_id,
 				     &input, &output);
+	mutex_unlock(&asus_wmi_eval_lock);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -2605,9 +2614,11 @@ static int show_call(struct seq_file *m, void *data)
 	union acpi_object *obj;
 	acpi_status status;
 
+	mutex_lock(&asus_wmi_eval_lock);
 	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
 				     0, asus->debug.method_id,
 				     &input, &output);
+	mutex_unlock(&asus_wmi_eval_lock);
 
 	if (ACPI_FAILURE(status))
 		return -EIO;
-- 
2.53.0



