Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E036F1BDEC;
	Wed,  3 Jan 2024 17:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAU6vJXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B88C433C7;
	Wed,  3 Jan 2024 17:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301873;
	bh=DgVeq1KRqeXod0ETDD6488iwAEoIpkZE/qVgVxGoWCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAU6vJXaVdQyRQO1mXf7AN3Ipr3HHYvz2oE/Fg/CVa+oXNw21AmYNzAkjcv+5rqMt
	 2z9X73UpDnrx/kJzuP+0lcAALQQXqe5mAJgqfHoZ1/Unwt+oa7J+IYKBx01E9/Cj48
	 /HHGnIW1qZCvE+RYyxsw/Ks0kV/wgaJ43VgKYFLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Saarinen <jani.saarinen@intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/75] ALSA: hda/hdmi: add force-connect quirk for NUC5CPYB
Date: Wed,  3 Jan 2024 17:55:05 +0100
Message-ID: <20240103164846.836582201@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 3b1ff57e24a7bcd2e2a8426dd2013a80d1fa96eb ]

Add one more older NUC model that requires quirk to force all pins to be
connected. The display codec pins are not registered properly without
the force-connect quirk. The codec will report only one pin as having
external connectivity, but i915 finds all three connectors on the
system, so the two drivers are not in sync.

Issue found with DRM igt-gpu-tools test kms_hdmi_inject@inject-audio.

Link: https://gitlab.freedesktop.org/drm/igt-gpu-tools/-/issues/3
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Saarinen <jani.saarinen@intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231208132127.2438067-2-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 3060dbf1daf58..0d1c6c4c1ee62 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1970,6 +1970,7 @@ static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x1043, 0x86ae, "ASUS", 1),  /* Z170 PRO */
 	SND_PCI_QUIRK(0x1043, 0x86c7, "ASUS", 1),  /* Z170M PLUS */
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
+	SND_PCI_QUIRK(0x8086, 0x2060, "Intel NUC5CPYB", 1),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", 1),
 	{}
 };
-- 
2.43.0



