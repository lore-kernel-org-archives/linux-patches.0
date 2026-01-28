Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31932874FE;
	Wed, 28 Jan 2026 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615878; cv=none; b=eUWKikYO8qdO0J/jOKxLJ5Qa2ncpfCfilEdoEORgTwKCakDDDP0F2pytKzBuqWwdswABf3yXefZZS3BG4cL/FHMHR4au8aPuLOctAISuDDFr1ulYT0Da/4JKihVjViRWenxEdfwjiB2i1/NFPLxwJiMyCGyCtsn6DzAs6zbIFuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615878; c=relaxed/simple;
	bh=IZsMG+EvL7VGf5vOKHBZaCgDAzNbpzqVm11d1NMcfBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9KiT7jd6KB6JkWjx713swZ0H/+bA9FY7uEQWdZyUzibcl0APNo6ogG+cYsl5TxfaRwjrm2XNO8yKGYid7mhZdkcTSrUiwRjYokckyOWP22i2elQzgHaleq0b1/3hvmvFz/hVHCGmpbVViUlj72/sqcEmAm6iQ5Npbw76lHo3HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/tJ2xO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/tJ2xO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED88C4CEF7;
	Wed, 28 Jan 2026 15:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615877;
	bh=IZsMG+EvL7VGf5vOKHBZaCgDAzNbpzqVm11d1NMcfBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/tJ2xO7Xkg/yaAJBRCtmQiwe4MLqb0+pN16X4LQSoyxVK1HK6qQGdH/oQjW5aZRj
	 40Ot+ncLgOTF5h9UkqQoWgqO99nfQn53e5FBMH+ZpimiW+W/1xxnIPbnjSv6hhResl
	 nbeRKvA07MWGkFlGPXMeIZVHPljyLPY0w6mFWIXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alex=20Ram=C3=ADrez?= <lxrmrz732@rocketmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/227] drm/nouveau: add missing DCB connector types
Date: Wed, 28 Jan 2026 16:22:58 +0100
Message-ID: <20260128145349.245014916@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Ramírez <lxrmrz732@rocketmail.com>

[ Upstream commit 3036b4ce4b209af690fa776e4616925892caba4c ]

* Add missing DCB connectors in conn.h as per the NVIDIA DCB specification.

A lot of connector logic was rewritten for Linux v6.5; some display connector types
went unaccounted-for which caused kernel warnings on devices with the now-unsupported
DCB connectors. This patch adds all of the DCB connectors as defined by NVIDIA to the
dcb_connector_type enum to bring back support for these connectors to the new logic.

Fixes: 8b7d92cad953 ("drm/nouveau/kms/nv50-: create connectors based on nvkm info")
Link: https://download.nvidia.com/open-gpu-doc/DCB/1/DCB-4.0-Specification.html#_connector_table_entry
Signed-off-by: Alex Ramírez <lxrmrz732@rocketmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
[Lyude: Clarify DCB_CONNECTOR_HDMI_0 weirdness in comments]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20251213005327.9495-2-lxrmrz732@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../nouveau/include/nvkm/subdev/bios/conn.h   | 95 +++++++++++++++----
 1 file changed, 74 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h b/drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h
index d1beaad0c82b6..834ed6587aa52 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h
@@ -1,28 +1,81 @@
 /* SPDX-License-Identifier: MIT */
 #ifndef __NVBIOS_CONN_H__
 #define __NVBIOS_CONN_H__
