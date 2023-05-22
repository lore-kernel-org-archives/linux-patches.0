Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97192171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC42C433EF;
	Mon, 22 May 2023 19:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784137;
	bh=9cYUqgjCmXL70d3v/YxD5FMzfW9udcK3i96jAMwBI1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FopVz5UsK8+6x/Cy8AceDUUy7N9L0244Cw3Kb2fhj/fxvOqPS7IDAffMOKANL+xaD
	 jn3GUQAHM8kvnxI9r4sE2Hs3nGKu4H23xZ8knSBScr1JEKsGnGRcOB49Vn/Ewmo4DJ
	 1CibQuBlcnpdFlcjYT3dwwbf0Rhjwv9CSwYSEhjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.1 276/292] dt-bindings: ata: ahci-ceva: Cover all 4 iommus entries
Date: Mon, 22 May 2023 20:10:33 +0100
Message-Id: <20230522190412.839358884@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Simek <michal.simek@amd.com>

commit a7844528722619d2f97740ae5ec747afff18c4be upstream.

Current only one entry is enabled but IP itself is using 4 different IDs
which are already listed in zynqmp.dtsi.

sata: ahci@fd0c0000 {
	compatible = "ceva,ahci-1v84";
	...
	iommus = <&smmu 0x4c0>, <&smmu 0x4c1>,
		 <&smmu 0x4c2>, <&smmu 0x4c3>;
};

Fixes: 8ac47837f0e0 ("arm64: dts: zynqmp: Add missing iommu IDs")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Michal Simek <michal.simek@amd.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml
+++ b/Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml
@@ -32,7 +32,7 @@ properties:
     maxItems: 1
 
   iommus:
-    maxItems: 1
+    maxItems: 4
 
   power-domains:
     maxItems: 1


