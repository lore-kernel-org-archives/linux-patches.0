Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033510;
	b=U6lob+7TBChoVm/OfO3Klk10fm5l1lr3C0z7q6F802+dIx11p/sZgfKkGinw/v6WCdR4
	 cfxGwzdBxNleUfOc0PymtnJudc78OLchaXPdIoZmn6G5QQppUjtxXAZGCQG9/rxXG43LH
	 i1es52Y3QMb2RyNO3bh06s1tLROEwtniztUd75bN7kc94ghcuvqHZ3gkTfoQMSo6+GqM4
	 1k5tq6f5LAmBBwMOPdupH6t3047MrzRN0RzTD7+N7VFfk/z8T7OoP5hMiuco/NH1gZpTW
	 /Fu7rMvjVBkMNy+7/v6C+Amkn5GkZnzbp7g2sb+XEya2OecZiIfiDcfJiMgeNo1uy1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fXbT1tAs2v643qxd9fsnck+gOj0VjagjoyWT6ICa8/E=;
	b=NdL8LLUIWV+zU01LpVgH+oWpLsTUzyBOshpPCwF8OHnDdgxRjWAZRx4tsWDSCTG1STgR
	 JbGIUD+LM9/V/BWeX/dTGPhDuC4uLY0y/3C752h+qgrRE+eSSCpYwnHzSz3HG5RkVVpBz
	 +nc4/i+OwBFjq8xMN0457xAsHZvLPsdgkfA0tqbxeBMf9yPVG2FsaUYi/Sxt5HZymEJft
	 H7nsW8/2CKk3c/tsRp23ncAcc474/+NXLfBcXmQACVQaPIxte36gFyo42LT/VgNy9aKCd
	 mSLudo4VDlITvKvVkFkFp0la0HXPrunPXuN2TR5zsvdjjFTmr+HRtGdgHi0rnW6V/8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0BqxONdh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD52F606A325;
	Wed, 18 Nov 2026 20:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0BqxONdh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1040D1F000C4;
	Wed, 18 Nov 2026 20:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033510;
	bh=fXbT1tAs2v643qxd9fsnck+gOj0VjagjoyWT6ICa8/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BqxONdhjEn+WkCd0JcUsNi9sjxSxVQtZeSzxIJGb/z/Kh1vAzG3nlLOQyQhjnTsb
	 1SsaX5oepzxnGmrLabwIGzhyJ6/kl5rLKkuUa1xDyR4jpW9/en5qSBt06m8CDAXvAX
	 SB2xg3dvwxd+Z8DjLSLwj8/v38Om6bzQetrjms+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0041/3318] drm/panel-edp: Add BOE NE160QDM-NY1 panel
Date: Wed, 18 Nov 2026 15:11:03 +0100
Message-ID: <20261118150315.096016802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit be4f10d44757211fd656fa57f37034657f26c883 ]

Add an entry for the BOE NE160QDM-NY1 eDP panel. The panel's AUX
backlight functionality is verified and working on the RK3576 EVB1
board.

edid-decode (hex):

00 ff ff ff ff ff ff 00 09 e5 85 09 00 00 00 00
1c 1e 01 04 b5 22 15 78 03 7c e5 a4 55 4c 9f 26
0f 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 6b 6e 00 a0 a0 40 84 60 30 20
36 00 58 d7 10 00 00 1a 00 00 00 fd 0c 3c a5 1f
1f 4e 01 0a 20 20 20 20 20 20 00 00 00 fe 00 42
4f 45 20 43 51 0a 20 20 20 20 20 20 00 00 00 fe
00 4e 45 31 36 30 51 44 4d 2d 4e 59 31 0a 01 ed

02 03 1d 00 e3 05 80 00 e6 06 05 01 6a 6a 24 6d
1a 00 00 02 03 3c a5 00 04 6a 24 6a 24 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff

Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260625071916.744686-1-damon.ding@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index aacc5cf758d93..6a3107be3d2ef 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1906,6 +1906,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x094b, &delay_200_500_e50, "NT116WHM-N21"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x095f, &delay_200_500_e50, "NE135FBM-N41 v8.1"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0979, &delay_200_500_e50, "NV116WHM-N49 V8.0"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0985, &delay_200_500_e50, "NE160QDM-NY1"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x098d, &boe_nv110wtm_n61.delay, "NV110WTM-N61"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x09dd, &delay_200_500_e50, "NT116WHM-N21"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a5d, &delay_200_500_e50, "NV116WHM-N45"),
-- 
2.53.0