+
+/*
+ * An enumerator representing all of the possible VBIOS connector types defined
+ * by Nvidia at
+ * https://nvidia.github.io/open-gpu-doc/DCB/DCB-4.x-Specification.html.
+ *
+ * [1] Nvidia's documentation actually claims DCB_CONNECTOR_HDMI_0 is a "3-Pin
+ *     DIN Stereo Connector". This seems very likely to be a documentation typo
+ *     or some sort of funny historical baggage, because we've treated this
+ *     connector type as HDMI for years without issue.
+ *     TODO: Check with Nvidia what's actually happening here.
+ */
 enum dcb_connector_type {
-	DCB_CONNECTOR_VGA = 0x00,
-	DCB_CONNECTOR_TV_0 = 0x10,
-	DCB_CONNECTOR_TV_1 = 0x11,
-	DCB_CONNECTOR_TV_3 = 0x13,
-	DCB_CONNECTOR_DVI_I = 0x30,
-	DCB_CONNECTOR_DVI_D = 0x31,
-	DCB_CONNECTOR_DMS59_0 = 0x38,
-	DCB_CONNECTOR_DMS59_1 = 0x39,
-	DCB_CONNECTOR_LVDS = 0x40,
-	DCB_CONNECTOR_LVDS_SPWG = 0x41,
-	DCB_CONNECTOR_DP = 0x46,
-	DCB_CONNECTOR_eDP = 0x47,
-	DCB_CONNECTOR_mDP = 0x48,
-	DCB_CONNECTOR_HDMI_0 = 0x60,
-	DCB_CONNECTOR_HDMI_1 = 0x61,
-	DCB_CONNECTOR_HDMI_C = 0x63,
-	DCB_CONNECTOR_DMS59_DP0 = 0x64,
-	DCB_CONNECTOR_DMS59_DP1 = 0x65,
-	DCB_CONNECTOR_WFD	= 0x70,
-	DCB_CONNECTOR_USB_C = 0x71,
-	DCB_CONNECTOR_NONE = 0xff
+	/* Analog outputs */
+	DCB_CONNECTOR_VGA = 0x00,		// VGA 15-pin connector
+	DCB_CONNECTOR_DVI_A = 0x01,		// DVI-A
+	DCB_CONNECTOR_POD_VGA = 0x02,		// Pod - VGA 15-pin connector
+	DCB_CONNECTOR_TV_0 = 0x10,		// TV - Composite Out
+	DCB_CONNECTOR_TV_1 = 0x11,		// TV - S-Video Out
+	DCB_CONNECTOR_TV_2 = 0x12,		// TV - S-Video Breakout - Composite
+	DCB_CONNECTOR_TV_3 = 0x13,		// HDTV Component - YPrPb
+	DCB_CONNECTOR_TV_SCART = 0x14,		// TV - SCART Connector
+	DCB_CONNECTOR_TV_SCART_D = 0x16,	// TV - Composite SCART over D-connector
+	DCB_CONNECTOR_TV_DTERM = 0x17,		// HDTV - D-connector (EIAJ4120)
+	DCB_CONNECTOR_POD_TV_3 = 0x18,		// Pod - HDTV - YPrPb
+	DCB_CONNECTOR_POD_TV_1 = 0x19,		// Pod - S-Video
+	DCB_CONNECTOR_POD_TV_0 = 0x1a,		// Pod - Composite
+
+	/* DVI digital outputs */
+	DCB_CONNECTOR_DVI_I_TV_1 = 0x20,	// DVI-I-TV-S-Video
+	DCB_CONNECTOR_DVI_I_TV_0 = 0x21,	// DVI-I-TV-Composite
+	DCB_CONNECTOR_DVI_I_TV_2 = 0x22,	// DVI-I-TV-S-Video Breakout-Composite
+	DCB_CONNECTOR_DVI_I = 0x30,		// DVI-I
+	DCB_CONNECTOR_DVI_D = 0x31,		// DVI-D
+	DCB_CONNECTOR_DVI_ADC = 0x32,		// Apple Display Connector (ADC)
+	DCB_CONNECTOR_DMS59_0 = 0x38,		// LFH-DVI-I-1
+	DCB_CONNECTOR_DMS59_1 = 0x39,		// LFH-DVI-I-2
+	DCB_CONNECTOR_BNC = 0x3c,		// BNC Connector [for SDI?]
+
+	/* LVDS / TMDS digital outputs */
+	DCB_CONNECTOR_LVDS = 0x40,		// LVDS-SPWG-Attached [is this name correct?]
+	DCB_CONNECTOR_LVDS_SPWG = 0x41,		// LVDS-OEM-Attached (non-removable)
+	DCB_CONNECTOR_LVDS_REM = 0x42,		// LVDS-SPWG-Detached [following naming above]
+	DCB_CONNECTOR_LVDS_SPWG_REM = 0x43,	// LVDS-OEM-Detached (removable)
+	DCB_CONNECTOR_TMDS = 0x45,		// TMDS-OEM-Attached (non-removable)
+
+	/* DP digital outputs */
+	DCB_CONNECTOR_DP = 0x46,		// DisplayPort External Connector
+	DCB_CONNECTOR_eDP = 0x47,		// DisplayPort Internal Connector
+	DCB_CONNECTOR_mDP = 0x48,		// DisplayPort (Mini) External Connector
+
+	/* Dock outputs (not used) */
+	DCB_CONNECTOR_DOCK_VGA_0 = 0x50,	// VGA 15-pin if not docked
+	DCB_CONNECTOR_DOCK_VGA_1 = 0x51,	// VGA 15-pin if docked
+	DCB_CONNECTOR_DOCK_DVI_I_0 = 0x52,	// DVI-I if not docked
+	DCB_CONNECTOR_DOCK_DVI_I_1 = 0x53,	// DVI-I if docked
+	DCB_CONNECTOR_DOCK_DVI_D_0 = 0x54,	// DVI-D if not docked
+	DCB_CONNECTOR_DOCK_DVI_D_1 = 0x55,	// DVI-D if docked
+	DCB_CONNECTOR_DOCK_DP_0 = 0x56,		// DisplayPort if not docked
+	DCB_CONNECTOR_DOCK_DP_1 = 0x57,		// DisplayPort if docked
+	DCB_CONNECTOR_DOCK_mDP_0 = 0x58,	// DisplayPort (Mini) if not docked
+	DCB_CONNECTOR_DOCK_mDP_1 = 0x59,	// DisplayPort (Mini) if docked
+
+	/* HDMI? digital outputs */
+	DCB_CONNECTOR_HDMI_0 = 0x60,		// HDMI? See [1] in top-level enum comment above
+	DCB_CONNECTOR_HDMI_1 = 0x61,		// HDMI-A connector
+	DCB_CONNECTOR_SPDIF = 0x62,		// Audio S/PDIF connector
+	DCB_CONNECTOR_HDMI_C = 0x63,		// HDMI-C (Mini) connector
+
+	/* Misc. digital outputs */
+	DCB_CONNECTOR_DMS59_DP0 = 0x64,		// LFH-DP-1
+	DCB_CONNECTOR_DMS59_DP1 = 0x65,		// LFH-DP-2
+	DCB_CONNECTOR_WFD = 0x70,		// Virtual connector for Wifi Display (WFD)
+	DCB_CONNECTOR_USB_C = 0x71,		// [DP over USB-C; not present in docs]
+	DCB_CONNECTOR_NONE = 0xff		// Skip Entry
 };
 
 struct nvbios_connT {
-- 
2.51.0



