Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043603;
	b=KPckFpWt5UUh4E5/kM/Vw8OWSc7tOQWCAshqnGRtz2ci2pija7gDAAqrJuUTd9d53Ymg
	 1t42L/lmZfRw8IenzPiGpdLqKqF7la292STvs1HnCUzqQmRoWVkXOG8B6jBULRFDcJxYg
	 WFld8rWYRlucxN5sLNzGier6ASRlBCZHkB2wctwMtxIQy18nO9X8kmAgInzkOHGX25Bft
	 M+pRDdcBkQROkHxdvgfMDhjdKvtH9udI0+iPgKs03WmrqYT0MUPsCVKvAdaB++8SmXLUa
	 4oKQDdM2DtbqeYWEavLQz+TRWbYmFZiuD/zvddWR8imPFKqny+iLAb3zGlJahohgJcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GriAOJNsgT0XnD4Dh3kJMPqDbrKMiltLUTZiNDgPSdo=;
	b=P926p30+ml/Tdg9czc/vs5A66R5AIA/zN8WHLauzAEZfuXVV5EfxTACxesUC2KBYuTqR
	 52REBZzB8Z4X8zVIQCF87NPcmMWthUkMdeNR3Y3Jd5TNJkiVyHRLLrxyrRDNbZuHECrQC
	 80i1TGDEvQW5z3hU0bc2EQoerHO6+beT6YKbwDUFLms8MfiuuQOvEXJhnPa12RJRAm2ro
	 76OWy0CcP8eg0RB0VTaQc+2OVrFfNlxdLcLrYAz/RMCS9zJf+Hd9POlmRXW1/Cu1zte/7
	 JGKE6KA1UHCl3SHiJzMqHtEpTfEH0eVxIyhbT5PfrySUoLhQPJPzwHzggl1nuzh/Otw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S36odkyP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B87606A31C;
	Wed, 18 Nov 2026 23:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S36odkyP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A8A1F000C4;
	Wed, 18 Nov 2026 23:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043602;
	bh=GriAOJNsgT0XnD4Dh3kJMPqDbrKMiltLUTZiNDgPSdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S36odkyPm0378SmbtzyVJPyh6uOSqTly+uYlR9A1+dEW+v6ivPm4Y0Zgt/87y7XAi
	 D+t8N50L9WERu8eTwz17EoRxqxfI1fOJC6t/5MhlitgYowVw6hhkkJICr5Agy06mzY
	 f1XmTyCuXwmLzxM0osstNVsEOXXSEUiyJJmpCTF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Everaars <robineveraars@pm.me>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0268/2857] ACPI: button: Add DMI quirk for Razer Blade Pro 17 early 2020 lid switch
Date: Wed, 18 Nov 2026 15:21:42 +0100
Message-ID: <20261118150211.076841913@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 000a7a7e5d49c..bc2906038f4e0 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -121,6 +121,17 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
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



