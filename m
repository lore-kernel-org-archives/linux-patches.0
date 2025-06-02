Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AF8221578;
	Mon,  2 Jun 2025 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872845; cv=none; b=Am4usabhxpAEkmgz8ttseStIfgd+z1204VaHj/sGb1hUKQIi2eg352P3gLmYTjxD/gj4ga+BagIO4GXV89v6rYBIejfja1m1xfeLmNohX1mWzvBx1x08togaPiDoCxGLE3EckwKuZx9wtiIWOh+YfE6W4sM0fXJ4D6jSYGkDkGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872845; c=relaxed/simple;
	bh=Mb17ghtf/RGUtyhiA4GrZhRCf+7cCgwBh96NjCbtCp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgoaU/dwELF6loUx9PS8EW5DxjvSdLtVuGq6w0kgTALVFILiIgxK/+kxzJPVAU3G8V+/WpH1I8/+0hlj398NK6KsRQXwuh3fuBKXVMRJBPDF+8fhztNIQsjzHYYnTGiie6WQAuL+ultMgExrWh4ilwo2cepz8dSlBIRNfLBy8hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q17Rk49e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q17Rk49e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042A9C4CEEB;
	Mon,  2 Jun 2025 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872842;
	bh=Mb17ghtf/RGUtyhiA4GrZhRCf+7cCgwBh96NjCbtCp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q17Rk49eP++mWOgSpLqZeUI1o/gZVXnVXydDZv5swdoc8+pGa6MeCKVsqhccDQebY
	 snDDWQm72b506IAE5c36lZiZ8bihq9jVVzcRVxD5foJZ18F40NHI5+6+oTvsHNBknm
	 xnmrRAuRXpum0r/pZce3Q8wTjfOQUabRRuP9E7Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 13/55] arm64: dts: qcom: x1e80100-yoga-slim7x: mark l12b and l15b always-on
Date: Mon,  2 Jun 2025 15:47:30 +0200
Message-ID: <20250602134238.802424718@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit f43a71dc6d8d8378af587675eec77c06e0298c79 upstream.

The l12b and l15b supplies are used by components that are not (fully)
described (and some never will be) and must never be disabled.

Mark the regulators as always-on to prevent them from being disabled,
for example, when consumers probe defer or suspend.

Fixes: 45247fe17db2 ("arm64: dts: qcom: x1e80100: add Lenovo Thinkpad Yoga slim 7x devicetree")
Cc: stable@vger.kernel.org	# 6.11
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250314145440.11371-7-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
@@ -266,6 +266,7 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l14b_3p0: ldo14 {
@@ -280,8 +281,8 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
-
 	};
 
 	regulators-1 {


