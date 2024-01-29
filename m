Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A594F15A492;
	Mon, 29 Jan 2024 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548283; cv=none; b=ny5nRFc/vTI3R/QE6YjS1E/q4chZ7imPM0ggySEGVpeN4jGgaPvFxn0xu0LM+BlfQh2rVaSpIwsxod+ZSaJNAWDUXbrdmNlh+14oH/uI6PI1NQPdx5OwQ9r1z59kofj6Wy8A9MoDXQiZDMckKcmYS4wHqUxQgGP1dRdZrGmhPTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548283; c=relaxed/simple;
	bh=V988f7AC7PElDecn8iKzuPqEPcL6HHkXzR1GImjWy+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXY3ZuasAekv1C7Ur3ThvOrdjVIojf2bFguUlXdcoQeL9wSIVbXGaC7iyZ3pPx9esoCp4ez3AWOdX8oSDz7IL/v4Rv9cUnju3R+1yZKCpybXk1f7pQgplJQCyem+V3mcFUqFJfIPHL1QqtI9KSM71Bhl+9tmG95n/p3Hq48KVME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+7L7uTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+7L7uTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCC0C433C7;
	Mon, 29 Jan 2024 17:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548283;
	bh=V988f7AC7PElDecn8iKzuPqEPcL6HHkXzR1GImjWy+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+7L7uTZOH1iQAQWhbsUdhMi9YUF1UD0rnQ7QuUb4oIbdHpjhOaNE95iB/5pm6AQT
	 vNC8bHGNx/euUeWnd3gGb/H7gwykF6ubdmXebF7NB53qo2S45d1LojZEvqEowBrUIt
	 +cqbgjsvMLS5182znaPeFTs84A9QlbcN1u7dqT40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 296/346] drm/panel-edp: drm/panel-edp: Fix AUO B116XTN02 name
Date: Mon, 29 Jan 2024 09:05:27 -0800
Message-ID: <20240129170025.119424467@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Yi Wang <hsinyi@chromium.org>

[ Upstream commit 962845c090c4f85fa4f6872a5b6c89ee61f53cc0 ]

Rename AUO 0x235c B116XTN02 to B116XTN02.3 according to decoding edid.

Fixes: 3db2420422a5 ("drm/panel-edp: Add AUO B116XTN02, BOE NT116WHM-N21,836X2, NV116WHM-N49 V8.0")
Cc: stable@vger.kernel.org
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231107204611.3082200-3-hsinyi@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index e93e54a98260..7dc6fb7308ce 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1842,7 +1842,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x145c, &delay_200_500_e50, "B116XAB01.4"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1e9b, &delay_200_500_e50, "B133UAN02.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1ea5, &delay_200_500_e50, "B116XAK01.6"),
-	EDP_PANEL_ENTRY('A', 'U', 'O', 0x235c, &delay_200_500_e50, "B116XTN02"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x235c, &delay_200_500_e50, "B116XTN02.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x405c, &auo_b116xak01.delay, "B116XAK01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x582d, &delay_200_500_e50, "B133UAN01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x615c, &delay_200_500_e50, "B116XAN06.1"),
-- 
2.43.0



