Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60673074AE;
	Mon, 18 Aug 2025 13:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522166; cv=none; b=PRKLqwVym2A/5HCEmbgYmw/+XuRTZpI41O3EMJ6fv3sooZpYW2pcVs8NjDUDDmmpOxIAf+w/J/FDpz97AJClOjrHaoSdua3hDj9qKtrxGf++BiLEJugS91Lf27jJkUGaVb3dGS53rjSn410prTPyGzuPOzFR01QoJia71pbjF94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522166; c=relaxed/simple;
	bh=AKNHmzDoymK30pp3q1dcgfCL/CQKK3pznFcpfMdjpk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcMxyCjV9UCNyKLuasyjkuzLa5vOU9k/Qk874qDD45wL/FBHaXgQSD8lMW3ZJ5z2uCJB9a6gt2RhzRYaaDNX4TBTEJ+IMPpu796Ihsexbqf8CP1Ff+azFylYOePh+UJktQOUnCVpAJsJ4ow/w/AClzai/1CM8t6gmPdWeNvlJCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGGV5Q3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGGV5Q3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23731C4CEEB;
	Mon, 18 Aug 2025 13:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522166;
	bh=AKNHmzDoymK30pp3q1dcgfCL/CQKK3pznFcpfMdjpk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGGV5Q3QC4G4E9GfPfSf79vCKPvChcl6vKi3DGB1w5jH/9xnMF/HulmEeplGRdcZP
	 NIj5nNyFWhapZZkhWmuzvPERgijZ2cySUTOjPQAa9nu32kaT1zG26EGPWTl4D4g9wB
	 SDtSpS848M3N1mj/cgXKGcQKb7elkyX8XJWlG2zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/444] wifi: ath12k: Enable REO queue lookup table feature on QCN9274 hw2.0
Date: Mon, 18 Aug 2025 14:44:22 +0200
Message-ID: <20250818124457.682202138@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>

[ Upstream commit b79742b84e16e41c4a09f3126436f39f36e75c06 ]

The commit 89ac53e96217 ("wifi: ath12k: Enable REO queue lookup table
feature on QCN9274") originally intended to enable the reoq_lut_support
hardware parameter flag for both QCN9274 hw1.0 and hw2.0. However,
it enabled it only for QCN9274 hw1.0.

Hence, enable REO queue lookup table feature on QCN9274 hw2.0.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Signed-off-by: Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250609-qcn9274-reoq-v1-1-a92c91abc9b9@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/hw.c b/drivers/net/wireless/ath/ath12k/hw.c
index e3eb22bb9e1c..057ef2d282b2 100644
--- a/drivers/net/wireless/ath/ath12k/hw.c
+++ b/drivers/net/wireless/ath/ath12k/hw.c
@@ -1084,7 +1084,7 @@ static const struct ath12k_hw_params ath12k_hw_params[] = {
 		.download_calib = true,
 		.supports_suspend = false,
 		.tcl_ring_retry = true,
-		.reoq_lut_support = false,
+		.reoq_lut_support = true,
 		.supports_shadow_regs = false,
 
 		.num_tcl_banks = 48,
-- 
2.39.5



