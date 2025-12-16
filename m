Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7866056B81;
	Tue, 16 Dec 2025 11:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884140; cv=none; b=AIONIoWIya/zq/6FitO1VbKBb42f1GWIiJBOnyV11bxxGPwFpk4Tgd2QrI36qK3uV7dFYGrmhB7eR/Jv/wPcHTnOMZpn65P4hPIWCy4tLn7hJRyxAtee3vUm5LvwKljTP9kqtd/lNUSkPVB97SrKpqf7aO+qnSgqWC2f6448clk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884140; c=relaxed/simple;
	bh=4xQbo6DPjuqwAsjhUtfYwQzpLVuHHOViAehh1zdLQOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGxvU8a8MDp1cXMgt11u9apG6M4waqzMzR/nJu+qpzw0maXZF21L4Etp5VJ6104uhYkNle5YhGgOavOKOCnd4oLBgaCu/8BG6c1Elq31HhH4/eLMkzbnc4gw4CtaXhunOnXjhUnXBof1fww4PZJynH9UzApmzv6p926Xi7S74EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+fD2RJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+fD2RJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9409C4CEF1;
	Tue, 16 Dec 2025 11:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884140;
	bh=4xQbo6DPjuqwAsjhUtfYwQzpLVuHHOViAehh1zdLQOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+fD2RJ6PJFzs+38/bA7SP71nDTAEP2zRKy3RnJ5guLEMb/Vmw5LRQsQszgF0RHsc
	 A89APG/3UVguVFxhRvnlysw/1t5m/H1vCqSVr6cE0Cfr0yGlExL/oxE7Cdgb867mFs
	 xro+GNaBzW8qNHjVmVYI1EmU+5ykK4Tz4zV9wFvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randolph Sapp <rs@ti.com>,
	Michael Walle <mwalle@kernel.org>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/354] arm64: dts: ti: k3-am62p: Fix memory ranges for GPU
Date: Tue, 16 Dec 2025 12:10:37 +0100
Message-ID: <20251216111323.461822186@linuxfoundation.org>
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

From: Randolph Sapp <rs@ti.com>

[ Upstream commit 76546090b1726118cd6fb3db7159fc2a3fdda8a0 ]

Update the memory region listed in the k3-am62p.dtsi for the BXS-4-64
GPU to match the Main Memory Map described in the TRM [1].

[1] https://www.ti.com/lit/ug/spruj83b/spruj83b.pdf

Fixes: 29075cc09f43 ("arm64: dts: ti: Introduce AM62P5 family of SoCs")
Signed-off-by: Randolph Sapp <rs@ti.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Link: https://patch.msgid.link/20250919193341.707660-2-rs@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p.dtsi b/arch/arm64/boot/dts/ti/k3-am62p.dtsi
index 75a15c368c11b..dd24c40c7965d 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p.dtsi
@@ -59,7 +59,7 @@ cbass_main: bus@f0000 {
 			 <0x00 0x01000000 0x00 0x01000000 0x00 0x01b28400>, /* First peripheral window */
 			 <0x00 0x08000000 0x00 0x08000000 0x00 0x00200000>, /* Main CPSW */
 			 <0x00 0x0e000000 0x00 0x0e000000 0x00 0x01d20000>, /* Second peripheral window */
-			 <0x00 0x0fd00000 0x00 0x0fd00000 0x00 0x00020000>, /* GPU */
+			 <0x00 0x0fd80000 0x00 0x0fd80000 0x00 0x00080000>, /* GPU */
 			 <0x00 0x20000000 0x00 0x20000000 0x00 0x0a008000>, /* Third peripheral window */
 			 <0x00 0x30040000 0x00 0x30040000 0x00 0x00080000>, /* PRUSS-M */
 			 <0x00 0x30101000 0x00 0x30101000 0x00 0x00010100>, /* CSI window */
-- 
2.51.0



