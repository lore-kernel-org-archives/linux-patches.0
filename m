Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0B919DF5F;
	Thu, 15 Aug 2024 14:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731095; cv=none; b=ZXylt0yTnaucPk9Xc+j1+m8IMoGH4JxTb9YgqamlJyKobK/nlbiHOPgpSgKLcFgh33sMWRRN6kZeiKw5/kKr2sl0Ztkyr9IOX+1oehfWo+VhL3/Z6aeRYLDchIYgIY/3uszxFnGZ4vjijia1GNC2hU2l2tBwizX8x7m2CCxKHRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731095; c=relaxed/simple;
	bh=lAEvQDXxbKIemCUcxtz2WksZdQZce0JaDS+P9yPjXEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7XfhTNL2WWvpUdMbjG8YuMRcQsyojFNJvs9X3JFT+eiiHTNOFTpZNHsQe0yFNGlgPCA6J7eHiyOq+r/mCChYZjuC5C+i9NpIO6gNqsQqGmfXe+XK+VKX5h3cR/u+cNtBxfiZJPGxP+KBBhsTWBNGBADIikswD8ObN8pbpShJYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZmz6gtn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZmz6gtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5302DC32786;
	Thu, 15 Aug 2024 14:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731095;
	bh=lAEvQDXxbKIemCUcxtz2WksZdQZce0JaDS+P9yPjXEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZmz6gtnKr0eoWHhmTNEQwg0P4Q9fbj0/+mTab71Kr2PYCnP+wa7OvXo1Tw2Wq0dY
	 ItnvBYTef7ra/K2LLyzfsgft2pn2tEyyJJF7qDLPvb+NQZHoi6XNhKoq39NlyDvhzs
	 mRtcwpjUlU3GY6Mp5Ysb0lJTe/cVHCRAaCmrE5uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/259] ARM: dts: imx6qdl-kontron-samx6i: fix PCIe reset polarity
Date: Thu, 15 Aug 2024 15:22:34 +0200
Message-ID: <20240815131903.615981530@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit df35c6e9027cf9affe699e632a48082ab1bbba4c ]

The PCIe reset line is active low. Fix it.

Fixes: 2a51f9dae13d ("ARM: dts: imx6qdl-kontron-samx6i: Add iMX6-based Kontron SMARC-sAMX6i module")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 49b17ecb40224..7434b37337063 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -725,7 +725,7 @@ &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_pcie>;
 	wake-up-gpio = <&gpio6 18 GPIO_ACTIVE_HIGH>;
-	reset-gpio = <&gpio3 13 GPIO_ACTIVE_HIGH>;
+	reset-gpio = <&gpio3 13 GPIO_ACTIVE_LOW>;
 };
 
 /* LCD_BKLT_PWM */
-- 
2.43.0



