Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034657;
	b=gRVPo+yT/vtUN65JSzdU1Zpo399jHLtvvfQ2OcIMlGf6HgHY+XfVDyI8orzzJthTybXE
	 9PADsgvnkxGBrztGmiMGHgAf3xmcO6aSWxUXGGEIcMhriS4d7HX3EF/CQbf2GwXTmIb6t
	 X0qau/ZDVLEym950reYsvK8bQe1YySl8epHwBTbQC9sfpGO95hIDpzuhEivM32FDEgWXN
	 +C9ToAoHs4iXH4lCASQHwUoBMYpgIjHtcLWW0Btzphr1+9MtI4C8YuYQkKDsjx4fWFx9e
	 U0kRrUxYqOQdWiTdPnFqBwETH3uOcqvvQrkv1AsjEQ59m843WV70e6nUxWHVJpbPoJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZcTKhNrBrf46nW6ln7Q/tetIrOCh+ekqqEY0aDCxXEk=;
	b=AZoemPyti6L9equlY7rSwE2vcFwtuU2EPm9ugUb6I33p22eRqn2IfvRdM3sNPGHp9yNu
	 FuilpBG+CfcMMsj70NXdlAY3zKdaL9tlFrtBEpkFKZvx/xz44Fi6AocCLG27Ho9EKQuAa
	 2ZoPhshYZjep/ebjphQtUdFTAWqNMrwMobwLydStE1vYnsI22GtazWuF6UfZIgpuAh1Eb
	 GC45cjW/EjdhnU6lzr/xwAAA9itNbP0TAzTe7t8TvbWFA1hx6Uxl+ao0MwF4isyCTlcb3
	 KfJrPHgZQLZVCkH4IKZ42FvWWeFmt0U39W3cllwKoInSzaSvj8hEqoywkvBwk5H9n6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtXmo7iC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93367606A31C;
	Wed, 18 Nov 2026 20:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtXmo7iC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCD61F000C4;
	Wed, 18 Nov 2026 20:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034657;
	bh=ZcTKhNrBrf46nW6ln7Q/tetIrOCh+ekqqEY0aDCxXEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtXmo7iC4HafB1VPSRkKZd6EYoJdYaxZMx52kW+3IO1YqZMpHxeHWN1aTtIZ1uA0W
	 zf6T1wcUqZFiEOxLiafac4S7VXghAW8nfSdHvmK/k/P/2ALlfSIBl2Ht54MvnLc9W0
	 3HJpUfxSAH1rdqxg9orgsQD0CEmVx7A9UlaS+Ko0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0448/3318] drm/amdgpu: Skip accessing psp rum time db for APUs
Date: Wed, 18 Nov 2026 15:17:50 +0100
Message-ID: <20261118150330.190105826@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>

[ Upstream commit a26301203a196a991527f7b1ab884d4dd0e7c95e ]

Psp runtime DB is for dGPUs only.

Signed-off-by: Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dce8195027f146467c9378efb2bb1b0859cb735e)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index e678fd5a0a60c..f918ded27b49a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -335,6 +335,12 @@ static bool psp_get_runtime_db_entry(struct amdgpu_device *adev,
 	bool ret = false;
 	int i;
 
+	/*
+	 * Runtime DB is for dGPUs only.
+	 */
+	if (adev->flags & AMD_IS_APU)
+		return false;
+
 	if (adev->ip_versions[MP0_HWIP][0] == IP_VERSION(13, 0, 6))
 		return false;
 
-- 
2.53.0



