Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F09365A02;
	Tue, 16 Dec 2025 12:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887113; cv=none; b=lZUS6Lz530S0mdotMGMQvmKJQLXfJO563fGbEvK+8tRVcgVdSTzaYEyz+HjUy4H4l8t/5nIzVpNgkdurMgvs7PfQO1+f0oFoCVr6+u6BnNRhnPWtUefEgZbPu4AmxR150wbomirRwWQFwIMnTARgTdp6fyzp4TSJmRg1AchZ9Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887113; c=relaxed/simple;
	bh=4VWCsu98lJkEZUxvrvt74tK/Xx9NX4HhxLKkOG2FcFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLk6eCAHnPgyKIUCN/zYwSKc2NqOa/0pw11VJbvGDaqPdROsgK+qcJNzLgZuowJ2qI+7g97lw+sod0EfbvcIGLocF2D6MHOv3guiARqdKLa6a1uzdzCciYpANJ2JePXd/8loBhuYoRS/42fomQ+U4zQNc1iesmgGVR5y7dzf8Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0F8vRLd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0F8vRLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B32C4CEF1;
	Tue, 16 Dec 2025 12:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887112;
	bh=4VWCsu98lJkEZUxvrvt74tK/Xx9NX4HhxLKkOG2FcFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0F8vRLdoW3Lg+vT+WHBJreDHezwxz3+zHcDYcbbyWHEMOIZeKf6c65DaGsf8ewZy
	 36ocSl72bTAv7UMQlR00tLdTc9jdQoNx9nfbsyQLr1gOpDxTxVHPDVwVAK1/FbMkY5
	 goAq6FSkGh+qaw/FFJT8Btvle3teFW3EJjDCG2+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/614] arm64: dts: qcom: qcm2290: Fix camss register prop ordering
Date: Tue, 16 Dec 2025 12:08:16 +0100
Message-ID: <20251216111406.010811225@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 67445dc8a8060309eeb7aebbc41fa0e58302fc09 ]

The qcm2290 CAMSS node has been applied from the V4 series, but a later
version changed the order of the register property, fix it to prevent
dtb check error.

Fixes: 2b3aef30dd9d ("arm64: dts: qcom: qcm2290: Add CAMSS node")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250918155456.1158691-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm2290.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcm2290.dtsi b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
index 08141b41de246..3b0ba590ee825 100644
--- a/arch/arm64/boot/dts/qcom/qcm2290.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
@@ -1685,25 +1685,25 @@ cci_i2c1: i2c-bus@1 {
 			};
 		};
 
-		camss: camss@5c6e000 {
+		camss: camss@5c11000 {
 			compatible = "qcom,qcm2290-camss";
 
-			reg = <0x0 0x5c6e000 0x0 0x1000>,
+			reg = <0x0 0x5c11000 0x0 0x1000>,
+			      <0x0 0x5c6e000 0x0 0x1000>,
 			      <0x0 0x5c75000 0x0 0x1000>,
 			      <0x0 0x5c52000 0x0 0x1000>,
 			      <0x0 0x5c53000 0x0 0x1000>,
 			      <0x0 0x5c66000 0x0 0x400>,
 			      <0x0 0x5c68000 0x0 0x400>,
-			      <0x0 0x5c11000 0x0 0x1000>,
 			      <0x0 0x5c6f000 0x0 0x4000>,
 			      <0x0 0x5c76000 0x0 0x4000>;
-			reg-names = "csid0",
+			reg-names = "top",
+				    "csid0",
 				    "csid1",
 				    "csiphy0",
 				    "csiphy1",
 				    "csitpg0",
 				    "csitpg1",
-				    "top",
 				    "vfe0",
 				    "vfe1";
 
-- 
2.51.0



