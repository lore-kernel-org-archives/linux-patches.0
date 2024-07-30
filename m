Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB9918800D;
	Tue, 30 Jul 2024 16:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355693; cv=none; b=GxjZwzWfCstMjDdsPzhEkoaONP8A6qbxFeVYIh5H507zMGl/Af9lGCaU4tI9hFkETw7605GOQcRAYO3pP9dOAjCu9IS/vtksoawHV9zT8X+4gZ5IPmuHJqSx0fMxb/J7mWd3LPBYyDCg16U0jWiPIXoWb/qiMY+bymInFgAsG8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355693; c=relaxed/simple;
	bh=ZZ+j2lWm2k/FvJCx4qwpyjxqXRFG5H6Bqr8on91sGE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRdY2w5gv51FM4MMxer2iruUy+eIYERQqe7dCWJ6tUIuB+2J3N9IF9gGAPvw10WfdbXZA33JWg/N7LH7nFOLAPAmxdTYxU5W4wA1qx/0QGFj3t+uKQVM3gLUxBQL7ZAN6Qd8AgwF6H/wm2pm/v7IHxry7gZXErlz023J1YGS+xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYGIpy6N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYGIpy6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D69C4AF0C;
	Tue, 30 Jul 2024 16:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355693;
	bh=ZZ+j2lWm2k/FvJCx4qwpyjxqXRFG5H6Bqr8on91sGE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYGIpy6NyUJhOLma6h9ronDjKhkboJj1nuZG1hiaboJpHO30bExvyCUGm2eN+3hQp
	 VKrhwmZWh2CxB/wN3TSeeKJblXPkHeu8bVwxFoL6eTsUeUg169P/4Gmg1PYhkPTwzc
	 v6OopdNkRSIxi/ZC/JMlP8/VdUd+iSXLUlR3p33o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 080/809] arm64: dts: ti: k3-am62x: Drop McASP AFIFOs
Date: Tue, 30 Jul 2024 17:39:16 +0200
Message-ID: <20240730151727.799344565@linuxfoundation.org>
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

[ Upstream commit 6ee3ca0ec7fabc63603afdb3485da04164dc8747 ]

McASP AFIFOs are not necessary with UDMA-P/BCDMA as there is buffering
on the DMA IP. Drop these for better audio latency.

Fixes: b94b43715e91 ("arm64: dts: ti: Enable audio on SK-AM62(-LP)")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240606-mcasp_fifo_drop-v2-1-8c317dabdd0a@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
index 3c45782ab2b78..63b4e88e3a94a 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
@@ -504,8 +504,6 @@ &mcasp1 {
 	       0 0 0 0
 	       0 0 0 0
 	>;
-	tx-num-evt = <32>;
-	rx-num-evt = <32>;
 };
 
 &dss {
-- 
2.43.0



