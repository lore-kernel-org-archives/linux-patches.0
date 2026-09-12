Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5E2367F36;
	Sat, 12 Sep 2026 07:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197678; cv=none; b=jKXL9irpO8hzA83HArNDvSRMDyZ75dqBpohI58cf8HvT3zTWaZfIuU20nOU+iYhjsH3QygQaLz7V2prNLuP0TNmTbSA0xON+rpagV7ZOmfPLetnbfFQSdB/cj4EK4SzTtYjWKfG/LZm0d0/nalSdwxOmDqetSErl1CHlHujkG/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197678; c=relaxed/simple;
	bh=2j7Ssgv99gzfD+8yWqqqyUsp+tdbqkDlwc28baFqbJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFJMiFexK5uiSAgBqBa2sfGRrsfIeJLCjdZlsj4mPk4aFfSns/xNTu7kD1/X6ahrPiw9Fijmox8Idjn0DS14t954yEUUy3C7le/8I0/CYRi7J575tIWoQDUtp5xZmhK8A3aJ6U6fzw+F2MGI2NTRuOtCqK+0qnbuZR4XiwiQu4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+JQ5R25; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+JQ5R25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8741F000FF;
	Sat, 12 Sep 2026 07:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197677;
	bh=sgivpiSOOQ6HklQWUcstUGYPBa5fC2muebnS0Gzk0Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+JQ5R25A3lCfvQOpUoaHoPVtJjc5j/VPkOO44Tl1N63pJZTUZty5KEZYMSEkgI2o
	 ER5NUwdTyb0/yFj/NWJgbAXac3Elhg0UndD6d4BT1HedtAGEVKACCbRYnffZ3g2zvo
	 zj8V50VeaV+srOyBqokAtXnZ9aE6J4ce7SXjr59s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pradyot Kumar Nayak <pradyot.nayak@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0222/1815] arm64: dts: glymur-crd: Add reset GPIO to touchscreen node
Date: Sat, 12 Sep 2026 08:32:52 +0200
Message-ID: <20260912065654.206347480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pradyot Kumar Nayak <pradyot.nayak@oss.qualcomm.com>

[ Upstream commit f64ef325f1d9ca9d005b7124c2bf065bb0b99c3d ]

The touchscreen module on Glymur/Mahua CRDs is different from the one
used on Hamoa CRDs and requires the reset-gpios to be wired to the device.
Without this in place the reset line will remain permanently asserted
during resume leaving the device offline and causing all I2C transactions
to fail with -ENXIO.

Error Logs:
i2c_hid_of 3-0038: failed to change power setting.
i2c_hid_of 3-0038: PM: dpm_run_callback(): i2c_hid_core_pm_resume [i2c_hid] returns -6
i2c_hid_of 3-0038: PM: failed to resume async: error -6

Add the reset GPIO so the driver can deassert the line on resume,
restoring I2C communication with the device.

Fixes: e6bf559f7eb9 ("arm64: dts: qcom: glymur-crd: Enable keyboard, trackpad and touchscreen")
Signed-off-by: Pradyot Kumar Nayak <pradyot.nayak@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260522-arm64-dts-glymur-crd-add-reset-gpio-to-touchscreen-v1-1-c7653924acdc@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur-crd.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
index db6f5419b4bc8..7d3c6bbd31d28 100644
--- a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
@@ -640,6 +640,8 @@ touchscreen@38 {
 		vdd-supply = <&vreg_misc_3p3>;
 		vddl-supply = <&vreg_l15b_e0_1p8>;
 
+		reset-gpios = <&tlmm 48 GPIO_ACTIVE_LOW>;
+
 		pinctrl-0 = <&ts0_default>;
 		pinctrl-names = "default";
 	};
-- 
2.53.0



