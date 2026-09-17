Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DD2374A0E;
	Thu, 17 Sep 2026 18:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670658; cv=none; b=QWQd3Qdqwbi4ZGdY7+Jr8tdoyUUjQSnxQguq8WSObd2uuGEmNi+YwJ5H7gVJWywvCAeSSPfyLq+SjntBhKY6uRHlyyiWIzrNMlB6T/UmTZRKVJBfREQN/B+oldinUSiMi3yyRzWajv41j5W1ec52ZtoMIEqLQY5BOHvFSR+HHOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670658; c=relaxed/simple;
	bh=ArlME3EFTZAxbDzH0kHcxl72IZcxJyRNtDYtNPkaFac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iElsCj10XebvGc99QlVvj8UyjACMi/p5XG9In+oPbjWCCaiNUnsHWA/dNqOt8pNnohl2/MlNFKs3P5APveazGM9biLUcEGCa83k7ws/l3GhkKMyMU+8EsHrYt2Pm2Ucv0jLZKEs1Z0JLjUacFdEK4xyPjKew3KG4L9vPSKHAMV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u315wmbj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u315wmbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317F41F000FF;
	Thu, 17 Sep 2026 18:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670656;
	bh=JZxFztHKfni4iyN4yaf6WiHTfAWT+Dyg3Ut9K05hk3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u315wmbjqLeVAaQ2mPpsgstyUmqLq1NbyWClfyRyZ+Mgmo32ty+x9VlG+7gY57Ecq
	 S/kSDQ0IKp+Fhd0GpYz26GrGUPe2qBbUwINjysxAyZZpN2f3t7eg9AJkgpwJBUivE/
	 2XBO7E1rLiK9ga0iTaXT6r4B8ZXuqgvDpQFWD6xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0731/1102] drm/logicvc: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER
Date: Thu, 17 Sep 2026 16:11:14 +0100
Message-ID: <20260917151558.727694864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit f97802dd98b27e45c04293f9926f07642578b23f ]

CONFIG_DRM_KMS_CMA_HELPER was removed by commit 09717af7d13d ("drm:
Remove CONFIG_DRM_KMS_CMA_HELPER option"). When commit 6bcfe8eaeef0
("drm/fb: rename FB CMA helpers to FB DMA helpers") later renamed the
select in this Kconfig to CONFIG_DRM_KMS_DMA_HELPER, no symbol of that
name existed, and git log -S finds no Kconfig file that has defined one
since. The select is silently ignored. The driver already selects
CONFIG_DRM_GEM_DMA_HELPER, which is what it needs.

Remove the dead line.

Fixes: 6bcfe8eaeef0 ("drm/fb: rename FB CMA helpers to FB DMA helpers")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260905080344.34077-1-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/logicvc/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/logicvc/Kconfig b/drivers/gpu/drm/logicvc/Kconfig
index 1df22a852a23e..283dca51e4bdd 100644
--- a/drivers/gpu/drm/logicvc/Kconfig
+++ b/drivers/gpu/drm/logicvc/Kconfig
@@ -3,7 +3,6 @@ config DRM_LOGICVC
 	depends on DRM
 	depends on OF || COMPILE_TEST
 	select DRM_KMS_HELPER
-	select DRM_KMS_DMA_HELPER
 	select DRM_GEM_DMA_HELPER
 	select REGMAP
 	select REGMAP_MMIO
-- 
2.53.0



