Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E16335555;
	Tue, 21 Jul 2026 15:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648929; cv=none; b=kuxOLalAa5PtSY/Aps50FOmwTjlFnIsHuW54Yh323xoxPiyyCdBrxSMD00G8wFXWI8F5/XyWr1NdQKjN7jIEkF4kA3xsXwCJ9MQI4iY82FM8dW9SajytvhzZ1fQTAyHZq5aBHagjBVcSulbhV096/EiXXlRDLf1rK7idCwTAIU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648929; c=relaxed/simple;
	bh=Q6fJruOOW9r5xoXXTy991AFoenuBXLhTAsafpqBLciw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8NRudxEfF+rnPdzBUY0J5CcLUlDzwasAUEHskww3//Yry3GEDBiRfBXd07WceED5r+pLvakaTRY8r49ZGEw/pn/gYGfcdlU9lA0E665WA41RmDr2dQo4kX+nESKhoYzT0BZKylzK1MkhGxu/teUKjNVD8tXer6gygBOQ+IJO3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYG24ICr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYG24ICr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B971F000E9;
	Tue, 21 Jul 2026 15:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648928;
	bh=3GtvLfVHzifUfS0WI1699ydGTrvor8pU2T8Z5V+Qk/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYG24ICr34ZMivXmA8PUOZ3+644q29UP0Yjiit6C7vYk31qrUULCKgi4JKWHS2v/d
	 hrxS+SI2P+tRDa/2MWGpFV+cdvK5TjL+SpeWnet5liBYGsSfjIU7Uy5MQbgSG4qkrr
	 ao4FFgwxCjxh49IS4m1yvdDHB4SAQZsnKtUIpZXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0385/2077] dts: riscv: spacemit: k3: Fix I/O power settings
Date: Tue, 21 Jul 2026 17:00:58 +0200
Message-ID: <20260721152601.778561145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yixun Lan <dlan@kernel.org>

[ Upstream commit 3ea695eb111fc5a7ffddd21d5c3fee6d82560413 ]

SpacemiT K3 SoC support dual-voltage I/O power domain, while initially
configure to 3.3v, and need to access register from APBC space to switch
to 1.8v domain.

Fix the GMAC0's I/O pins 1.8v switch failure that will result a broken
ethernet driver.

Fixes: d8944577496b ("riscv: dts: spacemit: k3: add pinctrl support")
Reported-by: Han Gao <gaohan@iscas.ac.cn>
Link: https://patch.msgid.link/20260518-07-dts-pinctrl-io-power-v1-1-abe19c14a726@kernel.org
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/spacemit/k3.dtsi
index e6faf8d8759e1f..719850aa7aac5a 100644
--- a/arch/riscv/boot/dts/spacemit/k3.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
@@ -803,6 +803,7 @@ pinctrl: pinctrl@d401e000 {
 			clocks = <&syscon_apbc CLK_APBC_AIB>,
 				 <&syscon_apbc CLK_APBC_AIB_BUS>;
 			clock-names = "func", "bus";
+			spacemit,apbc = <&syscon_apbc>;
 		};
 
 		uart10: serial@d401f000 {
-- 
2.53.0



