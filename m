Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F82B1BE876;
	Tue,  2 Jul 2024 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941407; cv=none; b=D5IEmyeHUv3d9U/fL0RJU7MMS7lIJz7467K5ohiaeMUFnzbujDv+fl1n+Yfm6P9YatOncwDOfTRcGMIlX5io1olzswpyu1DsupI0obva2QUfUramiq8UIyydwW6FibMszfp26qSXX+9yCCs6w+8ocsnliWc6YbHktULYICnGbU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941407; c=relaxed/simple;
	bh=m9vTLfxnRcLTLJeBg7i0nA5HGSRhsVUq+5S3YTa08YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7LqE+E+fF4KZ5DWBjPM7L2za/5Lm4GKZcdJ2jZVfmikPusZMLWWOxKcsNi6ugXdex/knHvXe1it8VUh0JecaUb5xfh9llA4eLJUs7wEL3lPs4jGlSC4SSy0utQMiPWkUCwAO3QhZfF0fDfRxHP9EgdtHe2yw1vw9un/PBxg0Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6A+lpKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6A+lpKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4793C116B1;
	Tue,  2 Jul 2024 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941407;
	bh=m9vTLfxnRcLTLJeBg7i0nA5HGSRhsVUq+5S3YTa08YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6A+lpKBaoOji2ltTAJbgyLuiEaCD/r5Cmv22v04JlnsRjqmJXljwo5j6eKTDB1Wb
	 3QSD4m691gQ+DFX9N6daeYmJqxpj3DBohGaPhlQIpS30MvzEY31Mz/HgfmQ0vZyYR3
	 9HSDV5ePHY7aZU6RLO4MPaOJ6sdV0d36BRBHhEso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/128] drm/panel: simple: Add missing display timing flags for KOE TX26D202VM0BWA
Date: Tue,  2 Jul 2024 19:04:15 +0200
Message-ID: <20240702170228.276229664@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 37ce99b77762256ec9fda58d58fd613230151456 ]

KOE TX26D202VM0BWA panel spec indicates the DE signal is active high in
timing chart, so add DISPLAY_FLAGS_DE_HIGH flag in display timing flags.
This aligns display_timing with panel_desc.

Fixes: 8a07052440c2 ("drm/panel: simple: Add support for KOE TX26D202VM0BWA panel")
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240624015612.341983-1-victor.liu@nxp.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240624015612.341983-1-victor.liu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index acb7f5c206d13..b560d62b6e219 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2371,6 +2371,7 @@ static const struct display_timing koe_tx26d202vm0bwa_timing = {
 	.vfront_porch = { 3, 5, 10 },
 	.vback_porch = { 2, 5, 10 },
 	.vsync_len = { 5, 5, 5 },
+	.flags = DISPLAY_FLAGS_DE_HIGH,
 };
 
 static const struct panel_desc koe_tx26d202vm0bwa = {
-- 
2.43.0



