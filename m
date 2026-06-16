Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A6E34FF79;
	Tue, 16 Jun 2026 18:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635914; cv=none; b=Dg7u/H77wVm3Qd7Cs1xmOr8sGOPfv8ExkIKhypTC3TVwMsIVxDqsIKynB/jmfiKGZrKhJIsK5JU3m4XIl13JiIxfZ3IhqYgOQeMU6f7hB86dNN/K5quhXx+GZLmYHJ9qPcwEqYEtUrOf9tzT/okO3qUxyttSwXfjBZMBe/NzKNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635914; c=relaxed/simple;
	bh=tsUkCCjXvt1MnLCzN7IFB89dSbfY+TR+h4vwNnJrOqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rg9uTcFL2N3qaXk/Eu4ShXqxcCCLfzS/sOT0OAKXCcLcxc1bGBRDmUnwj2NSeody3EyqpgsT8vQxJRFW+hpfQHcoyBDXUef1atovZhi8GeNjCFLzJSvNXH1kK/RwOgp7MLPaXPTSbUeUf+zrC53pkWPOtpl0VnLw84jTN/Ggs5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXR3rU0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXR3rU0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C558D1F000E9;
	Tue, 16 Jun 2026 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635913;
	bh=PkkSnaygBLb3MFz1SGYfefhUtKG+15QjmXl7TrGBhA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXR3rU0ov2PstAO4oSChOcSVN1Ef8SufLtaucVMxssn8WcPWApy4JNXhIMbF7b3LZ
	 fZjtjyhcl8O0nTvwcm+2Fe1N4puRJJQvRah1SC/Hv6+8Ik8ho93YScA5lLEds6yMCH
	 VADPWpxmvjAFYLK5PIVBTgLM142BfH9Rn6bX3nTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Hui <yiconghui@gmail.com>,
	Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
	Liu Ying <victor.liu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/342] drm/imx: Fix three kernel-doc warnings in dcss-scaler.c
Date: Tue, 16 Jun 2026 20:27:16 +0530
Message-ID: <20260616145054.709777906@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cd21905de580ff..d156cc60c3f4aa 100644
--- a/drivers/gpu/drm/imx/dcss/dcss-scaler.c
+++ b/drivers/gpu/drm/imx/dcss/dcss-scaler.c
@@ -164,6 +164,7 @@ static int exp_approx_q(int x)
  * dcss_scaler_gaussian_filter() - Generate gaussian prototype filter.
  * @fc_q: fixed-point cutoff frequency normalized to range [0, 1]
  * @use_5_taps: indicates whether to use 5 taps or 7 taps
+ * @phase0_identity: whether to override phase 0 coefficients with identity filter
  * @coef: output filter coefficients
  */
 static void dcss_scaler_gaussian_filter(int fc_q, bool use_5_taps,
@@ -249,7 +250,9 @@ static void dcss_scaler_gaussian_filter(int fc_q, bool use_5_taps,
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



