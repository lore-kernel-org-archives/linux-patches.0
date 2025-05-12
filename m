Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8FD254863;
	Mon, 12 May 2025 17:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072434; cv=none; b=e/AkPvfi3DoxMEXLnZTf4cGdr08s0LrlfRgKs7ZMcJTwLJ9gq+iISSsUQ2Dow/yHUYmHAnFqzOFHIJxqDadFDDR/2tECplaNq1Z6MjyIeTFuzhwaO7JSX1SYZ0A3jePzecjiOkX+DC3DtEYP7Bqzcyg3rWc7L/6OtMXfcjBT1zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072434; c=relaxed/simple;
	bh=x9kCZj5ayE09eaCsrrtNd+kHBSZs+gRNyXBHCxX1rHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ki7X8/dYXB2xbLWGYwVXgaVkWeCosdaioJywb/Bo/rF1XSORTEtDAzqmCT052rMzqpOv94JSvururMeWSW+v1PeiHk4V7GPKQ3RxGMG/QqyO0Mvks19I4mfZNhAuoi1/dwgcbmRFi4eB7S0ssKc0PRUa6ZX+CY8yMnwDEjFj2ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCQpG5Zd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCQpG5Zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD01CC4CEE7;
	Mon, 12 May 2025 17:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072434;
	bh=x9kCZj5ayE09eaCsrrtNd+kHBSZs+gRNyXBHCxX1rHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCQpG5ZdbrOg0CyPqSnRW4465fOnxLoVlSwqhJZRYyAJtGrq1IrvQpqTEV535DJOC
	 Oz/+dResOW8MxQdFPFIbRVeK1uT4WsxkkK3idg1a7Yr+Y9brs06TO5YiS92E8d2D46
	 odGc4zokiFf0qQ+qm8ZrPV+jMGfejF459fFxNFR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 40/92] drm/amd/display: Remove incorrect checking in dmub aux handler
Date: Mon, 12 May 2025 19:45:15 +0200
Message-ID: <20250512172024.754700393@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit 396dc51b3b7ea524bf8061f478332d0039e96d5d upstream.

[Why & How]
"Request length != reply length" is expected behavior defined in spec.
It's not an invalid reply. Besides, replied data handling logic is not
designed to be written in amdgpu_dm_process_dmub_aux_transfer_sync().
Remove the incorrectly handling section.

Fixes: ead08b95fa50 ("drm/amd/display: Fix race condition in DPIA AUX transfer")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 81b5c6fa62af62fe89ae9576f41aae37830b94cb)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10708,19 +10708,9 @@ int amdgpu_dm_process_dmub_aux_transfer_
 		payload->reply[0] = (adev->dm.dmub_notify->aux_reply.command >> 4) & 0xF;
 
 	if (!payload->write && p_notify->aux_reply.length &&
-			(payload->reply[0] == AUX_TRANSACTION_REPLY_AUX_ACK)) {
-
-		if (payload->length != p_notify->aux_reply.length) {
-			DRM_WARN("invalid read length %d from DPIA AUX 0x%x(%d)!\n",
-				p_notify->aux_reply.length,
-					payload->address, payload->length);
-			*operation_result = AUX_RET_ERROR_INVALID_REPLY;
-			goto out;
-		}
-
+			(payload->reply[0] == AUX_TRANSACTION_REPLY_AUX_ACK))
 		memcpy(payload->data, p_notify->aux_reply.data,
 				p_notify->aux_reply.length);
-	}
 
 	/* success */
 	ret = p_notify->aux_reply.length;


