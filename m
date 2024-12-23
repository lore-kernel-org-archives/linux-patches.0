Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990402EAE6;
	Mon, 23 Dec 2024 16:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969937; cv=none; b=rky1e4OvVNBu7g2yqWBekArWeyZW3x86hqaz/iGHFYyNkMTnyzZjblmXdeuVvkky/1MkZW35o2wb1r8TdnooUS1u6qEfVimXKltw5GHtT/wRFbi/9G7WhL1pTMCsDGyNLw7LDW40vfsaeNlRmXlZHtZ1l27E1y3zb5t9boNh8m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969937; c=relaxed/simple;
	bh=y4Ogqgh4dbF4pnUIM3ZH1tTGRZ71AptGOj6VAhuhnwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHMstPJ5wTFdKs3CIN2dk1B0OSW2hrLd7l0CNoAIf//1ch4bmuhpmYSIyKhVgaenQcrc9NzxKDcugrHlUQzFJaHWMCr9YCHehNTcLdJ+WJOCA66Ja0wV+Wx2BPcZ+fPgTHCYrsv6QFALGRwcn0zQYVYzC5Ig12NsC04pq/kkd2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+adBZ0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+adBZ0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B3DC4CED3;
	Mon, 23 Dec 2024 16:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969937;
	bh=y4Ogqgh4dbF4pnUIM3ZH1tTGRZ71AptGOj6VAhuhnwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+adBZ0c4Rye4jM8vsO46wYwUpVUX3zVMvCGX0BWfyFXl3iwMa/hpEAnLFvwKn0Jy
	 GxDtOU5GR4U6XsAGnSuvwvPXDZRujaIxKJ9ni87y5wnvexsQIjM3fNDaPhgLEuNEc5
	 H28nlB05gxVt54qGg/4xBhH4EkRux6a9XQgTG3Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Michael Trimarchi <michael@amarulasolutions.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/160] drm/panel: synaptics-r63353: Fix regulator unbalance
Date: Mon, 23 Dec 2024 16:58:27 +0100
Message-ID: <20241223155412.400696667@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Trimarchi <michael@amarulasolutions.com>

[ Upstream commit d2bd3fcb825725a59c8880070b1206b1710922bd ]

The shutdown function can be called when the display is already
unprepared. For example during reboot this trigger a kernel
backlog. Calling the drm_panel_unprepare, allow us to avoid
to trigger the kernel warning.

Fixes: 2e87bad7cd33 ("drm/panel: Add Synaptics R63353 panel driver")
Tested-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Link: https://lore.kernel.org/r/20241205163002.1804784-1-dario.binacchi@amarulasolutions.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241205163002.1804784-1-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-synaptics-r63353.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-synaptics-r63353.c b/drivers/gpu/drm/panel/panel-synaptics-r63353.c
index 169c629746c7..17349825543f 100644
--- a/drivers/gpu/drm/panel/panel-synaptics-r63353.c
+++ b/drivers/gpu/drm/panel/panel-synaptics-r63353.c
@@ -325,7 +325,7 @@ static void r63353_panel_shutdown(struct mipi_dsi_device *dsi)
 {
 	struct r63353_panel *rpanel = mipi_dsi_get_drvdata(dsi);
 
-	r63353_panel_unprepare(&rpanel->base);
+	drm_panel_unprepare(&rpanel->base);
 }
 
 static const struct r63353_desc sharp_ls068b3sx02_data = {
-- 
2.39.5



