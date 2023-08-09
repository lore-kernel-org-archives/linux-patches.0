Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E511915AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6365CC433C7;
	Wed,  9 Aug 2023 10:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578116;
	bh=V7G+holsThWloMXbTQ2nVssqirkjVAIo9GB+txgNUDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06H+RpYfxXQQWN8zZPnplg72PXpN82lpQ4lN05xQjuM3uXsGIlvhspwJvdOrUmG+e
	 UnVrp+7whxy7Vi3BWhie1mwOgVt182holsvqEV7EZSs/qQJMsNLVfFfVqK5iuHnOs6
	 W3yALKS4iVRkjuggYS1mhl6eJM6n97t6g1GUehtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.4 112/165] arm64: dts: stratix10: fix incorrect I2C property for SCL signal
Date: Wed,  9 Aug 2023 12:40:43 +0200
Message-ID: <20230809103646.456668857@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dinh Nguyen <dinguyen@kernel.org>

commit db66795f61354c373ecdadbdae1ed253a96c47cb upstream.

The correct dts property for the SCL falling time is
"i2c-scl-falling-time-ns".

Fixes: c8da1d15b8a4 ("arm64: dts: stratix10: i2c clock running out of spec")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts      |    2 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
@@ -145,7 +145,7 @@
 	status = "okay";
 	clock-frequency = <100000>;
 	i2c-sda-falling-time-ns = <890>;  /* hcnt */
-	i2c-sdl-falling-time-ns = <890>;  /* lcnt */
+	i2c-scl-falling-time-ns = <890>;  /* lcnt */
 
 	pinctrl-names = "default", "gpio";
 	pinctrl-0 = <&i2c1_pmx_func>;
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
@@ -141,7 +141,7 @@
 	status = "okay";
 	clock-frequency = <100000>;
 	i2c-sda-falling-time-ns = <890>;  /* hcnt */
-	i2c-sdl-falling-time-ns = <890>;  /* lcnt */
+	i2c-scl-falling-time-ns = <890>;  /* lcnt */
 
 	adc@14 {
 		compatible = "lltc,ltc2497";


