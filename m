Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563D6369D67;
	Wed, 20 May 2026 17:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299123; cv=none; b=j80VRqDhouI/jfzs7dogk4K3QN/QVdVLlB+yXFg3xnMeFHlwXzdEZrickEx5KY4GpDe4gBWDZotd+SqiyhbpteUsUHK0hhvyZeH9Fd2RcJKmeSyZKi0bf0JXgbWnWi3JE090tlBIqeKdCyw4P/MC7KsGUGjUgEb4N6lZfPe2lcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299123; c=relaxed/simple;
	bh=fEGd3uZO0gHIoM5femBZXSJTleMvTAV0UMsLsMCGS4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyfWW7uShxYhEVRgF7cSpN7vXjJZO9dhRJAoIwA4/6DPUZ0Z8JSGYnkYNVlTc/GTpctJnxcabsBChjAzKUh97xmT0LrCPgcTRmqZBpGDq16o4+l1IZB0wGNtoHDV3V6usfyzroSdNQp8CQq6umWpYScWwRDGs6ET2FibSMhB1j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlpNdSlq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlpNdSlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC62E1F000E9;
	Wed, 20 May 2026 17:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299122;
	bh=WxSM6sUgvGyuETTiXnh1YtycyYGm/9PFcynTNEZuxMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlpNdSlqC6qA/QIp8skmRHxUsvap8shLLGth+msXga8PAejde0gIzCOVincGDMntz
	 y7kjXloqV1JbuIzW59Nagf6w+gGoesIFcnuft0NVyNoPwS3psyr6KmPZxqGD+89Eay
	 oJolteaIGJfJ1lxo1iXSk/d30NPFteex94I8/U+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yan <jerrysteve1101@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 672/957] arm64: dts: meson-gxl-p230: fix ethernet PHY interrupt number
Date: Wed, 20 May 2026 18:19:15 +0200
Message-ID: <20260520162149.110819968@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Jun Yan <jerrysteve1101@gmail.com>

[ Upstream commit 174a0ef3b33434f475c87e66f37980e39b73805a ]

Correct the interrupt number assigned to the Realtek PHY in the p230

following the same logic as commit 3106507e1004 ("ARM64: dts: meson-gxm:
fix q200 interrupt number"),as reported in [PATCH 0/2] Ethernet PHY
interrupt improvements [1].

[1] https://lore.kernel.org/all/20171202214037.17017-1-martin.blumenstingl@googlemail.com/

Fixes: b94d22d94ad2 ("ARM64: dts: meson-gx: add external PHY interrupt on some platforms")
Signed-off-by: Jun Yan <jerrysteve1101@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patch.msgid.link/20260330145111.115318-1-jerrysteve1101@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
index 7dffeb5931c9b..701de57ff0f37 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
@@ -84,7 +84,8 @@ external_phy: ethernet-phy@0 {
 		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
 
 		interrupt-parent = <&gpio_intc>;
-		interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
+		/* MAC_INTR on GPIOZ_15 */
+		interrupts = <25 IRQ_TYPE_LEVEL_LOW>;
 		eee-broken-1000t;
 	};
 };
-- 
2.53.0



