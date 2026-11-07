Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060811;
	b=ETF5kz/8ZQBWekz4fg63Jskoj77c6FqX6gbH5fVcdGUz24ohwNmjejH73iZkxvLoS3lL
	 WaM3c1mibtgtnMTbQ9hOehW906OLZjo0OXfXJnpa1/kI9JZYWCGy52koJl5JdDavVy5S/
	 zP8JMC9Eb9pFx8wCAqJvS2WXrDBZG3Z0MYcqepkuOCBfHdLXxUm4EGZbndiFeGUkCFZgW
	 HUiyW5ApEE9+HYJBgJ1Z3gmGGkXtlxvRZ3essHninPLKPXQBVl5Y84A/Iu6BSD3we9R1h
	 6p6StbAxxO5Hpxtw/PLinbAUIalUv+A/tKNDvDH0E+aV6jDQc5ppJywtT4ocrBqW1rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6G1TSrqtF7nWMRAVziBWYZ6hoyCGUgWFJOII/ADtOV0=;
	b=OvbZifhWyNu3HWIKrAtKxTJsLqIoYmzt+bCsl9ciQtImO8Vgd/ml5G041nzafUrh+cfu
	 kOmqPAEOWuyXl5pJnYddITEnUat0v05M6TATsScXZ0JqMx8WZ+ONGcUugEaIWOacdKf2i
	 CiLFgGObe12VUYdHBppMXYjXjR8Vtpo2+09fjg8H835Cx6ZTEUCML+wDSYaJ+bC+2Cpqk
	 gTuBIb5ZF2WPjFxgefgChQ+9yR0XQ89aAYCiDsdc5693/d/DaeZLz5wolzV83iD6LnL2G
	 ZWQYqXE2eXvx+brJqN6YMe/EN8Yu4lHkXdX5jYNHdVk47ALap0MCYz6i6WIrU0ox3nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGvBbUgT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD037606A326;
	Sat,  7 Nov 2026 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qGvBbUgT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569661F0089F;
	Sat,  7 Nov 2026 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060810;
	bh=6G1TSrqtF7nWMRAVziBWYZ6hoyCGUgWFJOII/ADtOV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGvBbUgToO9x0hemCV5ucrh+nv7lx7fTULQ14OCEwf1j+t/Yt+q0tdnu5iKdaBTZp
	 FNbgmSE/oEMYAN8USTj0Qiib9E0bbK98HX4ipV1JcNc+XiETXWQXMoq7zVYb8Ujct4
	 p+vFqoigkVVjRMR+SR323S3LPpelX4xaN1wX51XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0170/1536] ALSA: hda: Check snd_hda_power_pm construct error before executing verb
Date: Sat,  7 Nov 2026 08:36:26 -0500
Message-ID: <20261107135002.436813818@linuxfoundation.org>
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

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit df27e4dc80c4a30ad206432cb848aab00de22ca7 ]

When userspace writes 1 to /sys/bus/pci/devices/XX/remove to remove
HDA PCI device, the HDA hardware control path is shut down and devres
unmaps the BAR virtual address bus->remap_addr automatically during
driver removal.

If a delayed HDA verb command arrives after the MMIO region is
unmapped, the driver will access invalid virtual addresses and trigger
a page fault splat.

So add an error check right after constructing snd_hda_power_pm.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260717024948.506335-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index b4006b31251f9..24ecb1101504c 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -38,6 +38,12 @@ static int call_exec_verb(struct hda_bus *bus, struct hda_codec *codec,
 	int err;
 
 	CLASS(snd_hda_power_pm, pm)(codec);
+	if (pm.err < 0 && !bus->core.chip_init) {
+		codec_warn(codec,
+			   "Failed to send cmd 0x%x ret=[%d], hda control stopped\n",
+			   cmd, pm.err);
+		return pm.err;
+	}
 	guard(mutex)(&bus->core.cmd_mutex);
 	if (flags & HDA_RW_NO_RESPONSE_FALLBACK)
 		bus->no_response_fallback = 1;
-- 
2.53.0



