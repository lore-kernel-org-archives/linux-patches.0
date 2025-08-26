Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B7F2E88B7;
	Tue, 26 Aug 2025 11:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207450; cv=none; b=lNn3avWLyJ2OMybniL6AHyZGt+Es8xXzd5bCmpWJeddDlIYUc2Wp5FqvvxsO01OZ7khcCNiumwuZNyre4T9gT4rPvLsbvfKUP+w9UfteO0p/BFKXe90xuX/3ktil3nEM8u4RidrwwU8RDyoDJbBYAtMUC7U2ySLlY+orZfgv3vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207450; c=relaxed/simple;
	bh=LuPLeNvPt8ryPd8m6I8/N/uJFTV1OBFnhv7TZdB6Ga4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvofVKdEX8qD1VY4aUBG5ij0iGb0HzDxVtpceXhf1CGasVhz/RdaaTfixO9N5yXohtYbB0sRg5OcenZPdrRV5jqUEqBuScyjOe02BsSDx2gk9CEoTiLeFmhAnVF2B05nR5DIGYl84NzDUR8tjcyMjND74t0yfSyQp+RadsV0J/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bkmdq8Kj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bkmdq8Kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C78C4CEF1;
	Tue, 26 Aug 2025 11:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207450;
	bh=LuPLeNvPt8ryPd8m6I8/N/uJFTV1OBFnhv7TZdB6Ga4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bkmdq8KjDxQkBch21ctiB4KMlMrvbROaTdBzJUsuFHDFDqVgp8f9a4+VpsivaS2h3
	 asdUkD2MMdFWxcZ1fsbAkQfAx3+tRXR3EEgcMhpy5kyRMkUp8SeacvGLTtALicobAW
	 JyyanHQWVrHvHeVNMF3bYisSlabWdAO2e5m4sCns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.16 145/457] media: qcom: camss: Remove extraneous -supply postfix on supply names
Date: Tue, 26 Aug 2025 13:07:09 +0200
Message-ID: <20250826110940.956693590@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit c26e8dcd9d4e86d788c5bf7a5dd0ea70a95ab067 upstream.

The -supply postfix is wrong but wasn't noticed on the CRD devices or
indeed the Dell devices, however on Lenovo devices the error comes up.

Fixes: 1830cf0f56c3 ("media: qcom: camss: Add x1e80100 specific support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
[bod: reworded commit log per Konrad's feedback]
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index e1d64c8f42ae..e08e70b93824 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -2486,8 +2486,8 @@ static const struct resources_icc icc_res_sm8550[] = {
 static const struct camss_subdev_resources csiphy_res_x1e80100[] = {
 	/* CSIPHY0 */
 	{
-		.regulators = { "vdd-csiphy-0p8-supply",
-				"vdd-csiphy-1p2-supply" },
+		.regulators = { "vdd-csiphy-0p8",
+				"vdd-csiphy-1p2" },
 		.clock = { "csiphy0", "csiphy0_timer" },
 		.clock_rate = { { 300000000, 400000000, 480000000 },
 				{ 266666667, 400000000 } },
@@ -2501,8 +2501,8 @@ static const struct camss_subdev_resources csiphy_res_x1e80100[] = {
 	},
 	/* CSIPHY1 */
 	{
-		.regulators = { "vdd-csiphy-0p8-supply",
-				"vdd-csiphy-1p2-supply" },
+		.regulators = { "vdd-csiphy-0p8",
+				"vdd-csiphy-1p2" },
 		.clock = { "csiphy1", "csiphy1_timer" },
 		.clock_rate = { { 300000000, 400000000, 480000000 },
 				{ 266666667, 400000000 } },
@@ -2516,8 +2516,8 @@ static const struct camss_subdev_resources csiphy_res_x1e80100[] = {
 	},
 	/* CSIPHY2 */
 	{
-		.regulators = { "vdd-csiphy-0p8-supply",
-				"vdd-csiphy-1p2-supply" },
+		.regulators = { "vdd-csiphy-0p8",
+				"vdd-csiphy-1p2" },
 		.clock = { "csiphy2", "csiphy2_timer" },
 		.clock_rate = { { 300000000, 400000000, 480000000 },
 				{ 266666667, 400000000 } },
@@ -2531,8 +2531,8 @@ static const struct camss_subdev_resources csiphy_res_x1e80100[] = {
 	},
 	/* CSIPHY4 */
 	{
-		.regulators = { "vdd-csiphy-0p8-supply",
-				"vdd-csiphy-1p2-supply" },
+		.regulators = { "vdd-csiphy-0p8",
+				"vdd-csiphy-1p2" },
 		.clock = { "csiphy4", "csiphy4_timer" },
 		.clock_rate = { { 300000000, 400000000, 480000000 },
 				{ 266666667, 400000000 } },
-- 
2.50.1



