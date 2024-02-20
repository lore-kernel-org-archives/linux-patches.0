Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F5876C9C;
	Tue, 20 Feb 2024 21:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463312; cv=none; b=ZUjFM1muI1wXNOlDlhFcNwLDRxddhlRfU7moTlnJyB7mgK0s0UqAMOQbKwDhPbx0De26Ujy2+fTenI5P7oSRE38mUmsLPBDYmvwChwBFpZ8RnIWpaS5ld1coP64kia1GwDP/+qqDpF+rXYfU9NcgvOwNWBkvMAN3hlNRbXgecy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463312; c=relaxed/simple;
	bh=HU3I2c5hEJUjCZDYuiSBnJl2z4HXDD+6rXALPs+vapw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lcd+5OWhNgQwr2ZlDarqIf5vb1P9rKkneShj5d/sJ4PA5licmqGRzFJOYfeR03qnGsHNR31E47mzCEne1WuWEP1/BQ6v2k+h0R9LGFDyil50U3vJy7wyj4uCMhJ0KPVRe9Ik58yk6tDp+aqPv9jVLXIQBUBkTujHtldCxzXToNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bVGW13M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bVGW13M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEAEC433C7;
	Tue, 20 Feb 2024 21:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463312;
	bh=HU3I2c5hEJUjCZDYuiSBnJl2z4HXDD+6rXALPs+vapw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bVGW13M6RfWVWyr9BWpRCGeSivx8mmHWCYWgrvWcE1akyDVSf20uEssoNW1o3WKC
	 VLlZ+7pljt34mpMOXm5mNFsaa7BMP7urzDi4PAUgNvRsezCR9dmjrUX2E18Uk3Vlu8
	 E4IfeLj9G3T9S0djn+9gPH9sAB8MZbulJHy4Fpf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/197] ARM: dts: imx6q-apalis: add can power-up delay on ixora board
Date: Tue, 20 Feb 2024 21:52:12 +0100
Message-ID: <20240220204846.250352157@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>

[ Upstream commit b76bbf835d8945080b22b52fc1e6f41cde06865d ]

Newer variants of Ixora boards require a power-up delay when powering up
the CAN transceiver of up to 1ms.

Cc: stable@vger.kernel.org
Signed-off-by: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-apalis-ixora-v1.2.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-apalis-ixora-v1.2.dts b/arch/arm/boot/dts/imx6q-apalis-ixora-v1.2.dts
index f9f7d99bd4db..76f3e07bc882 100644
--- a/arch/arm/boot/dts/imx6q-apalis-ixora-v1.2.dts
+++ b/arch/arm/boot/dts/imx6q-apalis-ixora-v1.2.dts
@@ -76,6 +76,7 @@ reg_can1_supply: regulator-can1-supply {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_enable_can1_power>;
 		regulator-name = "can1_supply";
+		startup-delay-us = <1000>;
 	};
 
 	reg_can2_supply: regulator-can2-supply {
@@ -85,6 +86,7 @@ reg_can2_supply: regulator-can2-supply {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_enable_can2_power>;
 		regulator-name = "can2_supply";
+		startup-delay-us = <1000>;
 	};
 };
 
-- 
2.43.0



