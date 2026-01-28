Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC80928D8DB;
	Wed, 28 Jan 2026 16:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616162; cv=none; b=JRD79IwwKhQzof1tO5k3r6slH3g7oL4bIZciV4sSYhCYQ+c5GCZTn0h4EfDHrYOaX5SAt+yci2A6NnFtqvetvpoV5VBUL1dIcSWxeLXXtN5GHp3VuQ3lVW4xqLhe6ola1gjvA9YvJaACvvsMCljESSyyTGX++GvvR/q8M51mYD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616162; c=relaxed/simple;
	bh=PDqloht/DxhcBHGsuybyF4IAn6y1YHZKeDU4wZXRjW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JY7CyCqGp4q0DyhnDVofg6mPTFYXSlutTvxo9bLjaTQ0ownVMAoIIOG93au/uHcF3uPvVvoPRAtLCwbZ/8eHTVweofrYlNR09/aStb9oyG3kfKnoEuN34j5/TEl+dYnzcNvGurTviSu356H685aJVocp5jQIOb/OsoncyNEQZm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMBIQ62f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMBIQ62f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F742C4CEF1;
	Wed, 28 Jan 2026 16:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616162;
	bh=PDqloht/DxhcBHGsuybyF4IAn6y1YHZKeDU4wZXRjW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMBIQ62fxx6e/8wo9PvGA/NZK9i2vaR33oO5iPoC2F27MM5fZT03nryzH0SENLsl2
	 LIpKJV13CtO8LEUiLjHPBxd7QpZgz1YaiJHIjhP1hsunOFgd+0QwOV8gvHTIT5YqJb
	 Y0vezjEqK6AryK/cBWGzMPADbnkCgrw45Lj+q5sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 224/227] arm64: dts: qcom: talos: Correct UFS clocks ordering
Date: Wed, 28 Jan 2026 16:24:29 +0100
Message-ID: <20260128145352.495743500@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

[ Upstream commit 8bb3754909cde5df4f8c1012bde220b97d8ee3bc ]

The current UFS clocks does not align with their respective names,
causing the ref_clk to be set to an incorrect frequency as below,
which results in command timeouts.

ufshcd-qcom 1d84000.ufshc: invalid ref_clk setting = 300000000

This commit fixes the issue by properly reordering the UFS clocks to
match their names.

Fixes: ea172f61f4fd ("arm64: dts: qcom: qcs615: Fix up UFS clocks")
Cc: stable@vger.kernel.org
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251126131146.16146-1-pradeep.pragallapati@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6150.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm6150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6150.dtsi
@@ -1260,10 +1260,10 @@
 				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
 				 <&gcc GCC_UFS_PHY_AHB_CLK>,
 				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
-				 <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
 				 <&rpmhcc RPMH_CXO_CLK>,
 				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
-				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>;
+				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
+				 <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 			clock-names = "core_clk",
 				      "bus_aggr_clk",
 				      "iface_clk",


