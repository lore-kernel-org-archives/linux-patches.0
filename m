Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048744;
	b=nNmyZ690f6S8sZLmWqmt7ZZBoTSwJFUgC/DJ/fktgAVuLr7unyCJWFsKUXcGl7xIUI8B
	 gWPEkTt19ghucUf/C18YDMQbwfVICn8SV5R2gcnq2aFDRxgmBUbXrk4Et/RHrShAZWGpn
	 dsSuwBU9vAVnQyLkGg0T/X4XqHrNwlOyh1tvb9PusTCmOCVK2cYxqmMUa2F4aGfDGmU26
	 l4M8zQSzLdkNE/yOcdeyKeS4iiP5vXq1Iox2de7biVh6Ra6jaGtAMuHlAFMoSYklgATMA
	 LLkFJaCefT9CLHM5NG7IGvSUgZnOosda5Fjq7c/FEpvfBnhitJDS21Tw6M1anWoLp7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kv9EAm27ve1M1NMyzO/Mc1iDNRceETXXzc7whf9ie4Q=;
	b=p8wRXc600qqMrXWMhl5IAQS/Rzxe0+Db86dHEd8QAoGYAUwJJG1nXNB9Chcm7LCb2GKs
	 321GetUSLLpfXwK87DRZMeP4kVHHl5d7o+HiRqr8dA1jxaydJA7Y+b56mmUnIu/wpyfl4
	 vUVKpORQsR5if++sgT29Ou4AwnSGZZ9ZKFgx5VhTahc1BI4lyiLQb9JBFa+5IecKGL4dA
	 ebCBrqr0gN3OyfaGaB4NmIyvnxzER3RkErjzCVKXHlWTDNobR3deiwNnO8VN9EN8Er27s
	 AIsl0Wk2qL9v5mLzRH+BDjaWLb/MimgtrhWLzm/Yygwss3o9uS439PC5VtOt46Ng+UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PiHSoWwq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0127606A31C;
	Thu, 19 Nov 2026 00:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PiHSoWwq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6D01F000C4;
	Thu, 19 Nov 2026 00:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048744;
	bh=kv9EAm27ve1M1NMyzO/Mc1iDNRceETXXzc7whf9ie4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiHSoWwqDO8zMYLG1fSSiWU87Dwa5MRfRerN7ASpRCORBueNGS8YZP3uwK0OxY+Qx
	 g/JqIrPUeNU3Ci/Ufogd7IgunfaPJPC9Qcnz8uq4DjRn5W7TrtLWIdKoYXrpfhLOuG
	 uD1W3kFwplV9t1aJ6ri0P+7KsNMpsucqCemIUTT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2077/2857] drm/msm/a6xx: Fix secondary rail vote in ARC votes
Date: Wed, 18 Nov 2026 15:51:51 +0100
Message-ID: <20261118150316.194634526@linuxfoundation.org>
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

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit 128a0edde50780ed9eb93ab5d2e18ca24c1f1c43 ]

Using the requested level can pick a secondary corner lower than the one
required to support the chosen primary corner, under-voting the
dependent rail. To fix this, match against the selected primary voltage
instead.

Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/755592/
Message-ID: <20260923-hawi-gpu-v1-2-0c3c79a1a470@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 7c1894e5627f8..2b9171e8e2934 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1310,10 +1310,14 @@ static int a6xx_gmu_rpmh_arc_votes_init(struct device *dev, u32 *votes,
 		/*
 		 * Look for a level in in the secondary list that matches. If
 		 * nothing fits, use the maximum non zero vote
+		 *
+		 * The secondary rail depends on the primary rail, so match it
+		 * against the quantized primary voltage (which is >= the
+		 * requested level), not the requested level itself.
 		 */
 
 		for (j = 0; j < sec_count; j++) {
-			if (sec[j] >= level) {
+			if (sec[j] >= pri[pindex]) {
 				sindex = j;
 				break;
 			} else if (sec[j]) {
-- 
2.53.0



