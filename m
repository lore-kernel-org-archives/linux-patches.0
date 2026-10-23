Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774698;
	b=jHWahhNSg2Xxi8uIZv8fDR8YImkkxn+pqbWw9uLUfzHFMy8Qnu6EiupeF3+eSRYDCqI3
	 ruVlpCmdmtACYjZ5wJv+DA9L3tOiu4+XhJH7hhwTox6axgWnLqtRvsMrG8Pqms0KWKOoH
	 lpdc37UlSJJPjLiUQJF0hQBBbJuizejlVaIh/D07Vx76nouvE02XyRmEETj/xIPTXRwRD
	 4wlGigQ7lNRIwDukJDVulb4y3Pwovg5qRXRsrCmmkX01fqXJ7SP3aWAxdBudiGnEvbHht
	 2lJlLPJPjmdr5s204wUSFL/SFDUHOrlH1R2ba12kzPN7Mt37/9euB3+7E1WR/kwXfwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VEltbtQOe+3jQU8sIpFdZ435uHw0wBVB6CVBod0HCM8=;
	b=kuCsR25hOG3FPgClr5Hq3QftfoZMtHfKMpV24Fg3m+ftRiu6sTBX1H5FtFeP+C7psRTK
	 rBhcNmu0YCcvu6cvjgbVMK15nyU4hR3CYCsIcMlsDrpP6D1J7CbuNdGQStTnLU248XI9G
	 69fZ8tpTmqIdCTgt8HFmOKMY2BD62hnCJNjZlKBFv/42H/ExCVmLBgVPLxnKb8IwKNaTN
	 BpIrcrfUJs41rkzriuzEIuxuaAXuLNYp7rh/7vBT/l1QpmIWUvq9tWVPox1FADhClQmw2
	 afxE60yO1gOoOMB85cuczghIxf1ysrWzK2txkPoBNGiSaLfk4oSDiqh9dyEKQHIQf3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lf10nkHg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5813606A31A;
	Fri, 23 Oct 2026 16:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lf10nkHg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD201F01825;
	Fri, 23 Oct 2026 16:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774697;
	bh=VEltbtQOe+3jQU8sIpFdZ435uHw0wBVB6CVBod0HCM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lf10nkHgOxZpUe2GAcSjNpKA930LTcsGjj3SVDXr3Vec0CDkuyzE3BAqJKNOoM4uA
	 HzA0e28MA6gRseCot6ioFpOhnq5IOlCFKX+Fua3V7QUUC0lJ7nzf53QsauI1Xg7pMn
	 DBUmbHjJM7Lmdr0/fBtw8uCXpY+a2RpG1UCIXmFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olzhas Marat <marat.olzhas@gmail.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 7.2 126/242] pinctrl: amd: Clear S4 wake bits when firmware has _AEI
Date: Fri, 23 Oct 2026 18:39:28 +0200
Message-ID: <20261023163716.762747251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -886,6 +886,15 @@ static void amd_gpio_irq_init(struct amd
 
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


