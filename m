Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CC13E7BCC;
	Fri, 15 May 2026 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862529; cv=none; b=HH9jyUP8mVTbreZ13+kKvNhyHBXLQ4mJvOMU9nVffdl3GoPu2I7OfPMVl1qMpu1tEOFPKmxmkHK61VTRXHVepzg40fDDJkEDB0evD4d03vnHEBdpCb1JDrNA+2mu8XxnrfJYVZGemro4KJXYAluLT+4d/Zsg01W3fuBoAMZN/zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862529; c=relaxed/simple;
	bh=TRzWPFvVAYLE4St4IDrpOPBKL+tLo7z95KDB9L9DidI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNvtE+N1Vv7wykxnoevSWOCuKn7why8Kiy1/tHJ0EOUdah8My+fxAMOWD9XqOg4DuB1FtXgh1RpMLmJizloZHSX9zoFuyY5ttZ6m/vZZLtSNmqyAnEuhhThpo7XotfMLl/PWrNkuRfLpT/rNTT+IuRKkdd2CLffaSh/Z5tzCmYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtdmUKXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtdmUKXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92183C2BCB0;
	Fri, 15 May 2026 16:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862528;
	bh=TRzWPFvVAYLE4St4IDrpOPBKL+tLo7z95KDB9L9DidI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtdmUKXEhHcT+58s6iqjMsMo5uLhEvsUDlzC5pbm7Sz6EdnJ5RFQaz1546+UoUnw3
	 7s7Tf+hAKVOLjTmSBV7y3L8YiBWcUboOmSTlrqcTTjCwjbhxd8BqAbw8K4AaC9SzbN
	 YS2I+VxauElVPWVthA2cHgElY/g9lqjbBYS4OXS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 081/201] media: qcom: camss: Add missing clocks for VFE lite on sa8775p
Date: Fri, 15 May 2026 17:48:19 +0200
Message-ID: <20260515154700.286354520@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>

commit d31fac47b39f5e1ed85a587688ca70b793e421b4 upstream.

Add missing required clocks (cpas_ahb and camnoc_axi) for VFE lite
instances on sa8775p platform. These clocks are necessary for proper
VFE lite operation:

Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
Fixes: e7b59e1d06fb ("media: qcom: camss: Add support for VFE 690")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss.c |   40 ++++++++++++++++++------------
 1 file changed, 25 insertions(+), 15 deletions(-)

--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -3742,15 +3742,17 @@ static const struct camss_subdev_resourc
 	/* VFE2 (lite) */
 	{
 		.regulators = {},
-		.clock = { "cpas_vfe_lite", "vfe_lite_ahb",
+		.clock = { "cpas_ahb", "cpas_vfe_lite", "vfe_lite_ahb",
 			   "vfe_lite_csid", "vfe_lite_cphy_rx",
-			   "vfe_lite"},
+			   "vfe_lite", "camnoc_axi"},
 		.clock_rate = {
-			{ 0, 0, 0, 0  },
+			{ 0 },
+			{ 0 },
 			{ 300000000, 400000000, 400000000, 400000000 },
 			{ 400000000, 400000000, 400000000, 400000000 },
 			{ 400000000, 400000000, 400000000, 400000000 },
 			{ 480000000, 600000000, 600000000, 600000000 },
+			{ 400000000 },
 		},
 		.reg = { "vfe_lite0" },
 		.interrupt = { "vfe_lite0" },
@@ -3765,15 +3767,17 @@ static const struct camss_subdev_resourc
 	/* VFE3 (lite) */
 	{
 		.regulators = {},
-		.clock = { "cpas_vfe_lite", "vfe_lite_ahb",
+		.clock = { "cpas_ahb", "cpas_vfe_lite", "vfe_lite_ahb",
 			   "vfe_lite_csid", "vfe_lite_cphy_rx",
-			   "vfe_lite"},
+			   "vfe_lite", "camnoc_axi"},
 		.clock_rate = {
-			{ 0, 0, 0, 0  },
+			{ 0 },
+			{ 0 },
 			{ 300000000, 400000000, 400000000, 400000000 },
 			{ 400000000, 400000000, 400000000, 400000000 },
 			{ 400000000, 400000000, 400000000, 400000000 },
 			{ 480000000, 600000000, 600000000, 600000000 },
+			{ 400000000 },
 		},
 		.reg = { "vfe_lite1" },
 		.interrupt = { "vfe_lite1" },
@@ -3788,15 +3792,17 @@ static const struct camss_subdev_resourc
 	/* VFE4 (lite) */
 	{
 		.regulators = {},
-		.clock = { "cpas_vfe_lite", "vfe_lite_ahb",
+		.clock = { "cpas_ahb", "cpas_vfe_lite", "vfe_lite_ahb",
 			   "vfe_lite_csid", "vfe_lite_cphy_rx",
-			   "vfe_lite"},
+			   "vfe_lite", "camnoc_axi"},
 		.clock_rate = {
-			{ 0, 0, 0, 0  },
+			{ 0 },
+			{ 0 },
 			{ 300000000, 400000000, 400000000, 400000000 },
 			{ 400000000, 400000000, 400000000, 400000000 },
 			{ 400000000, 400000000, 400000000, 400000000 },
 			{ 480000000, 600000000, 600000000, 600000000 },
+			{ 400000000 },
 		},
 		.reg = { "vfe_lite2" },
 		.interrupt = { "vfe_lite2" },
@@ -3811,15 +3817,17 @@ static const struct camss_subdev_resourc
 	/* VFE5 (lite) */
 	{
 		.regulators = {},
-		.clock = { "cpas_vfe_lite", "vfe_lite_ahb",
+		.clock = { "cpas_ahb", "cpas_vfe_lite", "vfe_lite_ahb",
 			   "vfe_lite_csid", "vfe_lite_cphy_rx",
-			   "vfe_lite"},
+			   "vfe_lite", "camnoc_axi"},
 		.clock_rate = {
-			{ 0, 0, 0, 0  },
+			{ 0 },
+			{ 0 },
 			{ 300000000, 400000000, 400000000, 400000000 },
 			{ 400000000, 400000000, 400000000, 400000000 },
 			{ 400000000, 400000000, 400000000, 400000000 },
 			{ 480000000, 600000000, 600000000, 600000000 },
+			{ 400000000 },
 		},
 		.reg = { "vfe_lite3" },
 		.interrupt = { "vfe_lite3" },
@@ -3834,15 +3842,17 @@ static const struct camss_subdev_resourc
 	/* VFE6 (lite) */
 	{
 		.regulators = {},
-		.clock = { "cpas_vfe_lite", "vfe_lite_ahb",
+		.clock = { "cpas_ahb", "cpas_vfe_lite", "vfe_lite_ahb",
 			   "vfe_lite_csid", "vfe_lite_cphy_rx",
-			   "vfe_lite"},
+			   "vfe_lite", "camnoc_axi"},
 		.clock_rate = {
-			{ 0, 0, 0, 0  },
+			{ 0 },
+			{ 0 },
 			{ 300000000, 400000000, 400000000, 400000000 },
 			{ 400000000, 400000000, 400000000, 400000000 },
 			{ 400000000, 400000000, 400000000, 400000000 },
 			{ 480000000, 600000000, 600000000, 600000000 },
+			{ 400000000 },
 		},
 		.reg = { "vfe_lite4" },
 		.interrupt = { "vfe_lite4" },


