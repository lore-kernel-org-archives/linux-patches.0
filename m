Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A45F2DBF75;
	Tue, 21 Jul 2026 18:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660136; cv=none; b=KtdrZcTgbCFm52ncS9o4bn+L/J0YH7zDxCrD8zwCjxACAAFkxOKbqtnTHjLzGOTzegytb4Z4E8CrquVGT/kG9qTdnJlbCJKDoFhSek2hrB6NUmrJ9G277tARE1DV42SwQ/TnuwvwUM5XcX9BAQYwEqkqfdSFHwqs6BtCqyNkueM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660136; c=relaxed/simple;
	bh=JlKIXoleCEPuMDwnN4dOqDfdBtI7SOjtO8d+AKGgZYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbl9lfRx3R7cjh/lSiiBrgBWN5bdyyvAcymm0zIIAIDWA6vTt/s6cOI8rwU2Cc8Tb60Vry+0JEJNpdD9k1P4emjMh5PhRS4I2hBc6S4JfpT9fGknTmQCgPO8ZuLwLYQxOyuO1Qh3Yr5WLneMAwTv9cfEv4eGVXT2Oy9d6uNWo9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qP3+Jmad; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qP3+Jmad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F97F1F000E9;
	Tue, 21 Jul 2026 18:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660135;
	bh=um6nWQzxtUQJ4qwt5gdZyAIE0HpG/0w3K0rxjTjy/z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qP3+JmadGbustZJgcB5sKX0apPg303lsUmHvDSVZ8PU6rHq5TAy+zmyl92eV+xzN4
	 VX4Ir2eAibsxs0mFaHTGfP1ci7+hwJCvKmoQqIYI3rBvGcvGXlhXwtQqKrlFSy1StI
	 cDBMwo7MIHgCa7R7kP+IZQUp0YnupGXg9VMrznwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Biswapriyo Nath <nathbappai@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0864/2077] dt-bindings: clock: qcom,sm6125-dispcc: reference qcom,gcc.yaml
Date: Tue, 21 Jul 2026 17:08:57 +0200
Message-ID: <20260721152613.169998500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biswapriyo Nath <nathbappai@gmail.com>

[ Upstream commit dbabf6a32ffb69a604f966ec01a20a060836939d ]

Just like most of Qualcomm clock controllers, we can reference common
qcom,gcc.yaml schema to unify the common parts of the binding. This
also adds the '#reset-cells' property which is permitted for the
SM6125 SoC clock controllers, but not listed as a valid property.

Fixes: bb4d28e377cf ("arm64: dts: qcom: sm6125: Add missing MDSS core reset")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603150629.GYoouFwZ-lkp@intel.com/
Signed-off-by: Biswapriyo Nath <nathbappai@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260330-ginkgo-add-usb-ir-vib-v3-2-c4b778b0d7f8@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/clock/qcom,dispcc-sm6125.yaml      | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6125.yaml b/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6125.yaml
index ef2b1e2044309a..a177a1934b19f9 100644
--- a/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6125.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,dispcc-sm6125.yaml
@@ -42,12 +42,6 @@ properties:
       - const: cfg_ahb_clk
       - const: gcc_disp_gpll0_div_clk_src
 
-  '#clock-cells':
-    const: 1
-
-  '#power-domain-cells':
-    const: 1
-
   power-domains:
     description:
       A phandle and PM domain specifier for the CX power domain.
@@ -58,18 +52,16 @@ properties:
       A phandle to an OPP node describing the power domain's performance point.
     maxItems: 1
 
-  reg:
-    maxItems: 1
-
 required:
   - compatible
-  - reg
   - clocks
   - clock-names
-  - '#clock-cells'
   - '#power-domain-cells'
 
-additionalProperties: false
+allOf:
+  - $ref: qcom,gcc.yaml#
+
+unevaluatedProperties: false
 
 examples:
   - |
@@ -101,6 +93,7 @@ examples:
       power-domains = <&rpmpd SM6125_VDDCX>;
 
       #clock-cells = <1>;
+      #reset-cells = <1>;
       #power-domain-cells = <1>;
     };
 ...
-- 
2.53.0



