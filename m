Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB6513A26F;
	Tue, 27 Feb 2024 14:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042868; cv=none; b=Nf1fOIQx56uD+j3vPvTx8qxP7vnVm1fNzPB1SLtgIGaUCLpFlHeKTBu5ok0OPofJF6PpnnWXMqYPbjFtmHUdHsTuHVm0yFYT5HB/RZZUi11DT/RV6bZ3Lbe+iF/0Iz+QmhJCP73ccjjK/6P6pOA9JdEZrKQLOdkMU0ugeeH96rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042868; c=relaxed/simple;
	bh=Udvasd8ro9LWm2mVE3iMD5Z8vnh+87JrwdxZ0ikct9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hau73QFSzTTAd61U8Vl+DKzmXWKaG8PoQpqkviQKfbzvXbudRFEkHoL97dXb487l7qLqzD/RQowIVE/YHtEkdMKNSMBRhg4FPSeRxvkpLpwRkFXJjBmayKGi38FHo+g0sSTeHpJwLTGVwQv1p47WIAtq9DJVmNc0KwnvoyB+sRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqqivVKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqqivVKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703AEC433C7;
	Tue, 27 Feb 2024 14:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042867;
	bh=Udvasd8ro9LWm2mVE3iMD5Z8vnh+87JrwdxZ0ikct9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqqivVKItcXZ48Q0L1WO4fDkFdgyfAw1Jo30wS/pfGd0uCQg+MyykOSoInKiSm9v9
	 3sZN7jmMSEdyraQ2DhOA+mWzSBar10vEmBMHjnZCDCVlGPTXa+ys3JgB7ML6/1EYa4
	 ZGNmVR0WsEuIX+yOdfAN39Z6l7qDNID0IV4FJNZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Li Jun <jun.li@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/245] dt-bindings: clocks: imx8mp: Add ID for usb suspend clock
Date: Tue, 27 Feb 2024 14:25:37 +0100
Message-ID: <20240227131620.054841477@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Li Jun <jun.li@nxp.com>

[ Upstream commit 5c1f7f1090947d494c30042123e0ec846f696336 ]

usb suspend clock has a gate shared with usb_root_clk.

Fixes: 9c140d9926761 ("clk: imx: Add support for i.MX8MP clock driver")
Cc: stable@vger.kernel.org # v5.19+
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/1664549663-20364-1-git-send-email-jun.li@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/imx8mp-clock.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/dt-bindings/clock/imx8mp-clock.h b/include/dt-bindings/clock/imx8mp-clock.h
index a02fd723168cc..5e872b01d5ab8 100644
--- a/include/dt-bindings/clock/imx8mp-clock.h
+++ b/include/dt-bindings/clock/imx8mp-clock.h
@@ -325,8 +325,9 @@
 #define IMX8MP_CLK_CLKOUT2_SEL			317
 #define IMX8MP_CLK_CLKOUT2_DIV			318
 #define IMX8MP_CLK_CLKOUT2			319
+#define IMX8MP_CLK_USB_SUSP			320
 
-#define IMX8MP_CLK_END				320
+#define IMX8MP_CLK_END				321
 
 #define IMX8MP_CLK_AUDIOMIX_SAI1_IPG		0
 #define IMX8MP_CLK_AUDIOMIX_SAI1_MCLK1		1
-- 
2.43.0



