Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97163016E1;
	Sat, 30 May 2026 17:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161064; cv=none; b=neDD8jpXFUW2Xk5T/6G5A2BrDmxLzW04iCNA+etfcTclh8LkJtL4Uj2uZ4bItKQsxCW9UNilI1LTfqzPKouq2kA7xfQ1aAfo29v+0rqV+kB/21Qsci4GFNgIHz/mfAU6ESWEVMD2Ur9Rkm7nrtjCBGI1fOxE369Fg++HRFvwIjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161064; c=relaxed/simple;
	bh=UwIa17dU3niB6Qowns1XZurxbtBJH7yRhJ7PJyuOf4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJHCtqEiialRLsUg5jmpg3hiXpHTLpghuJVZ2xEcnU1V7VEPSr1zoFcioOfbGMdn5uVs67gsbA6IWZlFGl0iiYIj8mTp7AnidfzuwrzCiCm5xxbwUD/gzGm2CSEaUIkZMWelTBv3MscdCHxdVn6xky2JAg63LQqnDuwG4QanEDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Klo+eUlE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Klo+eUlE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6FB1F00893;
	Sat, 30 May 2026 17:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161063;
	bh=Vp0e+XUHdrzGjPo8yI2/KVqYOcstNYmOEppJo5OUVso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Klo+eUlEAQpLPLxCv4vA6JbHeQOf+v6FN43l97MwfnlLzevnFgAfv+AGWERns+gy+
	 hEATm2+MgtdWMZOFKLNfn7sR1ozhNfyd+ZpmqFKqQe5C2mi8nmugFiFL5c/lIW2J5u
	 pDZ1R6NJeR15zdoPd2ANTVdCA8j9ltBSWY/mildk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ian Ray <ian.ray@gehealthcare.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 515/969] drm/panel: simple: Correct G190EAN01 prepare timing
Date: Sat, 30 May 2026 18:00:39 +0200
Message-ID: <20260530160314.562670305@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3f41fd5edc333..316961a86b042 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1099,7 +1099,7 @@ static const struct panel_desc auo_g190ean01 = {
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



