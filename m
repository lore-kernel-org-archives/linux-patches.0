Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033814;
	b=MIdH5E6jtCBfBE/bM8AZtFDpyW5sxO5gabb/OPQfx9y3crdv7AcPo2Lcv0IBNzBU9boi
	 Fz76fAgRvBFSkV+cPFV8K8ejm+Tb0Rbh6/M+OV4hHe6sWQJ8t17FDxODUHZs1lXcTwo5m
	 HJdx8O87vPkFWf7O9tjJTIzEia4VGkM0Qeg8DTOZQYV6IQBrflnLrI3Vc3SYCssoQhd+9
	 FA/3BxLdRrg5ZptzaGvn8ZDS8XrFui5XLWb2SGWMLsg7AjDjfD+ZjRCxfJSvhLUmldtV4
	 Fy73ursgIZWFfddNi6gIHd/4D0iCT7wegSNS86nL8XhVR05hpVZXVkO7Nlpd+uVG6Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JG9CIKjmWAd+On362JFJIejOWf2sP1xGiwTKd7LQfZQ=;
	b=T0PVlMRL8IjK197MhXRuakY9bvtn8jMEA0TWgXabbFNfhe4sT4dHjUWpVlOKiq1ZzBCa
	 8frhPmi7SC2dQ/7X4bz1/qHjIbU3/kb4Ud9vVyz+WoyHi5Oagwojn/mo57hvyYyaz2doz
	 oPsTeYBUemHdDFJCzEB/DzY4WIHB+uOEBI6seAWFWqRlpuCSe7lsI2yN92bMFvHQtij0p
	 0SZ0uFaqYy0KZgI+WS6jDWeSlssdxsosjNmZuI77LiRpIZXdxR0/f6lpmK4gUg9I/MSMK
	 xF4qdWQC/d9lLQNlNVRMrM4lS1DxiEFUMV2m4lYEaVWutIzZt9fGE6jzslUTnUDBdBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=of5Aq6q8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C2B606A320;
	Wed, 18 Nov 2026 20:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=of5Aq6q8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662CC1F000C4;
	Wed, 18 Nov 2026 20:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033813;
	bh=JG9CIKjmWAd+On362JFJIejOWf2sP1xGiwTKd7LQfZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=of5Aq6q8xfS12LVLtu6tiKcSoBAUz/4UxCjMgIEezVFM6NKmHloANExB3JP59TI8W
	 OmTcWZZzlAwXMvR4RwE6cLauE6Rap66f3R926gpaIHSPwJ2GdHdoJUYtf93E/04oeS
	 AqrpImsjdKEJDpSCRT93yaNIF6bawSJOjqDlCKxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0147/3318] ALSA: hda: Check snd_hda_power_pm construct error before executing verb
Date: Wed, 18 Nov 2026 15:12:49 +0100
Message-ID: <20261118150318.904993569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3d0c03365148e..c6630dd0ced3b 100644
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



