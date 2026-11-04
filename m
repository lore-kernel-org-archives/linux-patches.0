Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829286;
	b=BBDaOlCGfgqwuV8ebXn+1AK6S+sIuEY+iUvfg44EsH10neoAEa/hBY5JyMqkxWbrlhzR
	 0sTNW/qB9UxoAmLVD4QE2jpZkzkHFHdSIM7iFJfLaW+RUoUYgDJa8CmdP8S6iqf1Mgffu
	 wBlbLI+biPcumLdA0o8pgOjiSCgVD7oipq/HiJyxHLASkSDQcqPh1qp4rwdg6JFiJVB6m
	 2rOySL3oKa55UY1qReExZzJOSVH63touYZOpoPrhNs7synar9dkw72ovEEsMMD8jOD2HT
	 ocOap+t+Cg3+z3NhfR8Y4gKltJSB93YCTY+ZZsbzHIugeXtDzcy1PYAQugm2GYdd6/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ia2IXwqE+ZG/1SZA6LzEil+rK9J5twtEtOsHDIiR6o8=;
	b=LQePj770n5KgnmdkvYqsjk78NpOgV6meuIfJmddDkc8ntpwIgo2YCgQ93TYIvlSqT17+
	 6jso/FlyKjRHiwjlJl1QDbU+6STRzqJeDdRCstP4/qM/Y59QXEHZ+3SoyY8lwrI5Eq5vT
	 ZBPaIMyF+GBKP9yswa8ITEvSn7ANQKU1HqCiUTECMMxo9jz9vpA3GT6waIREarytnoeX2
	 lFt29UpekBHr9brJA46mSWnR88TxV+9+D064h0sJfHZh4Iy7GKt90mI+cYDsYmbckiD+i
	 exgv6KlJDmGqFhbjFThV+EjpAh7IehnSsyDnkd+QIpAKbRjUWDMFY/haCr0wPEevHrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcK4FOE0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E734760745B5;
	Wed,  4 Nov 2026 21:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcK4FOE0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8191F0093A;
	Wed,  4 Nov 2026 21:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829285;
	bh=Ia2IXwqE+ZG/1SZA6LzEil+rK9J5twtEtOsHDIiR6o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcK4FOE0Qbcr5PjTm3tN54hDEeprL5NwX2z/+V7jcOgbUiePKaDKQvtCgsGRMk2OM
	 o/CqR20bZGy7SPCFNta/ztabUthfQIaaTDbygCt2dRbg5l2XLkFKSQN+8YkWLoXgYp
	 cbYqtVjxcN3IYdvaB9kxmyXAU8O7wG6TnJwPMrOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fu Hao <fuhao@open-hieco.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0029/1005] ALSA: hda: Add support for Hygon family 18h model 5h HD-Audio
Date: Wed,  4 Nov 2026 15:56:02 -0500
Message-ID: <20261104211044.377220946@linuxfoundation.org>
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

From: Fu Hao <fuhao@open-hieco.net>

[ Upstream commit 41212ff3e4ed475d9f91d26b5324075087702987 ]

Add the new PCI ID 0x1d94 0x14a9 for Hygon family 18h model 5h
HDA controller.

Signed-off-by: Fu Hao <fuhao@open-hieco.net>
Link: https://patch.msgid.link/8b38f2941375553e4246167736c6acb5a541e833.1781523812.git.fuhao@open-hieco.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/controllers/intel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index 98367b87d8017..f07fc5dc5cede 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -100,6 +100,8 @@ enum {
 #define ATIHDMI_NUM_CAPTURE	0
 #define ATIHDMI_NUM_PLAYBACK	8
 
+/* Hygon HD Audio controller */
+#define PCI_DEVICE_ID_HYGON_18H_M05H_HDA	0x14a9
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
@@ -241,6 +243,7 @@ enum {
 	AZX_DRIVER_ZHAOXIN,
 	AZX_DRIVER_ZHAOXINHDMI,
 	AZX_DRIVER_LOONGSON,
+	AZX_DRIVER_HYGON,
 	AZX_DRIVER_GENERIC,
 	AZX_NUM_DRIVERS, /* keep this as last entry */
 };
@@ -357,6 +360,7 @@ static const char * const driver_short_names[] = {
 	[AZX_DRIVER_ZHAOXIN] = "HDA Zhaoxin",
 	[AZX_DRIVER_ZHAOXINHDMI] = "HDA Zhaoxin HDMI",
 	[AZX_DRIVER_LOONGSON] = "HDA Loongson",
+	[AZX_DRIVER_HYGON] = "HDA Hygon",
 	[AZX_DRIVER_GENERIC] = "HD-Audio Generic",
 };
 
@@ -2814,6 +2818,9 @@ static const struct pci_device_id azx_ids[] = {
 	  .driver_data = AZX_DRIVER_LOONGSON | AZX_DCAPS_NO_TCSEL },
 	{ PCI_VDEVICE(LOONGSON, PCI_DEVICE_ID_LOONGSON_HDMI),
 	  .driver_data = AZX_DRIVER_LOONGSON | AZX_DCAPS_NO_TCSEL },
+	/* Hygon HDAudio */
+	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_HYGON_18H_M05H_HDA),
+	  .driver_data = AZX_DRIVER_HYGON | AZX_DCAPS_POSFIX_LPIB | AZX_DCAPS_NO_MSI },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, azx_ids);
-- 
2.53.0



