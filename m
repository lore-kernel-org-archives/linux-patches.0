Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFA9E56A;
	Fri, 15 May 2026 16:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862767; cv=none; b=fkP09ZjGybDqmBQHf+S3wyRZCZOrhSRayeeVcKBLfhfrzwDPAPVBH+voaP1t1IflmSw0KKaHHS73p2m08rE6khhenaXktK0hIgCNXO8MfNQlrsbSMnI3Ydg08w1fVshFZGUwKpNcqFoEJZoHOUmje3cEWvykOdYfUWJXax6ervI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862767; c=relaxed/simple;
	bh=sGNnaODJQMgvseagIhHiTvaxDB5+d2iDvHHqV/DOyZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNmDhqa+YmVyJ97LSEyYUqan/+rQ70/1MCSAlMhljbiytoAvXX0Mo2pqmd15yEQ8DHJWtyW9Mxx1nSADsKfapL7zLUVop0QG1dkri+4EBqRDNt8oE04z1KC0Dkj1ApQ8ykeKkbOe0D/JTY/9ZpkENEpGnIJyBrQnOtdjy0N82a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEAPXMnx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEAPXMnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BE5C2BCB0;
	Fri, 15 May 2026 16:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862767;
	bh=sGNnaODJQMgvseagIhHiTvaxDB5+d2iDvHHqV/DOyZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEAPXMnxgt+ntS13prZnTfDOnwJqItJa3koWj93Zh+qbygtCbEwvjOQvpSvazWULW
	 +TkW4x2muePuZFG7aBpg9etBlTqcwKoUIwBbdQgzIUJFwDJwkzVDcNd9i6FqZ9Wt36
	 0qdbabxhcDC1zXLOY38xjBvZqHAqOlaCw7pIO8RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	"Ramalingeswara Reddy, Kanala" <Kanala.RamalingeswaraReddy@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 133/201] drm/amdgpu: Use NBIF offset for register RCC_STRAP0_RCC_DEV0_EPF0_STRAP0 .
Date: Fri, 15 May 2026 17:49:11 +0200
Message-ID: <20260515154701.447127591@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramalingeswara Reddy, Kanala <Kanala.RamalingeswaraReddy@amd.com>

commit 08cdf07b55bff236aeaea3d52a8d1ffe11d801ec upstream.

Define and use regRCC_STRAP0_RCC_DEV0_EPF0_STRAP0_nbif_4_10,
to get correct rev_id in nbif_v6_3_1_get_rev_id().

Reviewed-by: Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
Signed-off-by: Ramalingeswara Reddy, Kanala <Kanala.RamalingeswaraReddy@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbif_v6_3_1.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/nbif_v6_3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbif_v6_3_1.c
@@ -54,6 +54,8 @@
 #define regGDC_S2A0_S2A_DOORBELL_ENTRY_5_CTRL_nbif_4_10_BASE_IDX                                                  3
 #define regGDC_S2A0_S2A_DOORBELL_ENTRY_5_CTRL1_nbif_4_10                                                          0x4f0af6
 #define regGDC_S2A0_S2A_DOORBELL_ENTRY_5_CTRL1_nbif_4_10_BASE_IDX                                                 3
+#define regRCC_STRAP0_RCC_DEV0_EPF0_STRAP0_nbif_4_10                                                              0x0021
+#define regRCC_STRAP0_RCC_DEV0_EPF0_STRAP0_nbif_4_10_BASE_IDX                                                     2
 
 static void nbif_v6_3_1_remap_hdp_registers(struct amdgpu_device *adev)
 {
@@ -65,7 +67,12 @@ static void nbif_v6_3_1_remap_hdp_regist
 
 static u32 nbif_v6_3_1_get_rev_id(struct amdgpu_device *adev)
 {
-	u32 tmp = RREG32_SOC15(NBIO, 0, regRCC_STRAP0_RCC_DEV0_EPF0_STRAP0);
+	u32 tmp;
+
+	if (amdgpu_ip_version(adev, NBIO_HWIP, 0) == IP_VERSION(7, 11, 4))
+		tmp = RREG32_SOC15(NBIO, 0, regRCC_STRAP0_RCC_DEV0_EPF0_STRAP0_nbif_4_10);
+	else
+		tmp = RREG32_SOC15(NBIO, 0, regRCC_STRAP0_RCC_DEV0_EPF0_STRAP0);
 
 	tmp &= RCC_STRAP0_RCC_DEV0_EPF0_STRAP0__STRAP_ATI_REV_ID_DEV0_F0_MASK;
 	tmp >>= RCC_STRAP0_RCC_DEV0_EPF0_STRAP0__STRAP_ATI_REV_ID_DEV0_F0__SHIFT;


