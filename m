Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCDE362124;
	Tue, 16 Dec 2025 12:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886926; cv=none; b=Neb+c6TSS70AR4sF2hxnjAl2bgwF6ojj6JxJyW1iwpDYXfiKr99T+SQ0LdfcAL3BdxBo0C/ZOZtFwEjTo+xGXiTd+I7e3/Lt3eC7hcFPpUfY95PkMuEWfRGFSijckTkgnyS8KOT1ll3k2DdY+coWQzDb0j5dI9Gg0+w5+/4idZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886926; c=relaxed/simple;
	bh=hFzxIfMI4/IeCczqJmR2hx3Z+dKQ0ngH3eWMsd++HjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qt6cYGR1hejeq/En6u5keOXOL7Bh8+8G7SGRuNmBFbjfFwvsfUhM8mXR5QlUj0wCq/qi3SU47Ubd5d5UkDN8EG8pjfqY4CtqhCL87h3+rP7aoHbOeOZNepkPqlKJh1LBZpvwXWOSVIArSXk+DyaSW/10y1zxNmd1OKFyAnt8ucQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Jiun8kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Jiun8kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48666C4CEF5;
	Tue, 16 Dec 2025 12:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886925;
	bh=hFzxIfMI4/IeCczqJmR2hx3Z+dKQ0ngH3eWMsd++HjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Jiun8kz0dAoxy8+10amLEIFY06pSPofTlFjwhAZ/WolnOaOOLAX4dQUxJhQdGBlY
	 TSv8oSgUBBQqTggRQqhW7TaQicVbAKfDVML9O8p0/5ajEZHRgc9QUjMMgfIG4fVoNp
	 CkDkm+Kxeoik0RdhjBQeQ0nJ4q3BNpfSGxtA2fwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/614] arm64: dts: exynos: gs101: fix sysreg_apm reg property
Date: Tue, 16 Dec 2025 12:07:22 +0100
Message-ID: <20251216111404.034256445@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit 4348c22a4f15dbef1314f1a353d7f053b24e9ace ]

Both the start address and size are incorrect for the apm_sysreg DT
node. Update to match the TRM (rather than how it was defined
downstream).

Fixes: ea89fdf24fd9 ("arm64: dts: exynos: google: Add initial Google gs101 SoC support")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: André Draszik <andre.draszik@linaro.org>
Link: https://patch.msgid.link/20251013-automatic-clocks-v1-5-72851ee00300@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/exynos/google/gs101.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/exynos/google/gs101.dtsi b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
index 6335e0a8136be..c01ff4e1b0d5d 100644
--- a/arch/arm64/boot/dts/exynos/google/gs101.dtsi
+++ b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
@@ -1402,9 +1402,9 @@ cmu_apm: clock-controller@17400000 {
 			clock-names = "oscclk";
 		};
 
-		sysreg_apm: syscon@174204e0 {
+		sysreg_apm: syscon@17420000 {
 			compatible = "google,gs101-apm-sysreg", "syscon";
-			reg = <0x174204e0 0x1000>;
+			reg = <0x17420000 0x10000>;
 		};
 
 		pmu_system_controller: system-controller@17460000 {
-- 
2.51.0



