Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831002;
	b=VQT9L4Vmfpo62C5W/9WJ80FBGAvtPPDxTvx0TK+wyZlUoqHMSNDJSLD6kI24lHspEr2s
	 /Gp8jCXcCllLerGAXGCJQiz/M3AMKTw7r6GU4okNkoCXKuKu6zc0MaCMLxiSDcM9PxJBx
	 jWTmjir8g/HKhBcFeowMg95SA9KYB911p0uMM4M84RpK+GcpLS80Q079Q/phlwoM/bW22
	 nFrpFIZnLLezCDrR+r8OnSVHkQ1TJ6ZRLoPh7KQ75VkPXKA2det1TOUQOuwrSOQ5SEaSB
	 gYGN6o53BSwoODGfpm9cEFQVvFFfkbhodV3kUDhjHajcS9P1nkWPXfaXeZ+ov/yPyYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mkYHsBxkG991Ac2/SWxjB2GU+TlZ8CszN9XHf7dIMXM=;
	b=qyCqY4RN8qH/eMl5Xf0tuQm5JMzVSXpZfz8GCprKyNBqM8D/Ul/bT3+H3zYnZrrjWshC
	 vKuCLfAWs+lyi+BO6cl4k9kavpMTzEoXiY0ll+7kq/r6LY3+9Z9/i6hMOaWXiztPzbSzx
	 HwtMRC0oRbXZvgriTyzNnwSSwWE1rFdqbywK6Bt10ENIzvXUn8F5AD1JVBukneKD/46pV
	 EcfpzVt1Ii5WsGeReV5JOZa/+CdcOYyar1w3V1gmtLv7Aw/wn70BkrBsv4kTZ/EwVFIvf
	 iZTngbMelPxtRWZe5ViIOFOKE7RWZQsqxa/3VwdTwJo49RNEymKyq3JTt0lAYj8o2Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypJ4S7Tu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969B6607031C;
	Wed,  4 Nov 2026 22:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypJ4S7Tu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B2B1F00A16;
	Wed,  4 Nov 2026 22:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831002;
	bh=mkYHsBxkG991Ac2/SWxjB2GU+TlZ8CszN9XHf7dIMXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypJ4S7Tu5mJX9MT84Xznzg4ANihKSlS9RHrMiS6Dm9m68k7qKOuqz9WkIqnKnGF6F
	 SqHrAOBKxnR+p7dHmoKGbB6cWNZD6UhjCY1tQh9G7xcZ2HQ7l6ewUBquLDuQmCWeKl
	 mzSnGzuCzY42OcdXvytn8D6DHkF/NSQQKCahWLo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Everaars <robineveraars@pm.me>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0450/1005] ACPI: button: Add DMI quirk for Razer Blade Pro 17 early 2020 lid switch
Date: Wed,  4 Nov 2026 16:03:03 -0500
Message-ID: <20261104211056.656826961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 384caea90ce5f..4ddaee8955c30 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -132,6 +132,17 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
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



