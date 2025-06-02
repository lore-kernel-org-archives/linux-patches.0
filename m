Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB7D221FD0;
	Mon,  2 Jun 2025 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872839; cv=none; b=TxKJlDxactAvfncQ5eRAIbkwWe3HaTYX7fBwECdGQYW/CvR8UDrxDGu23/m89WEZ+8zW7iyM4cIENuzH3WRnbQjL9NIKkLDGfUnVe8Oop2RKUuNvfedMqlgh9IOiHP/8cwcYf/KwpWI9q6Y0FUQsVCg9TNi4U+UWdIIwgkblyek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872839; c=relaxed/simple;
	bh=0IImWFj+mZ1jUCShdDfCQ/xW0GfVSyO80qbnT6d4gNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6O6xmYz1kJBb1rQb6oBRWnoNDc+xr6RwHEmDzn5uKnwgaDUu3LUD7Udv4JlgAYacJYjmwE7eCa9QAZYX6mnFXHm9hh3bmYgDiFicJ+F1wXPZUqLFiYWLrQPBWD7OfrP/oq0tnNtwbxqPI9JVb6X5IPfvc+ZB2JjlgLW/YV26iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZGCFoKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZGCFoKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4002C4CEEB;
	Mon,  2 Jun 2025 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872839;
	bh=0IImWFj+mZ1jUCShdDfCQ/xW0GfVSyO80qbnT6d4gNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZGCFoKW2ufTse3JR+tAR0Fy5B9U7Ax7I6lgIviU4V2YF1cWUMNqPXP0GbUz6hRz8
	 irAHb60V81dt7iKS34hQkXcbY0Vn0QEkUqSeLLNDutPsQFIlxSZEuCZWvd6uD2GcCV
	 +eJc1EEwvtUzLN+v8zZWwoIlQCNGe/xzpZtXxl4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 12/55] arm64: dts: qcom: x1e80100-qcp: mark l12b and l15b always-on
Date: Mon,  2 Jun 2025 15:47:29 +0200
Message-ID: <20250602134238.757731174@linuxfoundation.org>
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

commit ff6ba96378367133b66587bd3ee9f068a39ff3a9 upstream.

The l12b and l15b supplies are used by components that are not (fully)
described (and some never will be) and must never be disabled.

Mark the regulators as always-on to prevent them from being disabled,
for example, when consumers probe defer or suspend.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Cc: stable@vger.kernel.org	# 6.8
Cc: Rajendra Nayak <quic_rjendra@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250314145440.11371-8-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -356,6 +356,7 @@
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b_3p0: ldo13 {
@@ -377,6 +378,7 @@
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l16b_2p9: ldo16 {


