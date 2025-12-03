Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E35347BBE;
	Wed,  3 Dec 2025 16:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779284; cv=none; b=mmLhk29SwNdb3uyLylDkAOVafM43bNgFc/9hwDV9ODhKkRH6UYUbJkuMeXaVb8KX04JMHUrSdkjiQ3wDeb5ae1ZcZFu2ygh0STz02AWPzIcjztDqMphklRXP84A9IQiIorBvvyf0BDguouLoG4hK9yUnNPave9TNJQ15QTIhOoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779284; c=relaxed/simple;
	bh=6eD6dT3i1lydbnEWc3yILPy8OrnctzQVDyivME8VkKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKHtiXGr28LrkOVAEMvmsEuKRMCc5+wLTCm0ZALhAklAz5fZxsph5i48EOGGG1pqZ2CI3jRZXW0u2pOQfXi2eWNNFH2ZUIR9rchpdTwIUmKq/O+VNMPUv2MWzq8YcGmXhg8l3ZvYzqpN/8lSkcdyIYZqCmgy/EUTzTwaGwxAiiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHPnGaKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHPnGaKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC231C4CEF5;
	Wed,  3 Dec 2025 16:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779283;
	bh=6eD6dT3i1lydbnEWc3yILPy8OrnctzQVDyivME8VkKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHPnGaKdsA7C7sk9qIasKDoXW4Sd5X/iSsAYKW7yIu477UVVawTaIMnjFkZGJ39k2
	 PiiPICsUClbNSalp8MwhNtrLjZI1NpemhxJSHf86wUe24QNN2nxwj9vI9AuyjGbldi
	 tU6X7uh600nEJRdWxFkwBAA0J1ycOlLUBNoK6gA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/568] mips: lantiq: danube: add missing device_type in pci node
Date: Wed,  3 Dec 2025 16:23:00 +0100
Message-ID: <20251203152447.250409866@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit d66949a1875352d2ddd52b144333288952a9e36f ]

This fixes the following warning:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: pci@e105400 (lantiq,pci-xway): 'device_type' is a required property
	from schema $id: http://devicetree.org/schemas/pci/pci-bus-common.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube.dtsi b/arch/mips/boot/dts/lantiq/danube.dtsi
index ff6ff9568e1bc..1a5f4faa0831f 100644
--- a/arch/mips/boot/dts/lantiq/danube.dtsi
+++ b/arch/mips/boot/dts/lantiq/danube.dtsi
@@ -105,6 +105,8 @@
 				  0x1000000 0 0x00000000 0xae00000 0 0x200000>; /* io space */
 			reg = <0x7000000 0x8000		/* config space */
 				0xe105400 0x400>;	/* pci bridge */
+
+			device_type = "pci";
 		};
 	};
 };
-- 
2.51.0



