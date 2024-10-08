Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F551DE4CD;
	Tue,  8 Oct 2024 13:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393047; cv=none; b=b9rtIExlzn8NfLz42l2dT5B4M9/G9lkRuz8dQGhglSEAkqRlo+qcuN8QGPQax06x9ys+YZLFNUhgLwtMPy8B0z20OsBm9dwbKSZ9bnuRLwgDFwjfhbj6AbnmtHQdcOeY/PrabybyCGeGWCBQHUrV+jq2wvrUE0f66KtI4JwUR/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393047; c=relaxed/simple;
	bh=5xZyo8JPKDeyixdj4iVd7cseyDBJcE8GwOYUVuEuL+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgmEMbw7amuO8hkN4uhlQUAYeJQHnu8Ww7Qv7gzBgUbWIw+A2knVBae5W20O7Bk1LOWQDn5RoOHjqv+qn/MijeyKIaFd/XFJTn5qTiPy8BD22K2sOWNavbLks/ebg9StyTk2FHrdnOGuJTngzabfDf+QJAhdRJPaX5kA9ZaHBr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOvABd7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOvABd7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6203C4CEC7;
	Tue,  8 Oct 2024 13:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393047;
	bh=5xZyo8JPKDeyixdj4iVd7cseyDBJcE8GwOYUVuEuL+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOvABd7WuZgiOsWOmFZsp3eJdrN2sF41VQ8miPXl9/YX4aYQVyOviVa/kDsOXtRm/
	 i6/AG0gw1tcsGDs+U6f4VUp4XJq4xjUcHrBFA6Ttf5TFK9g6Y8w3a4PRhzE4oKp28v
	 /wepVYh6RGK2lFbRyQbHusOGan3L1scqBoMS2fM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravikanth Tuniki <ravikanth.tuniki@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/386] dt-bindings: net: xlnx,axi-ethernet: Add missing reg minItems
Date: Tue,  8 Oct 2024 14:04:42 +0200
Message-ID: <20241008115630.936345307@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravikanth Tuniki <ravikanth.tuniki@amd.com>

[ Upstream commit c6929644c1e0d6108e57061d427eb966e1746351 ]

Add missing reg minItems as based on current binding document
only ethernet MAC IO space is a supported configuration.

There is a bug in schema, current examples contain 64-bit
addressing as well as 32-bit addressing. The schema validation
does pass incidentally considering one 64-bit reg address as
two 32-bit reg address entries. If we change axi_ethernet_eth1
example node reg addressing to 32-bit schema validation reports:

Documentation/devicetree/bindings/net/xlnx,axi-ethernet.example.dtb:
ethernet@40000000: reg: [[1073741824, 262144]] is too short

To fix it add missing reg minItems constraints and to make things clearer
stick to 32-bit addressing in examples.

Fixes: cbb1ca6d5f9a ("dt-bindings: net: xlnx,axi-ethernet: convert bindings document to yaml")
Signed-off-by: Ravikanth Tuniki <ravikanth.tuniki@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/1727723615-2109795-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
index 1d33d80af11c3..652d696bc9e90 100644
--- a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
+++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
@@ -34,6 +34,7 @@ properties:
       and length of the AXI DMA controller IO space, unless
       axistream-connected is specified, in which case the reg
       attribute of the node referenced by it is used.
+    minItems: 1
     maxItems: 2
 
   interrupts:
@@ -165,7 +166,7 @@ examples:
         clock-names = "s_axi_lite_clk", "axis_clk", "ref_clk", "mgt_clk";
         clocks = <&axi_clk>, <&axi_clk>, <&pl_enet_ref_clk>, <&mgt_clk>;
         phy-mode = "mii";
-        reg = <0x00 0x40000000 0x00 0x40000>;
+        reg = <0x40000000 0x40000>;
         xlnx,rxcsum = <0x2>;
         xlnx,rxmem = <0x800>;
         xlnx,txcsum = <0x2>;
-- 
2.43.0



