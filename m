Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0011A3032;
	Tue, 30 Jul 2024 16:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355738; cv=none; b=CGdfb92KLIij1NrdNWv4euxzCIoWnFA4BtpR59crhyNiZfl2J8OKclJ8kjvKGPLReA4G6UGdr4Ni4ic6AxOrimqKR8fbTU7qy9V1Wlbi1eqnTi83/xsk/Z275WmC4B7GYevQ5s5qwaVsk/lXw35rvA5aOjXTmNRNeWzMdzEbX5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355738; c=relaxed/simple;
	bh=inVasS44b0xVdQNvQDXwjWQ+sbWuafP15MHwWeZTXzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naOuCOl/IbZbyKCR4u5HGzQIrv7oqTwk3siQpuNSeLtTZieoMnNLpAmD86fE7mzHt9tR96A0aXoPE0RB4XCuqdjxdjKLXSj/M2g7jWTem/4u5kA/OzI8RyQydODhiFVL8GT5B0iGEgW4VN//uYkrr2JoW2P5qyl2FpCI1HF7Oac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKkfjvQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKkfjvQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EFFC4AF0C;
	Tue, 30 Jul 2024 16:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355738;
	bh=inVasS44b0xVdQNvQDXwjWQ+sbWuafP15MHwWeZTXzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKkfjvQvctu1gvdIs3C89LYoBnAqHwofNK3fjDzSrIqVU2y4wWYEFyCbnHQAv22k9
	 cVv8QPWUx6szEZ8B9fc7zrjYhB9TY4hpp4mUACSDcPfCN4Kly+W5lbdICcpTu42P1v
	 ZYsEMRgXNMkb9rZwNIUIxOQg5VD1UC3uP69xC69s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 084/809] arm64: dts: ti: k3-am62-verdin: Drop McASP AFIFOs
Date: Tue, 30 Jul 2024 17:39:20 +0200
Message-ID: <20240730151727.956845791@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit fb01352801f08740e9f37cbd71f73866c7044927 ]

McASP AFIFOs are not necessary with UDMA-P/BCDMA as there is buffering
on the DMA IP. Drop these for better audio latency.

Fixes: 316b80246b16 ("arm64: dts: ti: add verdin am62")
Acked-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240606-mcasp_fifo_drop-v2-5-8c317dabdd0a@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
index 2038c5e046390..359f53f3e019b 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -1364,8 +1364,6 @@ &mcasp0 {
 	       0 0 0 0
 	>;
 	tdm-slots = <2>;
-	rx-num-evt = <32>;
-	tx-num-evt = <32>;
 	#sound-dai-cells = <0>;
 	status = "disabled";
 };
@@ -1382,8 +1380,6 @@ &mcasp1 {
 	       0 0 0 0
 	>;
 	tdm-slots = <2>;
-	rx-num-evt = <32>;
-	tx-num-evt = <32>;
 	#sound-dai-cells = <0>;
 	status = "disabled";
 };
-- 
2.43.0



