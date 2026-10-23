Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774771;
	b=lw5ZSEHbedoPq+KuoAR3XTpYVf/XBBIXQvrZA0m86AOzLg2cVQRCT1FZ8rj4lYXNnC/J
	 muQ4U2kq3XAVL/zINxAIvGietydoNKYeMdxM8llxiIr1d1SSU+pK4ZugKhYhHkZ2Rk4Yg
	 SpV2I+aSEaLFhsn3Bz9nHjUUR9RKKC+dtBx8Lkx42WysKv2qEIVo0VJk7tmjV1NW3K9K8
	 Kc30UIzERmjaj+hy7Qc5oTXt2Gw9gADAhxWbAVvDVNu/9x+JaRGquKSlCM/Zjsnq738w5
	 DH31Jn715RELzspJJkMSLmr3X9j/w3OvEHUfi6jTM30+aDkRTjvDa40+39HnQvzDREw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qBVl4dLi/QK/OViN2K6XIWBlvfdsJRbWEAMoXGozaHE=;
	b=tUiaQpyjHVN2Wli1EeHh4hZaGNfxilmYPt011vlrjuEdnjXNmhxbLUdi1Y6R0+Pykp//
	 KmCF/ilGcmpX0eCN95lLRMM0pBPqXD59GRhrLS2AyVzDI74YxZ9NvoEMsepEScA22dnMe
	 gqapugYwb9ZeLhLX1zZAe08WArSLhN2kLPQdpS+6KRIymcrTLutKyZtUMRFeSlP0oP4ln
	 MSbAcZ4v/nUpZxDwlYjnW/DkP0pYbq2pgc607nZUxmYEyeg2N7YVcTdelISLJ13gnQWJM
	 ou1jaqF2n/F9fRsgCIcFRVtv1NHi/L0+bcmi8V4xNdZZ07KuxIV5YSAu/iMtWAf0UXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cMGALPDH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5DA606A31A;
	Fri, 23 Oct 2026 16:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cMGALPDH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2FC1F01825;
	Fri, 23 Oct 2026 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774771;
	bh=qBVl4dLi/QK/OViN2K6XIWBlvfdsJRbWEAMoXGozaHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMGALPDHf0oGDFLRe1unTK3ZVY2LxMfwjk+io3G3OHLmCeRTUNwpmkeS2CLqJibGs
	 uuRgOF0GKZg8YD/QEV2hEXyzwUc7cBeuKQR453VtIcC/OVql88a3sVYzkH9J8akaBv
	 gyaUJIHnfdwKeynOCPQCYWni5RInVCmiQAgY9NZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 153/242] drm/amdgpu/uvd3.1: Fix checking whether UVD firmware keyselect was already set
Date: Fri, 23 Oct 2026 18:39:55 +0200
Message-ID: <20261023163717.402315623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 800ea86e83e137395eba54103e5c459c2bc9965f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
index efb3fde919ee..b7d451f439a7 100644
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
2.56.0



