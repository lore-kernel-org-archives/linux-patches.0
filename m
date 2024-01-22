Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2B460252;
	Tue, 23 Jan 2024 00:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970867; cv=none; b=iBdotrRAzzViqCAFxkWd75TTmOwIjBmUgpn6/Pg2KUC8pXBeLVlTr30WSTYzyNHlkq1DfRcBlZo/QD8RNMUBtQh5dVDBQgRSvYSdRwOjAhAiusBMLLZwUVk1TpG9YeoeKWSkVVE+WDLDotqkEgQEf/4lwfIknWG6l/HtTFzFYX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970867; c=relaxed/simple;
	bh=s0iS02lcLxIWg5viKAV406hfsJyGeDUcPDeKr6mdGWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7xQEt2Vl3YkPgI14Zgz2SPyHn9X6kHnlzZn38E2H49QVe/VxMtDOaYdQF8/uo7hWRcs++3vgpVtwCNZgDCVHZ/KFtDGWdmf2S/gwIaXghknVWXDKTLCps+hAhJsIDQnxnOpvixWocVjz/ydFSo0+UL96hONdyHWnGediwNSV2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3pgJZv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3pgJZv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919FDC43390;
	Tue, 23 Jan 2024 00:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970867;
	bh=s0iS02lcLxIWg5viKAV406hfsJyGeDUcPDeKr6mdGWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3pgJZv8R5ctkPQIufTV7ZLQsLSSbN2SpDxBe3MyVQ/21wX7lB+oiGSsXjJFf1gHQ
	 pRfiL2IMk9EBK5lr+SB7ji0TbG+Xr/zERn4k3AShIt3HD8bn9h3fpxJu6HrR6vsnrc
	 Sr30SFZfrOJigsPLz2UHpJCwevK/E/64gOzYJxKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/417] arm64: dts: qcom: ipq6018: improve pcie phy pcs reg table
Date: Mon, 22 Jan 2024 15:54:57 -0800
Message-ID: <20240122235756.276620120@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 08f399a818b0eff552b1f23c3171950a58aea78f ]

This is not a fix on its own but more a cleanup. Phy qmp pcie driver
currently have a workaround to handle pcs_misc not declared and add
0x400 offset to the pcs reg if pcs_misc is not declared.

Correctly declare pcs_misc reg and reduce PCS size to the common value
of 0x1f0 as done for every other qmp based pcie phy device.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221103212125.17156-2-ansuelsmth@gmail.com
Stable-dep-of: 5c0dbe8b0584 ("arm64: dts: qcom: ipq6018: fix clock rates for GCC_USB0_MOCK_UTMI_CLK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index d436fa64caad..f3743ef7354f 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -406,7 +406,8 @@ pcie_phy: phy@84000 {
 			pcie_phy0: phy@84200 {
 				reg = <0x0 0x84200 0x0 0x16c>, /* Serdes Tx */
 				      <0x0 0x84400 0x0 0x200>, /* Serdes Rx */
-				      <0x0 0x84800 0x0 0x4f4>; /* PCS: Lane0, COM, PCIE */
+				      <0x0 0x84800 0x0 0x1f0>, /* PCS: Lane0, COM, PCIE */
+				      <0x0 0x84c00 0x0 0xf4>; /* pcs_misc */
 				#phy-cells = <0>;
 
 				clocks = <&gcc GCC_PCIE0_PIPE_CLK>;
-- 
2.43.0



