Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B896168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5486C433EF;
	Mon,  8 May 2023 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543906;
	bh=YHkcl1MdQC4V+K23BzzvIjP/4qT95taRjGoWL3baj/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fpe8yV07BfHGnXpLwO/4uJ9nHFilTwPxUS0u0tvxvf95i4vF61MEsN46Eh6nv4CUg
	 5WuskJyrdTQG9IrXr/dT3mswRpi8mXY3upkvNdmM2GCGRkzX1sbMJ48YHAAIeDbhGs
	 NglxCAbNHgKh7+MFHhetvF/7ewxE2xO1w6pbAu3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 239/694] arm64: dts: ti: k3-am625-sk: Add ti,vbus-divider property to usbss1
Date: Mon,  8 May 2023 11:41:14 +0200
Message-Id: <20230508094440.093824958@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dhruva Gole <d-gole@ti.com>

[ Upstream commit 4b71618cb772f20dfeeba826e9d1713a04f9687f ]

The property "ti,vbus-divider" is needed for both usbss0 and usbss1 as
both USB0 and USB1 have the same external voltage divider circuit.

Fixes: 2d94dfc43885 ("arm64: dts: ti: k3-am625-sk: Add support for USB")
Signed-off-by: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20230328124315.123778-2-rogerq@kernel.org
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-sk.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk.dts b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
index 6bc7d63cf52fe..4d5dec890ad66 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
@@ -480,6 +480,7 @@
 
 &usbss1 {
 	status = "okay";
+	ti,vbus-divider;
 };
 
 &usb0 {
-- 
2.39.2



