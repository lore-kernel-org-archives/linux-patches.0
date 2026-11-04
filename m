Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831232;
	b=ccxUcPfwQGTjW7WtqkyUak2gg2m0l09Dp+bdGWedjT1oDrwSCRGWg7eXe5NMmqr1tLAi
	 WMPQU9A+PjMboHR9I3STsBDynZ+dsx0nFaQmQUG/zUj+99kroPZ1CoTaJCLgVkChvqHwh
	 cjbY4rRzkOdzKFI4jcKXbMudzOkVJzJErjqORRxkNrxhyadFwePeOfaJ3eCi6C7WjeUVi
	 jfBWLc3n6M+O2QmXThBIhF5JlDtQcO40/6myQnCuR3uoZoAqfGcM8uej+rZ6gGD9OCaoE
	 YiYFgqlChxgkk2QKwRbPzaHY0JZyoZkU++/b1QlfqK83PjmdLQPH4JMPu3BRZ1v59Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oZu5gtvXIxSCkvpGiQgJYG0DJkCiij1WICFBMofiu+4=;
	b=1gu+lCghXd4s0bSSgRjykScV5is2N7//z5PdlnRjopKxLa0vKrv3UnhuVOrztBv5WBjk
	 a6JY1UfWukO0xBofmYumhVvz+pxJo8F1wgqHvzkHG3GXS4i9OXYYlD+Pf3o/ML0kZquYh
	 OprLOu9eUzS2WOsIiqYIE/698GKd1MtTzTiDkizdaZ9PFR5tuYOv28sTYF8c4m52L0CJ6
	 EQeKClK9jSuuTWJZsD6Xd6t30/hxMuof3TboDChJMr1I4ISo1GQ8z/dx+l+a5fDJcjvoi
	 kwBKuQGQ+YdLH9b1eFyKbbBYWU6W1OAvr9aVZiabikSELwAA8nPVI3x3emiCd7PseBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8aTZVBA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A07F606AB32;
	Wed,  4 Nov 2026 22:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8aTZVBA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB43D1F000C1;
	Wed,  4 Nov 2026 22:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831232;
	bh=oZu5gtvXIxSCkvpGiQgJYG0DJkCiij1WICFBMofiu+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8aTZVBAzuCOrfvy1L9aGjJaop7/cIdFpuosH0bPxdSQRUCaUT8jwUNXy9/Ee9r4l
	 DouhaxDf9GMBlTI0XRmsN+Eg9VwfMs+TtWmIb7JWvgirdhhJw2vrLHaMFSzIxKZFM5
	 4F5OIowEGn+/rdpbbgIxYbnhK+EI4Y/ZAtk2TV8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0578/1005] hwmon: (asus_rog_ryujin) Rely on subsystem locking
Date: Wed,  4 Nov 2026 16:05:11 -0500
Message-ID: <20261104211100.053187566@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b4306c0c8e24f9e031185fb87de45391bc8c7fe9 ]

