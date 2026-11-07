Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062540;
	b=FpakzBrQo0H1rgKURdzE/68wYvq2hzaWRwWKwk1Gd2dsYp+A9X5kfhIV+83+ZUyoaUlb
	 55RJTK5vbWRoTnDHhoBLau5z9jTczemAQa5/I9XfRbTXv+KBeAiRsGJENAHeMl1kAzTtn
	 rAK7W13K9hSxh34M0U4vByu0rKTbCkQyfsvnSFHReVUFgPszIQLiS7tpBY2ocPbSm5A+M
	 feB1mI1hfe7WqR65cI2rA+2Jd89M1qDZEhEHLD8xrtVE+veC3djfcdrY5j0hJVJ+BXP6w
	 rqoKS1hyR5uIcQlkSLZIH11ndE4NxWvapTXRPpdEbTjHPxGI6EYpr9MVKbFbvaZT3Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HcNxN24e2gwI2ru/fPWwUpVd6wvoB5Zd9WXvCIM86UY=;
	b=h8wb6qhDIaAbZ/nKtVfjpL+o6gQ+kVlRPxhOOv4LgqUeZKCa/NKJ3/UyV83rPn2ucKBV
	 IvCLb0BoB4uqVwosaYGWN9+AZdscW1nCltlICbUpjO+cLxiRbJH8TfTBM83trpZaERE5h
	 SeSQJPvI4ZZmIseKX0pWk3RdFRLMNcQYnhy/4kIK/fIwmity5KfDcjyLnAu4PlJTPn4Xw
	 zvh35yGsUkyOVDMvMVDs3/uWq3YFYZoqigDEvujNTcO/kNzhuXZpTawQEULXqC6Jtq3x6
	 Kp9Gc9Kbxig221/sXEdZf64Kg/6vT1XS83qUI8k/vM+yvGkDwITGletER48MN+4yyFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hC/pgrJk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787E6606D812;
	Sat,  7 Nov 2026 14:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hC/pgrJk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4901F008A1;
	Sat,  7 Nov 2026 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062540;
	bh=HcNxN24e2gwI2ru/fPWwUpVd6wvoB5Zd9WXvCIM86UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hC/pgrJkHMsOuHMa6IQV35chX4Mezk7Udcpp7lGEqugK8ZIvtRsTM/rGtXss9kJ0f
	 xRNvmFFQ1CWlVrlC4dDQWkMvG9LmlM3l1p0NDJECukpOYf2CyuQjUVKl9hY5YXFc4Z
	 4b+5a803MxnlGamCnv6s35AnPYvf8AiSK71GgRnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartu Alev <bartualev@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1403/1536] platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming
Date: Sat,  7 Nov 2026 08:56:59 -0500
Message-ID: <20261107135037.231609889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index af9505b2455ae..1465057b3e3d3 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -994,10 +994,10 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
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
@@ -1010,7 +1010,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 		flags |= BIT(3);
 	if (sleep)
 		flags |= BIT(5);
-	if (keyboard)
+	if (shutdown)
 		flags |= BIT(7);
 
 	/* 0xbd is the required default arg0 for the method. Nothing happens otherwise */
@@ -1024,7 +1024,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 static DEVICE_ATTR_WO(kbd_rgb_state);
 
 static DEVICE_STRING_ATTR_RO(kbd_rgb_state_index, 0444,
-			     "cmd boot awake sleep keyboard");
+			     "cmd boot awake sleep shutdown");
 
 static struct attribute *kbd_rgb_state_attrs[] = {
 	&dev_attr_kbd_rgb_state.attr,
-- 
2.53.0



