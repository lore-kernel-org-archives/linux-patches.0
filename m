Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207602;
	b=vxECXBZMi5PWSddR6k2EaBFJ1Q72V+Q7snDgH1i/zRtRVCUZK68QsW7AOXV15z8s+2ML
	 qwhvcc5Ct+HX+0Ta6tjeEsAM6WQGPZwg/h730mj/aL7FGhtJEB20e2U4hE5PGlUW+oTnx
	 9afQSc+ODBoUE1Ntt+V3j6if9ca60KPVaxvRTq+fUSP5L2tGPMB+yeW3YocPbJGlfkdZO
	 +s51sfv6mBvdaEdXUsFbm/KSMAHDq181E2+M7HFR1JuIUo2aKg9DHOocn5QW2NZr3mkns
	 imgd88m5esOepMhmKUXEbkeeDKn2ru76h3cu9+ZyDmd/Tsvd1H/CRTqmT1nhTtSbEJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z7RUwg5Pyqt6IcmC/gkRLjyQBxgBZTaEskwhtrGhnjw=;
	b=Tj9PoJ4A5OI5oZylOqZJv3OC90uyo2fPK+xSi0/0cGUwt6aQc6Ksrk7sbEgmpHEdCNi1
	 9csU7U2VekimIKor2aJBxmTAZVraV+a0fM/1wlx313r3kqYHoJ0B0V3cWZwDaIftNCiul
	 unljFc9RRKf2Tw3ISlUzlIEye2sFgTKlje9tlfz5N5UdV70c4gBwttYg+j2wd8eYn0blc
	 rLxnpL1KR5lKo8c6reLjr2WO1SbbWsR1OPWSWWhMB13c6Z371hxXTuulWuwb88lVGQJF/
	 Pf1OJr2CaThTpA/7YX2bLX9rklSi/CyP+RDYeigrYLqow2byTnGyXQe67tqxaHsdfDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c01eHyBI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88758606A31D;
	Wed, 28 Oct 2026 17:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c01eHyBI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B8F1F01825;
	Wed, 28 Oct 2026 17:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207602;
	bh=z7RUwg5Pyqt6IcmC/gkRLjyQBxgBZTaEskwhtrGhnjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c01eHyBIuUXOXVP0Tllif4GjM0cGdfmkZtkpfEGPZBHrWFLuOEBzDlTwY2UNSy2AS
	 wWstL5OMAc1MPZ1DkvTjGatlwoDsmyA42/LOFMYcdmVDMzeN34mDYb9M38Y+FxTEsG
	 O0Eke9SVjWio4SAQ8EDcQ2CVbG8UybIEwV/ZLkfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olzhas Marat <marat.olzhas@gmail.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.12 073/247] pinctrl: amd: Clear S4 wake bits when firmware has _AEI
Date: Wed, 28 Oct 2026 17:57:56 +0100
Message-ID: <20261028165949.122376877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -871,6 +871,15 @@ static void amd_gpio_irq_init(struct amd
 
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


