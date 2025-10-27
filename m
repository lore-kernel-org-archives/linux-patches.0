Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB61F2C11DF;
	Mon, 27 Oct 2025 19:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593360; cv=none; b=oAfYy/+JaRNQCFIdVPuNsmTIe1X61SfBm7VaJDbYk4B1HYKTchu6JJSjU/dJZ9Yrsvogw+AcbRCIbKgl9hhxOrKnIDuLAoAPWKwqQijbFhZMI6KHOW2NhFXBy3QnGiXwlOtRJGM1EU/cUutODA8ORKQ729xBat2VzdTrOIjEcI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593360; c=relaxed/simple;
	bh=H72p1qsb7Id9judXdX6pZHlA/SmsTi5b82ay5DZZnaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1FgZzcP9awbM0MlDex9Lha/DcN9pRLwik2TlQAF/DYa0psySa22ZldhSVRIZhPhRKiKlTU09XeCtN6I2Grx06U8BoSWBNHMQqT9Rc+zedp98RArlvU1IM1K9cJvtYV/mffQ2MPe7zyu4pGBOaLCVHViLcsSXOPUKxJzqN41TVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ke+zLx+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ke+zLx+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261B8C4CEF1;
	Mon, 27 Oct 2025 19:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593360;
	bh=H72p1qsb7Id9judXdX6pZHlA/SmsTi5b82ay5DZZnaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ke+zLx+D78I4mWLS/b6ZPQzBPHsENfK1AP3bO1EnuRrWnV20lQth93A6ms6bbjdck
	 rmx2El77YSZKvqlzU/ViDG93ZWTS4chMrofI0qXikLmp464JX90/KqzcE+ycTRWxMu
	 SKiJVNNYzC+N2mSiHLLl58l3Pmz+rk9N9sdqIxSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
	Chris Park <chris.park@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>
Subject: [PATCH 6.17 108/184] drm/amd/display: increase max link count and fix link->enc NULL pointer access
Date: Mon, 27 Oct 2025 19:36:30 +0100
Message-ID: <20251027183517.829787385@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlene Liu <Charlene.Liu@amd.com>

commit bec947cbe9a65783adb475a5fb47980d7b4f4796 upstream.

[why]
1.) dc->links[MAX_LINKS] array size smaller than actual requested.
max_connector + max_dpia + 4 virtual = 14.
increase from 12 to 14.

2.) hw_init() access null LINK_ENC for dpia non display_endpoint.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Reviewed-by: Chris Park <chris.park@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d7f5a61e1b04ed87b008c8d327649d184dc5bb45)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c |    3 +++
 drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h         |    8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -200,6 +200,9 @@ void dcn401_init_hw(struct dc *dc)
 		 */
 		struct dc_link *link = dc->links[i];
 
+		if (link->ep_type != DISPLAY_ENDPOINT_PHY)
+			continue;
+
 		link->link_enc->funcs->hw_init(link->link_enc);
 
 		/* Check for enabled DIG to identify enabled display */
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h
@@ -44,7 +44,13 @@
  */
 #define MAX_PIPES 6
 #define MAX_PHANTOM_PIPES (MAX_PIPES / 2)
-#define MAX_LINKS (MAX_PIPES * 2 +2)
+
+#define MAX_DPIA 6
+#define MAX_CONNECTOR 6
+#define MAX_VIRTUAL_LINKS 4
+
+#define MAX_LINKS (MAX_DPIA + MAX_CONNECTOR + MAX_VIRTUAL_LINKS)
+
 #define MAX_DIG_LINK_ENCODERS 7
 #define MAX_DWB_PIPES	1
 #define MAX_HPO_DP2_ENCODERS	4


