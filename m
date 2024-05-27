Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFB717E90E;
	Mon, 27 May 2024 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837056; cv=none; b=Jgn6917NMYJkQThMQKF124nUAj4FiIFokBSBDX8HYvdEWE+f/EkxzJJsuI7AqbXzVAOlLAiNc/Hj1yoIM6ZX92sGWteny0Y61e6/dJPjuqU9Q5BpQxa0VivJmLtvhrthdFUL6w/btlVBiQ7lPTgWBqeAkdRriMRQ+0rU6+WyOPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837056; c=relaxed/simple;
	bh=YsU0dHfDOQb36vAFHHSpV2nIzQ5/G/Wp3VTpQFewo0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaEPxyHrWSvJlA8QxCZuCp133Qinbs26P5tYjNCc9gJYDi2SeRa13JulxIzJFRAAZCUJvE234fTsLdRL+93oP/UwkTRcfvtsOQcP2AQHbq13tre8ZTHyUg7u7Lb0pfp8aTpQTgRb1xEpluKuUQnszeVdl/4dHvjGsRKB1spe9lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSgfB3C8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSgfB3C8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCB4C2BBFC;
	Mon, 27 May 2024 19:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837055;
	bh=YsU0dHfDOQb36vAFHHSpV2nIzQ5/G/Wp3VTpQFewo0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSgfB3C8W1u0qE36Y23gl8N/Hn6H16slHMMIhINibkrWuvOJmjz76zVZcrAG3Y5SE
	 EwifjBoBY9dCUaz0pMl3sTBMuNWAc2emFjYyNFofu30t2PlHCX4JUMFikktHqlikmM
	 S0gn2UXbZlBLiAYTdLPRYNNCHRrY4zK/Xqmu1XP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 293/427] drm/panel: ltk050h3146w: drop duplicate commands from LTK050H3148W init
Date: Mon, 27 May 2024 20:55:40 +0200
Message-ID: <20240527185629.703253916@linuxfoundation.org>
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

From: Heiko Stuebner <heiko.stuebner@cherry.de>

[ Upstream commit 55679cc22e60e8ec23b2340248389022798416cd ]

The init sequence specifies the 0x11 and 0x29 dsi commands, which are
the exit-sleep and display-on commands.

In the actual prepare step the driver already uses the appropriate
function calls for those, so drop the duplicates.

Fixes: e5f9d543419c ("drm/panel: ltk050h3146w: add support for Leadtek LTK050H3148W-CTA6 variant")
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240320131232.327196-2-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c b/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c
index 57b56ade48add..1a26205701b5e 100644
--- a/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c
+++ b/drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c
@@ -295,8 +295,6 @@ static int ltk050h3148w_init_sequence(struct ltk050h3146w *ctx)
 	mipi_dsi_dcs_write_seq(dsi, 0xbd, 0x00);
 	mipi_dsi_dcs_write_seq(dsi, 0xc6, 0xef);
 	mipi_dsi_dcs_write_seq(dsi, 0xd4, 0x02);
-	mipi_dsi_dcs_write_seq(dsi, 0x11);
-	mipi_dsi_dcs_write_seq(dsi, 0x29);
 
 	ret = mipi_dsi_dcs_set_tear_on(dsi, 1);
 	if (ret < 0) {
-- 
2.43.0



