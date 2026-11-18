Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047478;
	b=O/Q0t5PLbgqi8TaDJcHJy65YD3SuDpEM4dXDNiyAhDi78p7DeR1z2ZdBaet+C/vBMkOd
	 /Y9MStYAydJljwN5nv8bIDGvX4e0sF62n8oFoRbgVxFam2Uw6/LgKxfFqVyia9Y3ufGIR
	 rr4GrXT4tqUujz653iC+HwwApN6hVIoSvR5Mj9H07vMmWYMSn8vFAlKF2bGNZT2rQmlLe
	 QtUMXrZkUm3EAQN1Un4RmnPPi+gqu4k+cO93j+J6tCRHhqTi5g6h6mF9B5LYX4gWwxu2i
	 JyFZoTEfW55juAVkD6KQxOjy2Tzz3738mtpSvasSFTdfipcnoPMeaRGvB2EoYUdU1Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UCzhOo5Ixi60VijM01i7mRYyQ+OCzbBtO9Igr20Pxcg=;
	b=gnpsld7gmYTLQ7jzbygnoxJcfuLKBfxCIJEAheZT3ZszHpFWldxo7hGBLbCggBgM+9DW
	 aU/ru4ZH8PAfCIZOzjiWOHM/vuACtIX6CJPa6UhR6V9H/cNEeZ4WDfRi7nAosldXX4i8j
	 YDKOELmmbrXHAv+A8hmcKhqIKw4mAhLeLGuWP8LtKwLFFMQV6XZ6ZZN6DYZE736Cqvbau
	 0rqLf1Ci3KB0l2QC/9xFmr8tISCYTjy8X1QsvcIq02rRfJdEbkCbh6qmSP0M2A/YBnVu5
	 7BsQV1pApNE1dLCiEvzd+O9ufQaj4HaV797p0cU89wF+DxKM6XgmUHTthXyuhI4O+RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m6/OUAfb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FD9606A32A;
	Thu, 19 Nov 2026 00:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6/OUAfb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54BC1F000C4;
	Thu, 19 Nov 2026 00:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047478;
	bh=UCzhOo5Ixi60VijM01i7mRYyQ+OCzbBtO9Igr20Pxcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6/OUAfbRDj0WRpCcOSCT51oFwXYv+IvMItfhBv4voyvx6uh6w+NPvoOoKtU3JWot
	 FEOPCKHMoFNF05is8zv6iNYczEfMJ2dlg8D0DvilonRDP+kubUg5mFSvDLKNNUZpJZ
	 OhPs4/c/U5o2/lnydJ5sR3kNG1OfqQssxzqtB6us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Wang <kevin.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1654/2857] drm/amd/pm: populate unique ID for smu 13.0.7
Date: Wed, 18 Nov 2026 15:44:48 +0100
Message-ID: <20261118150300.890513677@linuxfoundation.org>
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
[ sashal: Adjusted context to insert smu_v13_0_7_get_unique_id() immediately before the pptable_funcs table. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index f5e340c2c5984..50d4f7990dfb2 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1695,6 +1695,25 @@ static int smu_v13_0_7_set_df_cstate(struct smu_context *smu,
 					       NULL);
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
 static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.get_allowed_feature_mask = smu_v13_0_7_get_allowed_feature_mask,
 	.set_default_dpm_table = smu_v13_0_7_set_default_dpm_table,
@@ -1760,6 +1779,7 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.set_mp1_state = smu_v13_0_7_set_mp1_state,
 	.set_df_cstate = smu_v13_0_7_set_df_cstate,
 	.gpo_control = smu_v13_0_gpo_control,
+	.get_unique_id = smu_v13_0_7_get_unique_id,
 };
 
 void smu_v13_0_7_set_ppt_funcs(struct smu_context *smu)
-- 
2.53.0



