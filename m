Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9259A6A320;
	Tue, 23 Jan 2024 02:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975346; cv=none; b=dAm3aHvErfHds9rgmQdDMA/T9aLw56AipEmP0yXwke7+uUjK5uin6NunL5J/Vt0JIEgRyYv31euK7aeFCwxCvdxX2744morGz+Yn9/jOvgI1f/NMk2FDludAksE7mfW+x30bMFn4ln6XyLOUJWT3l0sGTo9FoSehpySzJx1KU2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975346; c=relaxed/simple;
	bh=yEh8BocRSLNUolOQ+NTCKozpHCuFBzqjMBM3/YIs+iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XG1eqRudBFYBSQvWmQnVzAV7g7AMezX+998qpJgAvKdobDCwITN5L6WYYtRTLzOGMHvMUXtbINzCESolHa2VzJeL/Yq1Tw0QZnmsT1Aig8wQxkvH8IFfboenWGsPFC7crLk5E5P+lCxp9961ZOyHYHLRNnTPeiYp+SRqhduMMe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEOj2M/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEOj2M/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57818C43399;
	Tue, 23 Jan 2024 02:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975346;
	bh=yEh8BocRSLNUolOQ+NTCKozpHCuFBzqjMBM3/YIs+iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEOj2M/eFprzXra6hzJR19Cxsdm3geY5Asvgx474suUYwyZAKgaXEGeuPFUEFEQv0
	 ZrB+uUgx108fuKHrcOueJZi1ycybMM+Jo/NhPHcGmzp7YvrLXRKVvOWwY//RThnuUL
	 dw4bsEv1b2zCFQTtcAsJjHeuBbvGxtJD0XcZ9pCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/583] drm/msm/adreno: Fix A680 chip id
Date: Mon, 22 Jan 2024 15:55:25 -0800
Message-ID: <20240122235820.382846946@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 3e6688fd96966b6c275e95c39aa367bc0a490ccd ]

The only A680 referenced from DeviceTree is patch level 1, which since
commit '90b593ce1c9e ("drm/msm/adreno: Switch to chip-id for identifying
GPU")' isn't a known chip id.

Correct the chip id to allow the A680 to be recognized again.

Fixes: 90b593ce1c9e ("drm/msm/adreno: Switch to chip-id for identifying GPU")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/569839/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index f2d9d34ed50f..b7b527e21dac 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -462,7 +462,7 @@ static const struct adreno_info gpulist[] = {
 			{ 190, 1 },
 		),
 	}, {
-		.chip_ids = ADRENO_CHIP_IDS(0x06080000),
+		.chip_ids = ADRENO_CHIP_IDS(0x06080001),
 		.family = ADRENO_6XX_GEN2,
 		.revn = 680,
 		.fw = {
-- 
2.43.0



