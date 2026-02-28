Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23271340293
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301205; cv=none; b=dYwBIJKT2cjMtpPOKYG+q/GTmzrmwOJIOUnHwwN5AVVaouplJNcK2mbtLneQbhXnsz62p0og/qM9tt9oC4I6LqH1+hml94/1ij/+nGz6/yoI1M5MAEz81rqcFWnhaLDOQrjqOrY9rbcMN86ofYXCiI+AEuwZI+J3coVNKIx4U8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301205; c=relaxed/simple;
	bh=z5mQlSzVkwPHuj5nkZeWaLR6a9ph9HQMHxY5lhTVUAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TllO4S4OUJI6D2eFjZV3q/VTWDbSmv9QDjsvu91OEs34gpp6IIDgpfKCr/5vH+/OzGdwguG68y9/Q5nV9/EIoS6y8857S69iDB2ZSAwiLsSPqgHgwZM7bo6AOCLD8gMlI7zLAZTEyPG44c3lcixVUC0XpVVu8bmlOf17p37yEWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N1fqecK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N1fqecK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E275C19423;
	Sat, 28 Feb 2026 17:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301205;
	bh=z5mQlSzVkwPHuj5nkZeWaLR6a9ph9HQMHxY5lhTVUAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1fqecK55Trm2ZkECv3qkSifCSM8qFqOIYCEn+TgcQr5lS053FO5WBzlQNrJmUZ88
	 hAh5Hrh4I/AO/a5s5LVGW/K8K9d6TUVtwKNELdW+MV1Ew3o78AJhvz+mhR6Wn03ooU
	 dpmm/866wqATh4KVed7ZYLoz4+wcI+Zq+CMApyynm/gjrxG02IFTFUzhsxNIU+BmCe
	 d2AXli5zcNLA4J64ONOJu7RS6qXWeCsri8IyTcXCZCYsA9KW5imWYcaXGUSYaUKszN
	 MI8PNcUIk3ICeFCKsZ0IfxlVWZAxdTnHMdIGlkrYwf0YnsvMpBBb9rFEFGpCbplF4Z
	 CwzqmewFIwMmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gangliang Xie <ganglxie@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 378/752] drm/amdgpu: return when ras table checksum is error
Date: Sat, 28 Feb 2026 12:41:29 -0500
Message-ID: <20260228174750.1542406-378-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gangliang Xie <ganglxie@amd.com>

[ Upstream commit 044f8d3b1fac6ac89c560f61415000e6bdab3a03 ]

end the function flow when ras table checksum is error

Signed-off-by: Gangliang Xie <ganglxie@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 3eb3fb55ccb05..dafa46a9656ca 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -1475,10 +1475,12 @@ int amdgpu_ras_eeprom_check(struct amdgpu_ras_eeprom_control *control)
 		}
 
 		res = __verify_ras_table_checksum(control);
-		if (res)
+		if (res) {
 			dev_err(adev->dev,
 				"RAS table incorrect checksum or error:%d\n",
 				res);
+			return -EINVAL;
+		}
 
 		/* Warn if we are at 90% of the threshold or above
 		 */
-- 
2.51.0

