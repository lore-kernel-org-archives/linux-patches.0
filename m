Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4083471267;
	Tue, 21 Jul 2026 18:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657342; cv=none; b=Msml9o+abkBThE9t5dYwNfMB83VnRNZR1cyAUb6B6XX5uTOJA8ONXXLpyW5IkalcLNHvuV2x7Njo/93T8sgl+CHUl6I6x4qbfiLxsR2nGuLQhIx09ZwcX2ACJlcmIDcunGvMLhBJrZT1yB/ruwtcuNSocsVEPVZ84uaZV4XCs5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657342; c=relaxed/simple;
	bh=kwrVvzBBBlpuXYvxOFdflvOEcE7VqTFwfvv0tvcHvnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UD0WFE0DTol3rPs01Mk4ecbAYNDBdBgrCEoLQmbAFpqRt9kr+PmFCSL81hX29QV2xvLnjyaMX9gx5nRAShUWP/ed/vLThCv1f8fZwwYDBAnELLQSfgWX6DodgoaDTh6D6PNdTI9wivW3g0mM3IpV+7xqw/Gz+UR7mZ/oLLoVWEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3gDRXL0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3gDRXL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB321F000E9;
	Tue, 21 Jul 2026 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657340;
	bh=jAqdKa3UxhnoJo4aEWmampLRHHf/+MPaF8O9H++DXLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V3gDRXL0jjNeb71isHmGQn2moqmjg7BvzFUJseQmc6bnYe5SvA9ATNY+HjeEIEMAm
	 KoTb8BDq5K/bKVvnmxoTJHXqxE2yTp8Els5dMtu4gZm8Uy+SGScwl9Tq8zQ5OGGnTN
	 XvIvu4JfIeJeVdnkY5vivkEmARmX1qLFveVyw9oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0727/1611] dt-bindings: phy: sc8280xp-qmp-pcie: Disallow bifurcation register on Purwa
Date: Tue, 21 Jul 2026 17:14:03 +0200
Message-ID: <20260721152531.734335082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit b3ee497970c63cea37976aeaa84bac39611fe0eb ]

Neither of the two Gen4x4 PHYs found on Purwa supports bifurcation.
The PHY is however physically laid out as if it were to, since there
are two separate ports (A/B).

Split out a new if-then block to un-require the bifurcation register
handle to squash this warning:

purwa-iot-evk.dtb: phy@1bd4000 (qcom,x1p42100-qmp-gen4x4-pcie-phy): 'qcom,4ln-config-sel' is a required property

Fixes: 2e1ffd4c1805 ("dt-bindings: phy: qcom,qmp-pcie: Add X1P42100 PCIe Gen4x4 PHY")
Reported-by: Rob Herring <robh@kernel.org>
Closes: https://lore.kernel.org/linux-arm-msm/176857775469.1631885.16133311938753588148.robh@kernel.org/
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20260610-topic-purwa_phy_shutup_warning-v2-1-951c1fbfe9b2@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml    | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml
index 119b4ff36dbd66..19d7de3ce7a967 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml
@@ -134,13 +134,22 @@ allOf:
           items:
             - description: port a
             - description: port b
-      required:
-        - qcom,4ln-config-sel
     else:
       properties:
         reg:
           maxItems: 1
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sc8280xp-qmp-gen3x4-pcie-phy
+              - qcom,x1e80100-qmp-gen4x4-pcie-phy
+    then:
+      required:
+        - qcom,4ln-config-sel
+
   - if:
       properties:
         compatible:
-- 
2.53.0



