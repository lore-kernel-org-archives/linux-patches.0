Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA5C4195A3;
	Fri,  4 Sep 2026 05:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499489; cv=none; b=M4KmZYAvqoVwUYne0igrH2W6SAohfxp7Jhoi+oTsx85q1ALjDLBEfQlr3Jhvv/wHCGrYz5ckFTwkfGVzSJKLYSLqVbUX3PiV8bP8NiBhp40udh1Imw7zhYxLpdVgLInexhtWPZc0Ct+NMygWz87xlT9cA/vZn2UTJTQ9e8kB7Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499489; c=relaxed/simple;
	bh=a8Gkw4zX6BXleqrO+tGkUTBDR8kUtHfbJ4tEgKp9oEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7Q4ZoDY8BozlhyP1lBVY7wwMyhk+ZmmU+AiUgCWbIQDggdFehP9ehI5X2hOENQQJmq+mgrRsFP2OQBkuX+dQSoUEGTuxqS5NKJPU524VJ9DfKyKPjAT/u0eAUTjj2bo/fIbLZk5Wu+tH0UDNKAglimC/60wWzrMDfeO6D71n18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVjiSkVz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVjiSkVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952A01F00A3D;
	Fri,  4 Sep 2026 05:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499488;
	bh=t++MgmLnduqIO9f9eZA0RxPnWY4izAvXY70BiDRDAwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVjiSkVzcfhRexQlT39dGVGMNsOCkFwmhih0p174VP0SGF15n38KHibOFLiBDfePG
	 rQYHSZnE4jqfxmD53Zj9TaOcda0wm/20AvCfQjoZlZtfNqqh2d+Hwz9yUVszT948zc
	 XRXlbFOWeSDEbSMrzQH4OVzPqLNF7Ix/2wVkoXno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>
Subject: [PATCH 7.2 434/713] riscv: dts: spacemit: k1-orangepi-r2s: fix maximum CPU core voltage
Date: Fri,  4 Sep 2026 06:56:42 +0200
Message-ID: <20260904045813.558734643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

commit d66267c35032c46c18b675601d03c80239bcd913 upstream.

On the OrangePi R2S board, the buck1 and buck2 voltage regulators, which
supply the CPU core voltage, are configured with a maximum output
voltage of 3.45V, while the highest operating point requires only
1.050V. This means that a kernel bug, OPP misconfiguration, or
privileged userspace could request a voltage above the safe operating
limit, causing possible permanent CPU damage.

Set the maximum regulator voltage to 1.050V instead.

Fixes: 793cc54475b4 ("riscv: dts: spacemit: enable PMIC on OrangePi R2S")
Link: https://sashiko.dev/#/message/20260728211020.1248676-2-aurelien%40aurel32.net
Cc: stable@vger.kernel.org
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260729150722.1598630-6-aurelien@aurel32.net
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-orangepi-r2s.dts
@@ -126,14 +126,14 @@
 		regulators {
 			buck1 {
 				regulator-min-microvolt = <500000>;
-				regulator-max-microvolt = <3450000>;
+				regulator-max-microvolt = <1050000>;
 				regulator-ramp-delay = <5000>;
 				regulator-always-on;
 			};
 
 			buck2 {
 				regulator-min-microvolt = <500000>;
-				regulator-max-microvolt = <3450000>;
+				regulator-max-microvolt = <1050000>;
 				regulator-ramp-delay = <5000>;
 				regulator-always-on;
 			};


