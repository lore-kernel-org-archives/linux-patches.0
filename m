Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA56832E728;
	Tue, 16 Jun 2026 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629291; cv=none; b=iV76X4O/vcE+mz0pMKtHjoLvXk2SwouE+NFbqFRykSZ1xry0+NJvPUnXPvvwOTc4WHZKhFd2gbdimAm2h9JsCMT0kP8O9U2yCyplwSSCzcBSywXmkLozdHsk7DYt325PbWG9SaVKVVzdc5Uy8K2sPYg8xT35EULiLvY/VZpXgiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629291; c=relaxed/simple;
	bh=yuMTw5I8rkN/oNTW3UQUTTFk3rMPrBdLvGNHjzldyEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJCE2GI4WI/rRMhZDgx5NFGEUfBRrsRM1kt3MSYUzDXhDP8d2FR2eP2rAfL3j0YNOBjQKohc3PR2LIn1lLBjQjehlepIBjqUQmU2FpvP4ySe4RJQKptdFRZHnEwzgsDqFps0rM2Z9qGJiuh6lYvIgD10UrgDKsTTYDxD8YwsaQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ubxizp53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ubxizp53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20511F000E9;
	Tue, 16 Jun 2026 17:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629290;
	bh=A5dlzgxXJnqAxMBO9iBWXDPu+xxpRkfC2om5hXCpMDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ubxizp53ErCu56tK5dT1PzHFiKPjIx79P0A7qPlRz30waGNCDdCVyaysX3asNEA9s
	 bYM2iddlhECo19qnodJFpYImJW6BMKKY3ZJMtYr+dH/PZfJLmQhktMnsxLJizreLFV
	 kRSHv+wIyxJIh9dTOBfyyA6X20AIQrRy8OxW34Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Hui <yiconghui@gmail.com>,
	Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
	Liu Ying <victor.liu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/452] drm/imx: Fix three kernel-doc warnings in dcss-scaler.c
Date: Tue, 16 Jun 2026 20:27:31 +0530
Message-ID: <20260616145129.518314951@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Hui <yiconghui@gmail.com>

[ Upstream commit ae0383e5a9a4b12d68c76c4769857def4665deff ]

Fix the following W=1 kerneldoc warnings by adding the missing parameter
descriptions for @phase0_identity and @nn_interpolation in
dcss_scaler_filter_design() and @phase0_identity in
dcss_scaler_gaussian_filter()

Warning: drivers/gpu/drm/imx/dcss/dcss-scaler.c:173 function parameter 'phase0_identity' not described in 'dcss_scaler_gaussian_filter'
Warning: drivers/gpu/drm/imx/dcss/dcss-scaler.c:270 function parameter 'phase0_identity' not described in 'dcss_scaler_filter_design'
Warning: drivers/gpu/drm/imx/dcss/dcss-scaler.c:270 function parameter 'nn_interpolation' not described in 'dcss_scaler_filter_design'

Fixes: 9021c317b770 ("drm/imx: Add initial support for DCSS on iMX8MQ")
Signed-off-by: Yicong Hui <yiconghui@gmail.com>
Reviewed-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Link: https://patch.msgid.link/20260406180013.2442096-1-yiconghui@gmail.com
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/dcss/dcss-scaler.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/imx/dcss/dcss-scaler.c b/drivers/gpu/drm/imx/dcss/dcss-scaler.c
index 47852b9dd5eaa2..d2a89a99bd71cf 100644
--- a/drivers/gpu/drm/imx/dcss/dcss-scaler.c
+++ b/drivers/gpu/drm/imx/dcss/dcss-scaler.c
@@ -166,6 +166,7 @@ static int exp_approx_q(int x)
  * dcss_scaler_gaussian_filter() - Generate gaussian prototype filter.
  * @fc_q: fixed-point cutoff frequency normalized to range [0, 1]
  * @use_5_taps: indicates whether to use 5 taps or 7 taps
+ * @phase0_identity: whether to override phase 0 coefficients with identity filter
  * @coef: output filter coefficients
  */
 static void dcss_scaler_gaussian_filter(int fc_q, bool use_5_taps,
@@ -262,7 +263,9 @@ static void dcss_scaler_nearest_neighbor_filter(bool use_5_taps,
  * @src_length: length of input
  * @dst_length: length of output
  * @use_5_taps: 0 for 7 taps per phase, 1 for 5 taps
+ * @phase0_identity: whether to override phase 0 coefficients with identity filter
  * @coef: output coefficients
+ * @nn_interpolation: whether to use nearest neighbor instead of gaussian filter
  */
 static void dcss_scaler_filter_design(int src_length, int dst_length,
 				      bool use_5_taps, bool phase0_identity,
-- 
2.53.0



