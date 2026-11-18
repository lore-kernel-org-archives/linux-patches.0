Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045060;
	b=KzMwx4Yj/c/JTivXPgPxCeo5dD3z6K+HCJS3t2yKEwXhEkiba0HXV7pdLKA/uD2XrEhg
	 +DUgxkQbZ3fbOgQhJ2QBDSavFNCMxGhebsdHDpWz2wPx/QmpX7z/s9ZjkHn7GWSr/KEln
	 2RN9UJRnzB8isM2viAltDv51w4Tq41FEL7ORrcXAYetErBsbBimrUPEZ1Oc0ZV1TKdKO1
	 FZ7qm1Qo6LSi69LQUtxLuVcH8kgnsuBrGlh0KUyVKDZvmeowuvmipPVaSSYHBkMAZgQYG
	 a62UDz4/1vtZPJVUsil9RRr0ZjIC09vXCYJR30G0Yz2WyuPQ+a4B4BZTgqnqKEc+Rmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5SvcRLsXv0eQM+0zvy9qN92SGcKKc63gcHDF0yHn37I=;
	b=0KkzUa7NFl5tf2mGYWB14cHhy7GdeEmE78TwM+c73kighxKRchwyEzrHpWEtRRbrMuVU
	 zTxtuAT6AeTX73GCwq2ZGRlHkwJs4cGkkWHcp/EJ2/dBToH2eUHwj1iCW+CEDKJgt2v8L
	 5JxDsK+F1Tlpt6Lnk+0P3fSzmol3aaxafNiMRht2Hed+A7W6vBMtWBpkQSwUjbwpZet/8
	 Z22sV1ZI8H87pQrqEoIF8IUfZK3nArlpW+fytY6t1LhYQoudHUypxHrSztgV7R0SpNPUA
	 j9+YURsfvfVLEm1/rY0WbX4lJxmwVIkj/W3I5aMoJOHh/NuM4+rXsbcM9lXp8D6gSlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MXKq2OYQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9B0606A325;
	Wed, 18 Nov 2026 23:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MXKq2OYQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB20E1F000C4;
	Wed, 18 Nov 2026 23:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045060;
	bh=5SvcRLsXv0eQM+0zvy9qN92SGcKKc63gcHDF0yHn37I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXKq2OYQqkfkLHmcxmFclz1+N+7RbemnJYa6aaDGR+AKQgUV4AlHtbbbhzJgU1+on
	 MLmBpqy5uyF/vbvJjZmgFFN73Pyz9vma6ajOD2wT0tiV3zIeMv3ffdp2ePip7x6zJg
	 EuiFiFKoW30yoJMTvT1GB7K80c5sG9j/t/4YGbhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0729/2857] wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()
Date: Wed, 18 Nov 2026 15:29:23 +0100
Message-ID: <20261118150227.797197989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5baa1a5ea3729..0203503ca31f5 100644
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



