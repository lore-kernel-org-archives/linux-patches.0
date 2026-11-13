Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585834;
	b=PQXGO8zhTiSEd0u1apW4/gKdpyraffTTDnjo5HdhNtOFWCbbMv9u0aMR9Ey3rPFjP+WY
	 JWrsKb8FhEZRDdd+T4lyNeMUfLtaeEXSeMAF/7m3o0DXmpLFkmKHvRbl/Pku7GQrMHb5I
	 aCboHC87DHl5lKwVGpq46SlvS6HtH7Cwdo2Owd4vQPr9rePTVmWrroPyYDDL47RnhLzUH
	 maS2p/Qpb7vfHQyBU/ZxIESvygF81KsvWa7DJkCpHIr4Vcl+H3MxpCbjTVaNYSx0sqmcP
	 CIv9fRwzlgxcOrzblX6rtGlU/ITR4HoJAABBMwDzxMDZVrDJL4JAnw/Idb+rQDmBbUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IIokZIQGc+lQ9SSmCZJw+YGNpxHcTlkI7kDGwilijdQ=;
	b=edIMchV1i1qqriqeO0FWgsIqJya+uNgaHHc9INlw9BH5ZpNtfhtL6ELwvGN1OCGGC6vR
	 J5UVKObKRJHQ5VC1Xdm+DXjTPC3aC0o8uYMjBt1LYsMBAPHk8Gc+1iK3rlSbjiPJXOXx4
	 iqbpKEUFxl+3sK/hlNu2F/xvql3h+uvYfrajV+Whof5YQOVZQWcOROf9PgddHEjyItLHP
	 WufSLrq3ugGyzuO/dvTFEW5UFfzRqHud63prsW9mCQIsf+VNGZj+HpMBEYGl1y2POqiaZ
	 06D4GonSzNM8RqSi1oO5RxPBe0TmfeNNdJl8Wtw+B295ZxHqModIKyWyAZKY5GV7uVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jkD47mHq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09909606BAA6;
	Fri, 13 Nov 2026 16:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jkD47mHq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24A21F000C4;
	Fri, 13 Nov 2026 16:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585833;
	bh=IIokZIQGc+lQ9SSmCZJw+YGNpxHcTlkI7kDGwilijdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkD47mHqh2jhzS+FsaSH945OnDKEKXwTXtJw+D8GtRH/lhkQPKNO9leCPwlYH3FUK
	 iyYx6WdXOqXnJ/FRL8PISK0TOx2lsNydIkDl2mhPxVih3sf8rAg7nX91He73bhsxDJ
	 bxfwmvv08MWAI/7G7SgxIaTsFX0lGyNPzjFThxxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Wang <kevin.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 371/507] drm/amd/pm: populate unique ID for smu 13.0.7
Date: Fri, 13 Nov 2026 10:51:15 -0500
Message-ID: <20261113153808.687036107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Kevin Wang <kevin.wang@amd.com>

[ Upstream commit 079f9103d9cde68fb2ccc414e94520f43ee102de ]

The smu 13.0.7 backend does not register get_unique_id, leaving
adev->unique_id at zero and KFD topology without the stable GPU
identifier consumed by HIP.

The failure is observed at:
    auto ierr = hipDeviceGetUuid(&uuid, 0);

Fixes: 113cc31dde66 ("drm/amd/pm: add SMU_13_0_7 ppt_funcs for SMU_13_0_7")
Signed-off-by: Kevin Wang <kevin.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5e2585daaf8336d9ce1bf52e55a9b7a8cdbf625b)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 8285d4a91589a..13e7e33fa0eb2 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2912,6 +2912,25 @@ static int smu_v13_0_7_mode1_reset(struct smu_context *smu)
    return ret;
 }
 
+static void smu_v13_0_7_get_unique_id(struct smu_context *smu)
+{
+	SmuMetricsExternal_t metrics_external;
+	SmuMetrics_t *metrics = &metrics_external.SmuMetrics;
+	struct amdgpu_device *adev = smu->adev;
+	u32 upper32 = 0, lower32 = 0;
+	int ret;
+
+	ret = smu_cmn_get_metrics_table(smu, &metrics_external, false);
+	if (ret)
+		goto out;
+
+	upper32 = metrics->PublicSerialNumberUpper;
+	lower32 = metrics->PublicSerialNumberLower;
+
+out:
+	adev->unique_id = ((u64)upper32 << 32) | lower32;
+}
+
 static void smu_v13_0_7_init_msg_ctl(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
@@ -2995,6 +3014,7 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.enable_uclk_shadow = smu_v13_0_enable_uclk_shadow,
 	.set_wbrf_exclusion_ranges = smu_v13_0_set_wbrf_exclusion_ranges,
 	.interrupt_work = smu_v13_0_interrupt_work,
+	.get_unique_id = smu_v13_0_7_get_unique_id,
 };
 
 void smu_v13_0_7_set_ppt_funcs(struct smu_context *smu)
-- 
2.53.0



