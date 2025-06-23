Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DD37482;
	Mon, 23 Jun 2025 21:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713653; cv=none; b=uC++CvlhQQf7dZNSvfZSP/zjsgJbgelDq5f/dkptf9CDgg2d/RApx/fY3K9J+oXCeqKqyG4s1KPbjW0hLSI+WSRkGWm4Tq7r5k5Q9+A3YjJnv8J9W+y7o930gD3XSMt9+PLtKF/f7SEav0/387rGdYCSAkIQcj+Fgbz00hVOUIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713653; c=relaxed/simple;
	bh=HOa43t17o11a2EEgwMcCBplLZlfKhvdRppoICNu8EV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nA9AkyfI4/l7yyV0k/k3xooxHBtrOw+D7SLiwEwCuCVndpmqt+RFPIY2X+HLur9wj+/fFYx06vQ2ZAHeNy9aN2DMLc95EjgSloBMv3Ax0RebpGjRSo08pe2xAn2cl/He5cJ8oEYAQCh856maAWpPnbsqo6aphIG+zULA4ztDxws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9cZzZxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9cZzZxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A87FC4CEEA;
	Mon, 23 Jun 2025 21:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713653;
	bh=HOa43t17o11a2EEgwMcCBplLZlfKhvdRppoICNu8EV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9cZzZxRD4Nl/Q3l/EWmRCRibfQYBOkTst6bChOPXD1Gc1NpAV0c1OjJTXk0oS15d
	 Yg0tKGATH2zKUONEy2dDBgnaXwFUwAsILo0Bcp9V0LVqXlKHLNvSIDk9Pmu2myhyjR
	 iY34YtsJMyE1GslnS3CA+2pwilCZhSdJLDEwohFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/508] arm64: dts: qcom: sda660-ifc6560: Fix dt-validate warning
Date: Mon, 23 Jun 2025 15:02:40 +0200
Message-ID: <20250623130648.124623135@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

[ Upstream commit f5110806b41eaa0eb0ab1bf2787876a580c6246c ]

If you remove clocks property, you should remove clock-names, too.
Fixes warning with dtbs check:

 'clocks' is a dependency of 'clock-names'

Fixes: 34279d6e3f32c ("arm64: dts: qcom: sdm660: Add initial Inforce IFC6560 board support")
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250504115120.1432282-4-alexeymin@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts b/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
index 28050bc5f0813..502a3481ba284 100644
--- a/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
+++ b/arch/arm64/boot/dts/qcom/sda660-inforce-ifc6560.dts
@@ -155,6 +155,7 @@
 	 * BAM DMA interconnects support is in place.
 	 */
 	/delete-property/ clocks;
+	/delete-property/ clock-names;
 };
 
 &blsp1_uart2 {
@@ -167,6 +168,7 @@
 	 * BAM DMA interconnects support is in place.
 	 */
 	/delete-property/ clocks;
+	/delete-property/ clock-names;
 };
 
 &blsp2_uart1 {
-- 
2.39.5



