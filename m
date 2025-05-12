Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C79295DAB;
	Mon, 12 May 2025 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072444; cv=none; b=VV38eXLd7vV6j6NA5NJMLZ69H56SlKoZAEzn/PGcwJLz5a2Y5b+vj/WvywLussrFtrvn79pazyepFRAUPg02GvS3yn92tURbpj0wUABGpe3Lu6g9fXhtodar6gh1YIGhnmNi2rLLbP0WovRxbnQFERYXiQSXOrUIyoE6B644dqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072444; c=relaxed/simple;
	bh=RS0QVrU7FpuIMpC+RQ0/VUozBcQesVV38Mkn9uCuHuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2z1SlZit8MsXsaBrTMI54Z/i3Y5ECSSJXWIkVOye9r16vIaoYTQQElAywSOnGLMSzK0VMJjKUhwvaUJuCNK01s2KjcUE+hJMXslHwY3VqJ+QeZguEWy7hVSYYB+FHhSjs8XTo8wX26+2ksFJ3rFEhE2tWQUTjPoiyat2MjvG5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zaZYBXhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaZYBXhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5868AC4CEE7;
	Mon, 12 May 2025 17:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072443;
	bh=RS0QVrU7FpuIMpC+RQ0/VUozBcQesVV38Mkn9uCuHuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaZYBXhVrft+uwriZgMLERSO2ZpkyURr8PEk41E94Ac0e7Giv0oTXtbBB3BHlpyg6
	 GF3qkKyO4CHY9fzt2i42NM4euG7d0zYsVbzcDFjQ1bNYOqZTPrlX+4YGSBT3yVx4WP
	 9qSQlwWTqVduYPcW5pGBYLaZYfLPgWJTzBvUVQwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 42/92] drm/amd/display: Copy AUX read reply data whenever length > 0
Date: Mon, 12 May 2025 19:45:17 +0200
Message-ID: <20250512172024.831867200@linuxfoundation.org>
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
@@ -10707,8 +10707,7 @@ int amdgpu_dm_process_dmub_aux_transfer_
 		/* The reply is stored in the top nibble of the command. */
 		payload->reply[0] = (adev->dm.dmub_notify->aux_reply.command >> 4) & 0xF;
 
-	if (!payload->write && p_notify->aux_reply.length &&
-			(payload->reply[0] == AUX_TRANSACTION_REPLY_AUX_ACK))
+	if (!payload->write && p_notify->aux_reply.length)
 		memcpy(payload->data, p_notify->aux_reply.data,
 				p_notify->aux_reply.length);
 


