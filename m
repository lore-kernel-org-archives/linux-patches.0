Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631D11DF72E;
	Mon, 12 May 2025 17:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072019; cv=none; b=JaUolykyjASjcD0b++F2tu8OjSfaPNDpdnbupbC4sTKWmtwdUMZmzYRs8/smJGjSR7XRG59cLyT00IJiShIptpyJZAwS6c/Xi3P8F7x0GUNzTYXtl4zlT7X5+UGIFL+a/NewX3U66yzp06iAtL2mNdA75lNaE0Ep7jQ+JZPl/hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072019; c=relaxed/simple;
	bh=ezVTGaaCVFTIdfFPqdaispQ+7UhT01PnbgPXkzNxnEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BotAJKHRFlM2MtGH9AzB5q6raJpszYjEuF20WRiHkdcZvTrq0njLQA/I/gDQ/DrrlE5llMBWBOkvge1oizPnoGYaGEcNlRQgAEvkxZb8ef8EhvqxJeFnQvYuP9yq3F5Z1hPe61az9jzNujad27Av7jbiwS6+qJpVgXCgzikNruk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYM+6TtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYM+6TtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4442C4CEE7;
	Mon, 12 May 2025 17:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072019;
	bh=ezVTGaaCVFTIdfFPqdaispQ+7UhT01PnbgPXkzNxnEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYM+6TtIkLcJIxE2zUl7idFvWUIn/in4FPVO6SBzqwNCLSm9z7otld5NzUkFTeyi6
	 oSiH0VlPGzLHAr16bkoaRgeFx6c3SyNPAylQgSSwzBOewj5I9rC8yimQT1ddYTOPK2
	 ePn3gSiOxCRb8YpEkFFwyU14siUOX3l4bpJkl1HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.14 111/197] drm/amd/display: Copy AUX read reply data whenever length > 0
Date: Mon, 12 May 2025 19:39:21 +0200
Message-ID: <20250512172048.899598268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit 3924f45d4de7250a603fd7b50379237a6a0e5adf upstream.

[Why]
amdgpu_dm_process_dmub_aux_transfer_sync() should return all exact data
reply from the sink side. Don't do the analysis job in it.

[How]
Remove unnecessary check condition AUX_TRANSACTION_REPLY_AUX_ACK.

Fixes: ead08b95fa50 ("drm/amd/display: Fix race condition in DPIA AUX transfer")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9b540e3fe6796fec4fb1344f3be8952fc2f084d4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12621,8 +12621,7 @@ int amdgpu_dm_process_dmub_aux_transfer_
 		/* The reply is stored in the top nibble of the command. */
 		payload->reply[0] = (adev->dm.dmub_notify->aux_reply.command >> 4) & 0xF;
 
-	if (!payload->write && p_notify->aux_reply.length &&
-			(payload->reply[0] == AUX_TRANSACTION_REPLY_AUX_ACK))
+	if (!payload->write && p_notify->aux_reply.length)
 		memcpy(payload->data, p_notify->aux_reply.data,
 				p_notify->aux_reply.length);
 


