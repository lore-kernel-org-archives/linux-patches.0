Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051497;
	b=YFDtf18IkTpy5vG/KHtBA4FJDNzzj7URUJeDHMSK1dnmsiIFIwCB9Jg6Y2JhNLLOyvyi
	 qnTdkgFPlze6weQ3mB6bJFwZlZTDzMnSzjxMHWLz2ea1reX+PDXhCgzEHE9g+IwIZ2r42
	 Ate99D3UFc+9ccGFuPJiG6hSSlAlSrduzgO8cNS4XLdCSzRfT+NZjV0yRhDoGZtMcEAd+
	 MVQu+agCcrWF7Rz2YC4Nd0EY9nuDGdTkybA3nptFhKUqMadYHK+hIf2XuWsPnvw1l4klt
	 NCUb2ZHrw87mCtg6sQOAOu6K6E98lJ6yHedW/hderRYYn904X/tiPhT9RuRuxAp2Hrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vkTRjrtQaojrR7qvmiHp1y415/+XqmnUntq0knV3n24=;
	b=vZw4pGUgeBsylvtcsYf0gXmyA7EkQnOrLcMYG1TdPhiNOdZlAhIdRO1Be7tf2ptljAjk
	 p7CA/w3xhYC10I0TTzsTPJtOPO5ERJNvS/EMv1yci53dguL51zvZQqGK5jbpuZLslQIOk
	 dlDDm4QiEgqKupMW+0b3teP9JAyzHVd1W2MVm9t+irOqkvzgNWTRIJUs39+z3WrG2VstQ
	 zsd//B6cclglml1AB8trUKVVx/gzlA58dLrDAHk790EIW+KyAezbXvrD9+XmMQgy8lifY
	 Gky6X4Ie+ksudFFWEJhUEyBc5Fg3qTWm1PyzTcDRIkEkn10ozwSqhlBA2DvUzwBDu/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EX8Igapo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C95606A31C;
	Thu, 19 Nov 2026 01:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EX8Igapo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDF31F000C4;
	Thu, 19 Nov 2026 01:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051497;
	bh=vkTRjrtQaojrR7qvmiHp1y415/+XqmnUntq0knV3n24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EX8Igapo9sHjToUmGk3QJwqzYfvVsViYc/EW8ex2/uwhDxzc93THVq3c79olSH5/H
	 H5CyT3CN8B/tt9poDIZCLDhoqg7Vn0L6J5fc28P7jaHdFCs+4OgB4W7niuf5htBIYv
	 EObkMVPlF42PfgV7NwfQazoHOIXeffPGdHXqoE/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Everaars <robineveraars@pm.me>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0229/2214] ACPI: button: Add DMI quirk for Razer Blade Pro 17 early 2020 lid switch
Date: Wed, 18 Nov 2026 15:31:45 +0100
Message-ID: <20261118150019.398570261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 067affd5d7397..c2d19a2e73d8f 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -130,6 +130,17 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
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



