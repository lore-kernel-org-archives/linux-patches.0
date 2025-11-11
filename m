Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0FC3043C0;
	Tue, 11 Nov 2025 01:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823309; cv=none; b=JXmnm9mPLgqnpEKTFrtWFPV4oivH/MhMBxWA8PXrG0b/MsWPX0Gi2CY7+to3QDsQcvVHi9M7/7VuRoH3yq/RgYsC6sSV7N8qoChJh8KWbKh8VQ9SqPwdy4g/qjpTrY/Shhn/aWOhZm5a4TZxWn7coo4Ej13WGes0m9oTqsWEp7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823309; c=relaxed/simple;
	bh=t0L0aUeulu6TJIghlfADSsNZGym8kO7Oo2POKvhiOkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejqrZlEVy5yVJhI5ajhX4fCvoB/+M+7Pvj6jS/qXN1iYbneyMZcwTCwpo6BQI16HXkYtZ3PWChnC6AlFGyUynfaAz6hEo/nSaDq4HjJnM/+cKiLZFJI/AjXjQ7e8SGEDnL44UTplPT3UB71m4YKhJXUlG5Xp3XJfwBQPU8kGtHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvu+PTnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvu+PTnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4640C113D0;
	Tue, 11 Nov 2025 01:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823309;
	bh=t0L0aUeulu6TJIghlfADSsNZGym8kO7Oo2POKvhiOkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvu+PTnBXg2JllDFTbEOZXFFfKNqLQL/VuOaRsyQfgcCtzbqAjIEzKHho4VLkX8Ae
	 +qZxgY/X56bH/U7x40AYu/xyWtC06psy5107JCO4H6pU3N2WJgMavbVsT1Jtjf5XXm
	 0LtRABufdsVB3D9OW7qmJH56RcZrId+69LcZxGsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Orr <chris.orr@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 273/849] drm/panel-edp: Add SHP LQ134Z1 panel for Dell XPS 9345
Date: Tue, 11 Nov 2025 09:37:23 +0900
Message-ID: <20251111004543.030641840@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Orr <chris.orr@gmail.com>

[ Upstream commit 754dbf164acd4d22dd7a5241b1880f54546d68f2 ]

Introduce high-res OLED panel for the Dell XPS 9345

These timings were selected based on Alex Vinarkskis' commit,
(6b3815c6815f07acc7eeffa8ae734d1a1c0ee817) for the LQ134N1
and seem to work fine for the high-res OLED panel on the 9345.

The raw edid for this SHP panel is:

00 ff ff ff ff ff ff 00 4d 10 8f 15 00 00 00 00
2e 21 01 04 b5 1d 12 78 03 0f 95 ae 52 43 b0 26
0f 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 fd d7 00 a0 a0 40 fc 66 30 20
36 00 20 b4 10 00 00 18 00 00 00 fd 00 1e 78 cc
cc 38 01 0a 20 20 20 20 20 20 00 00 00 fe 00 43
37 31 4d 31 81 4c 51 31 33 34 5a 31 00 00 00 00
00 02 41 0c 32 01 01 00 00 0b 41 0a 20 20 01 ea

70 20 79 02 00 20 00 13 8c 52 19 8f 15 00 00 00
00 2e 17 07 4c 51 31 33 34 5a 31 21 00 1d 40 0b
08 07 00 0a 40 06 88 e1 fa 51 3d a4 b0 66 62 0f
02 45 54 d0 5f d0 5f 00 34 13 78 26 00 09 06 00
00 00 00 00 41 00 00 22 00 14 d9 6f 08 05 ff 09
9f 00 2f 00 1f 00 3f 06 5d 00 02 00 05 00 25 01
09 d9 6f 08 d9 6f 08 1e 78 80 81 00 0b e3 05 80
00 e6 06 05 01 6a 6a 39 00 00 00 00 00 00 58 90

Signed-off-by: Christopher Orr <chris.orr@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/aJKvm3SlhLGHW4qn@jander
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index d0aa602ecc9de..a926f81f7a2e1 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -2035,6 +2035,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('S', 'H', 'P', 0x1523, &delay_80_500_e50, "LQ140M1JW46"),
 	EDP_PANEL_ENTRY('S', 'H', 'P', 0x153a, &delay_200_500_e50, "LQ140T1JH01"),
 	EDP_PANEL_ENTRY('S', 'H', 'P', 0x154c, &delay_200_500_p2e100, "LQ116M1JW10"),
+	EDP_PANEL_ENTRY('S', 'H', 'P', 0x158f, &delay_200_500_p2e100, "LQ134Z1"),
 	EDP_PANEL_ENTRY('S', 'H', 'P', 0x1593, &delay_200_500_p2e100, "LQ134N1"),
 
 	EDP_PANEL_ENTRY('S', 'T', 'A', 0x0004, &delay_200_500_e200, "116KHD024006"),
-- 
2.51.0



