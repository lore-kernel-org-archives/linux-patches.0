Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067FA13B7A3;
	Wed, 28 Jan 2026 15:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614394; cv=none; b=g+1NaBHO742Zm4OZ0MoJtckkYyXrvGRpHPuX5pC50UUJtoFPCKvnUCJchOirg05ygNWfvMqNvbLFnnbXgs0o/DIxCnvkXcfLRmP1aN5cZD5UW/XGjmMPX018sA3tdq9qT1S/fYL1yoiskIbr8/154jXLKbNbqH/Nv6DtCr9rDv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614394; c=relaxed/simple;
	bh=f9JynRnRtDieaoSsnjbCk/AjA1AV++jkeTUL+sNEx+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/rnuIbMjNgKy2rCZ7h1/5h4uPrurptMiTTcRPKjWd5j4rsxjIgj2ZukgjWavuruZN0lAn7fUQ0aTbfuWG1ps3XBOPtlh1hwHSTbFaC+Mp29AzB8o4aymLyfXxTmYd1hECXt/H+hnzL1BNDKNfK9FocIXWVhswFhiabQyfFYPfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIlKqyn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIlKqyn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3A2C4CEF1;
	Wed, 28 Jan 2026 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614393;
	bh=f9JynRnRtDieaoSsnjbCk/AjA1AV++jkeTUL+sNEx+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIlKqyn1+dA13NtuVfTEcyk8v5cRwmkKSekf9ikQ5jKRUcbaqy/XQJGRrepi+J7E+
	 HlKuHgbEXHzeporpmSE7QbJIm8nGY+HPdWJU07yZoshVOAUC9QMDOvYnGxHsq9Po0X
	 NF9aXMdXTmQqQT8GFW2rkBb+pkneMVgIqDCAZ8SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/254] dt-bindings: power: rpmpd: Update part number to X1E80100
Date: Wed, 28 Jan 2026 16:21:21 +0100
Message-ID: <20260128145348.604414300@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sibi Sankar <quic_sibis@quicinc.com>

[ Upstream commit 3d123f513af055b4c085b555f9c856bbd7390536 ]

There was a recent part number update from SC8380XP to X1E80100 and as
a result of which the SC8380xp rpmpd bindings introduced is no longer
correct. Given that it currently has no users, it was agreed that it
can be updated to the correct part number (X1E80100) without causing
any binding breakage.

Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20231123100021.10918-2-quic_sibis@quicinc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 45e1be5ddec9 ("dt-bindings: power: qcom,rpmpd: Add SC8280XP_MXC_AO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/power/qcom,rpmpd.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
index 2803f7d568217..2ff246cf8b81d 100644
--- a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
+++ b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
@@ -56,6 +56,7 @@ properties:
           - qcom,sm8450-rpmhpd
           - qcom,sm8550-rpmhpd
           - qcom,sm8650-rpmhpd
+          - qcom,x1e80100-rpmhpd
       - items:
           - enum:
               - qcom,msm8937-rpmpd
-- 
2.51.0



