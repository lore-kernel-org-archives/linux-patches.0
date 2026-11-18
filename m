Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024570;
	b=pRsy3anOPwNrE5CImu1rXjmu2jwZzD+8Q5r/RMWryRO/b9sPgfu/OdSolLq//1hjyIOB
	 ezVx84qkS8Rp9KZ20QrkvCEM2GS5BkQP3kl1mCYGlKMXu1ES7nivxSgUlwXcvLSu46BwB
	 J97skd9o2jarIKJQRablIZGUQoUDuroRWqPv+BwkTXoF/5rJhLVPRlhJkLtIRng2bb6ji
	 GedzuntgF00LX+8KoOJYFPeekC2g0eCQaPO+aYvQveD56be8qD9E5JAzYfVtucsV46YUO
	 dvbYaQ1mlC8V4o9oKDxyDuzsyCwf9i3h98c9oIFC506Ey38e9CQ8gh6iBWoiVsQ+ljg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8wlLIBhojEZXpGpYllw4XouTl/eIHdS6TDpLgmfS7U4=;
	b=Qx3PI1PzWpz2k+RRutxGa5LhyjXvzElBA0BylnYxlG/txyeSxHSIfIaMpVmrAe5FeP+T
	 H4pgYEb8b1wJDo7xavST47nIIn0q7WGS99E5dKBmUtt56mSMhjrgVl+bVCmZj12/Vlmpj
	 jWh7mGmSHZ0UhmxPpwRYfoVkqUMWR5i3kXwyEKp1mbhHUUGPV2SRHx/UNksfJpyAB31hj
	 l3KQBQ26LANGMZYT8mCkPNoCcPJIrvJJj9XNKVF4xp6iS+we7OicLAjRXH6/L0uDKVZlS
	 KqGUsJ30Kkh4ZDotjZUnPTgrRjvKvvOhTreykM/kr0Bx/WnOejJ92spVUQNKOHlRS0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9QZu4dW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEB5606A32A;
	Wed, 18 Nov 2026 17:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9QZu4dW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6298A1F000C7;
	Wed, 18 Nov 2026 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024569;
	bh=8wlLIBhojEZXpGpYllw4XouTl/eIHdS6TDpLgmfS7U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9QZu4dWHflfyti/1lTFWIQaqCYxsxZdfXoXB5bDXxPy1LO0Qut6Bp1Ww7+/Zu4m0
	 d0OKzkwnINuyfoa5KjCdfJXM/XPa3uAyl1IPvIXyWLSGrKryICtggcq8SZeWDxxATQ
	 TEA6oyj9gsLdk/paBzDddHhXq0LguDVoBblH0Tuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0771/2151] drm/msm/a6xx: Fix secondary rail vote in ARC votes
Date: Wed, 18 Nov 2026 15:41:46 +0100
Message-ID: <20261118150150.215442040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3f17cfaca8b47..5e2df5250a50d 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1539,10 +1539,14 @@ static int a6xx_gmu_rpmh_arc_votes_init(struct device *dev, u32 *votes,
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



