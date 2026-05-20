Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646393A16B6;
	Wed, 20 May 2026 16:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295761; cv=none; b=dEwy8ysIaNF1Zz9GdZhewHnl3KTAnvFsw3Li3pgRp96CAyOxEagKjB+UUzSzM1fvKoZRNy7mEXj1kONb1unXva7yMYnNAbvwHYYEKea1S7FLbEHdu7VEYvr3ZOthW52vI47IzJKXMtOD50HdTWPqJCUr1tFf8IPVveFvCFZRof8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295761; c=relaxed/simple;
	bh=f59W8OQZUhZHq7YzCk7amPfv1Kl1xQhypD6/TyhaNfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzzSsP8BetFUaRtaRFsKTWa6T/X+yPxkb+nk9CbKh8tWj3ZuYLsx6fD3jJ+EIySAxIRy9lmqvM1sZHX063oD/lnaFpJfQZzSR8KtVTOL/9uU9oKqUrkQSHDAJiTR1ym+QgBL6EqHjHCfBPGRLCnx2vSzPBH91OxgAPjZEC55isc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+iOopR5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+iOopR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294021F000E9;
	Wed, 20 May 2026 16:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295758;
	bh=OJ/hmVcmfpj4NjdMRa93iZFfdhTBRfD6bIeE7+unt6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+iOopR5Q8HntJf73JuC5arZw6maXQ1+X9vr3oWeBn0dNkqHTdWkZAsI4GMVSwCd4
	 IpZXo1HOpqJAcnZYWO/Wylh+3A2c59SJppR8a+bgoCypkExqWxmbN4Gi8yeGhZfBBk
	 sii1dVtwgH1Pxh8gDMJVflAo4SHD9iKkMULa4m84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0541/1146] arm64: dts: lx2160a: change i2c0 (iic1) pinmux mask to one bit
Date: Wed, 20 May 2026 18:13:11 +0200
Message-ID: <20260520162200.424546500@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index af74e77efabc5..d5bb55df03216 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -1794,11 +1794,11 @@ i2c7_scl_gpio: i2c7-scl-gpio-pins {
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



