Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D3F279DB6;
	Tue, 12 Aug 2025 19:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025704; cv=none; b=oyfYsEa17sjQmyKEEB2lOb2oX6nMt7YSon8K8SqxhEW0PtklP/5oWfRiKV7FL/4FMVUm7efZjuX5JoviCcEz+ebrXYcNS53alv1WDe4eQUGU7stv4Pc7E8tB3Con9g2y0Lw5OukuiWyNCkJJVeqgNQO+3lsaOnmxQApaflnuZEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025704; c=relaxed/simple;
	bh=VI9+5G+B7PPOfF18CIJQj2dGHkvhafL8LHf1372p8Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRXWzM5hXOACz69LaEy1/iY4YJuorFbcr013eeorcX6ftbc/qjSqPuHAAoXgtAnn1LQl6GQY8g7qKZOxSypMaj0sWFt214eHYg2IWBtN9qtzhIXJ3m+xe39EMj/NvJjyu1DGUp5z5ZhFe0P8ebstmIccsdfuTIMaURs6ubhhRw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJq3FKbE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJq3FKbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D33C4CEF0;
	Tue, 12 Aug 2025 19:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025703;
	bh=VI9+5G+B7PPOfF18CIJQj2dGHkvhafL8LHf1372p8Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJq3FKbEXX8pZLRuuIFAShXbJE1/uqNgiC7rnp6+5493Y6jGim0fz5K2/n/Jj7zsP
	 5WEtN/zPV+DtxnwZ+Rxl1p9xNISnX2+Vw5ibVgZH3Urhj4GiesA6kR6QXsRSGFWvPi
	 aFkJr2l5WcvvzQk2ETaGt/x4HszQCmXyTnQJ16oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Delaunay <patrick.delaunay@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 076/480] arm64: dts: st: fix timer used for ticks
Date: Tue, 12 Aug 2025 19:44:44 +0200
Message-ID: <20250812174400.579408059@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Patrick Delaunay <patrick.delaunay@foss.st.com>

[ Upstream commit 9ec406ac4b7de3e8040a503429d1a5d389bfdaf6 ]

Remove always-on on generic ARM timer as the clock source provided by
STGEN is deactivated in low power mode, STOP1 by example.

Fixes: 5d30d03aaf78 ("arm64: dts: st: introduce stm32mp25 SoCs family")
Signed-off-by: Patrick Delaunay <patrick.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20250515151238.1.I85271ddb811a7cf73532fec90de7281cb24ce260@changeid
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/st/stm32mp251.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
index 87110f91e489..afe88e04875a 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -150,7 +150,7 @@ timer {
 			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(1) | IRQ_TYPE_LEVEL_LOW)>;
-		always-on;
+		arm,no-tick-in-suspend;
 	};
 
 	soc@0 {
-- 
2.39.5



