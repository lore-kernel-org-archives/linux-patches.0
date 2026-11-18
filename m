Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035771;
	b=uzD1KzjpNtrP4oLLYAW4upk5zX1VFM/Uyx3Lfb0rjovL9LZAdz8EfzsUo8sLR4sTwJrW
	 UM32qQ9r8IFh2YA5puSC25qBRSaHjDM4if4W8zkqQ0kkFnrzu5gFh5yn6aUaEnzkkgToO
	 C7HeNtFsXsCDEf0W90gP6pSIw0g3o9rm84xBbUJkqF1HYXvWVXj+9QJ9AXtQHY6ZyOS04
	 NsMZ0FQx+O08QfGVW8a7Ys8deTNOkjdRGRcze0/T9k6n2yaqcyQICRvVENCcoSfJGd8Bq
	 eDa+V9oS0NSY8wCDN5pXUfjswrZl8uFiAP98GgBBCbSBZ2vbACygxkvsLQh1gNhRhfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tx6BuZvMf/3FMJurvMkybymqeqiawnaRy7bdAvIX/C8=;
	b=MXj4iugdQvckRVbDDbmEx0rt6HxmLSYYhjmgnTxaP8ban8uX1T4pm0MSLC6yG0cXfWP9
	 LrDsaSVmycForZ6zNB5Smu/kTmWU0aXY2Nd60WV6exOEOgAzxc55QuYAoxiph4wIL/U+/
	 oNBWYd/LaOfih+OFGbd+zs+7jxQqg9rM+HHNa/u+g+OwJtL8iDj7WPi1INMhBFXdofe4/
	 QiRH0wYCxwPxPJnIhxexSdfSkWfAzhXHqd8Jxy4LoZMsJtpWH+3RoH+ZlOQrPhQIOEFu/
	 md4O+HfDobLSlrJRTeCgeVvZiXqIXUxjFsh/6kmjCHUdFdP3XMpz+H07XjCfMJfGCAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QSmg1v9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD13606A325;
	Wed, 18 Nov 2026 21:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1QSmg1v9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1901F000C4;
	Wed, 18 Nov 2026 21:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035771;
	bh=Tx6BuZvMf/3FMJurvMkybymqeqiawnaRy7bdAvIX/C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QSmg1v99qILxS5pIuXBK8l9y0Yq3keCsyM8aVP6UV+WBuA10NbkRhFlz5+yIV1YW
	 JVNad6cRR9ncRN/a8hCDjsygPJhFXcrgSMEOw0H2YlgKAthA+fDJQ1b0RXq81gfe7y
	 Ky2dB9pl96UiusrWKIGhA7wEuaKva0wMxlr4j8p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0820/3318] wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()
Date: Wed, 18 Nov 2026 15:24:02 +0100
Message-ID: <20261118150343.651104015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 85af58c17e456..0575ed6c0f7c2 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -313,6 +313,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 	case HAL_RXDMA_DIR_BUF:
 		break;
 	default:
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "Not a valid ring type in dp :%d\n", type);
 		return -EINVAL;
 	}
@@ -324,6 +325,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 
 	ret = ath11k_hal_srng_setup(ab, type, ring_num, mac_id, &params);
 	if (ret < 0) {
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "failed to setup srng: %d ring_id %d\n",
 			    ret, ring_num);
 		return ret;
-- 
2.53.0



