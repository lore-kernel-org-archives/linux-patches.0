Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3824A34BA57;
	Tue, 16 Dec 2025 11:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885279; cv=none; b=X4zQIUP+FqxUdorwzOWlNI21D2MubQ6KXBB6QOKoZJr2fQ8GSaQZEHtJvNf3HaKN874euh8vNIVDyi7fr7rhtquBjXvpPWke86/f0zSUFHjISjmKigFxPGLzz01WsF0ZHqG77oCwhd8+Mi/WNuAP7oFZ+kseIsV2dj2JjVG8dyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885279; c=relaxed/simple;
	bh=Zz1kz3c00i7KdDhiIRw2d/YdLyxDsliubiQDtt0UwYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnDzzoCvLp5wO82pJCb2gh3VZO8AgkFNlgtaMwD43dNqgT6a1iidAXaRy/suZp8fbm9sfFoJciMliTmOYZcIh/YegCwdAzG3d1snMy21OzwMc6Re8y8JNtYmpG82vGjp6kNt0R214OXP3VFxszZxENmHPHEWO48gWqzZAoR9TWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rf9T1i1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rf9T1i1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E09DC4CEF1;
	Tue, 16 Dec 2025 11:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885279;
	bh=Zz1kz3c00i7KdDhiIRw2d/YdLyxDsliubiQDtt0UwYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rf9T1i1mhYmYaHtHchM1QAdYtOXC/57jI4uirxJmyEDS5vl55L6ZKipGZDHf0q+OG
	 frV+AQn/1WXOVwOwveuJKTNgFVaF2grRfsbThEPRCjnl+9BYVFMmgZTh9WpPB2v7w5
	 vAQqMezK7BpE04GazxwAlZMmwkQHd21kCHjj860A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randolph Sapp <rs@ti.com>,
	Michael Walle <mwalle@kernel.org>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 090/507] arm64: dts: ti: k3-am62p: Fix memory ranges for GPU
Date: Tue, 16 Dec 2025 12:08:51 +0100
Message-ID: <20251216111348.800151557@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



