Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3F51F1534;
	Tue, 26 Aug 2025 12:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213011; cv=none; b=KdJBoD6j/xPHnianRg7Uu2P6o8yidLS8hrOB9vuMVCOHOnA2Y3Avw4uJO5Vb4WOhU7m3iSexnKZbBT4/i7YNFuw1BepmkeVfKyLaWVYZ1rhSW2kdWO7XwDVo3kTl9KA4oK7QVMtIGfq8OCQFYT1SkjFDZZTagN/6xZeE/tpFryA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213011; c=relaxed/simple;
	bh=EbPS1fczFAqZscfSbt9v4jh1T/otaUSpo0zGKIR/ENI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgQO3Z7sDFkl0xNRteDf4njRsDwdjAX6HAtYrtUMgJ7l7iW4ovN7W291j6YGwS8yChI9UxtYKnfqHR4dwpPK1faFUx78NBweR6RfUnh42SMkdxIhohgmKi2UUGlNaZr8ROtMKMxXTgS3h757USAyrddgEb+sZlyMYagqfLyb4HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkmgAiYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkmgAiYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CAEC116B1;
	Tue, 26 Aug 2025 12:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213011;
	bh=EbPS1fczFAqZscfSbt9v4jh1T/otaUSpo0zGKIR/ENI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkmgAiYlKxjyRjTiV7m0+lfJ6RkGedHm6o/sz37rrxRYzLSyUnogVw5VY5XV+5wQJ
	 Ooa+J4wWYuXZOtyVfJCaR6aMOEsmAIB/7CkDyHHsD8XOclowemS9MPRvfT96axgdNv
	 dFTv/nlo2R4pkaqdpZq+4d7hE7elqlCruVEPL8kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/587] wifi: ath12k: Enable REO queue lookup table feature on QCN9274 hw2.0
Date: Tue, 26 Aug 2025 13:05:35 +0200
Message-ID: <20250826110957.674015804@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dafd7c34d746..97ed179be228 100644
--- a/drivers/net/wireless/ath/ath12k/hw.c
+++ b/drivers/net/wireless/ath/ath12k/hw.c
@@ -1002,7 +1002,7 @@ static const struct ath12k_hw_params ath12k_hw_params[] = {
 		.download_calib = true,
 		.supports_suspend = false,
 		.tcl_ring_retry = true,
-		.reoq_lut_support = false,
+		.reoq_lut_support = true,
 		.supports_shadow_regs = false,
 
 		.hal_desc_sz = sizeof(struct hal_rx_desc_qcn9274),
-- 
2.39.5



