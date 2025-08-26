Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DBA2BEFF0;
	Tue, 26 Aug 2025 11:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207186; cv=none; b=oDWiPPWNbCZuVvZj75cxmcdlqL71y4hoy1zHhfr6Ju3aQTe3tVYzf0eJLd6TLXYtSoHfCXqxNL9vGk8oOkWbAbHrVbAyqjiSDSkJs2HIg10RxY2B6zSBKnbun3mGy258YJJvhI0ETzL12vxpRIbJ03HB0io9PjqTNCKfM2gpWVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207186; c=relaxed/simple;
	bh=xXWaWvgj6o34RA+QSQYMxEWhzbJHFq6Le8Z9OnrCu6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhhtSjYqeuEMSeNV6k7BGK+lj93rM9FD9TTxDIQ7xJJPT2owo5h+AN0yfe+crwjV2EziSvBDDYi6nzHZh6b/NVpzI29AiPj/FM/jnjfDzOowONJWT3IN3K20VKl8cc9NZ/gogPhty1Zp4FPSg4EeFRoB8YgAUDLAFzC3awGA2tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTNZkWq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTNZkWq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7077EC4CEF1;
	Tue, 26 Aug 2025 11:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207185;
	bh=xXWaWvgj6o34RA+QSQYMxEWhzbJHFq6Le8Z9OnrCu6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTNZkWq3xk5wZfo5l5Wq1+panZ9jNd7hYSt2lydX6jV2+HO2dkjKywUgybpERgv0D
	 nYY2JOu/cT2cv1XMObaR+ofi52DceRGJLDzEPAGzM5CjhGmJhiB2H/hYAlzkN3XwUw
	 ecD573ype3NtfLLU5WcfxVYj7/ZBNWRDUMrd55tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.16 052/457] arm64: dts: exynos7870: add quirk to disable USB2 LPM in gadget mode
Date: Tue, 26 Aug 2025 13:05:36 +0200
Message-ID: <20250826110938.638338888@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaustabh Chakraborty <kauschluss@disroot.org>

commit e9355e894aebcbeacffd284644749190cc5f33a4 upstream.

In gadget mode, USB connections are sluggish. The device won't send
packets to the host unless the host sends packets to the device. For
instance, SSH-ing through the USB network would apparently not work
unless you're flood-pinging the device's IP.

Add the property snps,usb2-gadget-lpm-disable to the dwc3 node, which
seems to solve this issue.

Fixes: d6f3a7f91fdb ("arm64: dts: exynos: add initial devicetree support for exynos7870")
Cc: stable@vger.kernel.org # v6.16
Signed-off-by: Kaustabh Chakraborty <kauschluss@disroot.org>
Link: https://lore.kernel.org/r/20250626-exynos7870-dts-fixes-v1-1-349987874d9a@disroot.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/exynos/exynos7870.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/exynos/exynos7870.dtsi b/arch/arm64/boot/dts/exynos/exynos7870.dtsi
index 5cba8c9bb403..d5d347623b90 100644
--- a/arch/arm64/boot/dts/exynos/exynos7870.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7870.dtsi
@@ -327,6 +327,7 @@
 				phys = <&usbdrd_phy 0>;
 
 				usb-role-switch;
+				snps,usb2-gadget-lpm-disable;
 			};
 		};
 
-- 
2.50.1



