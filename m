Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038483;
	b=iCUtMtIhspH7Y93SYw9smt4VAfXvFBA32uJjWF0VqjLxywU5lyMxUX+Dt2LpjLplSrGC
	 Vcfd32Wed3VWKTkGyrUoN9vUuKBUuRTKGN/L2MTDM5G+nEQN6MXcWjEwgQ6pJ4k2t+hNC
	 mnrOUAl9b8y2p35cuOY69QxD0QhATqZ0zoJt5owrOSHM9lMusxl/5SRzg9IF5B6IYitRe
	 Z10WliZr5DHTLbIJd9a1q8TWHI1ho3kML/k88Ke3BjwsavtO88oSyAeZSUMdj8dr7Euzs
	 UtoSHB7c83ACz64icV9xmK6OSGI5KsqoSf4RPU9TICt/GNRCu1WBFym9zmu85BhnkKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mM2wNq1FHlGCyqXkwSPHiLldxg+GdJCI9iA14PLW5ps=;
	b=L+3gOeNfVF652M+vCrJdZVXRWb2MvJHDZDaUKVZbkEJj9tLy41R3PnmWhVKC3cOrsPaw
	 zNPuNf794RJKo1PAYM3ggooFqb/2dUB/ArBcRb6vrSpZlVGkyoWIlmaJR44j3ms3Jljcr
	 t6ISf9km2tuOjIaYoV29opn89A2Yl1N9jayfCfQ/W436wosz3OiDPE2eHPDWc4Clv1/Sj
	 jQqp9vRbCj2mjuv1tclCzB9h0fn4/S4GE9XQ3BHXPi5zUNLxZeY+tNCojr4j7u8IVAZNo
	 kHZNprpLxljjSi8S8xfBptT5RtmaiA7dfcFrcfJZ0J/YhlpJygwd9qp+ub+VRmppgJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tda7ocnM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3549606A320;
	Wed, 18 Nov 2026 21:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tda7ocnM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367631F000C4;
	Wed, 18 Nov 2026 21:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038483;
	bh=mM2wNq1FHlGCyqXkwSPHiLldxg+GdJCI9iA14PLW5ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tda7ocnMdfiSdAn8vH0SqdWWHnXT1kDR/C5/iVVcspk9pt4KlIwBvW0CjWXrT2yAz
	 KH9oiIbDV06d/7jmsek8J5IT2BWruGBVJqGDL2GpTQ2dWb3/3/x8GtmLdksIp0MWTU
	 F8pDSyX/EHfVt9qg/+1apyB1L1QxZ2nzNoBafNUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartu Alev <bartualev@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1759/3318] platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming
Date: Wed, 18 Nov 2026 15:39:41 +0100
Message-ID: <20261118150414.624446716@linuxfoundation.org>
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
index a3ebea7f0108a..5c12b50f2f6cc 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -944,10 +944,10 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
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
@@ -960,7 +960,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 		flags |= BIT(3);
 	if (sleep)
 		flags |= BIT(5);
-	if (keyboard)
+	if (shutdown)
 		flags |= BIT(7);
 
 	/* 0xbd is the required default arg0 for the method. Nothing happens otherwise */
@@ -974,7 +974,7 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 static DEVICE_ATTR_WO(kbd_rgb_state);
 
 static DEVICE_STRING_ATTR_RO(kbd_rgb_state_index, 0444,
-			     "cmd boot awake sleep keyboard");
+			     "cmd boot awake sleep shutdown");
 
 static struct attribute *kbd_rgb_state_attrs[] = {
 	&dev_attr_kbd_rgb_state.attr,
-- 
2.53.0



