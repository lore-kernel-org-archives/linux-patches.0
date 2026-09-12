Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646DB36728D;
	Sat, 12 Sep 2026 08:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201825; cv=none; b=swymnOTKcJrUXqsjqRQv374empcCvS/BA0RjIoRIvahBYGhUwIHT394DoKT047ca+OYG8aacq56NckTRoTnyZIRZu2QEcDh14VGtxfm/q7c6hUehqa+ABzXITsBP303r0Y7xb75nULOnBKQb1pisE/NjCa06VdLA9dEkh8ypd7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201825; c=relaxed/simple;
	bh=JUYkwt70HBWXXEwT6YSJzFsgr0OF4cnSut8sbNgf33M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aT4Dst4MRV8sFQ5O7pXB5y6hmnRPRMETQPtXDYMp1lQ9fOmztAmE6nWby1BgDaHL6ke+CBOaqwoE700OJwGWpgFK2epRbzBSfcFeHLsBntPZ7wdZak+c4RwkF1XId9Q/3vitT/nKyXCVWLWULC0MuejE2EbQjAgUR60dMsJxWG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfJG54ol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfJG54ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0401F000FF;
	Sat, 12 Sep 2026 08:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201824;
	bh=O/u4nr481471Dvb2r77eUQi5OaQo11DrDVqMKfMmt6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfJG54ol3CChWFsCMuSWGR2NRj5l9OSn4MyG2q+p59KIwQvHXEEoE7ozKqbyZ9jtw
	 0sFjKZaeBIrPzta5gTZnbCvq98ZYosqvuuMA5NixzOrk5AaX4yvj09Yb8GtEc98SXJ
	 2ZyJRSrS9M+DQ4GJsWcs2PzSpGMtOa8KRm0/J60Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1076/1815] arm64: dts: qcom: sm7225-fairphone-fp4: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:06 +0200
Message-ID: <20260912065714.281944135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit a3b3a060b696d964c769a7d9dc5835c79e4fe964 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHY on this board, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-14-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index 97efa2e0cfc36..ce97e5bddecb1 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -1247,8 +1247,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l22a>;
-	vdda-pll-supply = <&vreg_l16a>;
+	vdda-phy-supply = <&vreg_l16a>;
+	vdda-pll-supply = <&vreg_l22a>;
 
 	status = "okay";
 };
-- 
2.53.0



