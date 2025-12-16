Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2C934CFC5;
	Tue, 16 Dec 2025 11:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885289; cv=none; b=H74Oqfy6PhIi9XUSwxokVl3AUL6WF7sUCV+kZ+y1xEZagi+Admfh2g93//pYCeE7Gt6WITvarctzdfUdciiGP07f3EH21NbJE52dChzlTBm2GcezzbEWcAyDSfIWDHiFXxhIuPpgYljC5+P+nBDMBfjN7FZ3P71y/u2izZ09iyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885289; c=relaxed/simple;
	bh=CkBbyIeaY7AKjG1sanex3i25U44dgsv/UQCTzV+BHUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKRuBH/TJtedYy9/JykrUt8hp4uhmONobGbIMoHrtefGEohoNnrYqh6jIthvYZSv/NYJXR9d1DhQMzHDPu5/LpD0yXj71UvI8T9NcwTEGrXWrGxPzXwxh8LXETBHZM1dG8/NKYJbok5Ry5nKKhEFhgVekdYgGk1DOT0kxR45OZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vU4WCEUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vU4WCEUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C073C4CEF1;
	Tue, 16 Dec 2025 11:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885288;
	bh=CkBbyIeaY7AKjG1sanex3i25U44dgsv/UQCTzV+BHUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vU4WCEUV0F6tP/fWPqfuKhg0ebq0bX9ec7y4nsSC9k4TO1yKX5yx1yjHVmBFWRTZl
	 ORhS6Q4L0O7Jbp62R7my559W2UcvCrbv+FIsS9eFjhobWZoRqyQalEv7fR/g7nRF9K
	 KmuW/XuU0OifNKNHIq1TABaS8tst/Znq3ycblWTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 093/507] arm64: dts: qcom: x1e80100: Add missing quirk for HS only USB controller
Date: Tue, 16 Dec 2025 12:08:54 +0100
Message-ID: <20251216111348.907522805@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 6b3e8a5d6c88609d9ce93789524f818cca0aa485 ]

The PIPE clock is provided by the USB3 PHY, which is predictably not
connected to the HS-only controller. Add "qcom,select-utmi-as-pipe-clk"
quirk to  HS only USB controller to disable pipe clock requirement.

Fixes: 4af46b7bd66f ("arm64: dts: qcom: x1e80100: Add USB nodes")
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20251024105019.2220832-2-krishna.kurapati@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 2022aebf4889c..67c888ae94de5 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -4859,6 +4859,7 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			interconnect-names = "usb-ddr",
 					     "apps-usb";
 
+			qcom,select-utmi-as-pipe-clk;
 			wakeup-source;
 
 			status = "disabled";
-- 
2.51.0



