Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774003;
	b=oxOKTrGB1Gd1ZvoY+xbn3GUen8Xnz6a0VDssJTb9qv0YZiEBjso2eeLSrPMkwAChpq4o
	 WufvdN6u0yhmei4wthtzVPB0uaWbQZa+MlUAwvn9bLjZue1/vNuyfZzn9qGKJTH3+0dza
	 acRpJSyXsGk8dxnCYnaC1xk6OMxJo/XPjTBsT5nf+MbSonrnJ92meCHl8W2JtumXCemtL
	 YeK9ABCmBi6k0sVh2gvNJh+kZz5r5OzTPRhkLESjddxOJhTEgvjpeUhBiN22mV+t4AX+G
	 PU6LTYe7RWEt+bBLYKTh82ibw0Pxj1OdQUvSoxrO0qLXO3xwyp5BX1fE3CIJRt6F0pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AhYOpk8fHPNBMhk2IGFWr67qH2blaj2ASCb9FTbo0Fg=;
	b=DTyDM6PB0c8VxG7CAl3zGo2KvP7ovzm0kW3297D6bw3FEH3dqY2A24Aa231eJfZXqdcU
	 R0jrdYZ4iAzKkUhzdJMpbi2AED0/x9dT2+zP91FJe6M3khEasqEx6e0vFI4R+ZGtJvYD4
	 UjKUOR0N7/erUdT3rcOu+W4SR+/X9Vqm18SALiuM2PWrVgyiVLlYmStFu6t56TUdjlsPW
	 fDR1jS0fe+0cqWOWpzJTViRF1HXFN1Jie9nMyvxU7qljt2mqQWziZsuDUlzsbiyVX43TS
	 yHTfoC7Rt/dhYuNYTbUY8/e2YpTTet+0YG/s7pitJsvz4Z8op9OXD1mWeMBOMpej/7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b/Mdx3OO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BB5606A31E;
	Fri, 23 Oct 2026 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b/Mdx3OO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794281F01825;
	Fri, 23 Oct 2026 16:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774003;
	bh=AhYOpk8fHPNBMhk2IGFWr67qH2blaj2ASCb9FTbo0Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/Mdx3OOw5s2qPmj2bggnEjI/tbPHrfCumZ5ME8fLNL7LLf9pmA6WsQmBqhisUcMa
	 U2T09iVwj0RkryOt7JjBR5OQguUCg3LzUpTYI/UBxVHJ4jETTKlgdhSMNVw7jo+GKs
	 4gJ09X8wc6VD/30zaZyKuXVmASwRfsdW4G3UCLWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olzhas Marat <marat.olzhas@gmail.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.18 087/193] pinctrl: amd: Clear S4 wake bits when firmware has _AEI
Date: Fri, 23 Oct 2026 18:36:04 +0200
Message-ID: <20261023163716.266621505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 1cca81a683da7f0ef2fbaf34442376044cbbad22 upstream.

Commit ffe8a0c6b552 ("pinctrl-amd: Don't clear S4 wake bits at probe")
preserves firmware-programmed S4 wake sources because some PCIe devices
rely on them for Wake-on-LAN. The system that motivated that change does
not expose ACPI GPIO events through _AEI.

On a Chuwi CoreBook Plus, firmware exposes _AEI but also leaves the S4/S5
wake bit set for GPIO 24. This causes the machine to power back on
immediately after shutdown even though Wake-on-LAN is not enabled.

GPIO register dumps show that the only relevant difference is bit 15 on
GPIO 24. Clearing that bit makes the machine remain off. GPIO 24 is not
itself listed in _AEI, so _AEI is not a per-pin indication of which pins
the OS manages; it is a platform level signal of which wake model the
firmware follows.

Use that signal to decide what to clear. Continue clearing S0i3/S3 bits on
every system. Clear S4 bits when firmware exposes _AEI, indicating that the
platform hands GPIO events to the OS, but preserve S4 bits when _AEI is
absent so that firmware-programmed sources such as PCIe PME that bypass the
GPIO IRQ wake API keep working.

A platform that exposes _AEI for some pins while routing a wake capable
device through a raw GPIO not listed in _AEI would lose that wake source
unless firmware re-arms it during the sleep transition. No such system has
been reported.

Fixes: ffe8a0c6b552 ("pinctrl-amd: Don't clear S4 wake bits at probe")
Reported-by: Olzhas Marat <marat.olzhas@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=222041
Cc: stable@vger.kernel.org
Tested-by: Olzhas Marat <marat.olzhas@gmail.com>
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -888,6 +888,15 @@ static void amd_gpio_irq_init(struct amd
 
 	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3);
 
+#ifdef CONFIG_ACPI
+	/*
+	 * Platforms without _AEI leave GPIO wake sources to firmware, so
+	 * preserve their S4 wake bits.
+	 */
+	if (acpi_has_method(ACPI_HANDLE(&gpio_dev->pdev->dev), "_AEI"))
+		mask |= BIT(WAKE_CNTRL_OFF_S4);
+#endif
+
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
 		const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);


