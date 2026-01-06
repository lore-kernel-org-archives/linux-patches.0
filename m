Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9615E3559DC;
	Tue,  6 Jan 2026 17:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720544; cv=none; b=lIULhJd6Xv23dFyaE2SQXomVCMohz6++HZt6e5VkkqJZATXz+bAg+VuEoitqTnvgOP9K1RZYiqwWEgLud+ogIdkAru7MSEfKbdV3nxEA5ZaSVGbkgBXaYgRVHuAzO21KNIUxH6LARAU3UrY9FtEWHnNI8gF/FT5e+MN5WXJ7Vi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720544; c=relaxed/simple;
	bh=br0ZY6EwhYKuZ0hofkmuJCYZyIOe2z5QaWppBshwgUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doNSRAuEhNWk1WhoU/jiV8yiQXdKLagb9f5k6qP2ph0DHry4lk9RgFl/MwXIdJgPoQXFTtbYwUkE1G6bj3DzBn8bfxHxfmY9XIqghOmzoX7np7Fr1C8o+RpqRGuI2k28cemFyv4iKeu4ORdKWv8ew0+Z4Q+NYNwymFCIyR1v+YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WxCb7Ti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WxCb7Ti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9DCC116C6;
	Tue,  6 Jan 2026 17:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720544;
	bh=br0ZY6EwhYKuZ0hofkmuJCYZyIOe2z5QaWppBshwgUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WxCb7Ti+VId5Ar1afxPARi5EIin9872+SyHGvptujUiiLIKC4ME3TyhNcupWQV6t
	 6bt/j6m6s15XLV4WmVlL1B0RRwnkzBFsEm9/TomI/vgAI0qprk5aUy0/KsyjGq0gMG
	 oyGjMercUVOdt+R2pg57KFZerAKVOKHFIQ+aXKqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 269/567] dt-bindings: PCI: qcom,pcie-sm8350: Add missing required power-domains and resets
Date: Tue,  6 Jan 2026 18:00:51 +0100
Message-ID: <20260106170501.275474461@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 012ba0d5f02e1f192eda263b5f9f826e47d607bb upstream.

Commit 2278b8b54773 ("dt-bindings: PCI: qcom,pcie-sm8350: Move SM8350 to
dedicated schema") move the device schema to separate file, but it
missed a "if:not:...then:" clause in the original binding which was
requiring power-domains and resets for this particular chip.

Fixes: 2278b8b54773 ("dt-bindings: PCI: qcom,pcie-sm8350: Move SM8350 to dedicated schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251030-dt-bindings-pci-qcom-fixes-power-domains-v2-6-28c1f11599fe@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pci/qcom,pcie-sm8350.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/pci/qcom,pcie-sm8350.yaml
+++ b/Documentation/devicetree/bindings/pci/qcom,pcie-sm8350.yaml
@@ -71,6 +71,11 @@ properties:
     items:
       - const: pci
 
+required:
+  - power-domains
+  - resets
+  - reset-names
+
 allOf:
   - $ref: qcom,pcie-common.yaml#
 


