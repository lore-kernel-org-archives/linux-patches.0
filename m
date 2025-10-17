Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B20F30CD9F;
	Fri, 17 Oct 2025 15:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715236; cv=none; b=jxL+S+0s5OaxsnwHHBoaUdkX9yZ7tnE3gKmDj/NCjhQ/IxUqGP/slEJ2eNLGHxBpqNMKQnG7lLPsPmbbX6NY4M+vAHMwVUolDRxUpqssVjNk6zzIouL34J2Q9iX8r/CV1ct2B9uBKzVk7DUWJBdwZx+FKUVrbMFPLu4tNE6HFQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715236; c=relaxed/simple;
	bh=b3DxJHtjV8jf8EgGqEUY/vSoA7DrNj/nvfv0Ker0gsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLIGv5fY7lNPXIOwHKG6SdVdhZyAOqYTPh7cjQIks1y7r3xWJ0sBV32It0LkeqWM6JcPLW963Dwt+hMJF6qGHc5tpUAsXEKS59+0/+NxKSxwFnCHeY+BJXkkpts/rFX/fdqP/KvnHMvcyHZiSDbDJZtSM9Qn3sOTKNdNZCfnLxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKEFsQ6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKEFsQ6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88705C113D0;
	Fri, 17 Oct 2025 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715235;
	bh=b3DxJHtjV8jf8EgGqEUY/vSoA7DrNj/nvfv0Ker0gsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKEFsQ6fGiixXKdftvWuqQkg3ZqZA13HXnKxhggS6wfIMy1xrizyHfHObkIFdTsni
	 ES/PL/hNwLA/fp6dOzkiZUm48b23Wcvc9ztiBYsrMerKICdEeF5GB0+QHwEaKiT9Bo
	 JsulBpcI5rUs12n8uFCT3BPymZSMSd/af6Z5qeM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.17 145/371] arm64: dts: qcom: x1e80100-pmics: Disable pm8010 by default
Date: Fri, 17 Oct 2025 16:52:00 +0200
Message-ID: <20251017145207.180859045@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>

commit b9a185198f96259311543b30d884d8c01da913f7 upstream.

pm8010 is a camera specific PMIC, and may not be present on some
devices. These may instead use a dedicated vreg for this purpose (Dell
XPS 9345, Dell Inspiron..) or use USB webcam instead of a MIPI one
alltogether (Lenovo Thinbook 16, Lenovo Yoga..).

Disable pm8010 by default, let platforms that actually have one onboard
enable it instead.

Cc: stable@vger.kernel.org
Fixes: 2559e61e7ef4 ("arm64: dts: qcom: x1e80100-pmics: Add the missing PMICs")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Link: https://lore.kernel.org/r/20250701183625.1968246-2-alex.vinarskis@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-pmics.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/x1e80100-pmics.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100-pmics.dtsi
@@ -475,6 +475,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 
+		status = "disabled";
+
 		pm8010_temp_alarm: temp-alarm@2400 {
 			compatible = "qcom,spmi-temp-alarm";
 			reg = <0x2400>;


