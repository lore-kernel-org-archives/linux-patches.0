Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0497D3F9D2;
	Fri, 21 Nov 2025 13:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732325; cv=none; b=Sh6w6evhUJZscTrjEdym5joMYOJl4iCN5Oe4OnkCwJumCuBpro9L6vIrxs2NGz+CwxmDs9HYi9EvYlpc7ufa3Nu5GGuKXUngHowveVH3TQDoF5wSJRIi4cMPhJXTYBot8RlnPTe5uCnFQ/e43rDARNFaHH4zv6//cPyKTyaimdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732325; c=relaxed/simple;
	bh=AZT45wirM5hcViiwwT+TmlEGGsKPWv4OkECXQrIh4AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqotPg7uZVKOg7wJXUNtIpQ+m1993xnsGEvH+clHkHWnkLWH+4xW5RvlX4qGYC1TzEwJ1WxBkl4H96kllZMtkq/96Z5k3luOcHzfmNjMasS3rq6y528ZJvL3sVmP7s8ujs28ekM3O2OURyH5LklYa5beTDFc3XVypuOV5rquOjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05CoWyQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05CoWyQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43967C4CEF1;
	Fri, 21 Nov 2025 13:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732324;
	bh=AZT45wirM5hcViiwwT+TmlEGGsKPWv4OkECXQrIh4AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=05CoWyQmhEdYwylMX4fQtYcyawQNysDluX8i2sZ8MxwDQQCBUVTHe3lhFv80Iuc9j
	 bRVP04ss8lypySQbuAQaFbVJMyriLd/vHiQxRTk7e5bSJoENroQ2KSIISetjAp0yvz
	 qn2RG6NQRU19u9ahOdCxhM1Jf7uRInm2Odf1sXL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/529] arm64: zynqmp: Revert usb node drive strength and slew rate for zcu106
Date: Fri, 21 Nov 2025 14:06:20 +0100
Message-ID: <20251121130233.904045578@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit 767ecf9da7b31e5c0c22c273001cb2784705fe8c ]

On a few zcu106 boards USB devices (Dell MS116 USB Optical Mouse, Dell USB
Entry Keyboard) are not enumerated on linux boot due to commit
'b8745e7eb488 ("arm64: zynqmp: Fix usb node drive strength and slew
rate")'.

To fix it as a workaround revert to working version and then investigate
at board level why drive strength from 12mA to 4mA and slew from fast to
slow is not working.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/85a70cb014ec1f07972fccb60b875596eeaa6b5c.1756799774.git.michal.simek@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts b/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
index 50c384aa253e4..8c3f9735e563b 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
@@ -808,8 +808,8 @@
 			pins = "MIO54", "MIO56", "MIO57", "MIO58", "MIO59",
 			       "MIO60", "MIO61", "MIO62", "MIO63";
 			bias-disable;
-			drive-strength = <4>;
-			slew-rate = <SLEW_RATE_SLOW>;
+			drive-strength = <12>;
+			slew-rate = <SLEW_RATE_FAST>;
 		};
 	};
 
-- 
2.51.0



