Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886653074B3;
	Tue,  2 Sep 2025 13:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819877; cv=none; b=lkO/mpz0JcTqikI4JlcJMZOtJhb1hJZN38VCl0jZqx6EolzM7JkR52c3v+eU1dtgLHEHw6MDufqJCgSfHWVQFwDD3wiMLbDPYxXkGVQMsAEUEjjjWbLjbprOOcOtnUU/1sW0Jtk1WTqImgymYIMtPUIBe/OiHwNK0RyqBC5OzTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819877; c=relaxed/simple;
	bh=i0CGpNjW31RRXURtCWiqLIk6S4VVuiHSdvwuH1ybBWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0CbxLQjqwj5GyqwQkq0XPZg49AwKBHIudie1YNVd62zkEgluGsgXtDMB8hUPwWDyR2oOu0bHoZ5ydGdepEZpU77hMHVpg8I+Z1MNC/COwrszfaHfmENUHIvdzaL30o2kqTVQMmRPgqyO5y4km+Jy/zarFCIOkWKX6M0YgK1dtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YxdJ1qFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YxdJ1qFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078A0C4CEED;
	Tue,  2 Sep 2025 13:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819877;
	bh=i0CGpNjW31RRXURtCWiqLIk6S4VVuiHSdvwuH1ybBWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YxdJ1qFwq/OjAUGAwuGzXqJBx6EIX3cmU882U0/idLh+v4KPvIQlIb6UKpWsj6GJi
	 g+sOl8h445ZzskEPcappPincFiz2Ye/YjY7y+7IhDAUKOGBigIKZ5cwT2kwwZaWPQ4
	 mHYi/CYrHcsIwaPGVNjjeCt7SlA7gr/XKNNbhKpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayushi Makhija <quic_amakhija@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 23/95] drm/msm: update the high bitfield of certain DSI registers
Date: Tue,  2 Sep 2025 15:19:59 +0200
Message-ID: <20250902131940.504283170@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

From: Ayushi Makhija <quic_amakhija@quicinc.com>

[ Upstream commit 494045c561e68945b1183ff416b8db8e37a122d6 ]

Currently, the high bitfield of certain DSI registers
do not align with the configuration of the SWI registers
description. This can lead to wrong programming these DSI
registers, for example for 4k resloution where H_TOTAL is
taking 13 bits but software is programming only 12 bits
because of the incorrect bitmask for H_TOTAL bitfeild,
this is causing DSI FIFO errors. To resolve this issue,
increase the high bitfield of the DSI registers from 12 bits
to 16 bits in dsi.xml to match the SWI register configuration.

Signed-off-by: Ayushi Makhija <quic_amakhija@quicinc.com>
Fixes: 4f52f5e63b62 ("drm/msm: import XML display registers database")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/666229/
Link: https://lore.kernel.org/r/20250730123938.1038640-1-quic_amakhija@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/registers/display/dsi.xml | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/msm/registers/display/dsi.xml b/drivers/gpu/drm/msm/registers/display/dsi.xml
index 501ffc585a9f6..c7a7b633d747b 100644
--- a/drivers/gpu/drm/msm/registers/display/dsi.xml
+++ b/drivers/gpu/drm/msm/registers/display/dsi.xml
@@ -159,28 +159,28 @@ xsi:schemaLocation="https://gitlab.freedesktop.org/freedreno/ rules-fd.xsd">
 		<bitfield name="RGB_SWAP" low="12" high="14" type="dsi_rgb_swap"/>
 	</reg32>
 	<reg32 offset="0x00020" name="ACTIVE_H">
-		<bitfield name="START" low="0" high="11" type="uint"/>
-		<bitfield name="END" low="16" high="27" type="uint"/>
+		<bitfield name="START" low="0" high="15" type="uint"/>
+		<bitfield name="END" low="16" high="31" type="uint"/>
 	</reg32>
 	<reg32 offset="0x00024" name="ACTIVE_V">
-		<bitfield name="START" low="0" high="11" type="uint"/>
-		<bitfield name="END" low="16" high="27" type="uint"/>
+		<bitfield name="START" low="0" high="15" type="uint"/>
+		<bitfield name="END" low="16" high="31" type="uint"/>
 	</reg32>
 	<reg32 offset="0x00028" name="TOTAL">
-		<bitfield name="H_TOTAL" low="0" high="11" type="uint"/>
-		<bitfield name="V_TOTAL" low="16" high="27" type="uint"/>
+		<bitfield name="H_TOTAL" low="0" high="15" type="uint"/>
+		<bitfield name="V_TOTAL" low="16" high="31" type="uint"/>
 	</reg32>
 	<reg32 offset="0x0002c" name="ACTIVE_HSYNC">
-		<bitfield name="START" low="0" high="11" type="uint"/>
-		<bitfield name="END" low="16" high="27" type="uint"/>
+		<bitfield name="START" low="0" high="15" type="uint"/>
+		<bitfield name="END" low="16" high="31" type="uint"/>
 	</reg32>
 	<reg32 offset="0x00030" name="ACTIVE_VSYNC_HPOS">
-		<bitfield name="START" low="0" high="11" type="uint"/>
-		<bitfield name="END" low="16" high="27" type="uint"/>
+		<bitfield name="START" low="0" high="15" type="uint"/>
+		<bitfield name="END" low="16" high="31" type="uint"/>
 	</reg32>
 	<reg32 offset="0x00034" name="ACTIVE_VSYNC_VPOS">
-		<bitfield name="START" low="0" high="11" type="uint"/>
-		<bitfield name="END" low="16" high="27" type="uint"/>
+		<bitfield name="START" low="0" high="15" type="uint"/>
+		<bitfield name="END" low="16" high="31" type="uint"/>
 	</reg32>
 
 	<reg32 offset="0x00038" name="CMD_DMA_CTRL">
@@ -209,8 +209,8 @@ xsi:schemaLocation="https://gitlab.freedesktop.org/freedreno/ rules-fd.xsd">
 		<bitfield name="WORD_COUNT" low="16" high="31" type="uint"/>
 	</reg32>
 	<reg32 offset="0x00058" name="CMD_MDP_STREAM0_TOTAL">
-		<bitfield name="H_TOTAL" low="0" high="11" type="uint"/>
-		<bitfield name="V_TOTAL" low="16" high="27" type="uint"/>
+		<bitfield name="H_TOTAL" low="0" high="15" type="uint"/>
+		<bitfield name="V_TOTAL" low="16" high="31" type="uint"/>
 	</reg32>
 	<reg32 offset="0x0005c" name="CMD_MDP_STREAM1_CTRL">
 		<bitfield name="DATA_TYPE" low="0" high="5" type="uint"/>
-- 
2.50.1



