Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831083;
	b=5Hga2iMutXctcsD8KSv0tdl+9tt2PDT81UnyS24w973bkpev6Ukt8Y+4/j8ltlwKjjEe
	 4JhqEstBXQa8bexznDTT+tLLI2BanPY8eMQd1hSX1+WiSGLgHteAfxYAEe9BEtgDqHPUM
	 tHmdyzprDFZ8pNtIf5KyaVb5mQ3XHcUMcsZgJ0AXVnwl4qSyvH7wgDlZZ3RxvV2LHe/Yq
	 sUygduV2AL/mrd9VkMBNY1L156W/Z48Ofc1ECMiOH6XIH6DAFt7yUkSIOyTXGHJbFtJPI
	 f+tUS+Mmk8f1yA+uTwe2No9uGW4foV+F/x3q10RB6Do64rpz8gFWG3JZOAm5pLCdtlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b1TJHAFL/HJvsvHKSYyvzdbbTNHTbEerZgt1T6XIwhA=;
	b=bz+784CFlQUy1L8VulDjXU91kE197JaHRkFFP4m8Lh6AE2qx1ZxT54adsFRsO1Kn80OM
	 pPMla7Nrb/vyXOtZxt1GawbCiru4aYSzGpWh/5FuAYq4undbyA/TMLpZz5y+PHmh3O3YC
	 ALiSN8TUDqutUgdebSVAaF7u5X/qLcFO2GY0f1/YoS4hcQqwSHKUUfC1nH/mRtmB3SOnk
	 KFS0rx3hNPd6YlyHwt6C9RKRSIRwQ1JrxkFWR3+vNYjEL/FUsjJHB5IYLpd5Z8xuXvqGt
	 gJNir2kl9MhJvP5NH5SQYawQUSjPBe2NHUmdgg4mUOiebTK0C93nWVt05feRzzrPFhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WjQ5AQOp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1DE606AC29;
	Wed,  4 Nov 2026 22:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WjQ5AQOp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BAA1F000C1;
	Wed,  4 Nov 2026 22:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831082;
	bh=b1TJHAFL/HJvsvHKSYyvzdbbTNHTbEerZgt1T6XIwhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjQ5AQOpZjDO2mFJOskLsM5FDw4GsGElurDepXRgteo6lwSQg6+WSl7dgyqFqX3M4
	 snCwgXayQw+5q4O48snRS4fXDGMXtXWsqlzud3IvXo7E6UsgGryMPlDP/v911zRfGw
	 8UQzMqx82dgR1pG7lckNte8LHXiHddMqFguD7u30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	KIM MinWoo <phrimm136@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0494/1005] ALSA: hda/realtek: Add quirk for Lenovo ThinkBook 16p Gen 3 ARH (21EK)
Date: Wed,  4 Nov 2026 16:03:47 -0500
Message-ID: <20261104211057.801154464@linuxfoundation.org>
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

From: KIM MinWoo <phrimm136@gmail.com>

[ Upstream commit 3867e38b2d4b844d89076f988c7b9741c87a9858 ]

The ThinkBook 16p Gen 3 ARH (SSID 17aa:3871) has a TI TAS2563
amplifier device on I2C, exposed by ACPI as INT8866, the same
arrangement as the Yoga 7 14ARB7 (SSID 17aa:3870). Without a quirk,
the codec falls back to the vendor-wide Lenovo quirk
(ALC269_FIXUP_LENOVO_XPAD_ACPI), the amplifier is never bound, and the
internal speakers stay silent while the headphone output works.

Reuse the Yoga 7 14ARB7 fixup, which binds the INT8866 device as a side
codec. ALC287_FIXUP_TAS2781_I2C does not work on this machine because it
looks for a TIAS2781 device.

Assisted-by: LLM
Signed-off-by: KIM MinWoo <phrimm136@gmail.com>
Link: https://patch.msgid.link/20260923013756.106033-1-phrimm136@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 10d930d8fed72..b1cb93922c3bc 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7527,6 +7527,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	HDA_CODEC_QUIRK(0x17aa, 0x38a7, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C), /* this must match before PCI SSID 17aa:386f below */
 	SND_PCI_QUIRK(0x17aa, 0x386f, "Legion Pro 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3870, "Lenovo Yoga 7 14ARB7", ALC287_FIXUP_YOGA7_14ARB7_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x3871, "Lenovo ThinkBook 16p Gen 3 ARH", ALC287_FIXUP_YOGA7_14ARB7_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3874, "Legion 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3877, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3878, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



