Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852B7369D67;
	Wed, 20 May 2026 17:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298461; cv=none; b=eVi+LcytTueFEJ2WP7id1ZjEM8sEwwEVv6v8BrZ9z/jakxNbLxOfEJKaiuuIZvXnarI0cUt2iiVC+hRKjEITUeldPma76ps6EQapWOP/hhdHhb3omlZtsR9Y/uF/9o4xvOvTYxbUY1Tw9VTrlqpDuSEWmnKAwxteBYJ6YSvAfNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298461; c=relaxed/simple;
	bh=Nw1eIYD2mcgG9ov9OklBsh5rSKrDKvSzFokIcWepUZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zus7uRitgzp8NAjCbxLVDhwUteHPzdjjVoGRu0iw3NomsI70jf4esPHqpeaECKpxPUAkWvmRpEBFXEMdtE+idIKi/x/ZRtt6vDw+xOMAr6OKdborftjhEbSiZKK3YtUt4A9Ts3VqIsMOvjos5shKlvPc2115hgZRT+3oTV2eO/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8CbVpa7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8CbVpa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14AC1F000E9;
	Wed, 20 May 2026 17:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298460;
	bh=BXKwt5DabE7VERGvGLZ3PVj/XesBTKKRjsym5ykq748=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8CbVpa7/Wdmj75Ay9vUmoh5sZYxTPyWRwG7l3hNFlFa/NDuVDMHWqAXle0Ojxfqj
	 tDzbMm5xO6vmgK9s/9CD33dlbafFbT5jc3AzG80J24DT1a0DA84/BAovHS9bYyKQf4
	 9JIBrcnaKlkh60qOVB+J98yshuT+HPxbZwMpJq+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 419/957] arm64: dts: lx2160a: change i2c0 (iic1) pinmux mask to one bit
Date: Wed, 20 May 2026 18:15:02 +0200
Message-ID: <20260520162143.608660907@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bc1d34f1cd545..79a22f53afc50 100644
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



