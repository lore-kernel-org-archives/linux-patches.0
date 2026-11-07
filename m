Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061910;
	b=ToY6Oui6ICcZuta494SB0svBzQGWKm2BZrce1kb2AWoJ8QZCMrVklpGQCaKwKGISL3ei
	 U0/k+0fyx3TYDhCPUMBio9jVPm4LVh6P28iaDxGTckjf9LFsexpjNZsNmfevXwUnetaoS
	 XOkYv0ymA9iNYhpMze0onJ6vcqiMXOGEj8D6BWUmsaG2Zt3E59C8SlBjqG4jsxNU/HgEi
	 V6cGLmGu9c4L3InUGBtuq0w0QmWK7KC5nxcisBXqssEIVNpWiY7C90dyt5xSBe6RkXshA
	 i5vsqs7iLTCLiZ06bFG7a33nVOIzygqe+eOOjkNFzIuv2iituULl0zrIFmxIDFm0WoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1RP05fjr4azTYSmaDxV0GltimQ8B6DpIgonJx76MYz0=;
	b=tEFDxi1/naYsmWJaBHYxIJoyeys4EnBKHvAZSwzQnVmsIgDrvnC2VXM11iOR5LMBBNAy
	 MdT1jzQ0BPrvXcXYuT3r4ao0WlpfS8fv7dY8A3e/Bta3i9tajINXNeECWl8qfcDs7HXqU
	 2Wq8r/Emz1kPuOhd93b9/3DpIww54LTD3U6jzv05VVeqptfs9TFn/aiQBYJw4MfmXRxqG
	 uPnwy+LEpjLNq5mrkAcn/5ZZVb5x1gpSNDzrJWjOedSp3vZxcfYnDpKn7LYj/WZlYYM5g
	 Rps3l13WSSGCwsX3pbJ1kYfvKgt2CHx6OqGsf9qfH5LKszulhNVzk2DuDQ8iJkHhNag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v26KIfmx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D995606A326;
	Sat,  7 Nov 2026 14:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v26KIfmx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1444D1F0089F;
	Sat,  7 Nov 2026 14:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061910;
	bh=1RP05fjr4azTYSmaDxV0GltimQ8B6DpIgonJx76MYz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v26KIfmxugjZqCuARU17qBqpGsh0QsBqex+HLknkf3XiGvZ3Nld40ZxplJGqbTUDj
	 EMyraRfogNknruapU4MS9Ls4vuj3HSUImaD5iy5aqvXu2mVNESIcY4Jm8KAs9CtQxf
	 qerkLmID52XHmzcUIO0EvGxuucrWBcfq1Cu8f/gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0919/1536] wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()
Date: Sat,  7 Nov 2026 08:48:55 -0500
Message-ID: <20261107135023.455717091@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 6132d70d0890c03546f6970893fd71938efb2a2f ]

In ath11k_dp_srng_setup(), the memory allocated for
ring->vaddr_unaligned is not freed in the error paths that follow.
Fix that by calling ath11k_dp_srng_cleanup() in those error paths.

Compile tested only. Issue found using a prototype static analysis tool
built on the LLVM compiler infrastructure.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260801114911.91483-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index 06b574ff950ed..4c14365064903 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -314,6 +314,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 	case HAL_RXDMA_DIR_BUF:
 		break;
 	default:
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "Not a valid ring type in dp :%d\n", type);
 		return -EINVAL;
 	}
@@ -325,6 +326,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 
 	ret = ath11k_hal_srng_setup(ab, type, ring_num, mac_id, &params);
 	if (ret < 0) {
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "failed to setup srng: %d ring_id %d\n",
 			    ret, ring_num);
 		return ret;
-- 
2.53.0



