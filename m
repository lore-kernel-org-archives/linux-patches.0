Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F52834A338;
	Tue, 26 Aug 2025 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217332; cv=none; b=Yrkx7o9QjRInqxWWGaToTpyeJD//XjLkGkLYU7kkEcbC6eeAKal8q/IM9e5p4YG4wJKj2EJb3znkXoxfcL3OrdoZJcBtx67hbkSe674Wvz6k/USlAzdgKizKqfrlJGGuJ+l85JZtbQCcWDWjGA++ucKcuPepDZgc4V9IUyCEH74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217332; c=relaxed/simple;
	bh=AFxB4hD66AG5bpDA7zgesIeayVaTESltu9kLsebdKto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Es4Pb1pL/gWJ/3Q2Jho51H32uekOyviyFpb7g/vCvPITC//CRKKCvxudts8QaT6h1aiv6KiqjIbaF+NkEeSHRRpr9y3UXtDb6fGQDQEs3LRpVLqL2gdK8aRLqTagnsnAZE7+8V2txEr6DlaygGT8UWg7jbBx+KMcoIxg4xJLfkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zu1sUkO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zu1sUkO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DC3C4CEF1;
	Tue, 26 Aug 2025 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217332;
	bh=AFxB4hD66AG5bpDA7zgesIeayVaTESltu9kLsebdKto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zu1sUkO/ADP8Y58WfBu3m5l17LMG/ZxRG1P8e89gyK8ljdOwa4SCO5np37bKRPi2b
	 RStEmTPc9rOv4hheGnZwISttjYXtqCDpcVG1VKBSZPlAlaZPVQP3K8fib2mZ5D+RV3
	 e1UCI3IytTG9I9aUR/zgeV45m3GNbhUEFAOY5Yss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Dadap <ddadap@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/523] ALSA: hda: Add missing NVIDIA HDA codec IDs
Date: Tue, 26 Aug 2025 13:04:42 +0200
Message-ID: <20250826110926.348153365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Dadap <ddadap@nvidia.com>

commit e0a911ac86857a73182edde9e50d9b4b949b7f01 upstream.

Add codec IDs for several NVIDIA products with HDA controllers to the
snd_hda_id_hdmi[] patch table.

Signed-off-by: Daniel Dadap <ddadap@nvidia.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/aF24rqwMKFWoHu12@ddadap-lakeline.nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ change patch_tegra234_hdmi function calls to patch_tegra_hdmi ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -4354,6 +4354,8 @@ HDA_CODEC_ENTRY(0x10de002d, "Tegra186 HD
 HDA_CODEC_ENTRY(0x10de002e, "Tegra186 HDMI/DP1", patch_tegra_hdmi),
 HDA_CODEC_ENTRY(0x10de002f, "Tegra194 HDMI/DP2", patch_tegra_hdmi),
 HDA_CODEC_ENTRY(0x10de0030, "Tegra194 HDMI/DP3", patch_tegra_hdmi),
+HDA_CODEC_ENTRY(0x10de0033, "SoC 33 HDMI/DP",	patch_tegra_hdmi),
+HDA_CODEC_ENTRY(0x10de0035, "SoC 35 HDMI/DP",	patch_tegra_hdmi),
 HDA_CODEC_ENTRY(0x10de0040, "GPU 40 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0041, "GPU 41 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0042, "GPU 42 HDMI/DP",	patch_nvhdmi),
@@ -4392,15 +4394,32 @@ HDA_CODEC_ENTRY(0x10de0097, "GPU 97 HDMI
 HDA_CODEC_ENTRY(0x10de0098, "GPU 98 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0099, "GPU 99 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de009a, "GPU 9a HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de009b, "GPU 9b HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de009c, "GPU 9c HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de009d, "GPU 9d HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de009e, "GPU 9e HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de009f, "GPU 9f HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a0, "GPU a0 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a1, "GPU a1 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a3, "GPU a3 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a4, "GPU a4 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a5, "GPU a5 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a6, "GPU a6 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de00a7, "GPU a7 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a8, "GPU a8 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00a9, "GPU a9 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00aa, "GPU aa HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00ab, "GPU ab HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00ad, "GPU ad HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00ae, "GPU ae HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00af, "GPU af HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00b0, "GPU b0 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00b1, "GPU b1 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00c0, "GPU c0 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00c1, "GPU c1 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00c3, "GPU c3 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00c4, "GPU c4 HDMI/DP",	patch_nvhdmi),
+HDA_CODEC_ENTRY(0x10de00c5, "GPU c5 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de8001, "MCP73 HDMI",	patch_nvhdmi_2ch),
 HDA_CODEC_ENTRY(0x10de8067, "MCP67/68 HDMI",	patch_nvhdmi_2ch),
 HDA_CODEC_ENTRY(0x67663d82, "Arise 82 HDMI/DP",	patch_gf_hdmi),


