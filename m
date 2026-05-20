Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30081331220;
	Wed, 20 May 2026 18:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300894; cv=none; b=KQCl9TYBcbdC872oFT72CBwnkha1sy4wAGU+v1p5KIuWcVW/I5QIpfnKiPdsU2aStzUUlPYARii/+0jh6FXY3hvkTNZJ9XMu9ymb2DKWktF6n67ma2Ki5wyXay/4b7BtOOByiLzoLxBn/qmWO+gFiSOYxPXqDjgB6B/rUhT/py0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300894; c=relaxed/simple;
	bh=j3eTz9o7G+cbpsDigSRSnImtF0dXnvioZUEq8hbHkbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukTqtdponP1hzNbDK+I/dQoMI5KExyaCY9j1uoiCrj7aNy47oKLiTJnXFqjE0DTbTm7YvUoggTTJFEiVo4Iytz6wIcz6I+rkjdGbxHk4hZyjbx1I9Ettfgo8iubsDcizgCaF84SQjRh1cIhIusDHWEPhQq7VK+uUelCWXeSyx50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5Bv3ZkJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5Bv3ZkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835B81F000E9;
	Wed, 20 May 2026 18:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300893;
	bh=ZETdfsikSd9IChhCksthAvntS5QazxfP/3PBHPotfVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5Bv3ZkJUVmsFKO7KKaj+kHo1MK0Qgq+ewrRI75nTEJoG7gYmds6hWeCte6gvUZuG
	 EdV1wiBJ3/dAzkOTjaVRiQmVAwB9/FNp9D9nU956YlSr5a1rvj9DtMC9wkTYjBBSAw
	 GTQIOEgz+2e8WVeMJZ2txyL3xoVouUg8grfvT9dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/666] arm64: dts: lx2160a: change i2c0 (iic1) pinmux mask to one bit
Date: Wed, 20 May 2026 18:18:28 +0200
Message-ID: <20260520162117.652957402@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 7a3cc49ad1fc8d063abb7f5de8f1b981b99d2978 ]

LX2160A pinmux is done in groups by various length bitfields within
configuration registers.

The first i2c bus (called IIC1 in reference manual) is configured through
field IIC1_PMUX in register RCWSR14 bit 10 which is described in the
reference manual as a single bit, unlike the other i2c buses.

Change the bitmask for the pinmux nodes from 0x7 to 0x1 to ensure only
single bit is modified.

Further change the zero in the same line to hexadecimal format for
consistency.

Align with documentation by avoiding writes to reserved bits. No functional
change, as writing the extra two reserved bits is not known to cause
issues.

Fixes: 8a1365c7bbc1 ("arm64: dts: lx2160a: add pinmux and i2c gpio to support bus recovery")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 97f2ed267d698..e2c32f5b6a521 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1790,11 +1790,11 @@ i2c7_scl_gpio: i2c7-scl-gpio-pins {
 			};
 
 			i2c0_scl: i2c0-scl-pins {
-				pinctrl-single,bits = <0x8 0 (0x7 << 10)>;
+				pinctrl-single,bits = <0x8 0x0 (0x1 << 10)>;
 			};
 
 			i2c0_scl_gpio: i2c0-scl-gpio-pins {
-				pinctrl-single,bits = <0x8 (0x1 << 10) (0x7 << 10)>;
+				pinctrl-single,bits = <0x8 (0x1 << 10) (0x1 << 10)>;
 			};
 		};
 
-- 
2.53.0



