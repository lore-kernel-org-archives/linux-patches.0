Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040262;
	b=H26tEsm7/jo5KXF9DEOIO1561dARkaRSo//+i49RkARIlsO6XuWYsS/SY9IGX4deolmt
	 HYmYvU/7EyBaf2cTM9cn9XDX98FNCbLiBX3x8ZeCGS+uz7db55LIll6jj9aaLm39Dc1X9
	 4+dPaXJc4OrNZWN6TxXEgyM7eQNQd/a4BOkqrUli1/lexNh3o+pBhSWtNaXNxYDrtN+/A
	 Gx/N7QMNXRQg9Vjpi3/AfgEKRMs+AR3o9jLyciiJ6MwSv32nNHeBMluX0Gqlw86BeuxXT
	 b+1FitvWAyos+jZup9q9QDkjJwr9XIHMMdlc8B3tdZhJpa042pjhM2PqSDexw4MEnfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zLNIR8wN/0NwI2HlY1AooThKGRQx8nleRMkmQK/HjN0=;
	b=h2tOUCvje/89Jvi3+ZPYr9VVf1A2qZsDxjHE2JfGt4JqmMU6MUdrkWiUbPBIY7ybHgCN
	 3VyXItjnDwuxCwoJzghFYKrxseMwWi4zLt6gMsh/fGF4c2jzwhnP8hcVqqdHhpUA5so67
	 h/DHqi4uYEhSQFd0T9FljxE26lNENe8A71OWuEhuiMzRRBeLJKYS4EgU3Ocw+U7fJAxVU
	 0Fqd3jaY9HEzlus50YhE+5TxxOxdU9nVhxVz69Is6sa4iZI+Dg6C7JRu1n1Pe5/jj0Rep
	 GmvBjYfEj3aylsW5VZqKz7kig1azZ18sIRD6+dE+aJDgFJRFKnNrXxBgtGw5m0/lh/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZvOVFiHR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA239606A333;
	Wed, 18 Nov 2026 22:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZvOVFiHR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41431F000C4;
	Wed, 18 Nov 2026 22:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040262;
	bh=zLNIR8wN/0NwI2HlY1AooThKGRQx8nleRMkmQK/HjN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZvOVFiHRM0uTQL9kSXDvkxU7Rz8WhNC3yH/3I7RKyWOAYnm7CelFJtVv0hNYfYPq8
	 ipySehhVlt9YCx1q+Exo76DUXIR7+3kULpcg6as1jjuc9Xlr/IJOBT86Zjz13Ht2/T
	 SPTc2+fgZx0EA4dEKgHo21EyMnrbwuoXMHxaIS98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2393/3318] drm/msm/a6xx: Fix secondary rail vote in ARC votes
Date: Wed, 18 Nov 2026 15:50:15 +0100
Message-ID: <20261118150433.305481996@linuxfoundation.org>
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
index b5b77d9f6b7c8..b9c0a757e76f5 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1293,10 +1293,14 @@ static int a6xx_gmu_rpmh_arc_votes_init(struct device *dev, u32 *votes,
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



