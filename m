Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057590;
	b=zG30O1mRo3CnW3TkJiuNNyew48XcsASLafTCh3HJuhIuY5tQK5cYJfzety+nNzaUm6n0
	 DSrpSg58eEHNmh1+lIkAFj6oZ0JSJgoVhEFvapxEayTW414VaLMEjnyWWfuI7xZLK9U71
	 O8moZVpAY1ixa+y6O++otYdw/tXw87lQ2l6lcm0uBPGKq/I03OlNGAol5qabXR5VPwSUv
	 qCOpNtvoGLAAecO1h2HeDCAASYNSC9x6g49Mnn0y/pyWgJqK6AWbeP25G/OWam5Rm4fxW
	 YuMdcMkaqIyL69GJk6zileSLAm76PP9ZJrGRgykKe3GnFi2kYffT7k47U2CGcZWR7dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tAQ/thqm6PjMyaNHTHhq7NL0cckEkLhha6quGl5DunI=;
	b=z2Wx+0R55+vcV0OzrYu1Rjw5dayAr9sMjA5v1i9ZS0WsR2mZmaV+wlmIvAcBVo6ZECPa
	 RX2jc4UqyNn6LzImS8QoL8ZI86VtNJ72zkveokOjhSeb7QNMkGt01YcbLwFLot9aRahHF
	 WRyEfux22Uv+lglWmNDos1955lEtvdREocCVJMGNWBTMQazNEooJHOEq3W+gJThipQb+t
	 Onb0rsGe1oa2LgQKqnSuzfLStuuyBmgUqkRR4q97L8uef9mGyKpRnI2l7AW5umJOFFAAd
	 K+c7zPO2gZvffDr/bMYT0VguQGQM9aeakKLblz+rbHC6Z2Q/zY1w8g5ekvWa4/+UIAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wX6mbG8+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B265260A2619;
	Thu, 19 Nov 2026 03:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wX6mbG8+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1FE1F000C4;
	Thu, 19 Nov 2026 03:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057590;
	bh=tAQ/thqm6PjMyaNHTHhq7NL0cckEkLhha6quGl5DunI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wX6mbG8+Vy0C5Wyn+4un9xX22BzCvR4rNCojwMH00bhDspzwDFhZkvIbsmuo6qNPW
	 JnwywcM92DMnruaC3ToGbBysXfoSvvN1wnx2fi3wLIVsyRenXRYMNLy80pSU+BME3D
	 rtEcXQbMC82VejRz3cn69Ann8UuCnI9R7gTlsmZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Everaars <robineveraars@pm.me>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0185/1848] ACPI: button: Add DMI quirk for Razer Blade Pro 17 early 2020 lid switch
Date: Wed, 18 Nov 2026 15:37:03 +0100
Message-ID: <20261118145919.356332644@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Everaars <robineveraars@pm.me>

[ Upstream commit 415125669c2ddc773c579a60df108f75712dfa83 ]

The lid switch reports "close" but can miss the matching "open", leaving
_LID closed after resume. systemd-logind then suspends the system again
roughly every 35 seconds.

Reading the embedded controller's PSTA byte while _LID is stale shows that
bit 0x04 is set, which the DSDT treats as open. The DSDT returns the cached
LIDS byte from _LID. Its wake path aborts in RTEC on an unhandled
SystemCMOS region before copying PSTA to LIDS.

Initialize the lid state to open on resume, matching the existing quirk
for the Razer Blade Stealth 13 late 2019. With
button.lid_init_state=open, a physical close suspended once and resume
reported open without another suspend.

Signed-off-by: Robin Everaars <robineveraars@pm.me>
Link: https://patch.msgid.link/20260817141414.213075-1-robineveraars@pm.me
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 4b90dd928398c..10aca4d2b8244 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -124,6 +124,17 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
 	},
+	{
+		/*
+		 * Razer Blade Pro 17 early 2020, notification of the LID device
+		 * only happens on close, not on open and _LID keeps returning closed.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Blade Pro 17 (Early 2020) - RZ09-0329"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
 	{
 		/*
 		 * Samsung galaxybook2 ,initial _LID device notification returns
-- 
2.53.0



