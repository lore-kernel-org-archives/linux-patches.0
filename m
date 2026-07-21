Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DAE397E9A;
	Tue, 21 Jul 2026 17:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653979; cv=none; b=O0WSD2Q2cAz3bhkQtO7fLMR5mRyfbaZ00ElQE8QC0rcaM8x6LxmASMk+pcJuS7Y48M/TkHXHM3je+AJBxZw2Lx83LTtcOBMVw6gubZqNu1rG+HFgmMZRQKofeZDBIwfJen4ROOY7BQKulGpAsXQKiD7/pMXQMNQbxu/+aujUYz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653979; c=relaxed/simple;
	bh=zLcMtxGtte5Eyu7gfhcFRkWtbW2Fjj2RsOAOoOWtnIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKPAiHAXWfUDD0txqTnev6/r1bvan4UlfD0knb9d5rk1gSvaOPD9fukSo/by5nSTDgNPRXEwwvv/ytf6kEMTiOCCeklh/Qs5Q3HJnSPKxfdpPtTfhY2Rd7lGXXzatYPi07/xgaPFvDo6ZvKK8otpR/ijpIiQ94alZT2wP5Gr8WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onyyS9CT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onyyS9CT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A0D1F000E9;
	Tue, 21 Jul 2026 17:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653978;
	bh=xIUZpwv0iFQMN8f+04S1kNlF+ODnQ0XgJmjAom9ctWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onyyS9CTMVsct+92SXIHvHNYMwyrWXWNYJKh+817IE0DC8v1Z4pARUfBMknjLgA68
	 SLP76h3yFRPuSe/G1QLLLpa/PxICCys0/uOSKB4bVa7HFDDSXxIZz6EGKsiu97Sfsi
	 cpW5vM4MibAsrE0aKCPTKh3TJPMPORl6DRBs7hkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 7.1 1532/2077] arm64: dts: s32g3: Fix SWT8 watchdog address
Date: Tue, 21 Jul 2026 17:20:05 +0200
Message-ID: <20260721152628.913382735@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

commit 65210e81f7837a871a17237d15e4b1191d5e8771 upstream.

Add missing hex annotation to fix the SWT8 watchdog address in 'reg'
property, as reported by dtc W=1:

  s32g3.dtsi:863.27-869.5: Warning (simple_bus_reg): /soc@0/watchdog@40500000: simple-bus unit address format error, expected "269fb20"

Lack of hex '0x' meant address would be interpreted as decimal thus
completely different value used as this device MMIO.  If device was
enabled this could lead to corruption of other device address space and
broken boot.

Cc: stable@vger.kernel.org
Fixes: 6db84f042745 ("arm64: dts: s32g3: Add the Software Timer Watchdog (SWT) nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/s32g3.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/s32g3.dtsi
+++ b/arch/arm64/boot/dts/freescale/s32g3.dtsi
@@ -862,7 +862,7 @@
 
 		swt8: watchdog@40500000 {
 			compatible = "nxp,s32g3-swt", "nxp,s32g2-swt";
-			reg = <40500000 0x1000>;
+			reg = <0x40500000 0x1000>;
 			clocks = <&clks 0x3a>, <&clks 0x3b>, <&clks 0x3b>;
 			clock-names = "counter", "module", "register";
 			status = "disabled";


