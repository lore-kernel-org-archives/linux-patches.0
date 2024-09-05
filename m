Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAB5154BFF;
	Thu,  5 Sep 2024 09:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530098; cv=none; b=EfYcQQLf1+sDT+1+fox8fovJ/NknKLoC1L6BXORpCmi9M5ES9huZHijeQi6Qb2UH8t9jWROeUKG4SWWBcktXIhXNB1TNWRQZzKxLf70g8XJBeVL1OsvRh/yqdTpRA+aEzIaF2LfEv7P1XqKt1edUVJVHSPVW925kEyA8ocBjl0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530098; c=relaxed/simple;
	bh=pUFGV5yh1LUWW1GsDLy+aEcDmAyTtvzwed2r13tqNIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgUeohOXs2Eh6FQmka5S0MIAC7QSRADU17olpzGgvdA27yZqBQrTGua0YHhpy3s6n1KkvvqoF5nIZ2FJXEYcGNpLZjGU1G7Scc8SGVBNchPNuCO0F4o31fh0hku1vmaRHYWwkf7hftEXdtfLv8KjJSdgwqaHe3oZ03NERJcSBTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRNbj8R0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRNbj8R0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59069C4CEC3;
	Thu,  5 Sep 2024 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530097;
	bh=pUFGV5yh1LUWW1GsDLy+aEcDmAyTtvzwed2r13tqNIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRNbj8R0vRhdd9YwL/ItRJ9vaZx9a9VuHPG/IuzCYjxA2elUH69OdNjoaDSlp2MQn
	 kE7a9qqmBWE+JvUlLzaBkCU6DfSM5r/JdF3YxYXkREBnhQ9QpKlg7WcFVd8Gii5Kv7
	 rdLZHvJ/sSHiFTyzj/lwtt2UiaOAPmyYni6hy2xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/132] drm/amd/display: Check index for aux_rd_interval before using
Date: Thu,  5 Sep 2024 11:40:40 +0200
Message-ID: <20240905093724.320814748@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 9ba2ea6337b4f159aecb177555a6a81da92d302e ]

aux_rd_interval has size of 7 and should be checked.

This fixes 3 OVERRUN and 1 INTEGER_OVERFLOW issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_training.c  | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
index 16a62e018712..9d1adfc09fb2 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -914,10 +914,10 @@ static enum dc_status configure_lttpr_mode_non_transparent(
 			/* Driver does not need to train the first hop. Skip DPCD read and clear
 			 * AUX_RD_INTERVAL for DPTX-to-DPIA hop.
 			 */
-			if (link->ep_type == DISPLAY_ENDPOINT_USB4_DPIA)
+			if (link->ep_type == DISPLAY_ENDPOINT_USB4_DPIA && repeater_cnt > 0 && repeater_cnt < MAX_REPEATER_CNT)
 				link->dpcd_caps.lttpr_caps.aux_rd_interval[--repeater_cnt] = 0;
 
-			for (repeater_id = repeater_cnt; repeater_id > 0; repeater_id--) {
+			for (repeater_id = repeater_cnt; repeater_id > 0 && repeater_id < MAX_REPEATER_CNT; repeater_id--) {
 				aux_interval_address = DP_TRAINING_AUX_RD_INTERVAL_PHY_REPEATER1 +
 						((DP_REPEATER_CONFIGURATION_AND_STATUS_SIZE) * (repeater_id - 1));
 				core_link_read_dpcd(
-- 
2.43.0