Attribute access is now serialized in the hardware monitoring core,
so locking in the driver code is no longer necessary. Drop it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 8042312e73c5 ("hwmon: (asus_rog_ryujin) Validate HID report lengths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus_rog_ryujin.c | 48 +++++++--------------------------
 1 file changed, 9 insertions(+), 39 deletions(-)

diff --git a/drivers/hwmon/asus_rog_ryujin.c b/drivers/hwmon/asus_rog_ryujin.c
index e5e93a20723c4..10a1f5aca988d 100644
--- a/drivers/hwmon/asus_rog_ryujin.c
+++ b/drivers/hwmon/asus_rog_ryujin.c
@@ -81,10 +81,6 @@ static const char *const rog_ryujin_speed_label[] = {
 struct rog_ryujin_data {
 	struct hid_device *hdev;
 	struct device *hwmon_dev;
-	/* For locking access to buffer */
-	struct mutex buffer_lock;
-	/* For queueing multiple readers */
-	struct mutex status_report_request_mutex;
 	/* For reinitializing the completions below */
 	spinlock_t status_report_request_lock;
 	struct completion cooler_status_received;
@@ -153,18 +149,10 @@ static umode_t rog_ryujin_is_visible(const void *data,
 /* Writes the command to the device with the rest of the report filled with zeroes */
 static int rog_ryujin_write_expanded(struct rog_ryujin_data *priv, const u8 *cmd, int cmd_length)
 {
-	int ret;
-
-	mutex_lock(&priv->buffer_lock);
-
 	memcpy_and_pad(priv->buffer, MAX_REPORT_LENGTH, cmd, cmd_length, 0x00);
-	ret = hid_hw_output_report(priv->hdev, priv->buffer, MAX_REPORT_LENGTH);
-
-	mutex_unlock(&priv->buffer_lock);
-	return ret;
+	return hid_hw_output_report(priv->hdev, priv->buffer, MAX_REPORT_LENGTH);
 }
 
-/* Assumes priv->status_report_request_mutex is locked */
 static int rog_ryujin_execute_cmd(struct rog_ryujin_data *priv, const u8 *cmd, int cmd_length,
 				  struct completion *status_completion)
 {
@@ -196,14 +184,11 @@ static int rog_ryujin_execute_cmd(struct rog_ryujin_data *priv, const u8 *cmd, i
 
 static int rog_ryujin_get_status(struct rog_ryujin_data *priv)
 {
-	int ret = mutex_lock_interruptible(&priv->status_report_request_mutex);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	if (!time_after(jiffies, priv->updated + msecs_to_jiffies(STATUS_VALIDITY))) {
 		/* Data is up to date */
-		goto unlock_and_return;
+		return 0;
 	}
 
 	/* Retrieve cooler status */
@@ -211,36 +196,30 @@ static int rog_ryujin_get_status(struct rog_ryujin_data *priv)
 	    rog_ryujin_execute_cmd(priv, get_cooler_status_cmd, GET_CMD_LENGTH,
 				   &priv->cooler_status_received);
 	if (ret < 0)
-		goto unlock_and_return;
+		return ret;
 
 	/* Retrieve controller status (speeds) */
 	ret =
 	    rog_ryujin_execute_cmd(priv, get_controller_speed_cmd, GET_CMD_LENGTH,
 				   &priv->controller_status_received);
 	if (ret < 0)
-		goto unlock_and_return;
+		return ret;
 
 	/* Retrieve cooler duty */
 	ret =
 	    rog_ryujin_execute_cmd(priv, get_cooler_duty_cmd, GET_CMD_LENGTH,
 				   &priv->cooler_duty_received);
 	if (ret < 0)
-		goto unlock_and_return;
+		return ret;
 
 	/* Retrieve controller duty */
 	ret =
 	    rog_ryujin_execute_cmd(priv, get_controller_duty_cmd, GET_CMD_LENGTH,
 				   &priv->controller_duty_received);
-	if (ret < 0)
-		goto unlock_and_return;
-
-	priv->updated = jiffies;
-
-unlock_and_return:
-	mutex_unlock(&priv->status_report_request_mutex);
 	if (ret < 0)
 		return ret;
 
+	priv->updated = jiffies;
 	return 0;
 }
 
@@ -303,14 +282,11 @@ static int rog_ryujin_write_fixed_duty(struct rog_ryujin_data *priv, int channel
 		 * Retrieve cooler duty since both pump and internal fan are set
 		 * together, then write back with one of them modified.
 		 */
-		ret = mutex_lock_interruptible(&priv->status_report_request_mutex);
-		if (ret < 0)
-			return ret;
 		ret =
 		    rog_ryujin_execute_cmd(priv, get_cooler_duty_cmd, GET_CMD_LENGTH,
 					   &priv->cooler_duty_received);
 		if (ret < 0)
-			goto unlock_and_return;
+			return ret;
 
 		memcpy(set_cmd, set_cooler_duty_cmd, SET_CMD_LENGTH);
 
@@ -329,11 +305,7 @@ static int rog_ryujin_write_fixed_duty(struct rog_ryujin_data *priv, int channel
 			set_cmd[RYUJIN_SET_COOLER_FAN_DUTY_OFFSET] = val;
 		}
 
-		ret = rog_ryujin_execute_cmd(priv, set_cmd, SET_CMD_LENGTH, &priv->cooler_duty_set);
-unlock_and_return:
-		mutex_unlock(&priv->status_report_request_mutex);
-		if (ret < 0)
-			return ret;
+		return rog_ryujin_execute_cmd(priv, set_cmd, SET_CMD_LENGTH, &priv->cooler_duty_set);
 	} else {
 		/*
 		 * Controller fan duty (channel == 2). No need to retrieve current
@@ -538,8 +510,6 @@ static int rog_ryujin_probe(struct hid_device *hdev, const struct hid_device_id
 		goto fail_and_close;
 	}
 
-	mutex_init(&priv->status_report_request_mutex);
-	mutex_init(&priv->buffer_lock);
 	spin_lock_init(&priv->status_report_request_lock);
 	init_completion(&priv->cooler_status_received);
 	init_completion(&priv->controller_status_received);
-- 
2.53.0



