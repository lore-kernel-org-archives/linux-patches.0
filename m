Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1312C36B924;
	Sat, 12 Sep 2026 08:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200410; cv=none; b=WlwweR8eXCvohLbMxH76eWcRx/H/P+UzaHWpeJ7oSvS3KOUEQYg457VaMuqY/L5StiorZCI8Wd3niYBboPjsk9trcrM7gW45xnXOGEnaO21GvYWcILWuctQNtWwRLZnhJeGYvBa0m95QoAh3VlDi7kzzPak7LVC03jcn4KH7GQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200410; c=relaxed/simple;
	bh=PTEtkSA+EtrqZUl58/qyZkW3Gx05kcBgB0G69U2SFok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlRfOeluLJXnZpGHSv4jpFQA6cC4LV1GMICgUxp7nWcBl9R2axIthDJaAgbu2SaQD9hdh/DLTijfCLZqb8Pi/2C2HWlXPuSHClY8WNv35rhrai0ZmGgWEEXSz2wNXleZL8CErYjf+NHZDjWpXtDJhAn45aR9uHroJM5z+Xawmfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNNNIEXC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNNNIEXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8352F1F000FF;
	Sat, 12 Sep 2026 08:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200408;
	bh=nEKc0RSCbA719xiPC8KxI2rbfjOmnUP7YHrjCko8AlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNNNIEXCIaWT3dSbmhdkGbZfJE5ncl6qyUmEClHXM/xoi6Fd10hSRXjPvrDH67MzB
	 +kzsRKYrYvWQbGMG5oTarq10dVH4yjBYb2qLzUKZrxWId/H3sz1xdNfmEYeGeIL3F7
	 jcd/sPkvy+F2fWfeqGYYEwW3HN1ETybFMSUmVFwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Pradyot Kumar Nayak <pradyot.nayak@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0785/1815] arm64: dts: qcom: glymur-crd: Add FocalTech ft3d81 touchscreen support
Date: Sat, 12 Sep 2026 08:42:15 +0200
Message-ID: <20260912065707.337805573@linuxfoundation.org>
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

[ Upstream commit 67b5818ecadeb75e29c14add973b8cada2a73788 ]

The touchscreen module on Glymur/Mahua CRDs is different from
the one used on Hamoa CRDs and requires the reset-gpios to be wired to
the device. Without this in place the reset line will remain
permanently asserted during resume leaving the device offline and causing
all I2C transactions to fail with -ENXIO.

i2c_hid_of 3-0038: failed to change power setting.
i2c_hid_of 3-0038: PM: dpm_run_callback():
i2c_hid_core_pm_resume [i2c_hid] returns -6
i2c_hid_of 3-0038: PM: failed to resume async: error -6

The touchscreen on Glymur/Mahua-CRD is a focaltech ft3d81,
which is hardware-compatible with the ft8112.
we have added the required change in DT.

Fixes: e6bf559f7eb9 ("arm64: dts: qcom: glymur-crd: Enable keyboard, trackpad and touchscreen")
Fixes: f64ef325f1d9 ("arm64: dts: glymur-crd: Add reset GPIO to touchscreen node")

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Pradyot Kumar Nayak <pradyot.nayak@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260717-add_focaltech_ft3d81_touchscreen_support-v4-2-5dd091e25801@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur-crd.dtsi | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
index f09a957d094da..fcf497a8356e2 100644
--- a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
@@ -631,14 +631,13 @@ &i2c8 {
 	status = "okay";
 
 	touchscreen@38 {
-		compatible = "hid-over-i2c";
+		compatible = "focaltech,ft3d81", "focaltech,ft8112";
 		reg = <0x38>;
 
-		hid-descr-addr = <0x1>;
 		interrupts-extended = <&tlmm 51 IRQ_TYPE_LEVEL_LOW>;
 
-		vdd-supply = <&vreg_misc_3p3>;
-		vddl-supply = <&vreg_l15b_e0_1p8>;
+		vcc33-supply = <&vreg_misc_3p3>;
+		vccio-supply = <&vreg_l15b_e0_1p8>;
 
 		reset-gpios = <&tlmm 48 GPIO_ACTIVE_LOW>;
 
-- 
2.53.0



