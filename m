Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FC3154C15;
	Tue, 27 May 2025 17:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365307; cv=none; b=EgojnAr5KGplSfNHYDqMrJduKqANCFanlfd4EUBwa87JHmXUL+dJYHVCBLLtKW/OKM7mX63zuATamO2du6dRPUXTwq75imIZfwoeReE0a4LrW0ORPPfENbSA29i/aR3gVk9ZPZZU/M3DS44nHcKKo/T3p82ghGVSwdYckn1VdFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365307; c=relaxed/simple;
	bh=5iIwQzIQ0B8nJQUfZZ6bPzZWlZPxc1hio4htcx2tysQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+jCD5FaACm2HYtAf38/S2CerNcvpzZmQHPpiOtUFkGueCb1vcyldWsxXsJZTuC3swJ7einN/U/zaa4QkI82BsNKInhBdi/Se3wsTJjNfabw5fk1zgaqqGo9h46xTQGt0ckqlWQ955oS5snyMJjH+12hhMrB8Hl4eYP0tEM84gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DC1ZO4d+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DC1ZO4d+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CDEC4CEE9;
	Tue, 27 May 2025 17:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365306;
	bh=5iIwQzIQ0B8nJQUfZZ6bPzZWlZPxc1hio4htcx2tysQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DC1ZO4d+KM2irqtqU9uaEhPff1pkk0BwYiPaaQbkg4HkSFWHLnsR0Wq4JCBuMXnxR
	 K/LEunvI47GUBDc21VFWM47q3EqEPO2pRJ8RMoceEFmiLoC8W9jp3bFVMDdChQdWDg
	 t58Yx4+7inZvLaO+tV54RcoLMLV+WZE2A1KBqKjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Harry VanZyllDeJong <hvanzyll@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 333/626] drm/amd/display: Add support for disconnected eDP streams
Date: Tue, 27 May 2025 18:23:46 +0200
Message-ID: <20250527162458.553324670@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Harry VanZyllDeJong <hvanzyll@amd.com>

[ Upstream commit 6571bef25fe48c642f7a69ccf7c3198b317c136a ]

[Why]
eDP may not be connected to the GPU on driver start causing
fail enumeration.

[How]
Move the virtual signal type check before the eDP connector
signal check.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Harry VanZyllDeJong <hvanzyll@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/link/protocols/link_dp_capability.c  | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index 23e650e39910e..d9a1e1a599674 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -945,6 +945,9 @@ bool link_decide_link_settings(struct dc_stream_state *stream,
 		 * TODO: add MST specific link training routine
 		 */
 		decide_mst_link_settings(link, link_setting);
+	} else if (stream->signal == SIGNAL_TYPE_VIRTUAL) {
+		link_setting->lane_count = LANE_COUNT_FOUR;
+		link_setting->link_rate = LINK_RATE_HIGH3;
 	} else if (link->connector_signal == SIGNAL_TYPE_EDP) {
 		/* enable edp link optimization for DSC eDP case */
 		if (stream->timing.flags.DSC) {
@@ -967,9 +970,6 @@ bool link_decide_link_settings(struct dc_stream_state *stream,
 		} else {
 			edp_decide_link_settings(link, link_setting, req_bw);
 		}
-	} else if (stream->signal == SIGNAL_TYPE_VIRTUAL) {
-		link_setting->lane_count = LANE_COUNT_FOUR;
-		link_setting->link_rate = LINK_RATE_HIGH3;
 	} else {
 		decide_dp_link_settings(link, link_setting, req_bw);
 	}
-- 
2.39.5



