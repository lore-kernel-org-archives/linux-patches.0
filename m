Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342B2272E56;
	Wed, 20 May 2026 18:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302189; cv=none; b=CMwpQkMD7oB80w2onuusRQmSgpNLnnzHbvKutTc0g3WF5pmOs360dixr+cg2rwGSk+H5Y0IjfyrnOpWrfbJFAH4pr7gm0XcCjT2Z1PUGYYcT/Mg9ialhIZvlZKE1kPfq0jt8GhVMysjfkNQnj1v5vHXaUaFQxXEZAReNCp/2NH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302189; c=relaxed/simple;
	bh=Czxj7D9PHXzaoVE5f4ysm4HfKyu3jDET7V0ThXaqQ+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RA8HBDv4+XfQelnz/G9U2of7Q4JSNEJxt6erOHhJ731ekSoHBwVRZS69BYp8nSJDZppsK+5lps2Iw3te+5p9BymzR6aNSWXqbpr+LJMkMYTqzZAH1qNI+C1jkUroYGcxcl5mYyi9hOGjE48UxCLeDCjAVdsktsVSnUI/aNcztEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/sJ+V87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/sJ+V87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9922F1F000E9;
	Wed, 20 May 2026 18:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302188;
	bh=1nOSvPqrgi/wiHnD5m1hGlfMkGaRNwp1DeyEEpkMFhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/sJ+V87RXWbTbD1PUQOqHIFJtf1MKG6Rcr9ER/o2wmR4+HC+SIXY78lSgbwtGHqd
	 1PJbAujZQffoNoBEPzyodkSlLkbeDmpaH10wLJ4UysLtML8yBp1GX8adoMdffhevuq
	 OE44+X+agHos4c6OEwnMXO/b85ysznec0IaPBAw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ian Ray <ian.ray@gehealthcare.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/508] drm/panel: simple: Correct G190EAN01 prepare timing
Date: Wed, 20 May 2026 18:19:03 +0200
Message-ID: <20260520162101.229627915@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 8a94eee57d943..7620ac20393b7 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1157,7 +1157,7 @@ static const struct panel_desc auo_g190ean01 = {
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



