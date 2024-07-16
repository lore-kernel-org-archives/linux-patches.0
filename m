Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F14199EA3;
	Tue, 16 Jul 2024 16:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145770; cv=none; b=mVfxEZMytZdP4cIjvxKmvvQaXoN1Ub+ySh56eT/ibqJzzqndO6xNMK67qjpegyUYfox8nx5fcjF3vpUXDqMy0YDhUlZNCINITLpmVye5K7l6hcyq44DOWMe0u4U4HuKTjlYTplp+g55ZOU5SO3XOj4osyEAvnxgF9qRCU9BTjWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145770; c=relaxed/simple;
	bh=JDw50vEHa29ybpdUGGB6Du3LmQUC7t4vi+JkIrdlOYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcSRuY5+h5Y6dPI6C8Hi8CQs4apdU5wXJm5PP6w8/NpwP+IdA3O/Or26oeMts6hu9DASgSnnnu1oqlFCkWXEmrq3KR8dd19KNe54/SdhJxBabQyRi5S0ZIMxRP3dm9f7q1nsKlWjpuHx+hNMpqhReq+rEk+pF97NrQTuZQQSyUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELRuEs9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELRuEs9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C69AC116B1;
	Tue, 16 Jul 2024 16:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145769;
	bh=JDw50vEHa29ybpdUGGB6Du3LmQUC7t4vi+JkIrdlOYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELRuEs9Sw57/sFuNYm5IiZEzPn2iAWbD9U0vowLxy/+ldQRjfj7LJlxCUXbEjbO0/
	 ohY7l7QalXXc9DVyE2n4Aj7wSBPpjFRdW5MERsqjsH9elIgUv//XBE6BivrJc/3Yze
	 9nmQzHSXgEp/ivDykndjQ7q5gYM4I6VhQCxs+zhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steev Klimaszewski <steev@kali.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 078/121] arm64: dts: qcom: sc8280xp-x13s: fix touchscreen power on
Date: Tue, 16 Jul 2024 17:32:20 +0200
Message-ID: <20240716152754.329248839@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 7bfb6a4289b0a63d67ec7d4ce3018cb4a7442f6a upstream.

The Elan eKTH5015M touch controller on the X13s requires a 300 ms delay
before sending commands after having deasserted reset during power on.

Switch to the Elan specific binding so that the OS can determine the
required power-on sequence and make sure that the controller is always
detected during boot.

Note that the always-on 1.8 V supply (s10b) is not used by the
controller directly and should not be described.

Fixes: 32c231385ed4 ("arm64: dts: qcom: sc8280xp: add Lenovo Thinkpad X13s devicetree")
Cc: stable@vger.kernel.org	# 6.0
Tested-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240507144821.12275-6-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts |   15 ++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -619,15 +619,16 @@
 
 	status = "okay";
 
-	/* FIXME: verify */
 	touchscreen@10 {
-		compatible = "hid-over-i2c";
+		compatible = "elan,ekth5015m", "elan,ekth6915";
 		reg = <0x10>;
 
-		hid-descr-addr = <0x1>;
 		interrupts-extended = <&tlmm 175 IRQ_TYPE_LEVEL_LOW>;
-		vdd-supply = <&vreg_misc_3p3>;
-		vddl-supply = <&vreg_s10b>;
+		reset-gpios = <&tlmm 99 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
+		no-reset-on-power-off;
+
+		vcc33-supply = <&vreg_misc_3p3>;
+		vccio-supply = <&vreg_misc_3p3>;
 
 		pinctrl-names = "default";
 		pinctrl-0 = <&ts0_default>;
@@ -1451,8 +1452,8 @@
 		reset-n-pins {
 			pins = "gpio99";
 			function = "gpio";
-			output-high;
-			drive-strength = <16>;
+			drive-strength = <2>;
+			bias-disable;
 		};
 	};
 


