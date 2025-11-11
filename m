Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A072FB973;
	Tue, 11 Nov 2025 01:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823913; cv=none; b=boWAGFwzKiPNU6E1QKnm84CG7nzDDvoXdUmhu7Dm3GH3WtKGWZ2JWxTOhL/IOP+yMn9u4FzTNhF1534SSSc0VQoLDF5F0UZR/6iwP5m0ADty3Gblg2cwyMUiiAqWiF+cyEJ2wKtjymiJInZ8tXpkdw3GB/myX1nrIBOXpPOfqhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823913; c=relaxed/simple;
	bh=hyM5JGsKrVZ40jJdUSRUKNi0iqbvGN+QNnbBLReqfBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uITHB3/BJJrannvzTVuIZvSguewwVXSYxgDsI73OSpZMKw+9cMbQ4x06oTutazRredLxhNIKAg5QeKSkA6QgTVUGdZKhnfpmArf7k/c6gt/lCRSQE0Ch+fhe3XqOZtRDmXBxeHwS1Xrj/7XsMFtDfTD7AS69mGOy4hOtf3lChYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gH2uexWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gH2uexWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16320C116B1;
	Tue, 11 Nov 2025 01:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823913;
	bh=hyM5JGsKrVZ40jJdUSRUKNi0iqbvGN+QNnbBLReqfBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gH2uexWMQRIie6Y0/uqkQQmu9DJFO40n5JyyIQ6vTZ/ATaxqw16yblYB/GkcSurhb
	 p/43YFPObaJhK/ph97YMlZDs6q24kmbtlmbJaq0dTCjdOr2uLBVbpYZNf7vLCDQ26n
	 P9nM1hmbQNVZgHmQlMTpz/xO9e46ysg8fC26ILno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 396/849] mips: lantiq: danube: add missing properties to cpu node
Date: Tue, 11 Nov 2025 09:39:26 +0900
Message-ID: <20251111004546.012928755@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit e8dee66c37085dc9858eb8608bc783c2900e50e7 ]

This fixes the following warnings:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpus: '#address-cells' is a required property
	from schema $id: http://devicetree.org/schemas/cpus.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpus: '#size-cells' is a required property
	from schema $id: http://devicetree.org/schemas/cpus.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: cpu@0 (mips,mips24Kc): 'reg' is a required property
	from schema $id: http://devicetree.org/schemas/mips/cpus.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube.dtsi b/arch/mips/boot/dts/lantiq/danube.dtsi
index 7a7ba66aa5349..0a942bc091436 100644
--- a/arch/mips/boot/dts/lantiq/danube.dtsi
+++ b/arch/mips/boot/dts/lantiq/danube.dtsi
@@ -5,8 +5,12 @@
 	compatible = "lantiq,xway", "lantiq,danube";
 
 	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
 		cpu@0 {
 			compatible = "mips,mips24Kc";
+			reg = <0>;
 		};
 	};
 
-- 
2.51.0



