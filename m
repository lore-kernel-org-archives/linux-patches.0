Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD54512C819;
	Tue, 30 Apr 2024 10:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474397; cv=none; b=DupH7yvwCDMIazDu6j17dHxuNXFhXUaqkX2wLA+NlBk6mmYU7cApDvuogXUXqw9MCns/nFW3wh02CVHwaXHZLPJlcaq00If83XOnLcqD8owmwwmd2DAg1+qk+XMjP5A0M4MzO7s1BJmHUMVAP6sb3Z/UgsiQs6E2JZRPtB2x0Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474397; c=relaxed/simple;
	bh=ayOGMPM6YMUs4Gf+mjeCSha8XI8Xi4KWCiYXMuTh5Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7pwzvjbY2kyBVjNEFLUlJPoPcVUJGOQMLw9kzSLEnVqT8bmEMa9gJFcQYBIfc/yjhaEnRZ3z3QACPWM9y/31mg6j+ayIjY9f9RPeqPXP+eCjAuMNFYEVRnWOR+JoJWaAEc0e90dC1cCE6sGCD5/NrBga/Z1pRBhvYn4/B0/5Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0q9oOdym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0q9oOdym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E389CC4AF1A;
	Tue, 30 Apr 2024 10:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474397;
	bh=ayOGMPM6YMUs4Gf+mjeCSha8XI8Xi4KWCiYXMuTh5Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0q9oOdym/KZc39HUIgP3YeM1ehcykQ+F2IrFK3PWq5UcO9wNU6b0+gxoliXEqg9vb
	 ChsmK7Z3snHEY4u4exDYku6Z98bsY/7PxQxRhHIdgGi4iIvrdPwN+SoZi7ERxp5BWU
	 9XEFmuPuXw8PHVl7+DxSiLKn6uvRWR0cCj64skzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Heimpold <michael.heimpold@chargebyte.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 105/228] ARM: dts: imx6ull-tarragon: fix USB over-current polarity
Date: Tue, 30 Apr 2024 12:38:03 +0200
Message-ID: <20240430103106.826622309@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Heimpold <michael.heimpold@chargebyte.com>

[ Upstream commit d7f3040a565214a30e2f07dc9b91566d316e2d36 ]

Our Tarragon platform uses a active-low signal to inform
the i.MX6ULL about the over-current detection.

Fixes: 5e4f393ccbf0 ("ARM: dts: imx6ull: Add chargebyte Tarragon support")
Signed-off-by: Michael Heimpold <michael.heimpold@chargebyte.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx6ull-tarragon-common.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6ull-tarragon-common.dtsi b/arch/arm/boot/dts/nxp/imx/imx6ull-tarragon-common.dtsi
index 3fdece5bd31f9..5248a058230c8 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6ull-tarragon-common.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6ull-tarragon-common.dtsi
@@ -805,6 +805,7 @@
 		     &pinctrl_usb_pwr>;
 	dr_mode = "host";
 	power-active-high;
+	over-current-active-low;
 	disable-over-current;
 	status = "okay";
 };
-- 
2.43.0



