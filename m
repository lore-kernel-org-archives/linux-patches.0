Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2724D321F3F;
	Mon, 18 Aug 2025 13:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522999; cv=none; b=hxLnAs9U0KKUm7zneG7k9cW3/mIznR70z/lsR7ZNAiE9FTZkFn3eEg+ZMjstRecVlDI6egFiri5ZLXZqifjDoUQQ17cQaQzK/XhUhqRLmP7EMn50eAOBXshq4lDAuyrA5YHMYiZFeJ/B8jfzIQpuUcnb9XIw0gzdGuYuItL+MXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522999; c=relaxed/simple;
	bh=3B6yFXalwFkNmRGDSoq4pMTw9KdLSKYabEqh+egKYTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONaGWUgjFjzLt3lTkebDIKrBRvzPbDu0Lj0laDQS1GOOFMIp2DbFIUoel2K4qcWacs3GIXRa/8VwmjkEYYe07urOu5ca7VRFmGxfHXwgk1hUMBUl8LNDefsMdvm3rzpl88QL5u1MCHTnR7zb0S/1QfL7ATWKYiAQc1K0PBudscg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqApMmaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqApMmaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3721C4CEEB;
	Mon, 18 Aug 2025 13:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522999;
	bh=3B6yFXalwFkNmRGDSoq4pMTw9KdLSKYabEqh+egKYTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqApMmaO0r6WIDhq9GCWEycs7uJJ854xoGflhW8A1H+mhbjWLCOoDtJwBOKXHc+12
	 uM5MEPecVpcDdlcooxjf7379VXrcah1NhjlyMAb+rYMxiQpkFdToDeZjhyO8PGkWaL
	 MeErn16KYxuNlqS9tOHUWN5o66XYepgln5Hp3tRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.15 012/515] arm64: dts: ti: k3-j722s-evm: Fix USB gpio-hog level for Type-C
Date: Mon, 18 Aug 2025 14:39:58 +0200
Message-ID: <20250818124458.795979023@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 65ba2a6e77e9e5c843a591055789050e77b5c65e upstream.

According to the "GPIO Expander Map / Table" section of the J722S EVM
Schematic within the Evaluation Module Design Files package [0], the
GPIO Pin P05 located on the GPIO Expander 1 (I2C0/0x23) has to be pulled
down to select the Type-C interface. Since commit under Fixes claims to
enable the Type-C interface, update the property within "p05-hog" from
"output-high" to "output-low", thereby switching from the Type-A
interface to the Type-C interface.

[0]: https://www.ti.com/lit/zip/sprr495

Cc: stable@vger.kernel.org
Fixes: 485705df5d5f ("arm64: dts: ti: k3-j722s: Enable PCIe and USB support on J722S-EVM")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20250623100657.4082031-1-s-vadapalli@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
@@ -598,7 +598,7 @@
 			/* P05 - USB2.0_MUX_SEL */
 			gpio-hog;
 			gpios = <5 GPIO_ACTIVE_LOW>;
-			output-high;
+			output-low;
 		};
 
 		p01_hog: p01-hog {


