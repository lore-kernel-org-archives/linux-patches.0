Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2CB18B46E;
	Tue, 30 Jul 2024 16:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356293; cv=none; b=B4qpu0ZQK0hlLcOnmZUEFDP3dUzEePjjENp6e/PVp+JEBqi7+41KXWqcfk8LWimivdzykjUljhTzA8ssPgxvslKwqgHbEy7cBfzSVdbnlP4GvhziEsvc8BzJdJdjTMAEPEASWQnL2YUiFU4ky6UsKWn0fINfFbVAf6MJVGaZu48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356293; c=relaxed/simple;
	bh=dFPM7ISdTMF75vzkqhAQNJ+wI+6P6c1JsFbKcsMcD3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecEa9X5XZpbdvA2DU38j3Z2In6KGLMbtYG+sTXamNTW747boKgyo751STpRFg/OxF9eU4LJpg0DvWklD1q5QbFmr5KVSqtknhLUFSbBBa7FWs7O0ZFNvqOSSZrYQbel2vDMDS+WZGtwP04ZUPJflzmdFCPkkC6oYKbJ2lkE6Z+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zV0yalqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zV0yalqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A82C32782;
	Tue, 30 Jul 2024 16:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356293;
	bh=dFPM7ISdTMF75vzkqhAQNJ+wI+6P6c1JsFbKcsMcD3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zV0yalqCVqkMn02ORqYhOhyJ8Yvyd4u/4tQvTLvKMS85QiKtWCThoLGcy6fwMwIDj
	 6QW93He/cOYPzhNxNqDPSJROcnUgOpflt8tEMK8c8ei5L1iWxxSrcEo6D12mfeHOs7
	 OsSfJ6MwkqFPczW6z3s+Sroz6+3Cie+9B1cjjl4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 137/809] arm64: dts: qcom: sm6350: Add missing qcom,non-secure-domain property
Date: Tue, 30 Jul 2024 17:40:13 +0200
Message-ID: <20240730151730.023725993@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 81008068ee4f2c4c26e97a0404405bb4b450241b ]

By default the DSP domains are secure, add the missing
qcom,non-secure-domain property to mark them as non-secure.

Fixes: efc33c969f23 ("arm64: dts: qcom: sm6350: Add ADSP nodes")
Fixes: 8eb5287e8a42 ("arm64: dts: qcom: sm6350: Add CDSP nodes")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20240705-sm6350-fastrpc-fix-v2-1-89a43166c9bb@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 5f862cf8858a7..60383f0d09f32 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1323,6 +1323,7 @@ fastrpc {
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "adsp";
+					qcom,non-secure-domain;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
@@ -1582,6 +1583,7 @@ fastrpc {
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "cdsp";
+					qcom,non-secure-domain;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-- 
2.43.0



