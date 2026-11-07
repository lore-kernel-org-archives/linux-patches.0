Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061462;
	b=ErEZJmpVZpSS3s8e1gTiYOBHb+OFIADQ7o/GnAfw1dp+B+zcs4Jcvu/F1c9Zg0WX74VJ
	 poIKNcTKL5go1VUsifnrAwarcwbEAPFsx+//E7WjhlKEUvtNDYxjyQB7E9vBLrdKziVTE
	 04fRXXQ1oQ2wahaYmH8zl1ykrzjX/t6b06MvmwUi5k9TZlTggNa8NddqpbXalHgXM215g
	 WljEzJMynbbFf2tNTnc6Fz1TC7pUg+STvpzU5Tc6i+K2j85szdu5iAbRjuGulpjQQzd3S
	 r38yeMyGDd12b+Kf1CEZ5hmwS7l3AuwWZa+9h+mljxydUVpaE+/jDxDMEC2MvbJca2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=erh5fW2YXsROCQifQ879jQLYSER401s/DHP1l7Ty1vQ=;
	b=ZchG4rmeDMlMK4llhjMpmxG7fXOlc2gZ+r/Ab6aiY60gxdKpG+lF2OHcTYdQyeBtklxa
	 ogQKcmuHpsqh+ig+ZUuMZuTs3QqKlE1rxmS7w2Gea2G4/uC89ARdOBeWyMlSlcgiar75A
	 h47w1DRx31Ohea0O+zIiJG0SI3Cjs+KZOn/d+vlyOrKS9IbWkQFV8ai6A1DH/bLwPUEe1
	 l3gUl336E34w5Ek5l20ZPnMCmRCjEyEtvS74jXhhSJA73bm6Y57BVZBi1V5CvHfTYWTbP
	 0ftimlZSsPsjwqaWb2n7m6WiXcUCpGPKhh6UGl4d+P3VOTXP1MIYaz3D0i/f9togpGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIAo+KPd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3DD606A326;
	Sat,  7 Nov 2026 14:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIAo+KPd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458B41F0089F;
	Sat,  7 Nov 2026 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061462;
	bh=erh5fW2YXsROCQifQ879jQLYSER401s/DHP1l7Ty1vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIAo+KPdXtTh3EbEM8ZqSH7cKtCqfjwwFfrZ2qD3cY/zmhcWr3vjnG5UeeJ/Fe6ge
	 X1fCL+cry+4FeGgUlO6cWVO6HCVK2OSr8Pn+LK6RQRGBCY/ssTnCtFNQGblwVMHSPw
	 A268i0oZGqPFCwAmg7WTOvZ6BB7PuOIdNM09x5h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0565/1536] drm/amdgpu/uvd3.1: Fix checking whether UVD firmware keyselect was already set
Date: Sat,  7 Nov 2026 08:43:01 -0500
Message-ID: <20261107135013.450030446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0344f74cc4547..dc5cc48a31350 100644
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



