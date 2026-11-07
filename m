Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063571;
	b=jlLN1/VQbvt44wjUcUxGcf+CnLF5CoCK1EmbI7efjOEVGVjukKT8LJk1vZfN0NJO7T2g
	 /a/L8Ze4EbW6Q8jbhBO6xtSpYtOZ8LCigQimhv9DmjR4pI3I2ZbJAVEwIuvLqjU7l3zYi
	 L+uro9BvRnxVxFSR12IpYlaxBNVMetMWDAS9tZBdkPWPCffF0Gltx4pEdMtDiSDG4hlw7
	 1lzGIZnDWwEhA3RLjfl81QSl+Ad+r1DGXZKkE8Nh1RMr3TgQB6C+1iQXQ2Z0OJFATyaYg
	 Qnhbaiz9pzeOwtkWeky/Ip4zYXEHtvgfrgtzwaIeBJJ89jtuhaK0A5J/wHpb9d1deWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nlbXFEPh29a+BTcrtybQO219IoQ2H14eOGSxjoy+n+Y=;
	b=cD85Abw0m/0wVS1bG4G6vuhoU7lGNV7kV0Gy5qCsnmEHT7VqtpWGipM+14tYbQ/oPWt4
	 kzXEMueiEnfemXADxNXGyOMsFU5cg5FCDQvLuGsOtNxKAAk5WulLbpuDkAeE4PoZ1GE4J
	 X3v/SXVW4rwvh6KN1l/UyficgievohUBNcgZFT3hD+xULaO5QjvD6HUHvKR0ZfuMUGe1V
	 8VcBnl6tK/av+7+wfle7ZZ2EBhnsBqX/apWyOml+ui2lEtEa3gQ4fZ+cSl9ZcFA0xeQIP
	 QQDFrAbvQUi0vc2cgkoCSX0d0z+u6gHNwWkHIkEKUCZYoPo51/7BN4o0TQtRaiOET7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Db8a6MIM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DECB60A260A;
	Sat,  7 Nov 2026 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Db8a6MIM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2671F008BE;
	Sat,  7 Nov 2026 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063571;
	bh=nlbXFEPh29a+BTcrtybQO219IoQ2H14eOGSxjoy+n+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Db8a6MIMMK6yXdzTIEyFgGmFH92ruXtKIetQeB/281YoY2e0KgR6ggjoiSW0docnT
	 0D3UYTI5crCiiT5kHmQLXWUTFQsRd9qcnIqrw+UzS6XcPn4OlG7/EHSpF/WXLDFRza
	 HE4qvxM2verErn+VPrmhFWn1Zxm3kb7BF6RMnrtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartu Alev <bartualev@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 702/869] platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming
Date: Sat,  7 Nov 2026 08:56:24 -0500
Message-ID: <20261107134916.744637500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Bartu Alev <bartualev@gmail.com>

[ Upstream commit 3d9a175707eeb15a2d577af1e669b98e0236719b ]

The fourth state flag of kbd_rgb_state_index is named "keyboard" and has
long been treated as having no effect.  In hardware the flag, BIT(7) of
the payload sent to the TUF RGB state device, gates whether the keyboard
backlight stays lit while the machine powers off: with the bit set the
keyboard lights up white during the ACPI S5 sequence, with the bit clear
the machine powers off dark.  Verified by A/B testing both values on a
TUF Gaming A15 (FA507NV).

Rename the fourth field and its index entry from "keyboard" to
"shutdown".  The write format is unchanged, the value is still
positional, and the diff is two variable names and one string, so it
backports cleanly.

Fixes: 61f64515299e ("platform/x86: asus-wmi: Implement TUF laptop keyboard power states")
Cc: stable@vger.kernel.org
Signed-off-by: Bartu Alev <bartualev@gmail.com>
Link: https://patch.msgid.link/20261010101601.888709-3-bartualev@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 486c12b232d14..c8cc47df9294e 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -998,10 +998,10 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	u32 flags, cmd, boot, awake, sleep, keyboard;
+	u32 flags, cmd, boot, awake, sleep, shutdown;
 	int err;
 
-	if (sscanf(buf, "%d %d %d %d %d", &cmd, &boot, &awake, &sleep, &keyboard) != 5)
+	if (sscanf(buf, "%d %d %d %d %d", &cmd, &boot, &awake, &sleep, &shutdown) != 5)
 		return -EINVAL;
 
 	if (cmd)
@@ -1014,7 +1014,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 		flags |= BIT(3);
 	if (sleep)
 		flags |= BIT(5);
-	if (keyboard)
+	if (shutdown)
 		flags |= BIT(7);
 
 	/* 0xbd is the required default arg0 for the method. Nothing happens otherwise */
@@ -1028,7 +1028,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 static DEVICE_ATTR_WO(kbd_rgb_state);
 
 static DEVICE_STRING_ATTR_RO(kbd_rgb_state_index, 0444,
-			     "cmd boot awake sleep keyboard");
+			     "cmd boot awake sleep shutdown");
 
 static struct attribute *kbd_rgb_state_attrs[] = {
 	&dev_attr_kbd_rgb_state.attr,
-- 
2.53.0



