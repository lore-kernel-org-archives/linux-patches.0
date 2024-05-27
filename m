Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107AC17E90E;
	Mon, 27 May 2024 19:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837102; cv=none; b=bHEau+q+i7lwIQBlxni/PE3w8gyIQgidm2NT3HMdFiyJJDhXHhI+KiBDA6zGX3e20xiNTmu10KFXcGuHy433ser9nQ310CGziIzJPQSHNaEFOS8sDVUDq66lBFZt3ejfQYgkMntcszcxWCMghwHhuy0yMK2nZEmuRF3LRPIs5M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837102; c=relaxed/simple;
	bh=ENYqkh0v7EKIDMhJcn1+wXCTVc5cVWGfcV1RbVFVLyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONh12VRjBLZtUcYrVpInXrt4oBWVgWETwXW2PnTS3YOeSBnGyw03/OPDaVLis7KU3MwGjXzQml9fe5VkpavOYk+VgQ0W5tbpJGA/Oa8a+9VWrr3sahnL47ArzunogLw7neGqJP8t41kUWLNPXm1KSvOGWOKVMGTi02EfRwEBv00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+gjkFSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+gjkFSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99909C2BBFC;
	Mon, 27 May 2024 19:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837101;
	bh=ENYqkh0v7EKIDMhJcn1+wXCTVc5cVWGfcV1RbVFVLyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+gjkFSaUWVH3NOrZ41JpoQlqWuXPyb48zYCYeOp2PxSH2PYrRk2jaifUSFk9d62x
	 SNZDHDiid4vrwnWVyfWQPA2Bwr2fb2Q0y+2DuLohe3Ti69/2kY8kdqxMI9sOAnXhhO
	 SdFVArINON4dohxpgjO7KruW5dac7itqjSWYrMXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengqiao Xia <xiazhengqiao@huaqin.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 274/427] drm/panel-edp: Add prepare_to_enable to 200ms for MNC207QS1-1
Date: Mon, 27 May 2024 20:55:21 +0200
Message-ID: <20240527185628.091386056@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengqiao Xia <xiazhengqiao@huaqin.corp-partner.google.com>

[ Upstream commit e635b7eb7062b464bbd9795308b1a80eac0b01f5 ]

For MNC207QS1-1 panel, Splash screen occur when switch from VT1 to VT2.
The BL_EN signal does not conform to the VESA protocol.
BL_EN signal needs to be pulled high after video signal.
So add prepare_to_enable to 200ms.

[ dianders: Adjusted subject prefix and added Fixes tag ]

Fixes: 0547692ac146 ("drm/panel-edp: Add several generic edp panels")
Signed-off-by: Zhengqiao Xia <xiazhengqiao@huaqin.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240301084006.14422-1-xiazhengqiao@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index d58f90bc48fba..745f3e48f02ac 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1865,6 +1865,13 @@ static const struct panel_delay delay_200_500_e50 = {
 	.enable = 50,
 };
 
+static const struct panel_delay delay_200_500_e50_p2e200 = {
+	.hpd_absent = 200,
+	.unprepare = 500,
+	.enable = 50,
+	.prepare_to_enable = 200,
+};
+
 static const struct panel_delay delay_200_500_e80 = {
 	.hpd_absent = 200,
 	.unprepare = 500,
@@ -2034,7 +2041,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x14d6, &delay_200_500_e80_d50, "N140BGA-EA4"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x14e5, &delay_200_500_e80_d50, "N140HGA-EA1"),
 
-	EDP_PANEL_ENTRY('C', 'S', 'O', 0x1200, &delay_200_500_e50, "MNC207QS1-1"),
+	EDP_PANEL_ENTRY('C', 'S', 'O', 0x1200, &delay_200_500_e50_p2e200, "MNC207QS1-1"),
 
 	EDP_PANEL_ENTRY('H', 'K', 'C', 0x2d51, &delay_200_500_e200, "Unknown"),
 	EDP_PANEL_ENTRY('H', 'K', 'C', 0x2d5b, &delay_200_500_e200, "Unknown"),
-- 
2.43.0



