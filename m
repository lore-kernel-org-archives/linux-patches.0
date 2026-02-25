Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B24D18DB2A;
	Wed, 25 Feb 2026 01:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983108; cv=none; b=umIx+q0TZars6RKrHRDXBGDOiwEDAXNBIOn7F6zwH+VthykPvQxf3PIM53dcC8YV2C+Yao9OMItKiV7fNQLOjLCdahmrBhQC12QrHZUsv3cJ5DmiFouEi+oP7sjk45eI9wRd+WeSy4Az8WNV8YBN5ktMW/dk7CF49Jmx/qBeids=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983108; c=relaxed/simple;
	bh=Nu5sEFSZN1HVHMngeFLXhZhMLF4/p4mJxfnxXTk9eFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCsKuBQLw5u51fzmANtgQQOILNkJadn4ge3DiTRhc2wbVbqX5rzeknoem2zmHFUG+fKYlWwHDRiDmtPMAKK91H7PCfmMK7h+HVHM+iItniEOlRr0VasCMZZ2JXo0O6BlJY0wOhJdmPSB3ukh2XcN4wzXcO5yvWmcdJZSE7l1I84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeKKrIlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeKKrIlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAA9C116D0;
	Wed, 25 Feb 2026 01:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983108;
	bh=Nu5sEFSZN1HVHMngeFLXhZhMLF4/p4mJxfnxXTk9eFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeKKrIlRmaZPCQMnXZUULWM0gW70/wLam2FrKHbP73YauGFfwsYsNjAzKQ2LiF6ma
	 d3GR6AsGZWL8xqE0+BZpDac9zu7sZGwbc/s5XhLYwmlE3JXVHAF/PsGi0bBPMLeYjc
	 CmUF+DKyYotaUWh1GgHO/CBXTyefKrq+zq+EkN3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 269/781] drm/msm/a2xx: fix pixel shader start on A225
Date: Tue, 24 Feb 2026 17:16:18 -0800
Message-ID: <20260225012406.298353119@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 6a7b0a670ba4d283285d76d45233cbecc5af5e40 ]

A225 has a different PixelShader start address, write correct address
while initializing GPU.

Fixes: 21af872cd8c6 ("drm/msm/adreno: add a2xx")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/689906/
Message-ID: <20251121-a225-v1-1-a1bab651d186@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
index 1b1ee14b65cf0..f6e48bb8cc69e 100644
--- a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
@@ -77,7 +77,10 @@ static bool a2xx_me_init(struct msm_gpu *gpu)
 
 	/* Vertex and Pixel Shader Start Addresses in instructions
 	 * (3 DWORDS per instruction) */
-	OUT_RING(ring, 0x80000180);
+	if (adreno_is_a225(adreno_gpu))
+		OUT_RING(ring, 0x80000300);
+	else
+		OUT_RING(ring, 0x80000180);
 	/* Maximum Contexts */
 	OUT_RING(ring, 0x00000001);
 	/* Write Confirm Interval and The CP will wait the
-- 
2.51.0



