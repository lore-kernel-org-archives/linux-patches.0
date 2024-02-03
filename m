Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DBF1119A;
	Sat,  3 Feb 2024 04:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933384; cv=none; b=ZD3yoCwzS43my6yDF3d7Js8R0MW2UcRCkVy/vo8dRQesIGjupzIY4jO4AKaKJli2FCmN4/Ph0ConWgHrC/R1HsHZu4kPd1xGFllHPmpAFdvJiyE/IaOdwulbla3bnoJ9H764mefRFjyfQUo04gQ5QCU140E+06OCkAOv6iuk3kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933384; c=relaxed/simple;
	bh=POPr6WhOzHnM/011aBxveBGyPAD6H/5jCttTQ9LvI7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiEQrpqe/Qae4N6A9Q6LKYUpQX3CnWfg/m9ospCnMiFgXismZ6UcHGLr/6F0aMLoeN09ix9D/ic/3l+d9MeH/l6B52zIsoK3GO6Zu6yJQp4VQ9mZm0Yc4oiYSaWuuTXTp2F1HN1kPQo2L3vgR78eykLaZonq81KGXz0KCBvXRH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKc+c5fY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKc+c5fY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB73C433C7;
	Sat,  3 Feb 2024 04:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933383;
	bh=POPr6WhOzHnM/011aBxveBGyPAD6H/5jCttTQ9LvI7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKc+c5fYh2sAxPU7uSf2PABhkRSJO1I0WNgyvFJ0ItaGTdDjq/4I8fT5gkOCJyeZi
	 X35H3haocE9xMwkIHteMHG596YnLWVkPgJFKc3ghyBiTvFwrLAekNQ6lZBih5EkbqX
	 z0qIczvWLEWaNq8g+KopxdhBZf280U23hFyqAwlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/219] ARM: dts: imx27: Fix sram node
Date: Fri,  2 Feb 2024 20:04:04 -0800
Message-ID: <20240203035326.850078108@linuxfoundation.org>
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

[ Upstream commit 2fb7b2a2f06bb3f8321cf26c33e4e820c5b238b6 ]

Per sram.yaml, address-cells, size-cells and ranges are mandatory.

Pass them to fix the following dt-schema warnings:

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx27.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx27.dtsi b/arch/arm/boot/dts/imx27.dtsi
index e140307be2e7..eb6daf22486e 100644
--- a/arch/arm/boot/dts/imx27.dtsi
+++ b/arch/arm/boot/dts/imx27.dtsi
@@ -588,6 +588,9 @@
 		iram: sram@ffff4c00 {
 			compatible = "mmio-sram";
 			reg = <0xffff4c00 0xb400>;
+			ranges = <0 0xffff4c00 0xb400>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 	};
 };
-- 
2.43.0



