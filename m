Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585753;
	b=gJ6FfXbTSn8mfKgg80/l8S0MFyf8yy7zkb5sWM0dKXiqQVjr0uwbZnrKFo8RROlWwbK7
	 EUb1QeSy7cA2ns2WaTW9+/mtC2PWXgceVkS1i1W+c6vZ0f9/uxJK6WCIerVo6bawaTVvX
	 pF4poPd98ofZSMHrFdEq20Kjeyv2Z5YAYQR8fnKRZxCwCeXkYMWx3TuFS7FXCR4gh5po4
	 djNe5AeGZP6SuwxQlXP+kVPhePmc4p9h0rf0kBpo5T6LgED5FPJoB+l2GD0pPj6I3NMVk
	 Lge/mZKRyTjsKv2oiRjnrbChNNoUejUaof0b2/0m6bptmO5ODXZKBEO6fkArR7pPLpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dL4FByfggfMLAUlSPOoe31KLIp/9SWMm2eDoO+lplb0=;
	b=IsNycQfG9TRYf/eCRUBFsmNOKk5eo5YcnBMcZLBvrhVbfEqwspAMlhU4gj65fmRVSgPm
	 gFB0YeMDESfXKzhyftB8s+4C4NUy7ktzlkLY64k0LCwKwHiswEjo27INL/UxYuRanw9HN
	 kvSkssQa5FXCRXpsqHe+0CeItWOzsoHj6aIJIxbcjFteSzMBGOP506PHTU2dA6d/hlGpe
	 kiCSIG2HkPrFSxRR9snl/PzwKLpY8bdDWowHbN4l0UAZHwlP/pXirFL1PBoQ2AvNMpd4s
	 OoG5lSArJ2R4WiAM/oYmObbPymosWgp/xM2SqOT5CJ35keH2EZSmIU0l99+9WxwWvxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWwkEQ5Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3251E606AE18;
	Fri, 13 Nov 2026 16:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWwkEQ5Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8317F1F000C4;
	Fri, 13 Nov 2026 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585752;
	bh=dL4FByfggfMLAUlSPOoe31KLIp/9SWMm2eDoO+lplb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWwkEQ5QWjB1qvFLys3Bv0KOI5l3yFVv1LbhlQnL7MuecAwY0dlmtkK50IsRHtT21
	 8FiQv2QX2IfTaNSJ1jejxlFnYO4aR3Pmt5IVCUVa9Ilh51Nxsfc8wdi/KkEYVIxS2j
	 iSstNNFDyjUTla9urxgBTSnS8B5fLuFG1i/i3usw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 348/507] drm/amdgpu: skip RAS error count reset in debug mode
Date: Fri, 13 Nov 2026 10:50:52 -0500
Message-ID: <20261113153807.232967289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ce Sun <cesun102@amd.com>

[ Upstream commit 9b115ca0e5ceba08da9b9ca09e6ba65d1a2544c0 ]

After legacy ACA support was retired, some ASICs systems may trigger
security violations during driver load when
amdgpu_ras_reset_error_count() is invoked in debug mode.

The function only checks whether RAS is supported for the target
block before proceeding. In debug mode, ACA/RAS handling is not
available and attempting to access the reset path can lead to
unexpected HW accesses, resulting in security violation reports
during driver initialization.

Prevent this by treating debug mode as unsupported for RAS error
count reset and return -EOPNOTSUPP early.

Fixes: af1ae7d0beaf ("drm/amdgpu: retire legacy ACA support")
Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit af6b6f1a14dca860468b0fe2a55b7194702d5fa0)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 35eb87591740a..37cf1b8089502 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1485,7 +1485,8 @@ int amdgpu_ras_reset_error_count(struct amdgpu_device *adev,
 		return -EOPNOTSUPP;
 	}
 
-	if (!amdgpu_ras_is_supported(adev, block))
+	if (!amdgpu_ras_is_supported(adev, block) ||
+	    !amdgpu_ras_mgr_get_debug_mode(adev))
 		return -EOPNOTSUPP;
 
 	if (amdgpu_sriov_vf(adev))
-- 
2.53.0



