Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829683;
	b=i4IQKy4kimvDbKzqh3lHN3uUCjmGAg9TAOv1iix1gGSlRrinzkeCuNOM+ANuAxiLChvM
	 wcmFMVduHxAxtGsgIbbaqVKG2SA4dzHKNPnGhDpBDDNU6zVxXBDSki/oztsAnmafS6TBb
	 2lviF83jkZe/WHtXEMs6V0kdCT5pl/ugVkQqf7Ex9oYzFiqGgAN7kbLPSRLyPEeEZxhAK
	 hKatkXfUT1fNjfrV+D2XBzPFvbl5jZohWY7VXdAlqSJs7jmMN4TP+upfDr8BVAmTA3v3F
	 wP2bEomb76rKT6yhecCt2mo5YxsypaeCItj78VQEGa1Cmd4kQJ8B2vG/jhyxopFTgpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+hGkb598rogNG1289OXy6UACol8IF7fyoX+icDPOuvo=;
	b=l6SCgQNgiSos2/TdUiOemzCYDB0zq+SlouycfibVdFYdvGn7w0zJTGY0H1PVRzzXMWq3
	 H0oxwjy7irt2U654d8obKotR1MV2APHyAY+W7W/FWwVfHtcz7B/Dhd1AJyAlB11MaeJfP
	 qX2Y4UHgr+kLyJxbHI7ghkB7sIv4w+dkwodig5w3Wwbichok7IORJPFwrIwhGNmtcFPqc
	 f391tFU05QxIffWT0Y7byKq5G+LlavmufA0yOf3n7NmZ8PCabg9mFzZPt/zEZI9UloxQH
	 +s9EyRQasy8Ke26Sl36qLb/O6JfkuWP24A2KoIYZzydHgfWPZktzcd/pwf9UPTO4DMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CjIHnRLC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB38B606EE91;
	Wed,  4 Nov 2026 22:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CjIHnRLC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E051F000C1;
	Wed,  4 Nov 2026 22:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829682;
	bh=+hGkb598rogNG1289OXy6UACol8IF7fyoX+icDPOuvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjIHnRLCI5SLnyxUp71MLqibw23M190Zm9Krgw7XQ1JoQtPhJCbzQt7z5p47rdz1U
	 wPKR7mm20knk+kneaWU8PIvTFjPXCMnp02N6W47PP1xP0GzFlkbFIyDQpYeN2E5wJp
	 upfdSS0LJznMi7xi6BOFLDuHzKTD9bhrAEm6Jm6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0278/1005] platform/x86: dell-smbios-wmi: Fix chardev resource management
Date: Wed,  4 Nov 2026 16:00:11 -0500
Message-ID: <20261104211051.679284046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 41427211f663c6eb36986ca2ea68d7e87aac52e9 ]

When unbinding the WMI driver while a userspace application has
an open file descriptor for the character device, a UAF occurs:

KASAN: slab-use-after-free in _copy_to_user from platform/x86/dell-smbios-wmi

The reason for this is that even after calling misc_deregister(),
userspace appications can still call read() and/or ioctl() on open
file descriptors associated with the already unregistered character
device. This causes a UAF by attempting to access the already freed
state container of the WMI driver.

Fix this by no longer storing the state container inside
filp->private_data. Instead retrieve the state container using
get_first_smbios_priv() and return -ENODEV if the state container
does not exist anymore.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/178144969601.60470.13396800403157907003@gmail.com/
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260720131921.368000-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-smbios-wmi.c | 67 +++++++++++----------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-smbios-wmi.c b/drivers/platform/x86/dell/dell-smbios-wmi.c
index a7dca8c59d602..0729c5a1945c7 100644
--- a/drivers/platform/x86/dell/dell-smbios-wmi.c
+++ b/drivers/platform/x86/dell/dell-smbios-wmi.c
@@ -6,6 +6,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/dmi.h>
 #include <linux/fs.h>
@@ -13,14 +14,13 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/uaccess.h>
 #include <linux/wmi.h>
 #include <uapi/linux/wmi.h>
 #include "dell-smbios.h"
 #include "dell-wmi-descriptor.h"
 
