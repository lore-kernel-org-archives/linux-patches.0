Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F602FDC5E;
	Sat, 30 May 2026 18:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164077; cv=none; b=bX8CExhDY/mzOeZuV9zdYo/Ku/VbLz5Dt2LTxMDUYwWF3bE34Ixy8g3j9CdX13cJKkY6LXpOQ4QMR0PB9k6X/Cw1pLigGgLZQ4fwf3A15AmL0b+bO/tBAkqId16zcLjbO/aD2RObT0aP8y13wEPswjqdALoGZh5Di1z6w7gvfiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164077; c=relaxed/simple;
	bh=liV9vCbJQ4E4e22OWKHIfjMD7xfaERpvpBOTqSX4Pak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnL4wApA4YvKsjhpesw/lm0Co/vqvoK5MmOBPrRD9SqS+bMfsUuL2n/vFeBsf8Q/7XJLOUIQGw013uttiKHGA6Rml/mOYPbaYsHqvdLu11Ce/iT7M3H87pdZ3fJ6rpEAZtGDHDHHiCJFS+7/oBwHJhQn4xBhsWRdpuoN+hTc2J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBfCWY7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBfCWY7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336BB1F00893;
	Sat, 30 May 2026 18:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164076;
	bh=l/4gBBGRaQVDlJqdRMr7EqLB3gwBVaTW4dWqvRdkV/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBfCWY7DTn1BhxxBkpOck5PGBv91hA4iM3NCrvzDwSUa0GUTQjbBrLuzvjHjyq5UQ
	 yra9AKQZQgd5MPOT3uQJMD8iArNiODs+BOWwepLQ+uboS+oIUJkWmMUG9LIUGrP9iA
	 U2t35wYzSAx9IoVqiiPkrszHZHL3/OafXaAhEWGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ian Ray <ian.ray@gehealthcare.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 447/776] drm/panel: simple: Correct G190EAN01 prepare timing
Date: Sat, 30 May 2026 18:02:41 +0200
Message-ID: <20260530160251.953510318@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 17e1aaa706f1b..539b58af565ee 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1388,7 +1388,7 @@ static const struct panel_desc auo_g190ean01 = {
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



