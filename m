Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD025345752;
	Tue, 26 Aug 2025 14:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218604; cv=none; b=Bt+AYSYJuiWRMxatWn0yN/cxWFcuYAO5pH8nbJeWYV9wGoAkSEvNrDl1TDa8CBeer0k7M+LaiUsHgvqQiTzoqgXd6m0oznhUhIC1MYrnXPQXEKD9kffqxq6DRoCFC7Of91kWWdyxkLUzhSSSvwK1mOnhr0jdU1pm35kUcaahMIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218604; c=relaxed/simple;
	bh=IDUC2mDUnIZkcxyUlO/VGZEXCBQsdpRKYVfBojPxbyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDuLaiOO4jKLRi+rRsAkFqvaZ9EJK0NFMbiZEU4uOlCL5DUaWHda912m8NIsEAuwM4g7JaZV7JtY+6gBHD0ZLh3S+LKn0JImZi/fJiUKn6FX3I1VtQ/2ROjL5T9ePXxOg6NgAYt++JQ6rNK5YK1gVXtSIMXTZzE3l+br9GtX8zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diWrOevk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diWrOevk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8DEC4CEF1;
	Tue, 26 Aug 2025 14:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218604;
	bh=IDUC2mDUnIZkcxyUlO/VGZEXCBQsdpRKYVfBojPxbyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diWrOevkFd3O3ihyHzudQQjO7O6hT8z3CoXB22sI9o0Um2TwTqPS0l2opkb6DFMHn
	 lQOZEajgUxrf5mbsVo/pUUcDBC+L5RifNRD/cWXREbyyrurD/lSYVADc6Reqvzjzyd
	 eRimN35/TfyA0ylrTMQj/no1bFGjQ9clGRRl8nME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Dadap <ddadap@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/403] ALSA: hda: Add missing NVIDIA HDA codec IDs
Date: Tue, 26 Aug 2025 13:06:30 +0200
Message-ID: <20250826110907.844817547@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4161,6 +4161,8 @@ HDA_CODEC_ENTRY(0x10de002d, "Tegra186 HD
 HDA_CODEC_ENTRY(0x10de002e, "Tegra186 HDMI/DP1", patch_tegra_hdmi),
 HDA_CODEC_ENTRY(0x10de002f, "Tegra194 HDMI/DP2", patch_tegra_hdmi),
 HDA_CODEC_ENTRY(0x10de0030, "Tegra194 HDMI/DP3", patch_tegra_hdmi),
+HDA_CODEC_ENTRY(0x10de0033, "SoC 33 HDMI/DP",	patch_tegra_hdmi),
+HDA_CODEC_ENTRY(0x10de0035, "SoC 35 HDMI/DP",	patch_tegra_hdmi),
 HDA_CODEC_ENTRY(0x10de0040, "GPU 40 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0041, "GPU 41 HDMI/DP",	patch_nvhdmi),
 HDA_CODEC_ENTRY(0x10de0042, "GPU 42 HDMI/DP",	patch_nvhdmi),
@@ -4199,15 +4201,32 @@ HDA_CODEC_ENTRY(0x10de0097, "GPU 97 HDMI
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
 HDA_CODEC_ENTRY(0x11069f80, "VX900 HDMI/DP",	patch_via_hdmi),


