Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFBB248BDC;
	Wed, 15 Jan 2025 10:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938416; cv=none; b=Ch9Kp5DW03dNePLPpCVWIRKLeC0PQVQGDe10jzVct/svt2DGJB6Lnj+Lsk1YKxsiHqaub+reCbkttwj/TpTByVzg8pi/oX+0UMa5acT5zC/jIcdQ5hSFRbd+pdE4/N8kSma30F1wRIcB7MkC5XwPYBAtIvRfClWQFKzXlqD2gc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938416; c=relaxed/simple;
	bh=pFlxqZLrtpIc7YovvWJINsTksn8H2h7XuDERGmlc9zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRoVjji5S8qMY4G2/oFN3bQnxN0daLHhW6tvli1zK6ncXS8fvNkR/OyKjH/hFDMjvlzJd1sIJt0DIxYSKAU7EqurbtJNHcmprYFeqXyR7wVE7pzBcIDOtX08tv5QfGG0a6Zsrl894rsaMU27SyQAoiZZt4ss7XI9woPVVkvMNsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGmgiTYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGmgiTYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171EAC4CEDF;
	Wed, 15 Jan 2025 10:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938416;
	bh=pFlxqZLrtpIc7YovvWJINsTksn8H2h7XuDERGmlc9zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGmgiTYuoK4hUP33pI+K0encsh2e9h5cAvzQ0vAV44m1KuiqalyNSR5j2TF2VS10V
	 ZWMYNYgPlQlm7EYADmMt6GMVerwYC5Q+4HO7uBNMcWzVdGnjpyz3jDNa7e3glnpbvT
	 lMtagn9JmySVd8le4mlMS3H5XegVXM59lP87Z9JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <quic_jiegan@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/189] arm64: dts: qcom: sa8775p: fix the secure device bootup issue
Date: Wed, 15 Jan 2025 11:37:53 +0100
Message-ID: <20250115103613.470194436@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Jie Gan <quic_jiegan@quicinc.com>

[ Upstream commit 8a6442ec3437083348f32a6159b9a67bf66417bc ]

The secure device(fused) cannot bootup with TPDM_DCC device. So
disable it in DT.

Fixes: 6596118ccdcd ("arm64: dts: qcom: Add coresight nodes for SA8775p")
Signed-off-by: Jie Gan <quic_jiegan@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241219025216.3463527-1-quic_jiegan@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index 320a94dcac5c..8a21448c0fa8 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -1940,6 +1940,7 @@
 
 			qcom,cmb-element-bits = <32>;
 			qcom,cmb-msrs-num = <32>;
+			status = "disabled";
 
 			out-ports {
 				port {
-- 
2.39.5



