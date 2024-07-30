Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2497118C914;
	Tue, 30 Jul 2024 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355644; cv=none; b=R+xTm+M3yYVUX1XXro55OzIfDOBU1wRDUvRvL8bg775gBojavO8ODAPR0Fa6VvXHIrL0NtcDofRUyploIIcDBhMv2uhuykBrg5nOlwtZFOnNwxwwYw6ZUZWjE0ERGGk3JylBWLiyfrDZ/AXljw6PP9lae22cgxEd1kje3OzN1qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355644; c=relaxed/simple;
	bh=7xiwqtllw0bR4lxY+97vLiFtRmwHY6V+oPYwX1ItYuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ln8Qs68ijctoEgyx2kfdohov6d4g+2i8YUObhNMvGUlOOYjAlQ8lsYVJzXLliGaXKjKCcmxI09FOVaNwJaSk68m/CHznWl7KFi2uSBq+9vG14L4YysGSnTQCkMAcLhC288CfJt0GwOXlFWCeTuzhCTmAMtwb1Vav75JDbbmO3FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObBiUZVg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObBiUZVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0D7C4AF0A;
	Tue, 30 Jul 2024 16:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355643;
	bh=7xiwqtllw0bR4lxY+97vLiFtRmwHY6V+oPYwX1ItYuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObBiUZVgtZ990N1mYF2tbmUdPIddVakl1zZdDBW0cbzr3GghpgpHrS5RKNB54ta5F
	 zg7lZGQFvEJEmd3or564Fraaxbjt9SkPut4JsU11WJR/w/xO3PBsGCtkspxWtAXUaV
	 fiP3HgL+gbn5Nm6Hzjd7DFgpKcE0UYqWb12Ol3x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/568] arm64: dts: ti: k3-am62-verdin: Drop McASP AFIFOs
Date: Tue, 30 Jul 2024 17:42:45 +0200
Message-ID: <20240730151642.126097544@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d4f8776c9277a..0a5634ca005df 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -1309,8 +1309,6 @@ &mcasp0 {
 	       0 0 0 0
 	>;
 	tdm-slots = <2>;
-	rx-num-evt = <32>;
-	tx-num-evt = <32>;
 	#sound-dai-cells = <0>;
 	status = "disabled";
 };
@@ -1327,8 +1325,6 @@ &mcasp1 {
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



