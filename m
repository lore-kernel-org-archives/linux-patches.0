Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216711;
	b=xWWkTG1ie3IaGdnvSqHnAi2+wQ83XeJha9dgvgRbXPPYCZAafefxnL1Y90qPr7X33AZL
	 dNQS183d0SRB+TnP0vcd4e62v+AxiBp74/oFkQJJcDh5k9kPNdAltCUEINr0YRZBRd06H
	 qw6Ta6jVDu+usGPmUrYVzU8taSM2H/imuRgG8C1AdvWxTO3q4l8tBFl8X5qTYErzJ7cp3
	 YViyOnK240odqcnY/fHrZE46u/kmt6apMYsM6VAcS+BI4la29y8Y96IhzF99S+EmRspVm
	 +9xTYJ15Uu6svTx4fMiddFaYG9MQhZB4QrSTuFEfCfv2+DLURGA+VGbjYJBL9E6RJfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gcVOTbc4tDFNcrJlG5xUQ5n4/34tyV1WriB+ktOskB8=;
	b=kGoG9j4/EB3N0C0wwzGW5/GIlVeT09hWeTAPuI92jlgeuboTF/mi3Hs0ViUF9XtXpgXA
	 EOTmgh3oUhX+QFtmJK7O1FeiZuMljgFCgeDgiO8Fyh7n1PG/O6cfYOImg94WfRDEdSL9t
	 ffPUg0i2G4h0q2zU3FoZ71zJjq2Emqkc5iqXCKH6OJO53aUtsVeJ5N7emidbNZTdML3j4
	 YYxhs/vdvvXAZq4LHqFiEOiQQGtxOQ6Vxj3s5UL+CZB1TH12A9HOcLCvacFvi5B7wDIZ/
	 vUEHlFuzgP46sYXyaunVI3ft0eVpTm/IZqaU/Mj8qW/rtYeF2l2K1Tan2xj3WOqhywA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hG7ZD4p3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A61606A31C;
	Wed, 28 Oct 2026 19:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hG7ZD4p3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F94D1F01828;
	Wed, 28 Oct 2026 19:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216711;
	bh=gcVOTbc4tDFNcrJlG5xUQ5n4/34tyV1WriB+ktOskB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hG7ZD4p3iiEHC0zozsAjgcX71kK6FkyAVcwKxzRAJA2WuzUdGQg0Fg97UDwIP33S/
	 6GKLD3ZQIonHq5yvJyP+vJ/VazLVJkhl4ke+t3McnTjDs0nG2Wvn89Hm3SHGZ1/OIi
	 Z4/rx8Z/sXvbJ7xhMDsTiZS6o17q/FXOVOOp7ldw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1653/1887] remoteproc: qcom_wcnss: Fix handling the lack of PD regulators in v3
Date: Wed, 28 Oct 2026 18:02:29 +0100
Message-ID: <20261028170537.077248438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit 3dbc90b9c22ea96e37bf55f6011e63b5123ec668 ]

The changes introduced to handle single power domain platforms have
swapped the info pointer increment from num_pd_vregs to num_pds, which
would shift the info pointer past the end of the array for pronto-v3,
which does not list power domain regulators in vregs.

This showed up as a difference between GCC- and LLVM-compiled kernels
on SDM632 devices, where only with LLVM one would get the
"regulator request with no identifier" error, because the out-of-bounds
memory ended up being zeroed. Fix by skipping the increment when there
are more power domains than regulators.

Signed-off-by: Val Packett <val@packett.cool>
Fixes: 65991ea8a6d1 ("remoteproc: qcom_wcnss: Handle platforms with only single power domain")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 65991ea8a6d1 ("remoteproc: qcom_wcnss: Handle platforms with only  single power domain")
Link: https://lore.kernel.org/r/20260201210230.911220-1-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index af96541c9b69a..44301a77db938 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -430,25 +430,31 @@ static void wcnss_release_pds(struct qcom_wcnss *wcnss)
 }
 
 static int wcnss_init_regulators(struct qcom_wcnss *wcnss,
-				 const struct wcnss_vreg_info *info,
-				 int num_vregs, int num_pd_vregs)
+				 const struct wcnss_data *data)
 {
+	const struct wcnss_vreg_info *info = data->vregs;
 	struct regulator_bulk_data *bulk;
+	size_t i, possible_pds = 0, num_vregs = data->num_vregs;
 	int ret;
-	int i;
+
+	for (i = 0; i < WCNSS_MAX_PDS; i++)
+		if (data->pd_names[i])
+			possible_pds++;
 
 	/*
 	 * If attaching the power domains suceeded we can skip requesting
 	 * the regulators for the power domains. For old device trees we need to
 	 * reserve extra space to manage them through the regulator interface.
 	 */
-	if (wcnss->num_pds) {
+	if (possible_pds >= num_vregs) {
+		/* Do nothing if vregs do not include PD regulators (pronto-v3) */
+	} else if (wcnss->num_pds) {
 		info += wcnss->num_pds;
 		/* Handle single power domain case */
-		if (wcnss->num_pds < num_pd_vregs)
-			num_vregs += num_pd_vregs - wcnss->num_pds;
+		if (wcnss->num_pds < data->num_pd_vregs)
+			num_vregs += data->num_pd_vregs - wcnss->num_pds;
 	} else {
-		num_vregs += num_pd_vregs;
+		num_vregs += data->num_pd_vregs;
 	}
 
 	bulk = devm_kcalloc(wcnss->dev,
@@ -607,8 +613,7 @@ static int wcnss_probe(struct platform_device *pdev)
 	if (ret && (ret != -ENODATA || !data->num_pd_vregs))
 		goto free_rproc;
 
-	ret = wcnss_init_regulators(wcnss, data->vregs, data->num_vregs,
-				    data->num_pd_vregs);
+	ret = wcnss_init_regulators(wcnss, data);
 	if (ret)
 		goto detach_pds;
 
-- 
2.53.0



