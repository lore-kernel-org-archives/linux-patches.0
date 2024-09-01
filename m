Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676C617DFFC;
	Sun,  1 Sep 2024 16:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208340; cv=none; b=bk+kS//7QnXjK1Y/kuNUJiUjz9HTIZkDVNfYmrRxcaOC+JEAds7MUWByk5qWzX4NagclXqXhRD+eXm/m3H4PBWfuSOO5P8n/UPamtXlT4JPXcqWulAp+8Bv9lrAnBDFR2WvrFMLqF7BV699144kHNGVxIYhfGRymDSWsocjBwFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208340; c=relaxed/simple;
	bh=pizUEyOMdsOY3gkK65JglbpokWPyeCaKWcAtvo9+zOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEfTWamPGnWoDINe32M9ajEdCHERDOY3dQ/IlVhl1AhRgACBR9cjNRTHJxaLQwxGh9eHoaLnZHE0af+GE7nZWXAdh5h5Q3FS1IH4q3j48ozeZMNs6OEALrjAp1rnM17kCPicW2ZytQkvy41n7e0e4ScC6b1XBelzIppocBsSJFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1E2UqWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1E2UqWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE651C4CEC3;
	Sun,  1 Sep 2024 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208340;
	bh=pizUEyOMdsOY3gkK65JglbpokWPyeCaKWcAtvo9+zOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1E2UqWg1FhfJpCt4j0yMIS7v6vQo93Bn9DkOUaOpHg8qvcCfnWlSKk49g1aAh/qc
	 yjO4Iw0M6VqiYEBHtY0Oqc1WugTEQz9DVhVCvwaJk+PSGRob+d6G3rROU761Sg3vhv
	 JS73aByU2A+bgWINPt7Qef6+fyLPi1T+9JDvyvt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 051/149] pinctrl: qcom: x1e80100: Update PDC hwirq map
Date: Sun,  1 Sep 2024 18:16:02 +0200
Message-ID: <20240901160819.387934192@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit b7fd10333713e9984cc9b9c04f3681f80efdc809 ]

The current map seems to be out of sync (and includes a duplicate entry
for GPIO193..).

Replace it with the map present in shipping devices' ACPI tables.

This new one seems more complete, as it e.g. contains GPIO145 (PCIE6a
WAKE#)

Fixes: 05e4941d97ef ("pinctrl: qcom: Add X1E80100 pinctrl driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Rajendra Nayak <quic_rjendra@quicinc.com>
Link: https://lore.kernel.org/20240711-topic-x1e_pdc_tlmm-v1-1-e278b249d793@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-x1e80100.c | 27 ++++++++++++++-----------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-x1e80100.c b/drivers/pinctrl/qcom/pinctrl-x1e80100.c
index e30e938403574..6cd4d10e6fd6f 100644
--- a/drivers/pinctrl/qcom/pinctrl-x1e80100.c
+++ b/drivers/pinctrl/qcom/pinctrl-x1e80100.c
@@ -1813,18 +1813,21 @@ static const struct msm_pingroup x1e80100_groups[] = {
 
 static const struct msm_gpio_wakeirq_map x1e80100_pdc_map[] = {
 	{ 0, 72 }, { 2, 70 }, { 3, 71 }, { 6, 123 }, { 7, 67 }, { 11, 85 },
-	{ 15, 68 }, { 18, 122 }, { 19, 69 }, { 21, 158 }, { 23, 143 }, { 26, 129 },
-	{ 27, 144 }, { 28, 77 }, { 29, 78 }, { 30, 92 }, { 32, 145 }, { 33, 115 },
-	{ 34, 130 }, { 35, 146 }, { 36, 147 }, { 39, 80 }, { 43, 148 }, { 47, 149 },
-	{ 51, 79 }, { 53, 89 }, { 59, 87 }, { 64, 90 }, { 65, 106 }, { 66, 142 },
-	{ 67, 88 }, { 71, 91 }, { 75, 152 }, { 79, 153 }, { 80, 125 }, { 81, 128 },
-	{ 84, 137 }, { 85, 155 }, { 87, 156 }, { 91, 157 }, { 92, 138 }, { 94, 140 },
-	{ 95, 141 }, { 113, 84 }, { 121, 73 }, { 123, 74 }, { 129, 76 }, { 131, 82 },
-	{ 134, 83 }, { 141, 93 }, { 144, 94 }, { 147, 96 }, { 148, 97 }, { 150, 102 },
-	{ 151, 103 }, { 153, 104 }, { 156, 105 }, { 157, 107 }, { 163, 98 }, { 166, 112 },
-	{ 172, 99 }, { 181, 101 }, { 184, 116 }, { 193, 40 }, { 193, 117 }, { 196, 108 },
-	{ 203, 133 }, { 212, 120 }, { 213, 150 }, { 214, 121 }, { 215, 118 }, { 217, 109 },
-	{ 220, 110 }, { 221, 111 }, { 222, 124 }, { 224, 131 }, { 225, 132 },
+	{ 13, 86 }, { 15, 68 }, { 18, 122 }, { 19, 69 }, { 21, 158 }, { 23, 143 },
+	{ 24, 126 }, { 26, 129 }, { 27, 144 }, { 28, 77 }, { 29, 78 }, { 30, 92 },
+	{ 31, 159 }, { 32, 145 }, { 33, 115 }, { 34, 130 }, { 35, 146 }, { 36, 147 },
+	{ 38, 113 }, { 39, 80 }, { 43, 148 }, { 47, 149 }, { 51, 79 }, { 53, 89 },
+	{ 55, 81 }, { 59, 87 }, { 64, 90 }, { 65, 106 }, { 66, 142 }, { 67, 88 },
+	{ 68, 151 }, { 71, 91 }, { 75, 152 }, { 79, 153 }, { 80, 125 }, { 81, 128 },
+	{ 83, 154 }, { 84, 137 }, { 85, 155 }, { 87, 156 }, { 91, 157 }, { 92, 138 },
+	{ 93, 139 }, { 94, 140 }, { 95, 141 }, { 113, 84 }, { 121, 73 }, { 123, 74 },
+	{ 125, 75 }, { 129, 76 }, { 131, 82 }, { 134, 83 }, { 141, 93 }, { 144, 94 },
+	{ 145, 95 }, { 147, 96 }, { 148, 97 }, { 150, 102 }, { 151, 103 }, { 153, 104 },
+	{ 154, 100 }, { 156, 105 }, { 157, 107 }, { 163, 98 }, { 166, 112 }, { 172, 99 },
+	{ 175, 114 }, { 181, 101 }, { 184, 116 }, { 193, 117 }, { 196, 108 }, { 203, 133 },
+	{ 208, 134 }, { 212, 120 }, { 213, 150 }, { 214, 121 }, { 215, 118 }, { 217, 109 },
+	{ 219, 119 }, { 220, 110 }, { 221, 111 }, { 222, 124 }, { 224, 131 }, { 225, 132 },
+	{ 228, 135 }, { 230, 136 }, { 232, 162 },
 };
 
 static const struct msm_pinctrl_soc_data x1e80100_pinctrl = {
-- 
2.43.0



