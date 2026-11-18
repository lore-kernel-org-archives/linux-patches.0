Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034937;
	b=OK5KuddmUgXyrcjfccj0v3fTz9cpzeZaZXfh8c9SJkTUPivECFZbeABYj68zNnxzpPcc
	 4JXE2NggLPcKY4zEBUm4D1r/Q9+JQ++nY7Jj7y1TlzA6sh8y8fVq875hnaywi2QUlXKSv
	 hMrTsAhcieuu0yZ1D7ZMMBlax3AXH9qQKHes/mgBtvd4QQTc6MbVld2OFii70rrbCoxgB
	 hvEwY4sUayYmQhsZC68/7CdTisihSbz8wd6ljJPs6h+5ihBBl9Xpq32z0AB6IrWItFkKV
	 EGVCtyoGD0OuLjH+1GjBfPblWaQp8s8BzDE9e76rClh+kt60rnHkE7xaiJhJfekAacw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2jF26SSiQuVWnMuD0Ue37xpPOv1W3sAMurvXvvVuIjk=;
	b=v7DOkXeZB7sRE7VjhI0dAeVw+tMUjjB0QrXJ6RoqLabrJ6D1u58MG+BPVvQ3Ss0xFA4q
	 /xO/OGzq5z19F7kH4xHDmvyTbO0l9Uj6BeOdkqQKkemNeFiPCBicTBnN710AcqpKalwzH
	 W/mDjGOh+nlg5+PUB5JR6jVfskzQt/sYdIpIUJDvR6J5OJRRmHYWKV5dz4Lekfx+OvuUy
	 OUt3SQeZhwsYDiBRFO9V4DNbrCBgqoXjcZclqzmNY0biJzyZKDaUpBDEkAKSxy0WskyT9
	 XWicSdafgaaJYp+omjIpGzNrDT8bE5qyoHCZNTkGCSTQ9Tu36K/UMC+t/81HsPygn/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qVkWsx/e";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B22606A31C;
	Wed, 18 Nov 2026 20:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qVkWsx/e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E1E1F000C4;
	Wed, 18 Nov 2026 20:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034937;
	bh=2jF26SSiQuVWnMuD0Ue37xpPOv1W3sAMurvXvvVuIjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qVkWsx/eFPL2+Fj8pWTR2o+J4Y9ahqgUs6idFhvhFmFSIjXZYmhwIjb4vo/eXEq2W
	 k/3KiIiccLH1MECfeCkyJFIY7CtmKHPG4VtnXprx0CINSWA904YHiFVF2VssiWFSO4
	 GylGRsupHc90m1JlbL8FvtQ1St9+BEMz8Q0T93dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0548/3318] drm/amdgpu/uvd3.1: Fix checking whether UVD firmware keyselect was already set
Date: Wed, 18 Nov 2026 15:19:30 +0100
Message-ID: <20261118150333.737225519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 800ea86e83e137395eba54103e5c459c2bc9965f ]

The PASS_MASK is for a different register not for UVD_FW_START.
It was a mistake to check this flag. It should be enough to check
that the register is non-zero.

Fixes: 889a2cfd889c ("drm/amdgpu/uvd3.1: Don't validate the firmware when already validated")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20261006211607.75407-1-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9dee462c83259ca769aa1bf82228adee9831685c)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
index 49a0d66d5b2c0..5334da3c0cf1b 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
@@ -288,7 +288,7 @@ static int uvd_v3_1_fw_validate(struct amdgpu_device *adev)
 	int i;
 	uint32_t keysel = adev->uvd.keyselect;
 
-	if (RREG32(mmUVD_FW_START) & UVD_FW_STATUS__PASS_MASK) {
+	if (RREG32(mmUVD_FW_START)) {
 		dev_dbg(adev->dev, "UVD keyselect already set: 0x%x (on CPU: 0x%x)\n",
 			RREG32(mmUVD_FW_START), adev->uvd.keyselect);
 		return 0;
-- 
2.53.0



