Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCFE569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD21CC433D2;
	Sun, 28 May 2023 19:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301917;
	bh=ooO7p51311Fj1fQJr+hIDrUQSji1BBbn93jTT4YpTJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTwRO8tDC7cZwqMLLPJyP/Z0nZ2BPBxq66Bck2sDU7w6+1BSa9m29OFPut3KD3mqj
	 G/qDrotCd9T/sR/frJgpB6CT3GnXjqJN5snUomVaRmq6Rt/i5g7btbI7BZRk9lSU2G
	 zefW5xB9kKyE/PKrMNG60mekC8nkONKCCTBbKaX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Mahale <nmahale@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 087/161] ALSA: hda: Add NVIDIA codec IDs a3 through a7 to patch table
Date: Sun, 28 May 2023 20:10:11 +0100
Message-Id: <20230528190839.896103329@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikhil Mahale <nmahale@nvidia.com>

commit dc4f2ccaedddb489a83e7b12ebbdc347272aacc9 upstream.

These IDs are for AD102, AD103, AD104, AD106, and AD107 gpus with
audio functions that are largely similar to the existing ones.

Tested audio using gnome-settings, over HDMI, DP-SST and DP-MST
connections on AD106 gpu.

Signed-off-by: Nikhil Mahale <nmahale@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230517090736.15088-1-nmahale@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4197,6 +4197,11 @@ HDA_CODEC_ENTRY(0x10de009d, "GPU 9d HDMI
 HDA_CODEC_ENTRY(0x10de009e, "GPU 9e HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de009f, "GPU 9f HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a0, "GPU a0 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a3, "GPU a3 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a4, "GPU a4 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a5, "GPU a5 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a6, "GPU a6 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a7, "GPU a7 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de8001, "MCP73 HDMI",	patch_nvhdmi_2ch),
 HDA_CODEC_ENTRY(0x10de8067, "MCP67/68 HDMI",	patch_nvhdmi_2ch),
 HDA_CODEC_ENTRY(0x11069f80, "VX900 HDMI/DP",	patch_via_hdmi),


