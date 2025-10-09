Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FA22FB620;
	Thu,  9 Oct 2025 15:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025593; cv=none; b=bjyILI8DgeBSrqzjnAB54nrL64iSYiMEAn2iZ6yFFQydEPN7AZwJlZKu6dN42rPfSrlOhCBK3AmklBEVdxPobNwPIVVQXnPp7aimgxfIw48FrwLyYCZcRvRpIabx5ZWF/dp7NSawwMx4dygSRy+2QSuN/XRWZtR5VA3FG9H7Tp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025593; c=relaxed/simple;
	bh=cFghnHm6DMl6Pt9AEUG5rzDt7SAd9usE0hg1RbT6xsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=loiQ8NNCh9TA9Tb8pcsdWUmQh/Vwn2GsaQe1ULVUcNILQsV06RfYWe3dfQIo/C5sFaq167C+SOCbdjEvLwnk2baKuzeEY5Unw20zQWGx3ffRZg1n0JT184gDFyb6V2z14fR9J5biZ41/iwWBEpf1jVsdvswjUj3Q35cacS/KhfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bgTLqmg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bgTLqmg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01171C4CEE7;
	Thu,  9 Oct 2025 15:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025593;
	bh=cFghnHm6DMl6Pt9AEUG5rzDt7SAd9usE0hg1RbT6xsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgTLqmg92rhSvMwukpAle3dvfpyxp7x6x1BAZXxo5TO2PMrm1w+k7Ycn3m3i3/fH3
	 EyEwoqzXCXt1JHSI9WdhgJIcn7v2MnjUgm3gbASCfozb2SnowohWCoP9mnXQ2KPZVg
	 7bqUPg+Q01mjXjK24lT9aCV0+jrxfEl1g7scWwZoivlb1jFIjSMcMPRz38pd8zdTAd
	 S163rJIua8xk7VvAwc7q3csbHfR1KAO/BacT4Rge0W4ZqmRhKRD1bsJIU/KYy7p2mI
	 NMBwbcih2U0y0Yf8LglzFN5YKBJ065SYNRk2ZZPHK8k0bax8PcqRqjaUH0w7XFUBE7
	 er28DpYTk7sfw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.6] arm64: zynqmp: Revert usb node drive strength and slew rate for zcu106
Date: Thu,  9 Oct 2025 11:55:29 -0400
Message-ID: <20251009155752.773732-63-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES – this revert should go to stable because it undoes a regression
that breaks USB enumeration on real hardware.

- Regression context: the offending change (`arm64: zynqmp: Fix usb node
  drive strength and slew rate`, commit f8673fd570025) landed in v6.6
  and later; it forces the USB0 TX pins on zcu106 to `drive-strength =
  <4>`/`slew-rate = <SLEW_RATE_SLOW>`, and several boards stop
  enumerating basic USB HID devices as a result (confirmed in the linked
  report).
- Fix details: the new commit restores the TX pin mux entry to the
  previous working values (`drive-strength = <12>`, `slew-rate =
  <SLEW_RATE_FAST>` in `arch/arm64/boot/dts/xilinx/zynqmp-
  zcu106-revA.dts:811`), while leaving the RX pins unchanged, which
  matches the configuration that shipped (and worked) before
  f8673fd570025.
- Scope and risk: the patch is a board-specific device-tree tweak; no
  drivers or shared subsystems are touched, so the blast radius is
  contained to zcu106 USB0, making the change low risk and
  straightforward to backport.
- Stable criteria: it fixes a user-visible regression (USB devices fail
  to enumerate) without introducing new features or architectural
  changes, so it fits the stable rules and should be applied to all
  branches that picked up the offending commit (v6.6+).

 arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts b/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
index 7beedd730f940..9dd63cc384e6e 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dts
@@ -808,8 +808,8 @@ conf-tx {
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

