Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064262;
	b=SxBj37JlGfugaKhPE8tFFpxx/Mm+e6vra8KGM+I09NQ0Zj6wi9/wgVnqwZCmSKrpfS4p
	 +l/oDzRmBX0t8c0CfrgxDBY/NuleUbbDAkJQNCsgllx9SNvgPSpLS5Gawlx5Svw70YHqI
	 H59PS3G57mZML5toUxL1UD9RyeVIetdKv0H9CsMbBE7mXQMi1WTL6inxjJxC8BNtxdDZ1
	 0OwsirJppuA7fxxHvZniz09XSXCb7c/fxO7iBF/6BQ4/UnZzS/EZQNxDRPTR79+UE9aqa
	 jlUj0OacMtGfTTnrE3njkl8c6juDZUK1Vl+bo13LGViJmrZCvfqaMepulY8xucCgwSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MEPXR/6pqKAuzcvNtOqwDgaESNMDDMbJmT7DF/Y5DDU=;
	b=n1uPWb33whLCyySy85WogO5yEbtMpQRBKH8t3O7cQQKLUP/v+Y2iNvFsVcxTtstoSefx
	 BH9JTyv25UnJoJd+h5t6SIpEgUI3FrT06pm0p+hmACVFdZF/DrYIfdF5ehpg1qUY6nveg
	 ywGIOjPBSLP9SjzhUNrFlTfdvhbwc8Pgu5dvxnRQexdMNl0Q96fMKReCLDENIR4Dx858L
	 2k6MOYGMVbp9cKwVZIbke7JtN/kgoC788c03HS0Yvpb0hz+2RSHtoIgFwlCoTl8Lv8FD/
	 pxmnFNvQ3QkUXzrWVY+zpBMuR3ZVQavshOWOtN7AZ/dzmHZ+tPYMe6t/AJC9hRYMwJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sk9zzyE4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E179D606A9D3;
	Sat,  7 Nov 2026 15:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sk9zzyE4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEB71F0089F;
	Sat,  7 Nov 2026 15:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064261;
	bh=MEPXR/6pqKAuzcvNtOqwDgaESNMDDMbJmT7DF/Y5DDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sk9zzyE4JdXbaapolK7V0fCdBvbVUp0jZPbEZr/noaKynSEQE0zIyxzexpJ/071LH
	 Xq/2MUhKD8zgjGw00hc/6qDpzSOe+Jk936lkHl3GpIu0hwHEw04Wp5SlK01ayUeTYs
	 cjG4XNcL4A5ZZULSHJ1bu/B/tgdea8DY5PxCAl10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Cory Keitz <ckeitz@amazon.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0361/1257] media: qcom: camss: Add "gcc_axi_hf" to 8775p VFE lite clock lists
Date: Sat,  7 Nov 2026 08:44:17 -0500
Message-ID: <20261107134949.442195747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

[ Upstream commit 583b27edfe669fe27c631b4ac77c0ce0250f7bba ]

The "gcc_axi_hf" clock is correctly listed in the clock list of the
8775p 2 main VFE-s, but it is missing from all the VFE-lite clock lists,
causing these to not work on platforms where the firmware allows turning
off "gcc_axi_hf".

Add the missing "gcc_axi_hf" to fix the VFE-lite blocks not working on
these platforms.

Fixes: 924f45e58b1fe ("media: qcom: camss: Add missing clocks for VFE lite on sa8775p")
Cc: stable@vger.kernel.org
Suggested-by: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Tested-by: Cory Keitz <ckeitz@amazon.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss.c | 25 ++++++++++++++---------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 2123f6388e3d7..68491b16d6476 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -4037,10 +4037,11 @@ static const struct camss_subdev_resources vfe_res_8775p[] = {
 	/* VFE2 (lite) */
 	{
 		.regulators = {},
-		.clock = { "cpas_ahb", "cpas_vfe_lite", "vfe_lite_ahb",
-			   "vfe_lite_csid", "vfe_lite_cphy_rx",
+		.clock = { "cpas_ahb", "gcc_axi_hf", "cpas_vfe_lite",
+			   "vfe_lite_ahb", "vfe_lite_csid", "vfe_lite_cphy_rx",
 			   "vfe_lite", "camnoc_axi"},
 		.clock_rate = {
+			{ 0 },
 			{ 0 },
 			{ 0 },
 			{ 300000000, 400000000, 400000000, 400000000 },
@@ -4062,10 +4063,11 @@ static const struct camss_subdev_resources vfe_res_8775p[] = {
 	/* VFE3 (lite) */
 	{
 		.regulators = {},
-		.clock = { "cpas_ahb", "cpas_vfe_lite", "vfe_lite_ahb",
-			   "vfe_lite_csid", "vfe_lite_cphy_rx",
+		.clock = { "cpas_ahb", "gcc_axi_hf", "cpas_vfe_lite",
+			   "vfe_lite_ahb", "vfe_lite_csid", "vfe_lite_cphy_rx",
 			   "vfe_lite", "camnoc_axi"},
 		.clock_rate = {
+			{ 0 },
 			{ 0 },
 			{ 0 },
 			{ 300000000, 400000000, 400000000, 400000000 },
@@ -4087,10 +4089,11 @@ static const struct camss_subdev_resources vfe_res_8775p[] = {
 	/* VFE4 (lite) */
 	{
 		.regulators = {},
-		.clock = { "cpas_ahb", "cpas_vfe_lite", "vfe_lite_ahb",
-			   "vfe_lite_csid", "vfe_lite_cphy_rx",
+		.clock = { "cpas_ahb", "gcc_axi_hf", "cpas_vfe_lite",
+			   "vfe_lite_ahb", "vfe_lite_csid", "vfe_lite_cphy_rx",
 			   "vfe_lite", "camnoc_axi"},
 		.clock_rate = {
+			{ 0 },
 			{ 0 },
 			{ 0 },
 			{ 300000000, 400000000, 400000000, 400000000 },
@@ -4112,10 +4115,11 @@ static const struct camss_subdev_resources vfe_res_8775p[] = {
 	/* VFE5 (lite) */
 	{
 		.regulators = {},
-		.clock = { "cpas_ahb", "cpas_vfe_lite", "vfe_lite_ahb",
-			   "vfe_lite_csid", "vfe_lite_cphy_rx",
+		.clock = { "cpas_ahb", "gcc_axi_hf", "cpas_vfe_lite",
+			   "vfe_lite_ahb", "vfe_lite_csid", "vfe_lite_cphy_rx",
 			   "vfe_lite", "camnoc_axi"},
 		.clock_rate = {
+			{ 0 },
 			{ 0 },
 			{ 0 },
 			{ 300000000, 400000000, 400000000, 400000000 },
@@ -4137,10 +4141,11 @@ static const struct camss_subdev_resources vfe_res_8775p[] = {
 	/* VFE6 (lite) */
 	{
 		.regulators = {},
-		.clock = { "cpas_ahb", "cpas_vfe_lite", "vfe_lite_ahb",
-			   "vfe_lite_csid", "vfe_lite_cphy_rx",
+		.clock = { "cpas_ahb", "gcc_axi_hf", "cpas_vfe_lite",
+			   "vfe_lite_ahb", "vfe_lite_csid", "vfe_lite_cphy_rx",
 			   "vfe_lite", "camnoc_axi"},
 		.clock_rate = {
+			{ 0 },
 			{ 0 },
 			{ 0 },
 			{ 300000000, 400000000, 400000000, 400000000 },
-- 
2.53.0



