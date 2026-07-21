Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFEB46C4B5;
	Tue, 21 Jul 2026 15:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648514; cv=none; b=HbUxs87pL0LWhvLHkOzXVceZ/5OIHrLpUlhibPV0dIn8KsYoRg+W6I5duT0mh6FK/WV70kYKB1UavZ4LHyNURlUmlXCzGwPWsNY8C+//DGM6hEIN7jJAXdBCYpjXNzQfkd/6WXxdp14WY6LPdcpk9mQmOpW75OA8dLuJ68c4AFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648514; c=relaxed/simple;
	bh=ALUc8nArd9iKcCn7MLUAXjpeUTP8x/2fO/9BE/ySsrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJ+rBPEDEigK8qmQwbyMQIpBzpxZe/vPKyN1SazUSPcDdBUn8uiE1FDgUjnl/ed5ZdD8OeBN64Z8ntj7fMfBfWQ4fDNqHV9idnligDYyX7cEUyfDG1Q1YJmfNzZMl8C0p0ocPZf424SYZR+vXKUd9CPEVRgSNXxheLrEu3MdUjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iNs9EL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iNs9EL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FDF1F000E9;
	Tue, 21 Jul 2026 15:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648513;
	bh=9l5EIdHjLGkssJOy8pzFtN5xGI//2LSif/k/X6SDNd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iNs9EL9cSl8wBdXW4rwFw5qvnWY1LukgVbZpKtvUBrEYI1ctRNNDYFPfiBPaC4Xw
	 tk+dgeHpDcN6f03JYmqBxTxsDjOYrOuvQyNRELlrmdoEZr6ckGOWO+bVJXYi59Hu13
	 BSX7zAyeeexR+FMat5de21yTzRwl0eEiKQs6sXN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0175/2077] dts: riscv: spacemit: correct 32k clock frequency
Date: Tue, 21 Jul 2026 16:57:28 +0200
Message-ID: <20260721152556.811566700@linuxfoundation.org>
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

[ Upstream commit 3c350f6284d8ea5e7a9648241b2e9604f2262d42 ]

The 32k oscillator's clock frequency is actually 32768Hz, so correct it.

Fixes: 67072c8cd48c ("riscv: dts: spacemit: k3: add clock tree")
Fixes: a6fafa64b03a ("riscv: dts: spacemit: Add clock tree for SpacemiT K1")
Link: https://patch.msgid.link/20260428-06-k3-clk-osc32k-v1-1-e2378da7cb9b@kernel.org
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k1.dtsi | 2 +-
 arch/riscv/boot/dts/spacemit/k3.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1.dtsi b/arch/riscv/boot/dts/spacemit/k1.dtsi
index f0bad6855c970a..b0b9c19b56a091 100644
--- a/arch/riscv/boot/dts/spacemit/k1.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k1.dtsi
@@ -333,7 +333,7 @@ vctcxo_3m: clock-3m {
 
 		osc_32k: clock-32k {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32768>;
 			clock-output-names = "osc_32k";
 			#clock-cells = <0>;
 		};
diff --git a/arch/riscv/boot/dts/spacemit/k3.dtsi b/arch/riscv/boot/dts/spacemit/k3.dtsi
index 815debd16409be..e6faf8d8759e1f 100644
--- a/arch/riscv/boot/dts/spacemit/k3.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3.dtsi
@@ -424,7 +424,7 @@ vctcxo_3m: clock-3m {
 
 		osc_32k: clock-32k {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32768>;
 			clock-output-names = "osc_32k";
 			#clock-cells = <0>;
 		};
-- 
2.53.0



