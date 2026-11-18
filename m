Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017510;
	b=caqzaEL6iK8QdVKLBJ1T/0snVTNyYha+HbONasoCkFykQLmu4+qeE1/nh/4/beQpq+wr
	 Ug2HTNocKYmWcJawK4plICvphysh0ftYENiCX74odRr+OomZu+iSZEFq7BOELM3UNN246
	 E7jsBMUuhmRKxX4Fbor6UnF6QRnAstbZUyi4Dms9ZF6xn9dKi84dErevjiKvd5idnNmUJ
	 T4ux+psEjofddheYaFwsgkHqv6qr2mQ0quM5kdA6YgGbbfc+ciNvQUFWOmbquVOQMrhER
	 oRMRfy1sZTOvFncdxU5+Lfbw7Me3muaQjvnqUMYcYgCiicvcx6b3pcP/xgq4nMNVPyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uLed6f+ljv+ax6d5KHUGcdPZRGmcvhWagNeo2p8jcJ4=;
	b=hCYtUyMUT1MBt9k3tyhGqg1autZn1mZxZ1nhPkFV3ICDGpQ7qZ43+vpOsdBFzlVL/1Et
	 kBS8syQp7LDY5ERZR28NtrYjhH/4P1QbDmt80B3oocwrsAViyqcGEY5CCqsCk7/3jq+H3
	 aSi38K0GjnERhH+enlpE0WGGhAQMGXI4tAYEXGCI3RtnPje1P0Cuhoo+QYc+Ol9ldFqG5
	 c4gYaTyEtPSz9kutbUSpQ/EWMXUbgda9IyqDjtAuVlqCi5ooqTVHvDgAyWlpqGoV5aug6
	 c0EDYsTmntZBsJ4l3rAjyzEvoGHFbrdes4n47f8Si4e5xOLsZnUdbbd2vcfT6UOSSYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X/KL4lW/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A954F606A31C;
	Wed, 18 Nov 2026 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X/KL4lW/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FA21F000C5;
	Wed, 18 Nov 2026 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017510;
	bh=uLed6f+ljv+ax6d5KHUGcdPZRGmcvhWagNeo2p8jcJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/KL4lW/cdy6w7gnCAJe6Cqa6B0SrWcVNy/M70jOPWoXCmh3vK82/48P4TXOh0bsu
	 2qYQ/BWh0RzlQ624RIzBomhyEcoy5S7UZc8qXdd2wBkO4b4Z4hHRdrj/5uO7sULAar
	 Uq2/R0lSh8d+oX19P1SjcpVtBC6Eqdc7B+uaXeG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0908/2651] drm/msm/a6xx: Fix secondary rail vote in ARC votes
Date: Wed, 18 Nov 2026 15:35:48 +0100
Message-ID: <20261118150320.569433634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index baf77a6205724..d072646093a13 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1765,10 +1765,14 @@ static int a6xx_gmu_rpmh_arc_votes_init(struct device *dev, u32 *votes,
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



