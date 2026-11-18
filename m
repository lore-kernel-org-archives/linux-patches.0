Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039668;
	b=eaYOyAyPOFxREqfC/O3eiT0ek3DRFKu5f6Q3+NE2ELunfJ2kwwZqf0TbrpcYdnxJppHV
	 Lo/m4VOrfoC3GCfCmRAiEK2seHUgi1ad9z7R2hZMEnRwgDoJUlRwA5BSZQFYD/gfMwEgt
	 ds7C9Zk6LlPl7qvpIy4uP4sz9IC/2r3O1wwidATF1ewluNXFmdzjfOxg75V1w0gz1Wh9b
	 FPoSOfHuipEDSOZbe0pjx/BK/H/J7E5+hRI25Nq+RSPjw+EOOVrWP/L9Z/8sU/k78Nv4n
	 j8/0MsaOkCE7YpB9f1rYXWRHPc6ul30jQP0nrvvz7bSAZf2IotU4rE7RAH5uZZios8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W7X+u/K8PqDyQ/yLcPMHyDkBk0NAQoN4kADurufij7s=;
	b=rUcYd710PP7061hz+d17n+r5NBUiS/5FrlODEZc2MyiE5qW5Mn7TlfIitRRKIEmnA8Oo
	 icJgjpzc1cb41DxBrUpyND05jsIzkcXyQiHmWpJA/qYn3pRwVP0Bx9XPRPWRBdSQ8RxD6
	 YO5fmHWntjkgu3k/PGLLuEL2ra8qGs6J99kZ6z2Zr60sAUzCSBnoSmHzEz17Va4u6D8W8
	 qdrpbf9Ym8KED3UA3kendVWsiRNl83oMhbkDts5lyRnn0J1QDoKjOjWThC5UE2nOqo5C5
	 vxsb2FDcj/aMTR4maaI8eL9Fn6g08v7pJZIs/YLds9h5y7i/mMvbsbott728x+EljVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECmBo9cV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F19606A320;
	Wed, 18 Nov 2026 22:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECmBo9cV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B931F000CD;
	Wed, 18 Nov 2026 22:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039667;
	bh=W7X+u/K8PqDyQ/yLcPMHyDkBk0NAQoN4kADurufij7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECmBo9cVCgX7BuBdiHAAePuGBeEKFmxsLNrrGEx53RWQmN3OoLIdcyzyDXccXScbX
	 9WSmk3x/fHGDBLx54XbLERYRa50WWwWxO2zkvgWfhKT6WOrRTyjNK+PldwneWrLEbR
	 dHG0SySlM/aEHcNbtZcPv5IejyR32dWiOY+cEkwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2180/3318] ARM: dts: stm32: lxa-tac: change stdout-path baud rate from 9600 to 115200
Date: Wed, 18 Nov 2026 15:46:42 +0100
Message-ID: <20261118150427.365022550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 184b8bb4ebbf6..f7120f891362e 100644
--- a/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp15xc-lxa-tac.dtsi
@@ -25,7 +25,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = &uart4;
+		stdout-path = "serial0:115200n8";
 	};
 
 	led-controller-0 {
-- 
2.53.0



