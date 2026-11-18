Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016109;
	b=SNu87fyC2PwESUEVfn6fZJGWx0H3KGIfAqZ6lQrcaJKWYEZVSnmQ+vPlX8EhZrvipIOg
	 QgqHrtHFCGZk8yRpKiMRTGnuDd3LRwkauhp+K1lR5lu86NxIgRprHT7zp6tDDX1tmUrIE
	 CC9PcODcsyV1VNk6rawQh6LBJFVBlpb3AfH1CERBJ0ZU9/xS6HuN/hxk4WtRlWr+d7Wm6
	 kur8r7/S0bp5cF/dlKPFuLvAdUbMlmtuW14/xh71EVEzl2ttNfaFFIOW4M43TTcXYLH7e
	 dVHEzi1P8fLMO6sDIK6clQV8S99ZbD0RjJX803TSzeyA5i2JJ6NSGVMevlRWuNN8W2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v3XwQR5Fd7F64g3PUI5XUODnakCjfRAdGSrEnEbNkjw=;
	b=JKvlfsPJLvPg4aLpJ0TTS7dFvKhKtTiNR+nN7v365kj9voxAaIR3unr0C3/SYReIGLw1
	 mBBSoGIpks0CZo0m0YaJM+Aml4w4S/385x87lF08iqVQABlemm5yNIejLHtv5o+NLAYMH
	 OJSNShodnlpzcbEd/0yF80xLwUy6MhB4tVynJxRlofCw3GOnt+4EuFvG96F7Qm+thCsTj
	 wgnF1ALDVhI+WjUvkhju45UKV8li16NKGmFE8Ux/rbcRb9hVNQ7ZKYUPmDRoJgu5oQCsU
	 DeX6w8yNv5ZWRFA6g267bZwDzUDnD0au1A7y6LDRUEtsJe4bHGc/xpE5ehm+rsorLJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a5xb7Lnq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555BD606A330;
	Wed, 18 Nov 2026 15:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a5xb7Lnq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0691F000C7;
	Wed, 18 Nov 2026 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016109;
	bh=v3XwQR5Fd7F64g3PUI5XUODnakCjfRAdGSrEnEbNkjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5xb7LnqzshdPQ0s8RF1lnIIWTd0iRm7875C+VLpRPvAb7qO/b4IBFXcXx+TdG5MR
	 ++p75bfRSmLiukmva5YSXSlxAJkmi1ceNTe+oAuKo7RAJiMphBVVWqw4MGkJusNO4M
	 2mTNSI+60fLp/P37gA/10FuEoQMRNiH9iLDHkVCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0411/2651] ARM: dts: stm32: lxa-tac: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:27:31 +0100
Message-ID: <20261118150302.630434921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 85bb59fc12ef439b248d5f4faf846d5566b701fe ]

The default baud rate when none is specified is up to the DT consumer.

In the case of the Linux STM32 serial driver, it defaults to 9600 baud,
which differs from the 115200 baud that this board's barebox bootloader
configured.

This went unnoticed, because barebox automatically fixes up a console=
command-line option that looks like this on the LXA boards:

  console=ttySTM0,115200n8

This had precedence over the 9600 fallback baud rate.

But when EFI booting a kernel via GRUB, we run into this issue, because
the barebox-provided command-line is disregarded by GRUB.

Fix this by explicitly setting the baud rate to the correct 115200.

Fixes: 518272af37b2 ("ARM: dts: stm32: lxa-tac: add Linux Automation GmbH TAC")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20260611-lxa-stdout-path-baudrate-v1-2-59b60a5069ff@pengutronix.de
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi b/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi
index ab13f0c39892f..ddb1657cd7857 100644
--- a/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi
@@ -33,7 +33,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = &uart4;
+		stdout-path = "serial0:115200n8";
 	};
 
 	led-controller-0 {
-- 
2.53.0



