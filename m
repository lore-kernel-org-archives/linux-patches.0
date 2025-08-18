Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA1A31E11F;
	Mon, 18 Aug 2025 13:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522877; cv=none; b=k58nx7CYZQa/NiK86oo43P7qdDmiBy/MdKyEyrgPwOoBo68wufGflLUiQxkXn+cFRbpr6Cd3SdYI0W+KlsSfuUlQQqtK455oFUfQtCbTcvTiUllz4PqhXTQCIbsbBaskhscCuWp6Y/0n2xBDXHw8ZIT1on4x8XQH0F2QhIHXPiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522877; c=relaxed/simple;
	bh=YLaWzliUs01LkrD8LTh9KwUnCjCNEEY5g7+PTPS2chY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9HnOI4TflsbQGgxQdzds+1WBYwBwVvkp5IzJ6LVSlI/lv+RsTi1s8rKq/EnJMLK60O3QcVddT816wvc/kG5Gzhkk2UJBbxlGEkXfldsWL1ZQP4IgKqNW1PgLI2yk5dqA1qjQL+5gN/KIaDRo1FNe9n5DZDL9iceqjM1u5kXNMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNV18p+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNV18p+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C385C4CEF1;
	Mon, 18 Aug 2025 13:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522876;
	bh=YLaWzliUs01LkrD8LTh9KwUnCjCNEEY5g7+PTPS2chY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNV18p+FDi80fpgztTNKYwJvAgJQEKRS0ta+Qj1brLTdxfNng/rMwg4tNsGvVluco
	 8+yzHGpnKQ82TgDD7rhWGFZeWZxzBIna3mxfHeear0iXMF48TFUYIj3IXuzhk2y0or
	 AmbzdpZNk8vzpSCBQIZAQTW/vr2rE5QexpBhydYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 434/444] arm64: dts: ti: k3-j722s-evm: Fix USB gpio-hog level for Type-C
Date: Mon, 18 Aug 2025 14:47:40 +0200
Message-ID: <20250818124505.236415514@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 65ba2a6e77e9e5c843a591055789050e77b5c65e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
@@ -496,7 +496,7 @@
 			/* P05 - USB2.0_MUX_SEL */
 			gpio-hog;
 			gpios = <5 GPIO_ACTIVE_LOW>;
-			output-high;
+			output-low;
 		};
 
 		p01_hog: p01-hog {


