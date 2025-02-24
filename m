Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4D41514CC;
	Mon, 24 Feb 2025 14:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408651; cv=none; b=UFsL/GoUIaaIKv0CuBO0V22sOeooUCUzGdHWnujI0vzChAkuyb1b4IDmb4kqySQOlh5N7VdeR0qB99RVUuOCkmkpBEA1tfVlT45wggVtjmG0H7FZflVivIlGKqkUC4gaogQOPIkgk3gybREECS8OIBhoT3h34f+Blmg9f15YvsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408651; c=relaxed/simple;
	bh=zbXdLYQFr+XQzFb22Q1kps1e4bVRuKYk75VKWcaKzsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hG3EDJ9nsY5/SWwr1XB8lKLV0HL+7P8l1N7K293gu5olDkyqvKwf/9tNYYCQn6peOZ+OAKCXBUm6MvhTKtdG7uHEIPV6BpuLbuQndeGkbh8q/tSCstrXDBUPoUDZT4MTG0bRRMkSjeE40zZAzPQA/jR5+4tRdIwt8cnfFd7Souo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tr6ZIiIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tr6ZIiIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0115EC4CED6;
	Mon, 24 Feb 2025 14:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408651;
	bh=zbXdLYQFr+XQzFb22Q1kps1e4bVRuKYk75VKWcaKzsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tr6ZIiIw/H19T2KnDoJfyIq+OY/LmjFq99jVPnZ7hYL29/L7Uyd9+AyLMMGLRfhDj
	 6gvzSMGC519M8HSvikyJo13p8Rj6BWkdmAFoKcOaUXVonP7a9RElkex0vDdTDSUkNj
	 HkNOBj6oEyPLZjKv+pVd3EcLWjlwzKo8yzyiTsLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 119/154] arm64: dts: rockchip: Fix broken tsadc pinctrl names for rk3588
Date: Mon, 24 Feb 2025 15:35:18 +0100
Message-ID: <20250224142611.713598366@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

From: Alexander Shiyan <eagle.alexander923@gmail.com>

commit 5c8f9a05336cf5cadbd57ad461621b386aadb762 upstream.

The tsadc driver does not handle pinctrl "gpio" and "otpout".
Let's use the correct pinctrl names "default" and "sleep".
Additionally, Alexey Charkov's testing [1] has established that
it is necessary for pinctrl state to reference the &tsadc_shut_org
configuration rather than &tsadc_shut for the driver to function correctly.

[1] https://lkml.org/lkml/2025/1/24/966

Fixes: 32641b8ab1a5 ("arm64: dts: rockchip: add rk3588 thermal sensor")
Cc: stable@vger.kernel.org
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Alexander Shiyan <eagle.alexander923@gmail.com>
Link: https://lore.kernel.org/r/20250130053849.4902-1-eagle.alexander923@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-base.dtsi
@@ -2626,9 +2626,9 @@
 		rockchip,hw-tshut-temp = <120000>;
 		rockchip,hw-tshut-mode = <0>; /* tshut mode 0:CRU 1:GPIO */
 		rockchip,hw-tshut-polarity = <0>; /* tshut polarity 0:LOW 1:HIGH */
-		pinctrl-0 = <&tsadc_gpio_func>;
-		pinctrl-1 = <&tsadc_shut>;
-		pinctrl-names = "gpio", "otpout";
+		pinctrl-0 = <&tsadc_shut_org>;
+		pinctrl-1 = <&tsadc_gpio_func>;
+		pinctrl-names = "default", "sleep";
 		#thermal-sensor-cells = <1>;
 		status = "disabled";
 	};


