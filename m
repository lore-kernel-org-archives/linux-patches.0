Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831307;
	b=4bFwaxqc7iGsJGZqbUmSfaGjqU2t/Qs2NHQ5F5JwLvCz5/zxawq94DkC+6mWqranBm8/
	 PMru57f5KQn4xuwNMAXmtLFuDamQd1oSIg6r9Wao9ahR5ddD/bpMjBIRpgZktlVHC3x5D
	 hhDx95NceOqwYXmG+ZvrFS/MmhRYHNO0fVOJY4MLsTzY9o5QEPg/myEa3J/D2qPcVbu4y
	 YHxWJkxQ3BPweMlyLivXax9sGGvzxugsdm2i6HREOyG6Pj2HKUX68LvRvlDN0TMZoDCBb
	 /bdcrXayVZGR3E1NRWyzFwYaDErv0BDunoGL9Lo+INChoUBXMHG7it9QHkwhB015mrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+AbAKZfsTvilYszSqXO9h2oIu2DZn9QWn1YEVOCL+Ps=;
	b=RfUnTzCFmwXDqUmyN8GlpPRNnUp/mCKf6pmMsGuUoYHGVw1UPhGi7Gei24M4A2YZ44hu
	 aHPrSxDLiDH17VpjLfpxUx/k6KcjD/Mw6IrMTFxeTLX8V8ehDSMzLuPskCtav5pNpRS6z
	 xvEkdFG6gTafRuIsDJQxRAJpP+wqWlffTO1DacRPDnaJdLmJi0cLZjPZY6JFfV134hHNP
	 I+GozgPkbKnbZ7Vng+A4MMr/6kEv7fGpdd+XamYXSoRbUf4Cgm21Uk15nxpI0ubBm2oYR
	 1vh7zO5W8sMmTi+tf6znF70HxQp3/UKsIgH+QYEzRgCNMGOwpcq+Oi1//iawL3j1MUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mupQCm2A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61150606B2F8;
	Wed,  4 Nov 2026 22:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mupQCm2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDD31F0093A;
	Wed,  4 Nov 2026 22:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831307;
	bh=+AbAKZfsTvilYszSqXO9h2oIu2DZn9QWn1YEVOCL+Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mupQCm2AzrRLiezgBgf6JWt8SkbAADpMydDtN20MoQ64pLEy4+mQfAydJK4iKBw37
	 BU7sJOdlw9PtzWYuCgvAtJ8DsHWIg8bNfG8Ieewwo2q+bNmRL6OrcXP7xtZfGmPUov
	 +kgHC0r7Ku3Cq7sBqMpEFlAGuQ/zFTQb9mzrqIEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0623/1005] drm/amdgpu/uvd3.1: Fix checking whether UVD firmware keyselect was already set
Date: Wed,  4 Nov 2026 16:05:56 -0500
Message-ID: <20261104211101.263418599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1df45633e8120..ccb6572891136 100644
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



