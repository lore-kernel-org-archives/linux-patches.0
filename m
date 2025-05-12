Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D86219049B;
	Mon, 12 May 2025 18:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073030; cv=none; b=hPL2JyI+j+t/ikPPZpuc8LpBjcMV74xqSE131HTTAyOkwcu40yJQi7hOG2F6+QgoPoDgZYaQIpe1UTvCg1sTcgyMNdG1Q88YCWVsNfa2MbJqFndgu+4CPDjGmrKRY3VFqa9MpqoWZdMVZh/cXAPFZ5cjV3BxGIZpTKGsk6V5GEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073030; c=relaxed/simple;
	bh=+0zV5fdAYdWm5L9mbXdXqUaxqxdhVXFFwUzP1wGX9ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJQiQNy5RbL7YY85kDo5wjSAzSi99Gb+GtTtipy8+UukioTJ93FyLB7qOgFehJXJBxz6Sls41Qa4W/5BuVdc2lfQuM6GcEmEIkCbUyoCdwbSYeKWlKHnv+VEvuieBuNB/BnJJYxs+GhPephgTZLaa3BKO5CnobKz6UlRx+xA5cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6vmIWPM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6vmIWPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04254C4CEE7;
	Mon, 12 May 2025 18:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073030;
	bh=+0zV5fdAYdWm5L9mbXdXqUaxqxdhVXFFwUzP1wGX9ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6vmIWPMPRZ94MJTb8l9GooexPAgv6GY8Rze/xchlEwtJn751XuXVA+f0KU99KUMa
	 mbedrmWTo0SxHyaMCDq7qSakvzxyKnbG6mF9WG5d0KqFG0jFb+liWAUAedeRxq42xk
	 tfnHR7Au/eRoGCsOPegJz5d5VecUHDsLGZjQua7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 093/184] drm/amd/display: Fix the checking condition in dmub aux handling
Date: Mon, 12 May 2025 19:44:54 +0200
Message-ID: <20250512172045.614759910@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Wayne Lin <Wayne.Lin@amd.com>

commit bc70e11b550d37fbd9eaed0f113ba560894f1609 upstream.

[Why & How]
Fix the checking condition for detecting AUX_RET_ERROR_PROTOCOL_ERROR.
It was wrongly checking by "not equals to"

Reviewed-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1db6c9e9b62e1a8912f0a281c941099fca678da3)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12532,7 +12532,7 @@ int amdgpu_dm_process_dmub_aux_transfer_
 		 * Transient states before tunneling is enabled could
 		 * lead to this error. We can ignore this for now.
 		 */
-		if (p_notify->result != AUX_RET_ERROR_PROTOCOL_ERROR) {
+		if (p_notify->result == AUX_RET_ERROR_PROTOCOL_ERROR) {
 			DRM_WARN("DPIA AUX failed on 0x%x(%d), error %d\n",
 					payload->address, payload->length,
 					p_notify->result);


