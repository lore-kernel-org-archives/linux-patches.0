Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFE72EA16C;
	Tue, 17 Jun 2025 16:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177900; cv=none; b=Hx6TtHYhVvaxVkQM3arBjkbaE0ZubqQmWzxyQZnNn2VkcKVWsihprOG64YgLXXrpZY7j1kwyDIdBPzc49zoc2nLN4UzTwd0TjDFow30TZ4VWTTqxiU8gxVOs/a4z0jbAs/BIFXqquGqBsbJl7ZdF0zBNguhbwqAEiR4W3hk3WDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177900; c=relaxed/simple;
	bh=TQNHUhHBfxL9gUzFlIuT9/0u5UxrqGnwotsLxuTnT+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3kmAP9N80hDb8ZRTKd8fzLSsg2shLFfnHvupMgDqWvMqNLhxXx9sxhrdVjQy0paABQgad5qqEtZwbojw6UNr0xASQW2JqiGZKNs92vn8zQ/petZo5M88rcGticcLUu5AZO7mlVWfV0GnMuJRSMI5zPRIMi5SIgLCCK+XUAmOL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oL/fNp29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oL/fNp29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDB2C4CEE3;
	Tue, 17 Jun 2025 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177899;
	bh=TQNHUhHBfxL9gUzFlIuT9/0u5UxrqGnwotsLxuTnT+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oL/fNp29rsK3T73cSD5e9cmvK92/qf23h4+J2hs3ivRs7bwDv7r9p0sO7+kGUEnEj
	 +otEPLXSMqo8BbLDEioyJ+bRVkAfV/oBaAHmXxHxDyJ0qgCay3VV1vDQE8kRzh9f+3
	 8VoSHftYcin/wHpce6lMVvauiN078qt0h58ccsPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Massot <julien.massot@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 379/780] arm64: dts: mt6359: Add missing compatible property to regulators node
Date: Tue, 17 Jun 2025 17:21:27 +0200
Message-ID: <20250617152506.895721427@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7b10f9c59819a..0c479404b3fe3 100644
--- a/arch/arm64/boot/dts/mediatek/mt6359.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
@@ -20,6 +20,8 @@
 		};
 
 		regulators {
+			compatible = "mediatek,mt6359-regulator";
+
 			mt6359_vs1_buck_reg: buck_vs1 {
 				regulator-name = "vs1";
 				regulator-min-microvolt = <800000>;
-- 
2.39.5



