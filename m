Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98B93D3CE0;
	Thu, 15 Jan 2026 18:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500023; cv=none; b=f9AaDTZJEGcJ5KqwkcKgHzF/+jabJaKp87exZ3Lvfrt4lz9rtlsVH+XNmdHxqw9OQctpdGPwzSBs5coPRJmapl1jTLd0ZbuyLCe+fZKg43kuOWsxMD8/FIFvhcIkZakV0OdCNFivtsdoceTl+TSSwKxoGz169tMajytlQvW85fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500023; c=relaxed/simple;
	bh=cZ1vXr0DmhVXPw8dwiDTKDnPk42VYPMtRql1PWMwCRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZZ8+VPuUGTTbVegbgaWov+SqbovwufnzSZ2oxRWDiYtnkdBWQiopu8WxjB6qQnE0/AyRsiCU7Vmp/pLepmiGAaklS/eipj2X3INyNhnY+mUQd9zbBBxRFdWSfVXYZJxmFl3JLCRmMWMgHWEKXYB2EEE/VhBoJdVmrOq2gDaKVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDeyYzMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDeyYzMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CB1C2BC87;
	Thu, 15 Jan 2026 18:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500023;
	bh=cZ1vXr0DmhVXPw8dwiDTKDnPk42VYPMtRql1PWMwCRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDeyYzMaLtU7kRbjruB4IBIEOGouXJodTEwH/5fB4Fw9LTxtwx5/ZC6AIa2J1AFE8
	 BVbLLRweRZLihQonYi0LNDobi/tZyIX7YTSWdbyZx6maWO8ykqzjOY4lgFeqFfup/S
	 DYT5C9UWyJXprzI5ZgSn7ATtOKJ/SOdTyAjttj90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 431/451] ARM: dts: imx6q-ba16: fix RTC interrupt level
Date: Thu, 15 Jan 2026 17:50:32 +0100
Message-ID: <20260115164246.538311885@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Ray <ian.ray@gehealthcare.com>

[ Upstream commit e6a4eedd49ce27c16a80506c66a04707e0ee0116 ]

RTC interrupt level should be set to "LOW". This was revealed by the
introduction of commit:

  f181987ef477 ("rtc: m41t80: use IRQ flags obtained from fwnode")

which changed the way IRQ type is obtained.

Fixes: 56c27310c1b4 ("ARM: dts: imx: Add Advantech BA-16 Qseven module")
Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-ba16.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6q-ba16.dtsi b/arch/arm/boot/dts/imx6q-ba16.dtsi
index 133991ca8c633..6147d1ff4515e 100644
--- a/arch/arm/boot/dts/imx6q-ba16.dtsi
+++ b/arch/arm/boot/dts/imx6q-ba16.dtsi
@@ -320,7 +320,7 @@ rtc@32 {
 		pinctrl-0 = <&pinctrl_rtc>;
 		reg = <0x32>;
 		interrupt-parent = <&gpio4>;
-		interrupts = <10 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <10 IRQ_TYPE_LEVEL_LOW>;
 	};
 };
 
-- 
2.51.0



