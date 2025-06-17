Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C7C2ED17E;
	Tue, 17 Jun 2025 16:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176560; cv=none; b=bzJqHTMJ7NlGUIlE8hoHlTwPzKuw29wZAjmfAkU9eaWd9FphvQJBxPLqN1uKPdodcyJfnjt8FKWbfWwKoZJ3Rh7evad7vPH1Jz5SmyK6eMA+7c9KF+2MH02VxnXtUeVtEnvjv3Mr94ZbEBa1z3ySDnyVgIn7mUQubhnE0mPMQq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176560; c=relaxed/simple;
	bh=FPov3TwFI7Dzmn/OsQnAXm44QmJcsXv7gzATDrowzjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9NIMwu3tYPCRpQCTUplUuILkv78T+LPDt+qzlgD+pnOyrcdzpdIAW6Ur8xVCwmTmmHoxUbdE53oktPxK0/ybAk+YbhOKqIaOXlLrEmRiBqXaDaFB4oslmJATw5xMNiQZHfoo3WAbtztapwBjXJzSSuQ++FOHVJo73jlG2uHkQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idEsP7bK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idEsP7bK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466B4C4CEE3;
	Tue, 17 Jun 2025 16:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176560;
	bh=FPov3TwFI7Dzmn/OsQnAXm44QmJcsXv7gzATDrowzjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idEsP7bKa+vS1aiCHqpnhhv40zYppT6gOpfyH2RR3UjXW4Rxtfr/4J/nfvZ6e5lok
	 Jtc+w+iiE67YoUhEr7L9uZbKuzsrNK4uOSnE1KlMcEWMc77AJC6/DcbE+rqff9/fdc
	 FTtqElABrpPqz88CoVfTK1drtmrjM2+TnN72FIfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Massot <julien.massot@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 242/512] arm64: dts: mt6359: Add missing compatible property to regulators node
Date: Tue, 17 Jun 2025 17:23:28 +0200
Message-ID: <20250617152429.420843627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Julien Massot <julien.massot@collabora.com>

[ Upstream commit 1fe38d2a19950fa6dbc384ee8967c057aef9faf4 ]

The 'compatible' property is required by the
'mfd/mediatek,mt6397.yaml' binding. Add it to fix the following
dtb-check error:
mediatek/mt8395-radxa-nio-12l.dtb: pmic: regulators:
'compatible' is a required property

Fixes: 3b7d143be4b7 ("arm64: dts: mt6359: add PMIC MT6359 related nodes")
Signed-off-by: Julien Massot <julien.massot@collabora.com>
Link: https://lore.kernel.org/r/20250505-mt8395-dtb-errors-v1-3-9c4714dcdcdb@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6359.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt6359.dtsi b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
index 8e1b8c85c6ede..57af3e7899841 100644
--- a/arch/arm64/boot/dts/mediatek/mt6359.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
@@ -18,6 +18,8 @@
 		};
 
 		regulators {
+			compatible = "mediatek,mt6359-regulator";
+
 			mt6359_vs1_buck_reg: buck_vs1 {
 				regulator-name = "vs1";
 				regulator-min-microvolt = <800000>;
-- 
2.39.5



