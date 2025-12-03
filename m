Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEAD3590D6;
	Wed,  3 Dec 2025 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779277; cv=none; b=FdFeg3fRBF4LnnbwRCQLBiPqs7VNwfES1WEa1zAd9f3G11ZJrHiZcxk136jUClmXcu0sfhRsYTHhZ8i8weyMQezAhpaVVVtUcn1kzRZ72rsqNswW7WoVcMzjDdjHY8ndZuTr23CLhFbqYpsfpcbe1PPsnhLoyfqAIM4WJBoVGqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779277; c=relaxed/simple;
	bh=7ybhnwe6sIMyWh4o6r8gwAw7yLqnakfG97PGhZu+z8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jytlam4OGTMCnTGXffjB9J7lSPAWXiAMlsKiGcY0Eu+vrsfwBDHInG4Zgq0SyRbOgxyUMCuLDhWUcT2weuYKVeNsVB8xyb+RsboqVHvXPSdh0i8cs5LEBSOqhn/k5nJFg5FLOuT4FsEhRBu2e+bsU6tzQRe/6JW9VoGs7t8xiIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWf8r8X5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWf8r8X5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D5EC4CEF5;
	Wed,  3 Dec 2025 16:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779276;
	bh=7ybhnwe6sIMyWh4o6r8gwAw7yLqnakfG97PGhZu+z8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWf8r8X5YEhV9fCgLI0atoIfR96aRDDAs14lub1IABFF4xWmxXT0O1PK70rXCwAmf
	 xRp9yGLLcKA/huuwHVl+uOzihMyDXyDC/nL2w40vMGu+xzHYiV6TVOLmsUGQN2rEFy
	 GdKDXDJTMTGq3QH2GiepJU/Ej7dPrnhs3rGUrKrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/568] mips: lantiq: danube: add missing properties to cpu node
Date: Wed,  3 Dec 2025 16:22:58 +0100
Message-ID: <20251203152447.177387272@linuxfoundation.org>
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
index 510be63c8bdf1..ff6ff9568e1bc 100644
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



