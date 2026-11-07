Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061147;
	b=qWLO/9/eGntM3AwbAG90Spd2I263rljEuqrdzrP+qb3vE4sl75s6exB/yoSIe4iRn58P
	 ICapHfhYNtKadgOQukXVR4OcS2HSYRMJ5Xay3nypJKvNvhcxucJNU/XBiQJ4AEET2R9aL
	 G7QTQ5LPUTpNY1cQ8YfRSZNYwQ36bkPBdhEn7QiII6rYkpaGMYRxOoFV/aDiyfRKeoMnU
	 YTimm//TmivLVh/Lys8cIiBAD3ynEaX1hVA+lTj6xsU2xEBqN8uVBRCA494gTxmtV0Wl/
	 YQBWlUsEuT6NRuIQyewGLxzWQmV3PuB4Qy8b3M1pq0CWC3ny83rOv8hmc+hVe8oXI9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qn935csM/XwU5dNWlT1n/GMHKzfDasGlg30GfZofi5Y=;
	b=SKtYGLI7ZYPVFo1X+vo3OB7n3j2QF4Hli93KzDpw7KFqoYKXUP10xjH7UcGdP5sBhoBM
	 L4f75+9bQ/tPZIGz4SvXsAPIEpmptBvOHlndNaAbaC0chisxqaDFlcKJTO6e2NdUrVM2e
	 y3CRIPbwAps7IDyV5uoa3ohrcq9kLCaBwCqqvPDlVVU03FObVhyzchwioo/Wzbedw4Rah
	 JjYsVgo5WRrniC6srRzKLbUDevG5wpxm67jm9JhAR5hWRrrTS4tXiJJK6YuIMaxbucfDV
	 IeRQIaz8/DWlMYpHOZIqr6XxSpS9Eew+IriwwzwBVrOBvOiu+rOv0DdQ/L9KCcDaBrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N0XAzTZT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF83606A33E;
	Sat,  7 Nov 2026 14:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N0XAzTZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5171F0089F;
	Sat,  7 Nov 2026 14:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061147;
	bh=Qn935csM/XwU5dNWlT1n/GMHKzfDasGlg30GfZofi5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0XAzTZTAmp6RhSDEGwEjJVtMqn1lE+qMt3nIe5SrfLUDXNaCesSKEG6UCToGp0qV
	 gbPKKc6i9qXP4JTUCPWFGDXQt0UEiIJIEZA8Tlu9bGFoMUoBhMHtKYsFx2A+g19ppR
	 jdvvq5ImVCrF+FQ/ftapPracmgHTfzfWIPAHa+p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Banha <luisbanha26@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0416/1536] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-ec1xxx
Date: Sat,  7 Nov 2026 08:40:32 -0500
Message-ID: <20261107135009.260218361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Luis Banha <luisbanha26@gmail.com>

[ Upstream commit 775aa96c310d59f3d15a6e5a9bd1796fd1ba95ec ]

The mute LED on the HP Pavilion Gaming Laptop 15-ec1xxx (103c:87b2)
does not work automatically. Add the ALC285_FIXUP_HP_MUTE_LED quirk
to fix this behavior.

Signed-off-by: Luis Banha <luisbanha26@gmail.com>
Link: https://patch.msgid.link/20260921230105.16844-1-luisbanha26@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index cf2ffff796d69..41c8d0fe7aa06 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10958,6 +10958,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87b2, "HP Pavilion Gaming Laptop 15-ec1xxx", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0



