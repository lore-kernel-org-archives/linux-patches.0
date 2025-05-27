Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CAA86347;
	Tue, 27 May 2025 17:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367840; cv=none; b=uiCjYpz/BQuGomsXdFftTlvrAHwmNlmz960y70Nk6zfhb30X57j7JaOY5aq/KeRGYdAumMyeYP3v3Az6xpPb9ZOpkoNBjtSJjRYIPmOmBfxXXc4UcVvCar34iiRJEs5/1/GXfbQhSyEkZJaBzP7WEMXE9gpKI3TU3HYB3z/FU40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367840; c=relaxed/simple;
	bh=Uz6VgIvUlWvXCoP2dGqa9+TW9KS+D5+tGufWFDtyjy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuogRGggriAMD7AL3MMpAo0ehiKGws6TDHk99SDFtSy95O0bCQBojpXTyM6sBzp2nz56COcnmiN/zJe/W/cjrNX9AvZKDDB9BJDmN75KJ2dg4o3fAsVe1HNut4Injyih99BPGKBeNTe8cEAv9zc+YcQ45a9bCmPtM2UyHAekcMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtReDhVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtReDhVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B971BC4CEE9;
	Tue, 27 May 2025 17:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367840;
	bh=Uz6VgIvUlWvXCoP2dGqa9+TW9KS+D5+tGufWFDtyjy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtReDhVPL6b64Kzl0XYf52LNMccvawie7x5+5Ao16ZztFA569Pecgu31PVevhoQZM
	 WURLU0oJFHLhKkJH5+Eg7hZSp9RKwdDRBCiWT0Q+xyPUUSsuPLDcP0dTSXqO3+GNaH
	 gmXMIjqN++Jlgh+3UIUlDwOnip7XBxUN7Q1NwKno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 485/783] drm/amd/pm: Skip P2S load for SMU v13.0.12
Date: Tue, 27 May 2025 18:24:42 +0200
Message-ID: <20250527162532.879510156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 1fb85819d629676f1d53f40c3fffa25a33a881e4 ]

Skip P2S table load for SMU v13.0.12

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
index da7bd9227afeb..5f2a824918e3b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -450,8 +450,9 @@ static int smu_v13_0_6_init_microcode(struct smu_context *smu)
 	int var = (adev->pdev->device & 0xF);
 	char ucode_prefix[15];
 
-	/* No need to load P2S tables in IOV mode */
-	if (amdgpu_sriov_vf(adev))
+	/* No need to load P2S tables in IOV mode or for smu v13.0.12 */
+	if (amdgpu_sriov_vf(adev) ||
+	    (amdgpu_ip_version(smu->adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 12)))
 		return 0;
 
 	if (!(adev->flags & AMD_IS_APU)) {
-- 
2.39.5



