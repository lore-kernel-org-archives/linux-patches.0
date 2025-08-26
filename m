Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DDB35209C;
	Tue, 26 Aug 2025 14:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217271; cv=none; b=QMfRmer2SCTYtjjn3Z0FfAsPC74bG+Osi4DDpIZ3i8Vo7NMoGzFHioZqguFY4G0Pq345/We5KQX3KROsGnq/tQucztcN/PaUoecFABOU5se20nuKSU64ZHKdwaYZZCB/aQOWuJpvxPEkD1HuHLW6QRZLp2jDNtrEOpUJjBg6tMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217271; c=relaxed/simple;
	bh=rQIH94CfEkyiLep1fhl3or7cCfW7U7yXLQVMHwVu3hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PA1504a1mpgc3CMEoaT4CxwWONdKqegkUB/xe1sRf0jgRmIVmQMKgS2QI6dBJxfvw+c60auXR35Gx9Bo7DK73+c2DbGfar7y3NA/cPYi2ahnjQq8Zld3/r5QoUi0PJLUnZGyn9Rnjn23o0uA2nZjBi2baSNPQQpCMbqc4NI1Jms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7ORNaIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7ORNaIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C1BC4CEF1;
	Tue, 26 Aug 2025 14:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217271;
	bh=rQIH94CfEkyiLep1fhl3or7cCfW7U7yXLQVMHwVu3hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7ORNaIupSaMjjNkTNbo7C5bPgHnGvKNL4M09pwWvu66b97cbgLwhv7GvrzM0KDGa
	 O3VsEacOP70sT5SWr6ClPxqP+gQSnmUID4QtMbHblXB8eeCghZAAwklK7Hik2bjQP+
	 o2CqHBdjbYHuxFVrkzejTTNx+bcybB69HaTc3W/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/523] ARM: dts: vfxxx: Correctly use two tuples for timer address
Date: Tue, 26 Aug 2025 13:04:51 +0200
Message-ID: <20250826110926.562441937@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f3440dcf8b994197c968fbafe047ce27eed226e8 ]

Address and size-cells are 1 and the ftm timer node takes two address
spaces in "reg" property, so this should be in two <> tuples.  Change
has no functional impact, but original code is confusing/less readable.

Fixes: 07513e1330a9 ("ARM: dts: vf610: Add Freescale FlexTimer Module timer node.")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/vfxxx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index 2259d11af721..fb7709b8a334 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -617,7 +617,7 @@ usbmisc1: usb@400b4800 {
 
 			ftm: ftm@400b8000 {
 				compatible = "fsl,ftm-timer";
-				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
+				reg = <0x400b8000 0x1000>, <0x400b9000 0x1000>;
 				interrupts = <44 IRQ_TYPE_LEVEL_HIGH>;
 				clock-names = "ftm-evt", "ftm-src",
 					"ftm-evt-counter-en", "ftm-src-counter-en";
-- 
2.39.5



