Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052129;
	b=hsnNQNeSuC5x2zvO+HmaYLcdLSR2EBPBmapWLfYF7LU1S7BRKP0iNouxA3WDFhuCOHCJ
	 uOUuF+x0Pc0DOollyvz0HFH7yJEItud6dytWCuGWbIvnMQJu1DXvZdfIoxfLGLySKxCdd
	 SGx3tmGHYis3SRjDKM7+QL4ISnpgUOSp6oAj4QW+CVOjRqoOp7TI6MQfHFQR/bZHn8diu
	 WmsxAGW8KvSYpPfXSL++Rirk3V1lYzJco752FLxitX028EbkM9pfFVtc23C1g8Vora82Y
	 jf82wjsKlMecvSvw9DOn6c9dL8aWLXP84nTGKWCrcUilcde0oMriHU0eSATJsb2aH9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2PmAL2F+C+sLTUDHQLl9wxxixYQ5HdXhsR2+bOCZHPE=;
	b=Gq8+RSVmtEAtTNFXppaKQohwJn1DAfRv98PsYoVuTL9qjK5u0eoPIh4sYJhlxszRYfYs
	 j+XtgZJvWOsDNrFSP2dYo/SMiH5xsAxAj7FpptmlwbXNQRLhI4EZFQofp1YCJUUVt1XZq
	 LqApUzeujNeZ8vtXJB29KZT6MNogM2KnJcSsVvrTcrS4YFm71oYe/h1bSlYo07T+ixgFb
	 2o7MoXFsB8aYw+nufHLmWNJpODNWha4BYmVIc8deIplgHAwr7262GOHi7Gm5fRsi188nl
	 c2Ba3jbQH5r4MyvXvigipY3p5joSv70UshiBv6d0v3SLsrEj9ZXqYwOSRoGHT7WmGng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oAkFvipd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F58A606A32A;
	Thu, 19 Nov 2026 01:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oAkFvipd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD85F1F000C4;
	Thu, 19 Nov 2026 01:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052129;
	bh=2PmAL2F+C+sLTUDHQLl9wxxixYQ5HdXhsR2+bOCZHPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oAkFvipd+ybfIm+7vWzLdI6Wns1xFtpwwu7oU72lYDdMNzfW1Z6Mbv2efCPISH4zf
	 xM0GhWazebHPF6DaA3Csuo39USO+0a0dMH1H2SE4JocLfhlNqy60wNFh1B8ca0c2XS
	 fm1SPH4m3DdVL5w+nRe4BSu73rDfwpgUtR57+eNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0453/2214] wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()
Date: Wed, 18 Nov 2026 15:35:29 +0100
Message-ID: <20261118150029.274653294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 67be1362fe563..bab2d0b59cddb 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -288,12 +288,14 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 	case HAL_RXDMA_DIR_BUF:
 		break;
 	default:
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "Not a valid ring type in dp :%d\n", type);
 		return -EINVAL;
 	}
 
 	ret = ath11k_hal_srng_setup(ab, type, ring_num, mac_id, &params);
 	if (ret < 0) {
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "failed to setup srng: %d ring_id %d\n",
 			    ret, ring_num);
 		return ret;
-- 
2.53.0



