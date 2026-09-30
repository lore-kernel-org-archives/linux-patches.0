Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5953B51D503;
	Wed, 30 Sep 2026 18:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794010; cv=none; b=SRVHDYOAKNSPenCk5RO7j/uje3AfXT2yUvcTpgegEp1ssGx2srF5FTqdz2WWPx6/1BT/ECykXT3hKNHAJjTX81QXstv9NsHn38XhJGXWDmB1djMxl6+Av9PGlkVUkP6UmV9iloedhogBZQ5jYBhoIRNTtdtkK/LVOxftgZxO5Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794010; c=relaxed/simple;
	bh=dL5W07XPIjTbYbz+XvGI9sssUGtX73SDM39IYn6yz+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kn2bVo2ROxEfuTv/YctrrfWxgbsiV9+oJNdsn5Wh6zsT4dLiABSo11HiXF66OsrwdJhiBk2whoV58kJ5rIU2znI2zTB9fVLcp1htwBjxp6yAMp7r3eGhH6fm7jfV81rYR3eea3qPlIHaWZFJN/6GZBUENJ+u7M8lekWk/ZSVKyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPcB+FcJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPcB+FcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB31A1F000FF;
	Wed, 30 Sep 2026 18:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794009;
	bh=uA8je1jxt4h5NrOeKcc44MmQxZD8AUdRZ3pT/toCy1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPcB+FcJH7no8KdfE5EF/C3g1/njfyR9ESTQ3Ggi2DaKPnl5KOb/SadgA5k4IqWjt
	 6BBljUKQep7xAtSpEzliR30mT2RqykH60hGu0IZPn3UaDfkwVS424tLU+j1MhpQM6n
	 g5SpcHlSguTWCJ5bryHi8nZ1l6zZuRZb6YrKro34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Riccardo Mereu <r.mereu@arduino.cc>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0005/1193] drm/panel: jadard-jd9365da-h3: set prepare_prev_first
Date: Wed, 30 Sep 2026 17:11:29 +0200
Message-ID: <20260930152434.427564659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit b55a4b5d4769a650f52ea3f1ae680610169d125e ]

Sending DSI commands from the prepare() callback requires DSI link to be
up at that point. For DSI hosts is guaranteed only if the panel driver
sets the .prepare_prev_first flag. Set it to let these panels work with
the DSI hosts which don't power on the link in their .mode_set callback.

Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Riccardo Mereu <r.mereu@arduino.cc>
Link: https://patch.msgid.link/20260413-waveshare-dsi-touch-v3-13-3aeb53022c32@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c b/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
index 4879835fe101d..e7433ee109427 100644
--- a/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
+++ b/drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c
@@ -626,6 +626,8 @@ static int jadard_dsi_probe(struct mipi_dsi_device *dsi)
 	if (ret)
 		return ret;
 
+	jadard->panel.prepare_prev_first = true;
+
 	drm_panel_add(&jadard->panel);
 
 	mipi_dsi_set_drvdata(dsi, jadard);
-- 
2.53.0



