Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6980C2BF019;
	Tue, 26 Aug 2025 13:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215786; cv=none; b=WP2JTWGiFh4iUCKl+6cDKKj9rLwGFD2ubmSDN2U6rADuo8oQ5HsGSOd4vrPMOZcS6Wp/NyMLQO7YEdXmwDTnIXxcrSssJ2QfdrSfVW9y+ScT6gd/+M5Y7VpGtuofF6Rngb5HQFNyQ78lITsCbuOknGLdIMiLB1qCnMqLCfH8VU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215786; c=relaxed/simple;
	bh=aSDGq+BuK9R8JbNM/JB7o8U8Z5PjuWxxqhZb9BIorLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAZ/ZOT2McaQI/pED4WBVYxKyRFJYjDaC6CPo+RiGr4DMin4wrqJUqQQlGnBZCganrb2Joeaq8sW+0YirHJjC9I6rJv0RWrVboqnWG5Kyv4eVNiaXN8ZFyekcwUTvM38bXMuxHnRz2Dkf9zmpO45bwhJMb/kzAmmXUR6WMjufMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWsayKqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWsayKqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFE2C4CEF1;
	Tue, 26 Aug 2025 13:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215786;
	bh=aSDGq+BuK9R8JbNM/JB7o8U8Z5PjuWxxqhZb9BIorLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWsayKqSv+dUYjt1vfoLfTeSPvMDTA2QMD0JAxbwqvfAwtddSA3quPolZ3jhkgLSc
	 /NVgb3KeBxWAmYkvH2SvWSSYDBt0S5dQcGs4uDq8PMo3919jvF14zWQlZBvPAvias+
	 Ic88WJNbcmGJ08GLJMv5Yw/a6njq2kN73ZsOW3e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Annette Kobou <annette.kobou@kontron.de>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/644] ARM: dts: imx6ul-kontron-bl-common: Fix RTS polarity for RS485 interface
Date: Tue, 26 Aug 2025 13:03:36 +0200
Message-ID: <20250826110949.615361567@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Annette Kobou <annette.kobou@kontron.de>

[ Upstream commit 47ef5256124fb939d8157b13ca048c902435cf23 ]

The polarity of the DE signal of the transceiver is active-high for
sending. Therefore rs485-rts-active-low is wrong and needs to be
removed to make RS485 transmissions work.

Signed-off-by: Annette Kobou <annette.kobou@kontron.de>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Fixes: 1ea4b76cdfde ("ARM: dts: imx6ul-kontron-n6310: Add Kontron i.MX6UL N6310 SoM and boards")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul-kontron-n6x1x-s.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul-kontron-n6x1x-s.dtsi b/arch/arm/boot/dts/imx6ul-kontron-n6x1x-s.dtsi
index 770f59b23102..44477206ba0f 100644
--- a/arch/arm/boot/dts/imx6ul-kontron-n6x1x-s.dtsi
+++ b/arch/arm/boot/dts/imx6ul-kontron-n6x1x-s.dtsi
@@ -170,7 +170,6 @@ &uart2 {
 	pinctrl-0 = <&pinctrl_uart2>;
 	linux,rs485-enabled-at-boot-time;
 	rs485-rx-during-tx;
-	rs485-rts-active-low;
 	uart-has-rtscts;
 	status = "okay";
 };
-- 
2.39.5



