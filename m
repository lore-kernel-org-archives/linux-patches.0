Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AE83EAC82;
	Wed, 20 May 2026 18:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300431; cv=none; b=Tvjs9m0O2rQgbkUbrMz+g1w/sHHKn2v8VL6hOO24QqfYkCsnLQ29sssBTV+Br2UbhVtioRhujWnW1iRHozR+bCp2FNmRKjsfiLwRvywUpksayuV2GLuBPhOMfNXs1I6dyXwP9ovDYW5foyCGAAesa0BwVu1shySZe2wlQ6yFPeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300431; c=relaxed/simple;
	bh=ybetXSr5sxW237+j86bPRJzJ/Ab7uv0brKnar+yzebI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOW3eNynWFDsm4TxSq1MI7+dOr+CdEkhxeNNve26U5AfB7tJSgduPpyHhiaUcWqbdMjpKpxrsLU4kV/PFUqGomqHZ0HVdREdvFSOb5/g9CmbkXazrwCYG+QLi518kaB7J87/kMwu5hZAWKn03JgFJZ6hpVuckaBtChvw5fcBcss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w45knjnt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w45knjnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B781F000E9;
	Wed, 20 May 2026 18:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300430;
	bh=YOpLNBTI6g5RhMi9rZQ4x/Uw8+wSgJihYdxH44O7O5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w45knjnt0zCWo2m9jbh/3AG8sjPjU0TIBlgluNMDLvfcD3eSP1q7rtp/N5YSxG0HS
	 dqN0aV11zYqcGkcVFEIFWLC/TkJHxClkByP7fTwV5v+7odRg8Bebnl982H3MLMNSsb
	 Bb/34e4uxlJwEYl0hLL+Qa8rExZl9fGWkJd0VYqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ian Ray <ian.ray@gehealthcare.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/666] drm/panel: simple: Correct G190EAN01 prepare timing
Date: Wed, 20 May 2026 18:16:24 +0200
Message-ID: <20260520162114.952684628@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit f1080f82570b797598c1ba7e9c800ae9e94aafc6 ]

The prepare timing specified by the G190EAN01 datasheet should be
between 30 and 50 ms. Considering it might take some time for the
LVDS encoder to enable the signal, we should only wait the min.
required time in the panel driver and not the max. allowed time.

Fixes: 2f7b832fc992 ("drm/panel: simple: Add support for AUO G190EAN01 panel")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260217142528.68613-1-ian.ray@gehealthcare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 32d876f6684e2..a0e2da2953768 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1260,7 +1260,7 @@ static const struct panel_desc auo_g190ean01 = {
 		.height = 301,
 	},
 	.delay = {
-		.prepare = 50,
+		.prepare = 30,
 		.enable = 200,
 		.disable = 110,
 		.unprepare = 1000,
-- 
2.53.0



