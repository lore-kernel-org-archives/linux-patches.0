Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54677136348;
	Mon, 23 Jun 2025 21:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715401; cv=none; b=Zdlq3ny2p8ZEMKqW36CtdjFsHWBI0BkRbFIexyLhY1Yznb1G5lxwkiG46PXUe9IskTP+mLSMJ7DiJOyIbaWQdzKkWAGWliBKO1TktHbBmrMs7RBoRoDkjv3kt3iPGLce3VKpxYghAK37DL6/pj/Je/7GnSPms0rFdzRG4EbExeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715401; c=relaxed/simple;
	bh=5e84Hv55r+Gv0Oli+bxhGlxI3HpDn9Sq+dwHgw4KycU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJJ2KFUMUSX/4gJIQ8+sfeYnxc7uyvDn/PBMr7KXu+qVdI3R0PpTQ9FnhR9Tlcxb5yX1mvdD8cqbnOvTqq2sGnF/yLgebt2BMXLrT5s11sLQfciYeU+AHpSD7qkbB0j5PkS8MUrBdSZxObIaVxr5k4ZJG5p7JWvmuNSNKyXStu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WW9BW4X6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WW9BW4X6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5F4C4CEEA;
	Mon, 23 Jun 2025 21:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715401;
	bh=5e84Hv55r+Gv0Oli+bxhGlxI3HpDn9Sq+dwHgw4KycU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WW9BW4X637JDyHjYHp7Mt6AFFCEYwFGHsUKRogmyTYzs2hMWQenMdGnMK52I3IKBw
	 ee3deNVH0mj5vpMY725NZ6UAHPCgbcNaMkOY9oGEPGyPZJzpepnPWmoMZrgj7Sry0x
	 uZ2LDnXaqsl/sAslvItVr1YfbASfwOW32ATwkPd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/414] ALSA: hda: cs35l41: Fix swapped l/r audio channels for Acer Helios laptops
Date: Mon, 23 Jun 2025 15:05:17 +0200
Message-ID: <20250623130646.526555592@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit e43a93c41982e82c1b703dd7fa9c1d965260fbb3 ]

Fixes audio channel assignment from ACPI using configuration table.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20250515162848.405055-3-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda_property.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/pci/hda/cs35l41_hda_property.c b/sound/pci/hda/cs35l41_hda_property.c
index 61d2314834e7b..d8249d997c2a0 100644
--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -31,6 +31,9 @@ struct cs35l41_config {
 };
 
 static const struct cs35l41_config cs35l41_config_table[] = {
+	{ "10251826", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
+	{ "1025182C", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
+	{ "10251844", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, -1, -1, 0, 0, 0 },
 	{ "10280B27", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
 	{ "10280B28", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
 	{ "10280BEB", 2, EXTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, -1, 0, 0, 0, 0 },
@@ -452,6 +455,9 @@ struct cs35l41_prop_model {
 static const struct cs35l41_prop_model cs35l41_prop_model_table[] = {
 	{ "CLSA0100", NULL, lenovo_legion_no_acpi },
 	{ "CLSA0101", NULL, lenovo_legion_no_acpi },
+	{ "CSC3551", "10251826", generic_dsd_config },
+	{ "CSC3551", "1025182C", generic_dsd_config },
+	{ "CSC3551", "10251844", generic_dsd_config },
 	{ "CSC3551", "10280B27", generic_dsd_config },
 	{ "CSC3551", "10280B28", generic_dsd_config },
 	{ "CSC3551", "10280BEB", generic_dsd_config },
-- 
2.39.5



