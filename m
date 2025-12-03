Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F4F34C139;
	Wed,  3 Dec 2025 16:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777711; cv=none; b=moWAU8YSPCHjXDHgZV+XS1Lnmn0niv6rF1W6vzDiROSwM01f+MHRZh/UH7bvwtkwe99vuxvnv4/X984qN2dYR2sFQsOYsVQDPW8ivI1q44D+CVpiZZ47/76MfrA321qyS6ZuTelRopyruyX7ioobi0lxPuVoohU/8F49fjo/ryA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777711; c=relaxed/simple;
	bh=tT+PfbY16SnvRfaeG7DbHQR6fZrzaztvtBhkkF9P8ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhTNPMrDirL9Rw22Ye8IhfIcT1e6ckaa3fwmDiU9/S9PjCKXJFpMiETHCsd6FfVAHZo+rS70TRZuBh3YTmh6Ht9DscYB4Zgd+UBrfU/gTJhqoiDeyzQsJTldBx7CBbkvdvd47HcO3RkoF7G3tVmo0axZ0WVdDyJJjBH4e7yBgyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMIiZ/aO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMIiZ/aO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482F2C116B1;
	Wed,  3 Dec 2025 16:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777711;
	bh=tT+PfbY16SnvRfaeG7DbHQR6fZrzaztvtBhkkF9P8ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMIiZ/aOLWETkrjshk6qLtxQAcXOZKQ3lWmQIUh3SrM1amYfkb17pr3Li7mWU+TPz
	 oAc8L72yv6HUifwEby3Rttbtsa3LZU2OBb4GD77ksOM1CSoAg6u0JSlaqi5+Eer6c1
	 PrsSINNja6c7+gZsyWOtquLPh7hkkLDO8D5TnvKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/392] mips: lantiq: danube: add missing properties to cpu node
Date: Wed,  3 Dec 2025 16:24:32 +0100
Message-ID: <20251203152418.582812776@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



