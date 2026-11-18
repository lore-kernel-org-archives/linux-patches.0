Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040641;
	b=G7EWE53nIdaO1HoHJxsDwhXtwR9ZGSnxlwab0Zh7wCEnOroD4DAyFSpFXS8kd34Z2R22
	 X4w2A4ueSBvpJqjCw7biPEUalQOogMX0DZhwQTFkZAL3Y7tEYexGxBjsv3igsUA9oc+lu
	 qYy0lSbnXZMTYqOzoBXFWX4snlenfsmXnJW7y50kqyNztogjC3YzhGb3bKt8QQoGEilhi
	 pE0yTtCcqB86uHkDshqo6SdGw6Ay2JqNqn3SywD3PSybRpuIafhRFDAJBUobhHMKPYU3u
	 NneKlAVl5HrrV4tSYydH9ZEGSjp3CKPHDx0fxSy5RWXxv9Fp3RX7X2tH0ATKlwxqkTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8TzWh4hIfksibqFrrU0oNyE8cgdF08LVhCNFMLHnUmA=;
	b=5DrlTxRE5vDw+PQs3cS7YRng3dcZ+I1o3am+Zm08IIEAPjKSqMvU0rVxYI7Uii1lUY4W
	 UEd3AUmNAcwkGe+96aAbwqJ8bzRVR1omKtKccPsqQ+BDCMCTrgCtV7VWc2Ggs+0aIIGgm
	 7CwzXGYx5vz2WyCIPsfDhTaO4QbOd49geTSuqKfZ9F/kwAUf0iTMCiSMs3Z6WwPl9PADA
	 pCR3YY7WLXclh2dnBpOazKbof8TLMN72rNxOv1OedfHGcXAs50nMJl+iMxDetlwIMWN+R
	 IZvddizUSRqPmL8baYtI+C6rwl8fq3/cTF5H34jOjF8R6hazsdfKc9PKG4d4bzBABdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CAGmIheo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2067C606A325;
	Wed, 18 Nov 2026 22:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CAGmIheo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068861F000C4;
	Wed, 18 Nov 2026 22:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040640;
	bh=8TzWh4hIfksibqFrrU0oNyE8cgdF08LVhCNFMLHnUmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CAGmIheo19wSBHdQJSk1Bn0qniIlIwXzVVUvNbHnNr8LKVulnCO8CMxpkYkPpFqji
	 kCTJX0uUADUsP9+sVq+MfAydNHgP6GZwVcj60InvgkZwDG0ChPVRQDpcnkSTT4ZCw3
	 9yOm/ZQUQSX0ICzlM7LTLBsxht0Ez+4T+b86oPzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2528/3318] drm/msm/dpu: drop core_clk_rate overrides from _dpu_core_perf_calc_crtc
Date: Wed, 18 Nov 2026 15:52:30 +0100
Message-ID: <20261118150437.186304015@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit e7e2495595e01839b117e9c08500ff80cd218f6a ]

core_clk_rate override is handled in _dpu_core_perf_get_core_clk_rate().
Drop imperfect duplicating code from _dpu_core_perf_calc_crtc().

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/636070/
Link: https://lore.kernel.org/r/20250209-dpu-perf-rework-v5-7-87e936cf3004@linaro.org
Stable-dep-of: 480ba24aa340 ("drm/msm/dpu: compute the CRTC bandwidth from the state being checked")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 9ddeafe8f8f54..2c805356ae207 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -123,16 +123,14 @@ static void _dpu_core_perf_calc_crtc(const struct dpu_core_perf *core_perf,
 	if (core_perf->perf_tune.mode == DPU_PERF_MODE_MINIMUM) {
 		perf->bw_ctl = 0;
 		perf->max_per_pipe_ib = 0;
-		perf->core_clk_rate = 0;
 	} else if (core_perf->perf_tune.mode == DPU_PERF_MODE_FIXED) {
 		perf->bw_ctl = core_perf->fix_core_ab_vote * 1000ULL;
 		perf->max_per_pipe_ib = core_perf->fix_core_ib_vote;
-		perf->core_clk_rate = core_perf->fix_core_clk_rate;
 	} else {
 		perf->bw_ctl = _dpu_core_perf_calc_bw(perf_cfg, crtc);
 		perf->max_per_pipe_ib = perf_cfg->min_dram_ib;
-		perf->core_clk_rate = _dpu_core_perf_calc_clk(perf_cfg, crtc, state);
 	}
+	perf->core_clk_rate = _dpu_core_perf_calc_clk(perf_cfg, crtc, state);
 
 	DRM_DEBUG_ATOMIC(
 		"crtc=%d clk_rate=%llu core_ib=%u core_ab=%llu\n",
-- 
2.53.0



