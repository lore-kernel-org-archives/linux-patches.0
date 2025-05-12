Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083F7252904;
	Mon, 12 May 2025 17:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072012; cv=none; b=kjqyWRDm8I6vLZKEa0i9ACru2gMlioZk5yfz8DkMYHe3cfqV6KBCR7sALZwU6IYiqk42K/vns6TnYc0sDEMOoToJK8tLfdfvYjd+xvHdUOxGqNW5CbRNteaq5S73HbF3MfirYWqxIfWhE5XoYq/oKDrzjN1Tlj10B+gegEraKco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072012; c=relaxed/simple;
	bh=VqycT7FaDLA9/YD8FGzNLtvCBtIEKuDGV9N6DdmC42g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tw+x93Ygmnw95FXwL6FMZBr/27hCv6J8iSAclvFnISQfil2xGJEQo4E8sckz88jsqJRHOqIgecGdtiyL6WAsD/cylResa9iI5QnwMJ8AI810Ev2p8ZXIwEtleWzGlmVyG3/+lrTrGyUT+RMbKHVKAet3avg4JX9mQSe+GjYq3UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMaluGNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMaluGNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8252CC4CEE7;
	Mon, 12 May 2025 17:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072011;
	bh=VqycT7FaDLA9/YD8FGzNLtvCBtIEKuDGV9N6DdmC42g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMaluGNzKZKX2LHycGW52fLtSFM6nALEDRX2Kx8sf/Eh3XOPlrJ0hMDnfcEBKgZ9L
	 b03a1VzeVb+SOUkduGh2wV8A8epxYG/3J2zzWGztgWeuEuu6NR2tKJMce7ztp7UlF0
	 au14ORkaK3JJRWXklCBS3C3D9FUDLyiVFIVVw/eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.14 109/197] drm/amd/display: Remove incorrect checking in dmub aux handler
Date: Mon, 12 May 2025 19:39:19 +0200
Message-ID: <20250512172048.819489250@linuxfoundation.org>
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
@@ -12622,19 +12622,9 @@ int amdgpu_dm_process_dmub_aux_transfer_
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


