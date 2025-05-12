Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEE0339A8;
	Mon, 12 May 2025 17:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072008; cv=none; b=qS69scw6gWy2DSwoLIOVeGSvdAqPHB1UqGDw2jv6gE+59i6PwaxJ/b2Ob9KBBOn162h/FqDuiI0JluFpDO1LobojjwSE2Nd3pcpOBPB5CBC42MoQHjKDwtXCoPPV9FfC7XdVZ3P+iesOKG/3g/BOZ7VuoH7d7DezqwBDPXeWJUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072008; c=relaxed/simple;
	bh=RMLnY09YKfgrLnQPtF1VcYeUraMlU9MSNW5MaQjSpNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwxF9TC6PHobdAou9uB5vN9qE5QjT124b2TDnCPJrWXSCSe94E8j90CWWQXmzFMmsGUpNBTDoqaQ8d6fqqmeAa40eQBoSkztrte9wEB1+FSCMyT4QT/V+9WEnGr7IGmUn+W20t3kHbqQ2GXg8tflj3s36QqA1TOrLueeTIMtVwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnOf6HEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnOf6HEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52084C4CEE7;
	Mon, 12 May 2025 17:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072008;
	bh=RMLnY09YKfgrLnQPtF1VcYeUraMlU9MSNW5MaQjSpNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnOf6HEKFOjtSIMo2IQEK8iO0E0oqbRUiShWgWemHT4nXTjOjMavhYdljlY8jHspQ
	 usoubPPaK03q2XJaJpt3jJfaHV25XW/z8owH8klDtqFN9/BY5nakuKAKaM5K1oZg8a
	 o0L+aqQutftjDL499+oCczb1w7mxGXf8uRXl8C/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 108/197] drm/amd/display: Fix the checking condition in dmub aux handling
Date: Mon, 12 May 2025 19:39:18 +0200
Message-ID: <20250512172048.777627473@linuxfoundation.org>
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
@@ -12607,7 +12607,7 @@ int amdgpu_dm_process_dmub_aux_transfer_
 		 * Transient states before tunneling is enabled could
 		 * lead to this error. We can ignore this for now.
 		 */
-		if (p_notify->result != AUX_RET_ERROR_PROTOCOL_ERROR) {
+		if (p_notify->result == AUX_RET_ERROR_PROTOCOL_ERROR) {
 			DRM_WARN("DPIA AUX failed on 0x%x(%d), error %d\n",
 					payload->address, payload->length,
 					p_notify->result);


