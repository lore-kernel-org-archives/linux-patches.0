Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05E32F7477;
	Tue, 12 Aug 2025 17:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020455; cv=none; b=M2Kt/BnZNA+I0BaT0VjtSwIrVszOYG1zcpTUHDLKnZG8RQwr3PSDlT8T1vXUK/hbsUzmm5hU6LzFFldmPzM+OjPBAnjGjnrqTrf/DXCdIHXiOb4hjVXLMjt8WGMRIzyLpagdrCVfwz4M9NXn4i7ysQrw7H5zdmisAL74pXJqpuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020455; c=relaxed/simple;
	bh=FGJb53o4/9lpH0MfpvOOa+s8T24HaMOA65uNhMmlue0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUyXg95qnJ3nzZ8xm/3otIQ6E6yznIdFLs7tTiUkV1OqMMvwZM56yanXGVghxD+mVx70eH5G3YUR0IvCemZ+xOOqznWR9J498OTfZpY8+HxemwQtEWDNTsVaskJrUaZCd+Nqb+15CyLxFP9obY/trSRpvNNjqUG4tDzX6BCpRfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0bQZCsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0bQZCsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38310C4CEF1;
	Tue, 12 Aug 2025 17:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020455;
	bh=FGJb53o4/9lpH0MfpvOOa+s8T24HaMOA65uNhMmlue0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0bQZCsFamsHa2K7xFW1dBvMVmI4MpFsxbCJUK6kwDMCTZmhFB252hS1Mz7697LgE
	 ub9gHmoQocQq0aom/9Wv77cKG14G5TM3WheWYm7LQt3MRJrULc8HQvOH4TWaDjlXaB
	 X6m4/VOnWV509a54seX8KUxb26moT8JteBMPbyGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Annette Kobou <annette.kobou@kontron.de>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/253] ARM: dts: imx6ul-kontron-bl-common: Fix RTS polarity for RS485 interface
Date: Tue, 12 Aug 2025 19:27:53 +0200
Message-ID: <20250812172952.356064999@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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
 arch/arm/boot/dts/imx6ul-kontron-bl-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul-kontron-bl-common.dtsi b/arch/arm/boot/dts/imx6ul-kontron-bl-common.dtsi
index 43868311f48a..bb324725411c 100644
--- a/arch/arm/boot/dts/imx6ul-kontron-bl-common.dtsi
+++ b/arch/arm/boot/dts/imx6ul-kontron-bl-common.dtsi
@@ -169,7 +169,6 @@ &uart2 {
 	pinctrl-0 = <&pinctrl_uart2>;
 	linux,rs485-enabled-at-boot-time;
 	rs485-rx-during-tx;
-	rs485-rts-active-low;
 	uart-has-rtscts;
 	status = "okay";
 };
-- 
2.39.5



