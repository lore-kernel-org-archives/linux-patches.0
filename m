Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0608C2550C6;
	Mon, 12 May 2025 17:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072431; cv=none; b=MBlEOgYsD2IRiwlk1QIx6nQGF3b1RqVbq2u5visX1WrQs4HHUAGPDaZgf2x4NvWBhnSQYYtae+pgZIf0LUUi8kHB3F0Qc1Nt9NzrnL2QEjK1JXadQZlGxQh2VcNueC6QaTs22lXO8LQfuodyNdZdCh30v661NQdkC+gvs3HCLFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072431; c=relaxed/simple;
	bh=Qb1QBJP/3BHahEkWrepvhpzTNKphih0GoW5L5SqWijQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsPvNTSb91SUD5psrj2TUwx831D7+ht2Q1IOUiPLFs1qqkdpfUV40cLOoqIX13ZFwOWl/c7ZlbP+UzfdaKkrKIUY9aEdUHPYtpb1GSfh3gq56hSoZhhJ8hL5YqyNgLGjqv+e8Uh/eW0UkgwXlY0wUhF7kUhvqk4gRuLmANJLe6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c40TEea/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c40TEea/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8979EC4CEE7;
	Mon, 12 May 2025 17:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072430;
	bh=Qb1QBJP/3BHahEkWrepvhpzTNKphih0GoW5L5SqWijQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c40TEea/uA1MHk+lB4TnCWKPDxxe41KWIOBA/2BCAsS86xLCvN0pWND6AENC3hORl
	 3I9yC4Rpj81uPFoFjqF3ERyfQ8H/zaierufHFsAQJvJPgmlFumIwN5bjENxFQu7Uz5
	 AORdGWnQl9VPGHxlxS9Jv7ze9bqBlyFCTuSHwBc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 39/92] drm/amd/display: Fix the checking condition in dmub aux handling
Date: Mon, 12 May 2025 19:45:14 +0200
Message-ID: <20250512172024.715222640@linuxfoundation.org>
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
@@ -10693,7 +10693,7 @@ int amdgpu_dm_process_dmub_aux_transfer_
 		 * Transient states before tunneling is enabled could
 		 * lead to this error. We can ignore this for now.
 		 */
-		if (p_notify->result != AUX_RET_ERROR_PROTOCOL_ERROR) {
+		if (p_notify->result == AUX_RET_ERROR_PROTOCOL_ERROR) {
 			DRM_WARN("DPIA AUX failed on 0x%x(%d), error %d\n",
 					payload->address, payload->length,
 					p_notify->result);


