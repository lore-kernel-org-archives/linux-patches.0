Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDE5248BA1;
	Wed, 15 Jan 2025 10:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937782; cv=none; b=q68DA2NaLuo+/dNNZrdLb8fYbRbwD/dPxvLPnjAk2r29/6RUYhH8vjO+1NOkYEvkpNHbUe5SFB1VdXD8p2bIMBukV3gg99wTDASezOVlajxevwPn0SJZuJDILJLHQwFM+C64/EdSDvwgjVCnfeXV8K45U8r9rLWo94NyFh+pY+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937782; c=relaxed/simple;
	bh=pWV666QUqtXahZWZ90MK3NoTZYtHy7H8X4ug/xCXUQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAAdpoJXUPdI99VmXBpIKHKxVMlMgGKC0c+tdE5VoCItDYw6ut/u0ZrfuhcBpfVjsRvG9cCF4bba3AFG/seFlugKD5jZcKB490HCKCqwGY0Fob2mpVrkSgBoQXb/SbfQNGw0hI3JOOmVAdno4HeQKm0TZRsHhQHj42uexcQnIDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KucBWZuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KucBWZuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8420C4CEE2;
	Wed, 15 Jan 2025 10:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937782;
	bh=pWV666QUqtXahZWZ90MK3NoTZYtHy7H8X4ug/xCXUQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KucBWZuWZqb7Y0OzMJ7vtZKbDyzjFe/nLgvS7vnMvwmeTH1tDz/h77a3iKUhQGEDl
	 3cVvN16AuPf1tGOHyqyRxMuwUpeaYGy+xUKBHUOuCXCzxefin1o08PAB3r65t5tif8
	 4YFBi58scOnSUhmM/2hLcw2ymgG/FMq2ihLkvEoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Taube <Mr.Bossman075@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 80/92] ARM: dts: imxrt1050: Fix clocks for mmc
Date: Wed, 15 Jan 2025 11:37:38 +0100
Message-ID: <20250115103550.760581053@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Taube <Mr.Bossman075@gmail.com>

[ Upstream commit 5f122030061db3e5d2bddd9cf5c583deaa6c54ff ]

One of the usdhc1 controller's clocks should be IMXRT1050_CLK_AHB_PODF not
IMXRT1050_CLK_OSC.

Fixes: 1c4f01be3490 ("ARM: dts: imx: Add i.MXRT1050-EVK support")
Signed-off-by: Jesse Taube <Mr.Bossman075@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imxrt1050.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imxrt1050.dtsi b/arch/arm/boot/dts/imxrt1050.dtsi
index 03e6a858a7be..a25eae9bd38a 100644
--- a/arch/arm/boot/dts/imxrt1050.dtsi
+++ b/arch/arm/boot/dts/imxrt1050.dtsi
@@ -87,7 +87,7 @@
 			reg = <0x402c0000 0x4000>;
 			interrupts = <110>;
 			clocks = <&clks IMXRT1050_CLK_IPG_PDOF>,
-				<&clks IMXRT1050_CLK_OSC>,
+				<&clks IMXRT1050_CLK_AHB_PODF>,
 				<&clks IMXRT1050_CLK_USDHC1>;
 			clock-names = "ipg", "ahb", "per";
 			bus-width = <4>;
-- 
2.39.5



