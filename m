Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017064;
	b=q4Qo/XBNe/JZjgidoL3/lyhPfjXoLkV+ta2K71BY/GZ1He9NXpoFT+V0OqVESkMmybKU
	 RVheTS8JXhx9xy+A4HHLCQG0+QbirUy6ewB1CILGd9b9vPbAR7HBZLKM7Zzw9zZyX+L9T
	 sLlyJn4pI9ZCKLLjY3Vk3merwpj3nKB6KjoTU8d3VTOnhCVkmm7GUgGm1US0HfAl+1rfp
	 M1Yqq8/mwVIThuiy1ePcRRHtgNueOcjTjx1K3DM2IJUXzJdkKfOzRZRlBn2kR7CHLHLMw
	 82nHFS+x2BGMaiEQuGxqnb/YVUrw0olldGK9HUKS3YAlSVeKw0anoiCBAOAGs+yMaVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=anABYb2MdivIWjd9blLQVYXaCeWvNDV0MQaN0Pls1jM=;
	b=SeBFoaNqugP+u7vO/iWwssyOFzrBBOMdGvc8vlc7NV4anPQs7LoiYcKrVezU34GtlE9Z
	 C5r1FmVASCBwBhGw4+/NVmsepmL0RePMvtBO8olGlNB2nfITVZvKGayL/dP9O05/W0WE7
	 h3zw74NhHl7pw66Q68ebkycTmh44xtRT6LEzTZylLu/ARjPA3AoqZ48m90V55qMpxsWV8
	 D6F7EhBQX8snyb4jQMEaie/7UUvTtK4SAqfADsDatCZq/opQyhW/BeY1Ts8RApvbAfD+R
	 cABevwIwmVc2PzMmIsz42eQKWQRjNTFkcAMkuhw2YwHfxbjfhl6Cy3f00I01wtsnckQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5NhNrsc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32CD606A32A;
	Wed, 18 Nov 2026 15:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5NhNrsc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EEF1F000C6;
	Wed, 18 Nov 2026 15:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017063;
	bh=anABYb2MdivIWjd9blLQVYXaCeWvNDV0MQaN0Pls1jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v5NhNrscpAd3hwqIVuFEgXscTsVy5ihfup+x6RmFvkuZ1AfmrVuMtGmlk+cIJB9Gw
	 Wd7eP3dhnjrqvYBxQSSu4MAYGjHGsMcq1QKk/xTsMHu5Ly2OFFgeyjq3+R+Kf+ozOd
	 y2DdSj7Mz8OOfL0G+h/Zw8p69tPbwiKhfl58Wn5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0752/2651] clk: qcom: nwgcc-nord: Add video axi clock resets for Nord
Date: Wed, 18 Nov 2026 15:33:12 +0100
Message-ID: <20261118150314.951133582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 6f85eaa506e4b733d9537be85f99f1b14b10727f ]

The global clock controller video axi reset clocks are required by
the video SW driver to assert and deassert the clock resets during
their power down sequence. Hence add these clock resets.

Fixes: a4f780cd5c7a ("clk: qcom: gcc: Add multiple global clock controller driver for Nord SoC")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260801-nord_videocc_camcc-v2-2-674d7718e41f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/nwgcc-nord.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/nwgcc-nord.c b/drivers/clk/qcom/nwgcc-nord.c
index e061c0623e9a4..280558f15748c 100644
--- a/drivers/clk/qcom/nwgcc-nord.c
+++ b/drivers/clk/qcom/nwgcc-nord.c
@@ -623,6 +623,9 @@ static const struct qcom_reset_map nw_gcc_nord_resets[] = {
 	[NW_GCC_GPU_2_BCR] = { 0x24000 },
 	[NW_GCC_GPU_BCR] = { 0x23000 },
 	[NW_GCC_VIDEO_BCR] = { 0x1a000 },
+	[NW_GCC_VIDEO_AXI0_CLK_ARES] = { 0x1a008, 2 },
+	[NW_GCC_VIDEO_AXI0C_CLK_ARES] = { 0x1a01c, 2 },
+	[NW_GCC_VIDEO_AXI1_CLK_ARES] = { 0x1a030, 2 },
 };
 
 static const u32 nw_gcc_nord_critical_cbcrs[] = {
-- 
2.53.0



