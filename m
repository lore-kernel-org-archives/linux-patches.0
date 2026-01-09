Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E5C2F12D4;
	Fri,  9 Jan 2026 11:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959536; cv=none; b=CdtkmzswtLNo7CWeNguWh1quf02hD6F8xva0XuNqwMY+ywJUz6tfb2P+dv5UvIooezeSNn2pPQZPg0S3xHSqIXx98/KF3oVRrLBVBhn6Ek+H1XIHZVwX8ckUPvyFR0B0GYK09iej5qHkkt4DIk+mlg2CaPM7KR+6R6pv18KW+bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959536; c=relaxed/simple;
	bh=c7x2+MS7AutTYzzlGOowOSDReKJSihLBU7TPi0t7ex8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mf7tTjXHJ4Fl+eX6PFZbJHD1ArbPZgyy1nmfAKgJsIHh4eFoaRfKewceCRGVLiphwvHq4Ljb36R0FpQgxpZQVuu2wVEJ16le0OlkaBQ5rSNid7/P+6wLuXTgs1Yunr7BkJBPwRb7wNoVFSSwJlEaa44DP11gJ6g4DxENgEUexlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwWD9BS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwWD9BS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3ADC4CEF1;
	Fri,  9 Jan 2026 11:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959536;
	bh=c7x2+MS7AutTYzzlGOowOSDReKJSihLBU7TPi0t7ex8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwWD9BS4TfFQMleePrLyu0dHQ7/cDdtJFGIpYkl3skjjZwd90L1pYkBAgM+4O6dnZ
	 PhNbWuGN0z5AxtwyogNgTF3LfK7OynImjqtALRu7iMbFkFQmsAkXPe/35Iysv3ihq9
	 zlkxZANYc1WQ+ghKQ5OMnQG7V9kIcJxuy7PZGDoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randolph Sapp <rs@ti.com>,
	Michael Walle <mwalle@kernel.org>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/737] arm64: dts: ti: k3-am62p: Fix memory ranges for GPU
Date: Fri,  9 Jan 2026 12:33:46 +0100
Message-ID: <20260109112137.270925249@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dc0a8e94e9ace..0e0241e746fb1 100644
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



