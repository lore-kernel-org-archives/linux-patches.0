Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D851F76D7;
	Tue,  3 Dec 2024 16:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241633; cv=none; b=UImnNaqUI2/jJGM8biuR1c/QzZBYzX/TzszIT9dJYv/W+f5V8gvlNVbsvYUWfQ69sIXv2QBkhca/Kh09qkf3bQ7pWDel295ciEFYrjhCKe/WRSSGshp9VUfbMzyE6A23ZoBmuS/wHsxH9WV6L5TqOeJefh/C2RYoeqP4c0EB0VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241633; c=relaxed/simple;
	bh=jL84eRvLCvnuWLkDsDdOVtuIp7MiIv5FQI9LJAmtyZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqiU9oYP++CaW7KHGrrVkSiU5G7s6IAJrdwKXX3PxXu3op1rQeBnIaUwCg3/8mhLthi4KfeqqmaqtOovW2DW560h8+qmP/QGI3D9spDztknijpZ61WFIvJRZBLgNxHNKw7FCXWju7BjDVN+i7IYj2OLhQlwgIGTF9nWI2okpehg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIb8rpAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIb8rpAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE3BC4CED6;
	Tue,  3 Dec 2024 16:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241633;
	bh=jL84eRvLCvnuWLkDsDdOVtuIp7MiIv5FQI9LJAmtyZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIb8rpAH05veRbeT3rfUrIKr+TgxKNT+nPT9iJzuOYcCU1jYTQ9Tp5x6y4hftq9Qm
	 BnVcVFEF2gh+DmOVOvmOgZpc1Y+3H8kcNyftlqwYv+XqyNBmZ3fJfuBoRS4/QkjoVS
	 UhPOIxurx+quuFHU3+E+IS1dMxIfUOAfjmHwlUKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 472/826] dt-bindings: PCI: mediatek-gen3: Allow exact number of clocks only
Date: Tue,  3 Dec 2024 15:43:19 +0100
Message-ID: <20241203144802.175663710@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fei Shao <fshao@chromium.org>

[ Upstream commit 5efa23224bf573d4bceb51bc646dd67b6ccb83b5 ]

In MediaTek PCIe gen3 bindings, "clocks" accepts a range of 1-6 clocks
across all SoCs. But in practice, each SoC requires a particular number of
clocks as defined in "clock-names", and the length of "clocks" and
"clock-names" can be inconsistent with current bindings.

For example:

  - MT8188, MT8192 and MT8195 all require 6 clocks, while the bindings
    accept 4-6 clocks.

  - MT7986 requires 4 clocks, while the bindings accept 4-6 clocks.

Update minItems and maxItems properties for individual SoCs as needed to
only accept the correct number of clocks.

Fixes: c6abd0eadec6 ("dt-bindings: PCI: mediatek-gen3: Add support for Airoha EN7581")
Link: https://lore.kernel.org/r/20240925110044.3678055-3-fshao@chromium.org
Signed-off-by: Fei Shao <fshao@chromium.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/pci/mediatek-pcie-gen3.yaml          | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/mediatek-pcie-gen3.yaml b/Documentation/devicetree/bindings/pci/mediatek-pcie-gen3.yaml
index 898c1be2d6a43..f05aab2b1addc 100644
--- a/Documentation/devicetree/bindings/pci/mediatek-pcie-gen3.yaml
+++ b/Documentation/devicetree/bindings/pci/mediatek-pcie-gen3.yaml
@@ -149,7 +149,7 @@ allOf:
     then:
       properties:
         clocks:
-          minItems: 4
+          minItems: 6
 
         clock-names:
           items:
@@ -178,7 +178,7 @@ allOf:
     then:
       properties:
         clocks:
-          minItems: 4
+          minItems: 6
 
         clock-names:
           items:
@@ -207,6 +207,7 @@ allOf:
       properties:
         clocks:
           minItems: 4
+          maxItems: 4
 
         clock-names:
           items:
-- 
2.43.0



