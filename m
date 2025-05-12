Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B947297120;
	Mon, 12 May 2025 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073458; cv=none; b=e2l8M40kje4QLgPdED0jPYBp3CQVJ4B1Hvb0cTsrcAE9F8wuUCNeLrrSRk+xhPVn/JdS9ZlCDnX8WPEPbNcp6s5guLiiHbR8u5SnUepRIopqVLHpvWGgEXM6zUXugZT5Tf+C7EtUid5h5x3YSQBR6nE0Kzg14BzBJR40TIJB7xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073458; c=relaxed/simple;
	bh=lncpuXMfDXVet1nq9vsfZaVE656a1kKtvyO7bAnVy3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbRg3Ck9PUyH5eiw7+ulB6FUHnsPCPGFF3UACJga2vp/XSAhxRivpDQBLRA9X8fBuxdjzqXkm/oLsytyTYW94Kznvl4OEYPGD6VIYFeXi+INczLmpWMERWe+42fhhK+7NK+RwpKd6YyWJK5Xij+onW9u1AWu/9NgxwpYQwoOqts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ORqnG66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ORqnG66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89996C4CEE7;
	Mon, 12 May 2025 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073457;
	bh=lncpuXMfDXVet1nq9vsfZaVE656a1kKtvyO7bAnVy3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ORqnG66fFmwAyZSttwwnw2Q3GgpaHQHrFg9A6q0LSy33GNfg924eM/lcxoh645/s
	 H1ry6WKH5V6Ld7pXjoxaVAQLdcYRqCDAH8eAq79Pc8DYgcg9zx191VJPcW3UHT5BY4
	 SdvBO6V2g5FGy/wRrfWHCfw7RUVlB7sAbl9GQyKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 052/113] drm/amd/display: Copy AUX read reply data whenever length > 0
Date: Mon, 12 May 2025 19:45:41 +0200
Message-ID: <20250512172029.789728844@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -11069,8 +11069,7 @@ int amdgpu_dm_process_dmub_aux_transfer_
 		/* The reply is stored in the top nibble of the command. */
 		payload->reply[0] = (adev->dm.dmub_notify->aux_reply.command >> 4) & 0xF;
 
-	if (!payload->write && p_notify->aux_reply.length &&
-			(payload->reply[0] == AUX_TRANSACTION_REPLY_AUX_ACK))
+	if (!payload->write && p_notify->aux_reply.length)
 		memcpy(payload->data, p_notify->aux_reply.data,
 				p_notify->aux_reply.length);
 


