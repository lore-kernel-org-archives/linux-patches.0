Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEAC320CD4;
	Mon, 18 Aug 2025 13:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522873; cv=none; b=VvixhVoRs1XqXHJL1mAvqOj/Y2E4z1AWi46Xqkfa0UNGWSOgbp6aK4VtG9vGySbn50aF32B79LVcojK12Gctj7UTZuOKiiZIjht4eVmr04MB4boaQmIRXHmXh/h2YnLfd5znZ2nQtqXI97c6+K965fRB94YcafWzq8QmJagIQ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522873; c=relaxed/simple;
	bh=yNkNat653nSpSkrmPusKxp3CCqnsACxc0fMQe5z1h54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZciEkCgJL+ov4urihSDkk/mJXX+CNXkt9yhTh1gpbF5XtFsMsLYFq65uqcMnmfQhrSAgO5BWP6/c6uqL0pZJDnNYhFp04Bjqyvdr1Y0SSLhsOoZ3UnNsGBnnjko+MXFAZTNf9OH3ioMMM8+9q1QwXRADSAjtH/f5ve/c47BROQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmYG6K3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmYG6K3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3BDC4CEF1;
	Mon, 18 Aug 2025 13:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522873;
	bh=yNkNat653nSpSkrmPusKxp3CCqnsACxc0fMQe5z1h54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmYG6K3BPZwOSMSPAlp/S/bGGHHQejZBTmePPlxBGYk/Zq5xVXqV0iMbVfNfrViXU
	 G/uTsLY9qKTXW9n4LAX7FdV/YaPlA6KnsUbEXHJsShtfNGEhze6VYyG/0dEP8xQWh0
	 1u4Y4FgxJ4MuWGFKnsx1ZYRKAdx1Bge4Pj3m8OMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hrushikesh Salunke <h-salunke@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 433/444] arm64: dts: ti: k3-j722s-evm: Fix USB2.0_MUX_SEL to select Type-C
Date: Mon, 18 Aug 2025 14:47:39 +0200
Message-ID: <20250818124505.192287798@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hrushikesh Salunke <h-salunke@ti.com>

[ Upstream commit bc8d9e6b5821c40ab5dd3a81e096cb114939de50 ]

J722S SOC has two usb controllers USB0 and USB1. USB0 is brought out on
the EVM as a stacked USB connector which has one Type-A and one Type-C
port. These Type-A and Type-C ports are connected to MUX so only
one of them can be enabled at a time.

Commit under Fixes, tries to enable the USB0 instance of USB to
interface with the Type-C port via the USB hub, by configuring the
USB2.0_MUX_SEL to GPIO_ACTIVE_HIGH. But it is observed on J722S-EVM
that Type-A port is enabled instead of Type-C port.

Fix this by setting USB2.0_MUX_SEL to GPIO_ACTIVE_LOW to enable Type-C
port.

Fixes: 485705df5d5f ("arm64: dts: ti: k3-j722s: Enable PCIe and USB support on J722S-EVM")
Signed-off-by: Hrushikesh Salunke <h-salunke@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20250116125726.2549489-1-h-salunke@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Stable-dep-of: 65ba2a6e77e9 ("arm64: dts: ti: k3-j722s-evm: Fix USB gpio-hog level for Type-C")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
@@ -495,7 +495,7 @@
 		p05-hog {
 			/* P05 - USB2.0_MUX_SEL */
 			gpio-hog;
-			gpios = <5 GPIO_ACTIVE_HIGH>;
+			gpios = <5 GPIO_ACTIVE_LOW>;
 			output-high;
 		};
 


