Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359FE350A0D;
	Tue, 21 Oct 2025 20:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077453; cv=none; b=AmBo1XHk/+cjLUIJCSUrUwVAU0qXFLPtMBwSsXx9ys+/0IfE3/XG3bOKLYI+PjV7rdAJc0cFMjCWrmusYm6xB7j3wfKDjesh14uKrcJ2C4ueRVDT+mXXB+zgcuHQNb7AsgBfcykRvvbKB64YmPq6AKa5NE/OWg/sP8GjW6uJu78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077453; c=relaxed/simple;
	bh=rC38lbO5riC7K9qVQ1AzZ+EPyALvEReDtzrx6zQDJ6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7wR2ytZd5bfhQxX6SaQ9we7RZlVk6zGUdzzBb0cNoCRozUpekPwjNxU/99FVLq69tS2DIG5FY+PQPPzEBYF0aD5e4uPUye6r7h35Fy58dh7Wsw6uVlnZbkV3irOkDWjHK5OtUi0WAxByIt0lWQvGNmL1V0mEvooJ/SMb7mLUeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g068yJeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g068yJeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93827C4CEF5;
	Tue, 21 Oct 2025 20:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077453;
	bh=rC38lbO5riC7K9qVQ1AzZ+EPyALvEReDtzrx6zQDJ6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g068yJeJinNPl3bHLOFIy1YS6/oxEzatZR6gq9xpfjZb836Cpq25JKU7LfnyzftLa
	 bmfg54wgGjs8EtTMN0R881dwiFfYi6fGbtv+CfjF3LSZZhpdwBoHMCi/qnkp6nswLZ
	 MxQYysOjI20LYxKO0gKoF4P3J6CjbQ9BUHKjbzdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 110/159] drm/amdgpu: drop unused structures in amdgpu_drm.h
Date: Tue, 21 Oct 2025 21:51:27 +0200
Message-ID: <20251021195045.817151217@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit ef38b4eab146715bc68d45029257f5e69ea3f2cd ]

These were never used and are duplicated with the
interface that is used.  Maybe leftovers from a previous
revision of the patch that added them.

Fixes: 90c448fef312 ("drm/amdgpu: add new AMDGPU_INFO subquery for userq objects")
Reviewed-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/drm/amdgpu_drm.h | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/include/uapi/drm/amdgpu_drm.h b/include/uapi/drm/amdgpu_drm.h
index bdedbaccf776d..0b3827cd6f4a3 100644
--- a/include/uapi/drm/amdgpu_drm.h
+++ b/include/uapi/drm/amdgpu_drm.h
@@ -1497,27 +1497,6 @@ struct drm_amdgpu_info_hw_ip {
 	__u32  userq_num_slots;
 };
 
-/* GFX metadata BO sizes and alignment info (in bytes) */
-struct drm_amdgpu_info_uq_fw_areas_gfx {
-	/* shadow area size */
-	__u32 shadow_size;
-	/* shadow area base virtual mem alignment */
-	__u32 shadow_alignment;
-	/* context save area size */
-	__u32 csa_size;
-	/* context save area base virtual mem alignment */
-	__u32 csa_alignment;
-};
-
-/* IP specific fw related information used in the
- * subquery AMDGPU_INFO_UQ_FW_AREAS
- */
-struct drm_amdgpu_info_uq_fw_areas {
-	union {
-		struct drm_amdgpu_info_uq_fw_areas_gfx gfx;
-	};
-};
-
 struct drm_amdgpu_info_num_handles {
 	/** Max handles as supported by firmware for UVD */
 	__u32  uvd_max_handles;
-- 
2.51.0



