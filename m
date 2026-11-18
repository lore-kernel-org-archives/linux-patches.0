Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049050;
	b=4DwAz6jn92rD2s2RBioRr+e0htGsW7ZrQ3oFHCD9Xk56S1UL1mBsMvnpMug+D8DU+P8x
	 13ccAtlzB6V/9X0FpYlaKO3Cwm9AIPna2yLM7B8VxwtKIhvi5XpEl0RvHxPAB2WNdx6wI
	 EaEkQoSu7f7XPM9tby0cS3eoJAYhS4/MF3dR8FEkOKNpAt+MIY3A1dBs1ALRiol1m4G+7
	 cXl9khz1Mk9cSjy8UXkGa2iYXiNQy+uZq+2oOZmNKQWRMVQ2MQ/hPREVkTirJpSNcsb2b
	 /jw4z6mrmM2CqNdsQMO3L37zBUflf+lrqwftxd3aOW/GfQqkTQVylvyx67mgn0X6WNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oFhH9d5SD4Vk8E157QB/1Ayj8Y3UEddkqLE7cwxk+vA=;
	b=ekxGUgVNLL/ImLdOyqRfIGPjVOamMCnYmaOuf0RyTb6UJsYpyFVSCYtw8DkrYaJ37+ZC
	 7GkJa1fuH9Fw4vvX1FzPFm+miuY3O2L4/gjabja6BkTvMn5qzPaIbzPOXkdyPuyw+Gjxy
	 diemFyfoS2BdTiODgtOzlPTeU50sNRwgwoZ0Gz2OwvvUkfR6rCenTuyvmB/+AjBbcPdBn
	 KWIKFMk+XlsRGTG7++NBd1ALYWDL41zkvH/iYs0rnTV57xMK+rEM/j1D9QBJHG2x6nwDp
	 MRlaU8sfoLubfVNxQHJHSQ5TVNWiHKc+6la2maLZfIEFKSysZ3kO/TfoWJ5hTikjA4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0JiwJmw1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EBC606A320;
	Thu, 19 Nov 2026 00:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0JiwJmw1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5172A1F000C4;
	Thu, 19 Nov 2026 00:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049049;
	bh=oFhH9d5SD4Vk8E157QB/1Ayj8Y3UEddkqLE7cwxk+vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0JiwJmw1wW5cDOcxVqc/ZjE5mBOfF3Ny22eJ7eiw3aN728tu3pr9fiLgyj+XfelY5
	 EaxvIbLHVQ4r5QJFuJMuMOSREkftWUZYm75eK9iStJ053eRXYFeQnwEmQ2xOTnPhK4
	 gm9yQLPjjluvNRd9fvuBefIFj1N9vTVcXnVfLx3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2186/2857] drm/msm/dpu: bail from _dpu_core_perf_crtc_update_bus if there are no ICC paths
Date: Wed, 18 Nov 2026 15:53:40 +0100
Message-ID: <20261118150320.116262175@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 808c92df654a55251da7d85734f8a8842b1e465d ]

Skip bandwidth aggregation and return early if there are no interconnect
paths defined for the DPU device.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/550195/
Link: https://lore.kernel.org/r/20230730010102.350713-3-dmitry.baryshkov@linaro.org
Stable-dep-of: 480ba24aa340 ("drm/msm/dpu: compute the CRTC bandwidth from the state being checked")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
index 7f7557e17fafb..8d1529335a5b9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c
@@ -217,6 +217,9 @@ static int _dpu_core_perf_crtc_update_bus(struct dpu_kms *kms,
 	int i, ret = 0;
 	u64 avg_bw;
 
+	if (!kms->num_paths)
+		return 0;
+
 	drm_for_each_crtc(tmp_crtc, crtc->dev) {
 		if (tmp_crtc->enabled &&
 			curr_client_type ==
@@ -234,9 +237,6 @@ static int _dpu_core_perf_crtc_update_bus(struct dpu_kms *kms,
 		}
 	}
 
-	if (!kms->num_paths)
-		return 0;
-
 	avg_bw = perf.bw_ctl;
 	do_div(avg_bw, (kms->num_paths * 1000)); /*Bps_to_icc*/
 
-- 
2.53.0



