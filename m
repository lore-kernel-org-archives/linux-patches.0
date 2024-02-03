Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2E7134D9;
	Sat,  3 Feb 2024 04:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933369; cv=none; b=GM+MuY7XD2/0wcrlcpA0l1jgemzN9YsM+WF0TeSUQUQiQs6YlWbfG3an1qG6wJgksWssHp6pzChghOq3qWYZ2oyo6sBGjqRF2OkGrvKSFL1dYe/YGvMNt6EsZN7qnOPUpClCkQeNSjzcHLzDk6NdIgxn3H553vkiJLnfvt+LiNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933369; c=relaxed/simple;
	bh=zAayvX1wkrF6Pd0I+kxxakfVyNXzpnQNo8AFcbsqLoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSDivaGnLKi0CfSa1RE1xBzWm9+zxOuTvdHhIgGF2TZGoHPTJBzHKPr9h09L6boEOkklBctku8zUQOHk6YYI6MKny+Buzjtg+Of/oTkc2TqIEBIplsa7QAhAvjn54QzyzKK7ppaP0XrYbRoFsvsRJX6xvqVFsNvrWWQZZkb6FQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfeWTmzP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfeWTmzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C3BC43390;
	Sat,  3 Feb 2024 04:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933369;
	bh=zAayvX1wkrF6Pd0I+kxxakfVyNXzpnQNo8AFcbsqLoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfeWTmzPM61trDi8bF9w46Nca3aUDtTpJNToOAJB1WM4dYNI9+M30HUd/OBxyYWRM
	 IADuGLVz97eqbSKeZztPjJtykJ03DdHyBYn0Oc4v0akA7rNbSUxs2AG4sCnVlc11JC
	 AKoW7Xcm2uxER4HQ4mMPZGPPEjTNXzBj8+Pyd5uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/219] ARM: dts: imx25: Fix the iim compatible string
Date: Fri,  2 Feb 2024 20:04:10 -0800
Message-ID: <20240203035327.916519914@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit f0b929f58719fc57a4926ab4fc972f185453d6a5 ]

Per imx-iim.yaml, the compatible string should only contain a single
entry.

Use it as "fsl,imx25-iim" to fix the following dt-schema warning:

imx25-karo-tx25.dtb: efuse@53ff0000: compatible: ['fsl,imx25-iim', 'fsl,imx27-iim'] is too long
	from schema $id: http://devicetree.org/schemas/nvmem/imx-iim.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx25.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx25.dtsi b/arch/arm/boot/dts/imx25.dtsi
index 5f90d72b840b..5ac4549286bd 100644
--- a/arch/arm/boot/dts/imx25.dtsi
+++ b/arch/arm/boot/dts/imx25.dtsi
@@ -543,7 +543,7 @@
 			};
 
 			iim: efuse@53ff0000 {
-				compatible = "fsl,imx25-iim", "fsl,imx27-iim";
+				compatible = "fsl,imx25-iim";
 				reg = <0x53ff0000 0x4000>;
 				interrupts = <19>;
 				clocks = <&clks 99>;
-- 
2.43.0



