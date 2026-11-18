Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030185;
	b=n/niMUCBSwsvWWiR8yLGJPGC40jg3HexBYwgPcW8E7rLvHQ9rj5S302zJw8QjOlhsfue
	 FzVTeNANFJalO0ioFbYqAklu7WptqLWfrTS03MN8xuZ0TuhDuBO/GqWhlbUWCfNCCWQIg
	 lrZhSfky6yGeK+I5DwqVR9hIRYCwSBOY2EABbvdAH+JBJxDVDCzPvKKJ2nDuUWWWVn/ic
	 cYSlulTb96NRtWSWtHTXAr/l1rzhclZHZm5F52GfSgaDun0CzV6Sg17/lyI4Ua6Qn258U
	 tQ41FvnueNdkGvFn/mwRFdPIlPpbUM3FLx+2ToTtvlBwye6m1SZRYi62W8t+11i8hKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xqeQaHGpGGNSiYXrbOzUBwqFCZqMczoi6aP2aKWUpJk=;
	b=gBHgvL50S+tEIqg8vDGUKa7GUVgpikkuthqIhiTJUO0ovIQTzzfXLDkqX2QBdL/AZnvY
	 03rbwylVIo2wjHZTSvgjbJTU1BRSirLdXVEAjk6ucjr81mFNhYjLh/qxcCXO0PHXRLCZE
	 h5JK29wfU2dHulYQBbwBzIoFLZMUU76PyPW+EtjwhvtMcyXX+FzZy1cl7DN10O7Bgl7NI
	 /P17KfYbZjWihB3ZKPpgwNBhK2jYAVLeD4xPnFkTH6uhA5yrgqNoBPglkt1H89A4+4M40
	 cxWh5wt4Zt4wUElw85U8NURrRaIk9t2pkxImitS42dbUZM91EQkwIIF3Twd+C3aAiSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1xCiAobp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595BD606D347;
	Wed, 18 Nov 2026 19:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1xCiAobp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3D31F000C4;
	Wed, 18 Nov 2026 19:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030185;
	bh=xqeQaHGpGGNSiYXrbOzUBwqFCZqMczoi6aP2aKWUpJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1xCiAobpEsgrK7u3Re3QDTfOi8uP1tVD2EV6bI9+imPuvnxD8cr92yJDiYX+zgoHU
	 lrn0m0012UUCXYdgVXJ6XJ/01sUbwaxLh9azJGDQ8WUFZYWwa7to7zUtjHeZy9yef3
	 03FI2765fDQ8qBnOxml4CQR+oLddzAcqBn/aTYCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0616/1756] drm/msm/a6xx: Fix secondary rail vote in ARC votes
Date: Wed, 18 Nov 2026 15:45:43 +0100
Message-ID: <20261118150033.447173706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 99c3abd90c190..c65c8442acc76 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1380,10 +1380,14 @@ static int a6xx_gmu_rpmh_arc_votes_init(struct device *dev, u32 *votes,
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



