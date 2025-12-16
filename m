Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8896342151;
	Tue, 16 Dec 2025 11:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884146; cv=none; b=RlMDwZiD8fWnQH4chJQfs4sUvNvOtSM60aQnCYrQ/KCWyD8hG/XYOQ8kcfhdPTa7ZVG0OO5W8cmJ9VuN22WPFVd6SsuB7H3ehARcAkPlxnO1LRkC9R7vCtfF3dpivTPO8EPF4lKCMF/NEKaNtn7JGVTXOYvn+okiIhVclfQXvn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884146; c=relaxed/simple;
	bh=QWX9aCT5rl+vCTGk9vXb4A5NE6j/Tj/u1SU+C6gC3mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEluWrwchcdqVbRy+4j5Mn1WOtoad4rxd7P+pRarXZy5LreY5BECvTi5hS4m41aCM4eJCuooPMzuu23DF3B8Q3zPxFWWuAfl+gbkcOcpeGr1WpQKW8lLvLeddGXcap8jf1/794e5HgDxvCxK3N8oZ/s4rwTwiGzi3gi4VWAlzMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCvQv6PE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCvQv6PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39856C4CEF5;
	Tue, 16 Dec 2025 11:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884146;
	bh=QWX9aCT5rl+vCTGk9vXb4A5NE6j/Tj/u1SU+C6gC3mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCvQv6PEkn2oHZIbfTWKMafsFk+Yxbq4xFuHhwQm2X2kRQVD87DgN3uZnc2YeNw8v
	 fphmlWFQ56WsV8nDHhiTvs+kdb/qeCDOi+58P42EZdZ5U0h54RqaX89qYI5ZuqRO/X
	 UeDO/RYAf3rh2yxQAEVKVrgZ9/6GEqIq+ZRwHjTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/354] arm64: dts: qcom: x1e80100: Fix compile warnings for USB HS controller
Date: Tue, 16 Dec 2025 12:10:39 +0100
Message-ID: <20251216111323.533501245@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 0dab10c38282e6ef87ef88efb99d4106cce7ed33 ]

With W=1, the following error comes up:

Warning (graph_child_address): /soc@0/usb@a2f8800/usb@a200000/ports: graph node has single child node 'port@0', #address-cells/#size-cells are not necessary

This could be since the controller is only HS capable and only one port
node is added.

Fixes: 4af46b7bd66f ("arm64: dts: qcom: x1e80100: Add USB nodes")
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251019115630.2222720-1-krishna.kurapati@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 5082ecb32089b..b03f3ce250dbc 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -4287,15 +4287,8 @@ usb_2_dwc3: usb@a200000 {
 
 				dma-coherent;
 
-				ports {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
-					port@0 {
-						reg = <0>;
-
-						usb_2_dwc3_hs: endpoint {
-						};
+				port {
+					usb_2_dwc3_hs: endpoint {
 					};
 				};
 			};
-- 
2.51.0



