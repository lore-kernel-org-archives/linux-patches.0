Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043964;
	b=yEFSsQQQQ7vPhEnFx3cyLrF3id393O9X01pv9FJkO1zTMXFjMrnhihZaDuzqWyAedVn4
	 PH4fiST+cFMbgrE75gnwQsgCKgLm0aP28yhyMh1T7JoXGOQ2q6LBo8N72zHpPHx8QRvqU
	 jdDB7Hd6Dyi9e+YnNF23RqpjgpdovtfS55A39dDznf0dXlDiopeSxL67fxtfbQ9cEoL/d
	 YLzIAA5QbjPT++kXZ38dj2WLkRN8PMn97k0zgmR2xHnOkRhfHZraKpj5hjGvXXn1bOcx9
	 5562WdVJ/QeBQPtBGFVS2Q/gJDcWyJzX5AsDgh7OJ/wBJcLksP8C008OEUkXusD6TBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qi7+9HisFRayeJU+Dhn36Qw/12Pi+Avk0ukfgzf8vzE=;
	b=GhSftmKEChIaJA7iv5keBSj4YoP+dimghR4gyP+MbgAihMu3XoJIA+KU/t0A1YxtlEna
	 TcEpIOQtAhrinYl8W1efaexbY+fdaCn7qFike9o+2FeKNZnJHMwuyhntMMzkpBindyuoR
	 erd9C+qxRx1kmBy1rn/7Gs2ne7P/RdSqjsPxbPP12uREzi6k9Xa/DEf9BMnpghN4Pqgu2
	 wGP5bvWB+ypLPSDkfZw2nEza+7NdemN+Ucr0/64+VuzIczgFkT6jQa5r76mWlZ/a8VZGi
	 5Ckno5GxqjDH1NDfz6AxJtI0SeNS6bEmjw1X2chkIJTYZ9z3Vpuwk1NtnkuoNBXFd/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjIpVMXl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072E5606A32C;
	Wed, 18 Nov 2026 23:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjIpVMXl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4641F000C4;
	Wed, 18 Nov 2026 23:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043963;
	bh=Qi7+9HisFRayeJU+Dhn36Qw/12Pi+Avk0ukfgzf8vzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjIpVMXlITmPzmmtMaXCe+YUf0GORdk0+upZqAWOcfhoEMWiFR3yGBU5373n5pEMX
	 rU5KgLcB+YG1S8uRU+OdRUyuVWtSKj8z/ivKxc/sb/YE3UIEFYQzMzyWeBmD/PHEoG
	 kGALztH2GzkunF7A+FFuxrIwLZKMYjk12bYSEkys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0397/2857] drm/amdgpu: Skip accessing psp rum time db for APUs
Date: Wed, 18 Nov 2026 15:23:51 +0100
Message-ID: <20261118150215.688879869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>

[ Upstream commit a26301203a196a991527f7b1ab884d4dd0e7c95e ]

Psp runtime DB is for dGPUs only.

Signed-off-by: Kanala Ramalingeswara Reddy <Kanala.RamalingeswaraReddy@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit dce8195027f146467c9378efb2bb1b0859cb735e)
Cc: stable@vger.kernel.org
[ sashal: Adjusted context: the early APU return is inserted after the local declarations, since this tree's function lacks the MP0 13.0.6 check the upstream hunk used as context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index b489a97ba4ce2..c44c24c24bdf8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -266,6 +266,12 @@ static bool psp_get_runtime_db_entry(struct amdgpu_device *adev,
 	bool ret = false;
 	int i;
 
+	/*
+	 * Runtime DB is for dGPUs only.
+	 */
+	if (adev->flags & AMD_IS_APU)
+		return false;
+
 	db_header_pos = adev->gmc.mc_vram_size - PSP_RUNTIME_DB_OFFSET;
 	db_dir_pos = db_header_pos + sizeof(struct psp_runtime_data_header);
 
-- 
2.53.0



