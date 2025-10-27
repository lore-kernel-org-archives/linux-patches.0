Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3479831D754;
	Mon, 27 Oct 2025 19:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592953; cv=none; b=JE1VzdmEG6Ier+ePww3wg0TmlGSMCrBWhEFHGwr9n4YBxmdYIUa/8DrXUv4FZ6z5pxjrFSxdxavaBiKB3I+cpKPlOOu6Cvnmy8DA8vmo6ttPMUB6mBP55QfvqIIWCmhDTvlY/aHQBLfsJkpPjc0KMw2TS+kpUiwEoe76vJe098c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592953; c=relaxed/simple;
	bh=5+sUDh3QIYa0/wBm4gt3EqSXXGYqs8+wTjdJHrKkrl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/D+ji6pNusK14csxq2V+DrabntdZnGbPDo73YvAT2fZUePvNqqj6xPx2XkT50EGxnWGJC324EMXot/EkPNv4EwwO2r5LSQDBJzyukdfgJswHj9s2Kj0VtQI+RBNXXoFnj9DmWUuTxihwqBVCJcngEzogoFAKP/5l2Lpv9VDKqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YO1bPRw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YO1bPRw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC871C4CEF1;
	Mon, 27 Oct 2025 19:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592953;
	bh=5+sUDh3QIYa0/wBm4gt3EqSXXGYqs8+wTjdJHrKkrl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YO1bPRw8BszsSzysaTFNHi5SYuYaxKJWJztYaA9PL8pcQd8sEf/tuYr7LfOAN+xG9
	 KNATiZgqPxio6EiNLh33OBs0xusUgN/GdYOQqFoXEUxS6Su4dcTA2YEPCPJLFOZ1d2
	 WLAmjQzrEV2D0pJQIW+GDCy6JZ7UtyoUfXJtcWQY=
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
Subject: [PATCH 6.12 068/117] drm/amd/display: increase max link count and fix link->enc NULL pointer access
Date: Mon, 27 Oct 2025 19:36:34 +0100
Message-ID: <20251027183455.847656715@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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
@@ -287,6 +287,9 @@ void dcn401_init_hw(struct dc *dc)
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


