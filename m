Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016472;
	b=Q1hCDidekG/cGOAw/f1oerpGptiNTn2Nq5dxonjEBoupp8TSjNDR8HCiCz+4XY60DaoG
	 1MWqPggOQtzGd2XzW04Fl5cjrP0u1stT1W7SK8A+qNTs8Bz3HnNE27klmLdjRsiU1PIjT
	 iIr972oPVHkkk2hm5iKFQfhj7CB6zFwov3GDJtu1hQSvs3tMtsa35uvGoYHsIKRZXpfbR
	 Tj0XRuFOvm46kADF7InDDWt/8odlvgDmrzBDtdmcW/7J2zdNRpjiGT2hHSRxnCEwpN11A
	 AQKMYqP4pZqztrCMyIZGpHjo+qkXPJh8q23arFQmuYUxx3Eui4dBrguAqOlpQS+JyGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=smXsC7niBrA6tFa2SEHwgOD4wjJwEMb48gVJNVwkK10=;
	b=CMEIigigu/oi8pRUiq6r6MFuLUH7+3vFhPt5glkXx1C91Oo/hOKxzxakpbGi6uznPXkZ
	 mfIXEtwgtzhfanE3mNJpSQmQIK4lEMTa8fyt8kUgCXu1tCwJaCCyKdhJZUHj6Kzz+Ymn5
	 55zg1/CBnA3H3idSG6kd+kVofGhRdcKGnObDe1R4upbq3TstB2chsk7Ql5clwiRSRQ62Y
	 hbKsz09k9lY4eyFGZflQul5TSLUPvln9ulBAh+XjtCW3n9dZ8BAUSXfQCU+8L9n+h+5HB
	 vaEAQ4Vrnt6CuEdlGOQE8+Ilf+k+EYn9pEVedZ5rXIt28O+hjz/q737io1uS/IZ20NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n877B8fA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02521606A320;
	Wed, 18 Nov 2026 15:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n877B8fA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AAE1F000C5;
	Wed, 18 Nov 2026 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016471;
	bh=smXsC7niBrA6tFa2SEHwgOD4wjJwEMb48gVJNVwkK10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n877B8fA5lUMYQaU2AjQWIpT5qqE1GbvZJWzUicFuI0sDrSjZhS6LnvMN+Vzf34MM
	 ck9x+e07RIT91m7G6OeQIFUs7+mumfw/iEwnJPwClQSVLejBBYnLqb1WFQK1V9tuHP
	 kqIauHP8MbMF+UkwpEQfr/mTyaBXs8XqErQufgdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	James Lin <PingLei.Lin@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0541/2651] drm/amd/display: Cast DP DTO pixel clock math to avoid overflow and narrowing
Date: Wed, 18 Nov 2026 15:29:41 +0100
Message-ID: <20261118150307.229872553@linuxfoundation.org>
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

From: James Lin <PingLei.Lin@amd.com>

[ Upstream commit 0575f53925e832fba376583cd18667de8f31b13b ]

[Why]
Commit 0421fc6ab3a8 ("drm/amd/display: fix __udivdi3 link error") switched
get_dp_dto_frequency_100hz() and dcn401_get_dp_dto_frequency_100hz() to
div_u64() but dropped the original explicit casts, leaving two issues:

- In get_dp_dto_frequency_100hz(), "clock_hz * dp_dto_ref_khz * 10" is
  computed in 32-bit unsigned arithmetic (both operands are unsigned int)
  before being stored into the u64 temp, so the product can overflow
  before it is widened (flagged by Coverity OVERFLOW_BEFORE_WIDEN).
- div_u64() returns a u64 that is assigned directly to the unsigned int
  *pixel_clk_100hz, an implicit narrowing conversion that trips
  -Wconversion (possible loss of data) on stricter builds.

[How]
Cast clock_hz to unsigned long long so the multiplication is performed in
64-bit, and make the u64 -> unsigned int narrowing explicit with an
(unsigned int) cast on the div_u64() results in both functions. The
computed values are unchanged.

Fixes: 0421fc6ab3a8 ("drm/amd/display: fix __udivdi3 link error")
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: James Lin <PingLei.Lin@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
index 20ccecf23677d..f88404a37deae 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
@@ -1232,9 +1232,9 @@ static bool get_dp_dto_frequency_100hz(
 			 */
 			modulo_hz = REG_READ(MODULO[inst]);
 			if (modulo_hz) {
-				temp = clock_hz * dp_dto_ref_khz * 10;
+				temp = (unsigned long long)clock_hz * dp_dto_ref_khz * 10;
 				ASSERT(temp <= UINT_MAX * modulo_hz * 100ULL);
-				*pixel_clk_100hz = div_u64(temp, modulo_hz * 100);
+				*pixel_clk_100hz = (unsigned int)div_u64(temp, modulo_hz * 100);
 			} else
 				*pixel_clk_100hz = 0;
 		} else {
@@ -1293,7 +1293,7 @@ static bool dcn401_get_dp_dto_frequency_100hz(const struct clock_source *clock_s
 			BREAK_TO_DEBUGGER();
 			*pixel_clk_100hz = 0;
 		} else {
-			*pixel_clk_100hz = div_u64(temp, 100);
+			*pixel_clk_100hz = (unsigned int)div_u64(temp, 100);
 		}
 
 		return true;
-- 
2.53.0



