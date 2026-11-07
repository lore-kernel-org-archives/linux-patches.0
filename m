Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063863;
	b=3tA/894c6r713o3uaSXdsLzDiJ25+hOFDZeGBHw8bFOROFVXDXZMlAQxa5zJHQJCk0Lo
	 6avauBvF2VZCjCK3Mi+oBZADzO5FBpqvUkfNoucjSPRwZs6DMMG3P/mpBxhX3+czQPhoM
	 SLgqGzWOtp9eMnmhh0hTk45WZXswOp3Nl4e/EWVF1zA+G23NNWcnZwcsaLXf4Qd0SsNyL
	 scf3alQxBLPcW87YO6a/PZBYBrEaR8GIHkRHLnMidpG6ecOq3iOvGlaDyxW5/QOu8b4CU
	 9VUSsA8XcE4m78TMSZsgump3Bmi+i8WdNqBO7OL8zOTwIL590kh7ThgxCPwK0f8GGJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lRXtN041X6iTmUFAInZW48v/QOffO6bTrwt48Dz3wWY=;
	b=iJN8LHZDuQiUcHVnC9NowzksE+rjQceHJQ+7m0NYXRbxDN2cvYwKMkeTWmwAem2pCoQB
	 mUfNnUHd75Cr+eRqbjy90RwNPPwxqPQvAvJ2iQEyfgAcH95//zv0NV0ZXNLiJH1FHyJfn
	 rhzUjSxmatRRaaWd3CLU39G2tCWFfKpEchQMgwihX/ne2wAGVm1SBi9/f2yzf/AGzpbHE
	 tPCmTEB27Tw/i7nevs3wgSCXxvppf1O+GX3TnLWRZ2/dhoy6WuRfgpLsSBmTHoEIDskEX
	 Q1JkJXaKJ1w8jYx2TcJPRGyAStR82JXL4gdpU1dlb2nox58MoO9qecAA162pYxMOsMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JmTzr9W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6794606CE5D;
	Sat,  7 Nov 2026 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JmTzr9W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB5B1F008A1;
	Sat,  7 Nov 2026 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063862;
	bh=lRXtN041X6iTmUFAInZW48v/QOffO6bTrwt48Dz3wWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JmTzr9WG9ftFuqW9lie7r/l81cm4ZAs3pw6lPPX0OCxS8fcdIuE+Y9FGDnZFC8in
	 LLqN2UUzGJhWxYWwNr5Tg72wxAMSmL4hF2Versq+ddD3JToGPPLkTlPiqyhy5SfqId
	 wenqaxa7vZtPVfW4mrxLAyk5gyuPcdLl0d0n7SVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0069/1257] wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()
Date: Sat,  7 Nov 2026 08:39:25 -0500
Message-ID: <20261107134941.295724427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f389b97acbdd5..be65d73b904b6 100644
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



