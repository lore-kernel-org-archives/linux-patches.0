Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE51E3BF303;
	Thu, 15 Jan 2026 16:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496109; cv=none; b=jzgf3A2zVi3ftMKv9+9S7oAn1aIbxB4Ebh21aMlaxX/BhFTV6rOjy4IFnns+D1yyj1c8elV7HR/ocyAmmxc2jS7odR6113DUyrnF2109FnhXBbOjIsQidvHuWpwlhMh3YICoOnp0M3lQu6QJBnIxYd2ikabS+RPB0ZVWzt7sNAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496109; c=relaxed/simple;
	bh=tcbkn9xntfn2zjsMinAIiUueCnacfdNEoHkhNfawfCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgYVViygeNdu8702mmC3fxQQuWQL2PWn4dHTM1mPhV1qi8iRv9vaHQfly3vd6OAEjbDWIoRH/cxiwIE8M2pZ4sJ7gJN3iBOqt1wXPvhnpQFjVRYq5fW49CAzpz9DhIyLKTb/oGVm/OQA4qOc8mlCRo7oXuUpElnj6r/vEjbwKcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fd8WE5/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fd8WE5/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C13C116D0;
	Thu, 15 Jan 2026 16:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496108;
	bh=tcbkn9xntfn2zjsMinAIiUueCnacfdNEoHkhNfawfCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fd8WE5/gLWrvxdnCgVjqkjo4dGroe7TS8+72hSfmACACZPm17RQjAuQso1TmeuXX/
	 Mi5bRMwcaAp+cJQTo/m/plxI5JRN6gmp8085ilNXWByDl/m+9PjTQRHRDzwrM2ZrUR
	 bVOZd+rlNqFkBoFNAmJWe+0C4gLbgmK99YZssPOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/181] ARM: dts: imx6q-ba16: fix RTC interrupt level
Date: Thu, 15 Jan 2026 17:46:58 +0100
Message-ID: <20260115164205.251823795@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi b/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi
index 53013b12c2ecb..02d66523668d2 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6q-ba16.dtsi
@@ -337,7 +337,7 @@ rtc@32 {
 		pinctrl-0 = <&pinctrl_rtc>;
 		reg = <0x32>;
 		interrupt-parent = <&gpio4>;
-		interrupts = <10 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <10 IRQ_TYPE_LEVEL_LOW>;
 	};
 };
 
-- 
2.51.0