-static DEFINE_MUTEX(call_mutex);
-static DEFINE_MUTEX(list_mutex);
 static int wmi_supported;
 
 struct misc_bios_flags_structure {
@@ -32,6 +32,7 @@ struct misc_bios_flags_structure {
 #define DELL_WMI_SMBIOS_GUID "A80593CE-A997-11DA-B012-B622A1EF5492"
 
 struct wmi_smbios_priv {
+	struct mutex call_lock; /* Protects the content of the SMBIOS buffer */
 	struct dell_wmi_smbios_buffer *buf;
 	struct list_head list;
 	struct wmi_device *wdev;
@@ -39,6 +40,8 @@ struct wmi_smbios_priv {
 	u64 req_buf_size;
 	struct miscdevice char_dev;
 };
+
+static DECLARE_RWSEM(list_lock);	/* Protects access to wmi_list */
 static LIST_HEAD(wmi_list);
 
 static inline struct wmi_smbios_priv *get_first_smbios_priv(void)
@@ -93,40 +96,35 @@ static int dell_smbios_wmi_call(struct calling_interface_buffer *buffer)
 	size_t size;
 	int ret;
 
-	mutex_lock(&call_mutex);
+	guard(rwsem_read)(&list_lock);
+
 	priv = get_first_smbios_priv();
-	if (!priv) {
-		ret = -ENODEV;
-		goto out_wmi_call;
-	}
+	if (!priv)
+		return -ENODEV;
 
 	size = sizeof(struct calling_interface_buffer);
 	difference = priv->req_buf_size - sizeof(u64) - size;
 
+	guard(mutex)(&priv->call_lock);
+
 	memset(&priv->buf->ext, 0, difference);
 	memcpy(&priv->buf->std, buffer, size);
 	ret = run_smbios_call(priv->wdev);
 	memcpy(buffer, &priv->buf->std, size);
-out_wmi_call:
-	mutex_unlock(&call_mutex);
 
 	return ret;
 }
 
-static int dell_smbios_wmi_open(struct inode *inode, struct file *filp)
+static ssize_t dell_smbios_wmi_read(struct file *filp, char __user *buffer, size_t length,
+				    loff_t *offset)
 {
 	struct wmi_smbios_priv *priv;
 
-	priv = container_of(filp->private_data, struct wmi_smbios_priv, char_dev);
-	filp->private_data = priv;
+	guard(rwsem_read)(&list_lock);
 
-	return nonseekable_open(inode, filp);
-}
-
-static ssize_t dell_smbios_wmi_read(struct file *filp, char __user *buffer, size_t length,
-				    loff_t *offset)
-{
-	struct wmi_smbios_priv *priv = filp->private_data;
+	priv = get_first_smbios_priv();
+	if (!priv)
+		return -ENODEV;
 
 	return simple_read_from_buffer(buffer, length, offset, &priv->req_buf_size,
 				       sizeof(priv->req_buf_size));
@@ -173,22 +171,24 @@ static long dell_smbios_wmi_do_ioctl(struct wmi_smbios_priv *priv,
 static long dell_smbios_wmi_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct dell_wmi_smbios_buffer __user *input = (struct dell_wmi_smbios_buffer __user *)arg;
-	struct wmi_smbios_priv *priv = filp->private_data;
-	long ret;
+	struct wmi_smbios_priv *priv;
 
 	if (cmd != DELL_WMI_SMBIOS_CMD)
 		return -ENOIOCTLCMD;
 
-	mutex_lock(&call_mutex);
-	ret = dell_smbios_wmi_do_ioctl(priv, input);
-	mutex_unlock(&call_mutex);
+	guard(rwsem_read)(&list_lock);
 
-	return ret;
+	priv = get_first_smbios_priv();
+	if (!priv)
+		return -ENODEV;
+
+	guard(mutex)(&priv->call_lock);
+
+	return dell_smbios_wmi_do_ioctl(priv, input);
 }
 
 static const struct file_operations dell_smbios_wmi_fops = {
 	.owner		= THIS_MODULE,
-	.open		= dell_smbios_wmi_open,
 	.read		= dell_smbios_wmi_read,
 	.unlocked_ioctl	= dell_smbios_wmi_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
@@ -260,6 +260,10 @@ static int dell_smbios_wmi_probe(struct wmi_device *wdev, const void *context)
 	if (!priv->buf)
 		return -ENOMEM;
 
+	ret = devm_mutex_init(&wdev->dev, &priv->call_lock);
+	if (ret)
+		return ret;
+
 	ret = dell_smbios_wmi_register_chardev(priv);
 	if (ret)
 		return ret;
@@ -268,9 +272,8 @@ static int dell_smbios_wmi_probe(struct wmi_device *wdev, const void *context)
 	if (ret)
 		return ret;
 
-	mutex_lock(&list_mutex);
+	guard(rwsem_write)(&list_lock);
 	list_add_tail(&priv->list, &wmi_list);
-	mutex_unlock(&list_mutex);
 
 	return 0;
 }
@@ -279,12 +282,10 @@ static void dell_smbios_wmi_remove(struct wmi_device *wdev)
 {
 	struct wmi_smbios_priv *priv = dev_get_drvdata(&wdev->dev);
 
-	mutex_lock(&call_mutex);
-	mutex_lock(&list_mutex);
-	list_del(&priv->list);
-	mutex_unlock(&list_mutex);
 	dell_smbios_unregister_device(&wdev->dev);
-	mutex_unlock(&call_mutex);
+
+	guard(rwsem_write)(&list_lock);
+	list_del(&priv->list);
 }
 
 static const struct wmi_device_id dell_smbios_wmi_id_table[] = {
-- 
2.53.0



