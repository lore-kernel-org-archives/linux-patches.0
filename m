Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41E01C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54907C433EF;
	Mon, 20 Mar 2023 15:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324486;
	bh=88p+y96RFVtLR/W9g+4PK5rxdV6ML//27AwntK5NpVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6Yjc4PSArgKh4Zv4tVFS6+49vn3LtVFC6ua/a3IYYenU/kwOIdJIfn/ju+WR2CIx
	 g3fRFoTP/XaqHPO0p3OmMnG1iBogU0AUMzQnFjdQfZQ7ueKr5EZPXK009WWfaYuwrm
	 G7im4ta3c+KLfcB1o9Y0OAJnp1liimeBMzpZT6IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/60] ALSA: hda - add Intel DG1 PCI and HDMI ids
Date: Mon, 20 Mar 2023 15:54:18 +0100
Message-Id: <20230320145431.267543087@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 69b08bdfa8181bc7babd7d81c93dc60142c4bfd3 ]

Add Intel DG1 PCI id to list of supported HDA controllers and
add its HDMI id as well.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200921141741.2983072-2-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: ff447886e675 ("ALSA: hda: Match only Intel devices with CONTROLLER_IN_GPU()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c  | 3 +++
 sound/pci/hda/patch_hdmi.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index e387e8db65d22..c0b8844a2d5bd 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2501,6 +2501,9 @@ static const struct pci_device_id azx_ids[] = {
 	/* Tigerlake-H */
 	{ PCI_DEVICE(0x8086, 0x43c8),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	/* DG1 */
+	{ PCI_DEVICE(0x8086, 0x490d),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* Elkhart Lake */
 	{ PCI_DEVICE(0x8086, 0x4b55),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 54c67d8b7b493..bfa11073d9624 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4220,6 +4220,7 @@ HDA_CODEC_ENTRY(0x8086280c, "Cannonlake HDMI",	patch_i915_glk_hdmi),
 HDA_CODEC_ENTRY(0x8086280d, "Geminilake HDMI",	patch_i915_glk_hdmi),
 HDA_CODEC_ENTRY(0x8086280f, "Icelake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x80862812, "Tigerlake HDMI",	patch_i915_tgl_hdmi),
+HDA_CODEC_ENTRY(0x80862814, "DG1 HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x80862816, "Rocketlake HDMI",	patch_i915_tgl_hdmi),
 HDA_CODEC_ENTRY(0x8086281a, "Jasperlake HDMI",	patch_i915_icl_hdmi),
 HDA_CODEC_ENTRY(0x80862880, "CedarTrail HDMI",	patch_generic_hdmi),
-- 
2.39.2



