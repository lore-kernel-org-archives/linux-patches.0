Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C1D1DF99A;
	Wed,  6 Nov 2024 12:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896480; cv=none; b=Uw2+adMWD8sxzsUYJoVqoQrrDHcaKauV28vIaMsr1Qerme7qQdfUX+e55cUEDwHVsqM8VrKrUd5wMhx6mN2wpnTGt25DeX72fgtVwB783hE1fw36bYG9FqTe/Qw+AyfQgky7LTVqreKu8R92i2Eh56nK5kteqCctkyLTTK+er8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896480; c=relaxed/simple;
	bh=4KuJjlypflaElCwustt2mt3PQDpPZz7j8WcB0J5WxGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6Puv1PDNG55PaSP9YHRVRQK4Udptd+BvEtNBtcsKVA5d/SlBfw6eecdZlYuwOsR9jHgz2JE9RmIygJrbzBsj88n6i+rE4xozIzTuTqNE8eLLu4AWbEqS4MeI3MlJM1hH4LPAxXHwbLGj0vM0sR9CstOiIroPaIA8xbavzKXlLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yL/9Cbvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yL/9Cbvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD81C4CED6;
	Wed,  6 Nov 2024 12:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896480;
	bh=4KuJjlypflaElCwustt2mt3PQDpPZz7j8WcB0J5WxGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yL/9CbvzpsPF/Sq/njJqx+sSbAnsNX/x3SOnCvwF+wesuFkiBSMMWXkcvdQ5mSuOo
	 paZ31SNkcKnVBnSSNB0W7VZbpi5jonc+A4krytfGN4v9nO1x8DEvCfbwtkqdCmm99v
	 UMZtbmmcl2HhrVGsLDC4IOBc4Qk276Xm1EMr/Ng4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 216/245] arm64: dts: qcom: x1e80100-qcp: fix nvme regulator boot glitch
Date: Wed,  6 Nov 2024 13:04:29 +0100
Message-ID: <20241106120324.571746872@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 717f0637ffc6a6a59f838df94a7d61e643c98d62 upstream.

The NVMe regulator has been left enabled by the boot firmware. Mark it
as such to avoid disabling the regulator temporarily during boot.

Fixes: eb57cbe730d1 ("arm64: dts: qcom: x1e80100: Describe the PCIe 6a resources")
Cc: stable@vger.kernel.org	# 6.11
Cc: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241016145112.24785-7-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
index 1c3a6a7b3ed6..5ef030c60abe 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -253,6 +253,8 @@ vreg_nvme: regulator-nvme {
 
 		pinctrl-names = "default";
 		pinctrl-0 = <&nvme_reg_en>;
+
+		regulator-boot-on;
 	};
 };
 
-- 
2.47.0



