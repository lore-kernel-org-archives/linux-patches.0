Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643A816DEAC;
	Wed,  3 Jul 2024 11:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005034; cv=none; b=Su2Y/s896jdHnr580W/5NsUTOVyrULhBZjVdQifO2CtizT/V6gX2As/3aa4TTa/p4h4lCeK3cm4cqObdrP6Ksy2Rjph0ZEqs07WJaBZXiNZ7wDN7wahDyfsyBaaH9l7abt5hkDPOy8b/+WTLcYezCuOiRPK0mVSswLTmcyllljY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005034; c=relaxed/simple;
	bh=OuEDi3ZM/qex/Snb0A7v2rh2GcgvrhEW8u3sDxNp/kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYFSTtB/b5F6SbEGwNZpPu8DGpiMdggT9J3h/HHW7awFvdEvjol9IsKx93yNGHhsk3lDs9eeG6U1THQwLBEK+7KnqqA/DsBbLARZRSD2DQlEYAerI3TNz4UHfqhUlFx+54pwDBrCc7t/Ki0UsevRiwh49Eou2JY3m2QEwBrmuvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YF6Q9G7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YF6Q9G7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91554C4AF0E;
	Wed,  3 Jul 2024 11:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005034;
	bh=OuEDi3ZM/qex/Snb0A7v2rh2GcgvrhEW8u3sDxNp/kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YF6Q9G7oArsR8kDmnnaxgvfjREtqvtvKk0tYBOQk1VznhqIVdGP1ieQAg4uhvQtNs
	 HLsVJPUIzskAAn7nbM/0ApjmIrAWTvhazWqrt69oMajAeFK5smFhEKL31Zvjdat+Rx
	 S7qnUzW1vtkxqVz8HfbaV7opn5kbhUqrtFTbv4X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/290] drm/panel: simple: Add missing display timing flags for KOE TX26D202VM0BWA
Date: Wed,  3 Jul 2024 12:40:20 +0200
Message-ID: <20240703102913.177025159@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7797aad592a19..07b59021008ea 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2438,6 +2438,7 @@ static const struct display_timing koe_tx26d202vm0bwa_timing = {
 	.vfront_porch = { 3, 5, 10 },
 	.vback_porch = { 2, 5, 10 },
 	.vsync_len = { 5, 5, 5 },
+	.flags = DISPLAY_FLAGS_DE_HIGH,
 };
 
 static const struct panel_desc koe_tx26d202vm0bwa = {
-- 
2.43.0



