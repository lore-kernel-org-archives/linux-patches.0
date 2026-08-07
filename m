Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDD74B0480;
	Fri,  7 Aug 2026 15:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115700; cv=none; b=qb9BFOuNoiKOSB/N0GwmjQ9DYU4XwaVOnhgmWX5EN+L8BnL2Qr1mHQV3JPxCfL+BGg2QdH3E/ONjcVYrf8QTy2L9nYkJ9j+yV9IVL0BoEYLSSWScgq85Zu+wpggJPf7XKtGuPyPhf0CxYfe/nIx8KhIDrOM2d1lAXfdATJLAOdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115700; c=relaxed/simple;
	bh=so0rZk2z9URfLTmG1sTPqhArcoIRhwuG1abKzIqmjos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6z1AIH+/GZescIrzuvlLQb1h/vXgRiW3lLGSe6p3AQai7s8lyiP8/14c3R/qoTIAIlgvu0z2L6BIlb997Sz6otq128Fg8boMld/5iENxoZS4ywYI/FChWxThHin2Ci0HFA3A9p9Ou4LhLtf56zMbyt1CBD5WTks5xeGfNA7tTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afnEM1GZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afnEM1GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F371F000E9;
	Fri,  7 Aug 2026 15:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115698;
	bh=gfUjS1be7r67L8CGVXqKtAoHHJp2Mx+Z2M7zgEz82E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afnEM1GZ4rpoSFav/1ZnpSFgAB4THKj5hj1nM4P2ZgJh68WxtySjnOQme6xZeqX1Y
	 Sg7yY0utFfJkTRCO3/4/U0i8aVSuhugqCAZF+m5hPtaZHmnuEGru5VX608pxm+YYzy
	 Rp4O+R1zHl5JoVjYTi/Mvq/FfJdT2DiHl5lJqf9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 367/396] media: qcom: camss: csid-340: Fix unused variables
Date: Fri,  7 Aug 2026 16:38:47 +0200
Message-ID: <20260807143432.195857602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 0b61ce8dc4a71ea7baa19275c655677c612dde6d ]

The CSID driver has some unused variables and function parameters
that are no longer needed (due to refactoring). Clean up those
unused elements:

- Remove the `vc` parameter from `__csid_configure_rx()`.
- Drop the unused `lane_cnt` variable.
- Adjust call to `__csid_configure_rx()` accordingly.

Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: cc1c35619c98 ("media: qcom: camss: Fix RDI streaming for CSID 340")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss-csid-340.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/media/platform/qcom/camss/camss-csid-340.c
+++ b/drivers/media/platform/qcom/camss/camss-csid-340.c
@@ -55,8 +55,7 @@
 #define CSID_RDI_CTRL_HALT_AT_FRAME_BOUNDARY		0
 #define CSID_RDI_CTRL_RESUME_AT_FRAME_BOUNDARY		1
 
-static void __csid_configure_rx(struct csid_device *csid,
-				struct csid_phy_config *phy, int vc)
+static void __csid_configure_rx(struct csid_device *csid, struct csid_phy_config *phy)
 {
 	u32 val;
 
@@ -81,13 +80,9 @@ static void __csid_configure_rdi_stream(
 	const struct csid_format_info *format = csid_get_fmt_entry(csid->res->formats->formats,
 								   csid->res->formats->nformats,
 								   input_format->code);
-	u8 lane_cnt = csid->phy.lane_cnt;
 	u8 dt_id;
 	u32 val;
 
-	if (!lane_cnt)
-		lane_cnt = 4;
-
 	/*
 	 * DT_ID is a two bit bitfield that is concatenated with
 	 * the four least significant bits of the five bit VC
@@ -120,10 +115,11 @@ static void csid_configure_stream(struct
 {
 	int i;
 
+	__csid_configure_rx(csid, &csid->phy);
+
 	for (i = 0; i < MSM_CSID_MAX_SRC_STREAMS; i++) {
 		if (csid->phy.en_vc & BIT(i)) {
 			__csid_configure_rdi_stream(csid, enable, i);
-			__csid_configure_rx(csid, &csid->phy, i);
 			__csid_ctrl_rdi(csid, enable, i);
 		}
 	}


