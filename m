Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047054;
	b=cwxFdokudwi+znowpWEnlbEJGXSIJAPCW0SGGH6sxNb6l6qUrUP/84fRmwGcK/n1Y+5B
	 FGS30UhOyrQA+XR1sp6q3bv/V5NUWiMbYkxUYT2RJZMPs1ScZMemKxGSN0fyF9RFjeRdK
	 0sN/8sF60F2VRQ1QaOdjMlCuMCGAI9gbFXrQTW024HJxzNMfTdukwzkOxyN0d7rOsynQ6
	 h6pHV09N7DiAMSjenlIchJCgego5XxJYTELC9Bp/psx1p2nO+/45HPu801Ft/OEQr8Mtb
	 bM1GdjtHg400WWJ1iAc0ANcuPd6m5NqzsVCStPOZbWQMPsYl4SghRlqwEMnDklHImwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1MS5VXlhDXdsMNRDgb+0TdXK3g/Q1qdN2KLgyy47BEE=;
	b=uioFWqNChEBtAQrDozk3fPCHUZXGbhwny4/ZBuD5seIciG8KrgPzg2HW/cMuTJU5pLUB
	 vVNNfwPmFf8GL1aIsQkbUFiWxHqrS8clkjIYQ71UpSIm/ySyahP+EoMAxiCrCYRbAJiWc
	 dGBmK0LAcQlJ4+0hNyPTcyHxC85NfM1ME65QCFZ8MUgeE84Z8YrCCiVdGn22ry6iDjYTV
	 FrvHxKX4EcPrjMHt3MOb+6BuJeLpb/kTG1ZL6UIuweSSqAoA9LaZcK8TduN8Eh8s1u497
	 H92xpff0tqvUAissisyrc9GjKAq3xcSoHEcAEhk8FJYAMaFuuojArOeO3H0Cl+VIuwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cbLnHZqd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B037606A32A;
	Thu, 19 Nov 2026 00:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cbLnHZqd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0C51F000C4;
	Thu, 19 Nov 2026 00:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047054;
	bh=1MS5VXlhDXdsMNRDgb+0TdXK3g/Q1qdN2KLgyy47BEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbLnHZqdFBQXiQGZbELAFuhdbvB7K5fjhl6VuONDOXjBJ4SldJsHP3NJJgq+EprwO
	 6a4E8qm2jw0vvp/yayCnZRd+g3T+KFcQnyVw0FGwV0z6nMC8tfNM6PO19xk7xUgP3m
	 OriRqjQPeLi5Okvy1ettPc/FyxB8GVSbUrL1uDGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartu Alev <bartualev@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1500/2857] platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming
Date: Wed, 18 Nov 2026 15:42:14 +0100
Message-ID: <20261118150255.349125067@linuxfoundation.org>
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
index 4ed10997426a6..a2d877817183e 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -814,10 +814,10 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
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
@@ -830,7 +830,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 		flags |= BIT(3);
 	if (sleep)
 		flags |= BIT(5);
-	if (keyboard)
+	if (shutdown)
 		flags |= BIT(7);
 
 	/* 0xbd is the required default arg0 for the method. Nothing happens otherwise */
@@ -844,7 +844,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 static DEVICE_ATTR_WO(kbd_rgb_state);
 
 static DEVICE_STRING_ATTR_RO(kbd_rgb_state_index, 0444,
-			     "cmd boot awake sleep keyboard");
+			     "cmd boot awake sleep shutdown");
 
 static struct attribute *kbd_rgb_state_attrs[] = {
 	&dev_attr_kbd_rgb_state.attr,
-- 
2.53.0



