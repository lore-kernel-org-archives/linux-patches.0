Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050813659E6;
	Tue,  6 Jan 2026 17:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722034; cv=none; b=HrhKne6ssilCs2yZggkGcoGl1SpLaswg0nu46kVwC2RKt+J3nAvDmdozjLzk+FZUwjpYoam0gnqDPUe3IxmYfXnRKDc/E4ZEz5X/gN40hV/VTcKAMauxLjSlsfl61HNjbF+v9YWnAp1kcjQ01epwz0lq6/p2P+mgJrRhLX5Ls4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722034; c=relaxed/simple;
	bh=AuAjIe6QO8Wsj0NZuKcyEJ7As7CEOu7GhsHT45QDs+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkMFOYSACgkl5x5k3Xv+KniPHtzzQiLcXTGtgN2HO1Pms3qWOJo6x7ZqNpr50ZCu7D6EswkU8pIdqV4Yctf4wGklpVpKAt9ePEAiWnOBuCj8UEGMvytB0q/pkV5qCnj6vPl9S9xfEUTcFu9XjfHnpxzZaEL2cGdoPkKuNvGR3Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFRl1Zuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFRl1Zuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BA2C116C6;
	Tue,  6 Jan 2026 17:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722033;
	bh=AuAjIe6QO8Wsj0NZuKcyEJ7As7CEOu7GhsHT45QDs+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFRl1ZuzhT/ce+NMnUw/Zd612v7N3keS1O5z6WwCq5ktyNFu14LgR59CMk1KRmkn+
	 JH5tf86nXL6RPNbrNojxp7bmJvZi+SJe6az3ndBYyxvXJfFhN/ffvEhQ4phYU2+1kT
	 6ypHYN31jtImDA2vqbQ0tsxb7jeparVr7IsbNCfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paresh Bhagat <p-bhagat@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.18 145/312] arm64: dts: ti: k3-am62d2-evm: Fix PMIC padconfig
Date: Tue,  6 Jan 2026 18:03:39 +0100
Message-ID: <20260106170553.087178858@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Paresh Bhagat <p-bhagat@ti.com>

commit 394b02210a81c06c4cb879d65ba83d0f1c468c84 upstream.

Fix the PMIC padconfig for AM62D. PMIC's INT pin is connected to the
SoC's EXTINTn input.

Reference Docs
Datasheet - https://www.ti.com/lit/ug/sprujd4/sprujd4.pdf
Schematics - https://www.ti.com/lit/zip/sprcal5

Fixes: 1544bca2f188e ("arm64: dts: ti: Add support for AM62D2-EVM")
Cc: stable@vger.kernel.org
Signed-off-by: Paresh Bhagat <p-bhagat@ti.com>
Link: https://patch.msgid.link/20251028213645.437957-2-p-bhagat@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62d2-evm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts b/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts
index d202484eec3f..9a74df221f2a 100644
--- a/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts
@@ -201,7 +201,7 @@
 
 	pmic_irq_pins_default: pmic-irq-default-pins {
 		pinctrl-single,pins = <
-			AM62DX_MCU_IOPAD(0x000, PIN_INPUT, 7) /* (E11) MCU_GPIO0_0 */
+			AM62DX_IOPAD(0x01f4, PIN_INPUT, 7) /* (F17) EXTINTn.GPIO1_31 */
 		>;
 	};
 
-- 
2.52.0



