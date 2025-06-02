Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E6521C16D;
	Mon,  2 Jun 2025 13:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872099; cv=none; b=hZ52btcU1ICtYHNKu9BzfRD+NFgTv97yzVEo+yjfKo36Y6Gl6JRerWA5dBPFcAra+dNrMuK8h6+7+LiIkaWup+clnCMcORhYYXI2ooXeXty3VnWbKI2WYUHRWnExZ03FFq8YIvqy3egMr4A/LefkPWwLNvQMk6N6ABwVE848o1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872099; c=relaxed/simple;
	bh=O+96Wx6MPPCtijFVUViwyePlErzly2qepCcDO64+9Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJtUuUiEmgST5Z1KwPY/Qban+DIk+C2WDXsn7w+HobQeoiIrrLLn1+CbckQ7SViONhNP3HyutHNXZvt20YmXa0yQgJf2wK02qLyXkc+0AW27ov4LU2r1KMoty1BLjCflcqdIhiMvjRffMi3k4ND2a++9CcOGszgqJiq5uIa4HeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMGC+KHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMGC+KHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91F2C4CEEB;
	Mon,  2 Jun 2025 13:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872099;
	bh=O+96Wx6MPPCtijFVUViwyePlErzly2qepCcDO64+9Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wMGC+KHWBsX+yJruxndtHv8PQbgrXdy40rOUITYSFfk/IZN2ZSfeurDvaLJOWYGEV
	 BY4D4W+xjV2//HEAkogrYL8NOp1nACS/DMMKdriM36x0XU/lEg8P/N34C7t1yZikR1
	 Xz/0J2azKMoCEaWCkfByCC4OpvoDR2JyulWpU4h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 18/49] arm64: dts: qcom: x1e80100-hp-x14: mark l12b and l15b always-on
Date: Mon,  2 Jun 2025 15:47:10 +0200
Message-ID: <20250602134238.661124041@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 3ab4e212a41c46668adf93c8d10d0d3d6de8f0e4 upstream.

The l12b and l15b supplies are used by components that are not (fully)
described (and some never will be) and must never be disabled.

Mark the regulators as always-on to prevent them from being disabled,
for example, when consumers probe defer or suspend.

Fixes: 6f18b8d4142c ("arm64: dts: qcom: x1e80100-hp-x14: dt for HP Omnibook X Laptop 14")
Cc: stable@vger.kernel.org	# 6.14
Cc: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250314145440.11371-6-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-hp-omnibook-x14.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/x1e80100-hp-omnibook-x14.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-hp-omnibook-x14.dts
@@ -633,6 +633,7 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b_3p0: ldo13 {
@@ -654,6 +655,7 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l16b_2p9: ldo16 {


