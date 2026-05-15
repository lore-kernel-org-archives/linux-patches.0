Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422FE3FD94E;
	Fri, 15 May 2026 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862477; cv=none; b=r0eWr4NjNY3g6YZsLF5lvcRphu65CYs+nZzYkiZroGcsMlQx56rblDU63fiRHSGZ7xYkRZNJm4p6uI8T6S2xviofYgFF2WxDqdMCq0c7wmX4YEV7d9ZZAY6OtKCD6Ul4GmaZdDVjXuvvQgiw8wQ2XH4BCMYi2CbMLZoa4RxsJYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862477; c=relaxed/simple;
	bh=sHGy+X6CBURh3gr9fdG6ALH//hEWBeJMU5WksTR8efM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vrc8o/Nd5suY59SS4d2Di9+h7C4F2TdEIhBzS1W1ETIwcasFBS2/NWutcZeYnUkY3YoYh/nZ0Br/xiYBGSV/pL70W7IFbMtTC19TCBGMyi5a48PhvtkeKlYIgA0mdu+Sjt2u9HyNX2NjHVlidugjaYfybI9javVDb6u/Lwv46ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTzAYbwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTzAYbwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB901C2BCB0;
	Fri, 15 May 2026 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862477;
	bh=sHGy+X6CBURh3gr9fdG6ALH//hEWBeJMU5WksTR8efM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTzAYbwFTR48SPgLrWD8ZCKVeDS85e40AiQSfnvJ1Le6Xs5owIR2Lr8c4WD8JAGTc
	 Pn4oA69OwV6jxFk47GwO/njLlBZr+YYJ41pD7QeDpmEUnBa/CxHBZV1TEjB5jkU4GT
	 HyD8nkjmAFmwfFFquPeFtIQnsOM2lvk3Ety2R9SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@linutronix.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 7.0 063/201] arm64: dts: broadcom: bcm2712-d-rpi-5-b: add fixes for pinctrl/pinctrl_aon
Date: Fri, 15 May 2026 17:48:01 +0200
Message-ID: <20260515154659.900491212@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregor Herburger <gregor.herburger@linutronix.de>

commit aeb078cebc40d421f61a8f07b0e7919aeb44d751 upstream.

On the -d revision of the bcm2712 the pinctrl differs from the c0
revision. The driver already supports both and distinguishes the two
with the compatible string.

Update the compatible string and reg length to reflect the different
pinctrl.

Signed-off-by: Gregor Herburger <gregor.herburger@linutronix.de>
Link: https://lore.kernel.org/r/20260226-raspi-dts-updates-v1-5-60832d20ff04@linutronix.de
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts
+++ b/arch/arm64/boot/dts/broadcom/bcm2712-d-rpi-5-b.dts
@@ -35,3 +35,13 @@
 		"PMIC_SCL", // AON_SGPIO_04
 		"PMIC_SDA"; // AON_SGPIO_05
 };
+
+&pinctrl {
+	compatible = "brcm,bcm2712d0-pinctrl";
+	reg = <0x7d504100 0x20>;
+};
+
+&pinctrl_aon {
+	compatible = "brcm,bcm2712d0-aon-pinctrl";
+	reg = <0x7d510700 0x1c>;
+};


