Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDE1221F2F;
	Wed, 20 May 2026 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295201; cv=none; b=BE7CbCsJAi3dHSJy1SI95nSdK2p8fzJcJCSNxYW/8POyew8XSQcLdTswY3DuCMKH5ztnWg6gB4srHnnaUJSZ9/aB+C5qTeBZD3Z1Ls5uJkKjc0x87CDPiGVefNx1nLqIrHa/OPAk285Nf61uOZ2reNn/GTt1WRwhvG/sTljsUbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295201; c=relaxed/simple;
	bh=oUeIEVKcbrJwqRKDAnX06e9/T+f5zkgkQ+ELeBu0fIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJ27I17Bc8MixX5s+Ig2GIH67ZeeGGwsU6PJg1tAx8XxsHqBVoRXpQdrE5gcS1axQIwr2IhXifyXArk/EF3UyaMOoIuYSn411CG48eFGV4E5fw0awC0fJ1kNgknLsNPzLo3DMIC1xpBHTdOyMhi+PdOxLMbf1TRCk8Upf4eD75g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYLlJQwU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYLlJQwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402AA1F000E9;
	Wed, 20 May 2026 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295200;
	bh=p/okGHPdhzBiGKfUqJtzDMyUchg9mayqSknqRuWfMaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QYLlJQwUjiCkfXJlfKKv9hKbvc6MUgpJY2ta88tTtRHswRw7WSbQgc1caZTbrUVW5
	 ac/ir0TNl+nGOiuqGEIcry4lijpolgFHXdQybAoacJ4nU2pWXZk9CLXpCzmb2YHfTL
	 7kmZviJJ3KbGq6y6NjoYsQEi1CpewRVFbDtsxTfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ian Ray <ian.ray@gehealthcare.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0328/1146] drm/panel: simple: Correct G190EAN01 prepare timing
Date: Wed, 20 May 2026 18:09:38 +0200
Message-ID: <20260520162155.620553889@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 91ab280869bac..a242ae284db5a 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1295,7 +1295,7 @@ static const struct panel_desc auo_g190ean01 = {
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



