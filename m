Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C052FF178;
	Wed, 28 Jan 2026 15:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615503; cv=none; b=Q9IE2BnVuv9lqh1KyGGJiu/yt6i6zlZd384kNFpDb5rj8XQFyRb37YxXyVs2RsydeBalRPBwtr4oIp7pgsoldKpPDZSIol9m/pWJPaivwdQx3mshGZigu3d7RVlxWOqN1nEU6s9zkL8v3PdHpp8Gx7nZeHSJqOrcrObsxdsEO2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615503; c=relaxed/simple;
	bh=x6RYcWQhKVz8yJBz15Da9dglPhp6TKpZImlKi+OanfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUKwaWsrHtgur/HX4rWEB0nYjw4na78WfgUDEJz6X7gn2QtGkLyW55NMqZ+t+bfaHU8KD5ZF6ZPvFPlq/WHsw2oqzfhojWV/svvokfq1P7T24+2W/3uQ1JqYz0DffMVgZBWc0xicY5rL6Qvy4ioEpTIrCc6BnV86bsDCZRhICfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBoQcHyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBoQcHyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CB5C4CEF1;
	Wed, 28 Jan 2026 15:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615502;
	bh=x6RYcWQhKVz8yJBz15Da9dglPhp6TKpZImlKi+OanfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBoQcHyWM0eb+UKRxzRvZOe27vzPruq8I/1vSaJdnI4fhDhBAxgANjwBZBRlSZNkx
	 rFwfxnHNFGRHJfbB+Y00LmROlz8jPD0dK6GvGrTG3atcXwLjQ/JisP3ch7tzoOmhSJ
	 4/hBnZ7AykprP1wF/alhhg2UmwV3+9dWZQIE8+yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaoyi Chen <chaoyi.chen@rock-chips.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/227] arm64: dts: rockchip: Fix wrong register range of rk3576 gpu
Date: Wed, 28 Jan 2026 16:20:49 +0100
Message-ID: <20260128145344.496020058@linuxfoundation.org>
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

From: Chaoyi Chen <chaoyi.chen@rock-chips.com>

[ Upstream commit 955b263c421c6fe5075369c52199f278289ec8c4 ]

According to RK3576 TRM part1 Table 1-1 Address Mapping, the size of
the GPU registers is 128 KB.

The current mapping incorrectly includes the addresses of multiple
following IP like the eInk interface at 0x27900000. This has not
been detected by the DT tooling as none of the extra mapped IP is
described in the upstream RK3576 DT so far.

Fixes: 57b1ce903966 ("arm64: dts: rockchip: Add rk3576 SoC base DT")
Signed-off-by: Chaoyi Chen <chaoyi.chen@rock-chips.com>
Reviewed-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://patch.msgid.link/20260106071513.209-1-kernel@airkyi.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3576.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576.dtsi b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
index a86fc6b4e8c45..c72343e7a0456 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -1261,7 +1261,7 @@ power-domain@RK3576_PD_VO1 {
 
 		gpu: gpu@27800000 {
 			compatible = "rockchip,rk3576-mali", "arm,mali-bifrost";
-			reg = <0x0 0x27800000 0x0 0x200000>;
+			reg = <0x0 0x27800000 0x0 0x20000>;
 			assigned-clocks = <&scmi_clk SCMI_CLK_GPU>;
 			assigned-clock-rates = <198000000>;
 			clocks = <&cru CLK_GPU>;
-- 
2.51.0



