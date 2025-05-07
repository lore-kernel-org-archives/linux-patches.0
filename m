Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88971214813;
	Wed,  7 May 2025 19:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644820; cv=none; b=B/VCIPk7rxawcL65jG3Ulp3HbQIuBnwv+fpVruSnRmkYYLAN1FZu4v55rHBC4KIum14hOrM/idnGaz/ZB9AG2tDVhqz8a2heEqrbCGmo2SD79aEtkS6A4XCTKiOT5aaOiI8Gc8QSf7Vj8rhtje101Gjde5VqgHOwDtXJgK+KpXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644820; c=relaxed/simple;
	bh=7OoCjyuaRpMO9q4WzK0rCAoqOKy9pAW40UOm25Hdvzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u52Gt4ENhZNqyYo8eqSjLis1uOs17a6S/lPdoCtwQcOvfSd1/MfbqYzjVNZfngz44iGL9T9R/BsXxMFybTpc/NzSWxFktR8d3IqaFgC7Epj5VjVX522w+v/pM4jn238NNZXg8EzdTdxZLYxSp7UJ9MXTWHeSgOVJ6iqCEVGJBjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8vr0h/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8vr0h/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E81CC4CEE2;
	Wed,  7 May 2025 19:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644820;
	bh=7OoCjyuaRpMO9q4WzK0rCAoqOKy9pAW40UOm25Hdvzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N8vr0h/8BhpefCSy6WsMIHMRmTjUVsIpuOCm8rQk2UCJvopeBpvuCJ43C9m20k6sk
	 XZg2cnbRUfRepfefHLM5E6pmZqNi+iB8ew0WhCTcyxF7vUROClaaU9wNbp3wULOMwF
	 Xh/3ofojtMJK7T4p8C3bo3t3ntYwObV0HwmUQqQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bruel <christian.bruel@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/164] arm64: dts: st: Adjust interrupt-controller for stm32mp25 SoCs
Date: Wed,  7 May 2025 20:40:42 +0200
Message-ID: <20250507183827.320517774@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit de2b2107d5a41a91ab603e135fb6e408abbee28e ]

Use gic-400 compatible and remove address-cells = <1> on aarch64

Fixes: 5d30d03aaf785 ("arm64: dts: st: introduce stm32mp25 SoCs family")
Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Link: https://lore.kernel.org/r/20250415111654.2103767-2-christian.bruel@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/st/stm32mp251.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/st/stm32mp251.dtsi b/arch/arm64/boot/dts/st/stm32mp251.dtsi
index 1167cf63d7e87..896d92032284b 100644
--- a/arch/arm64/boot/dts/st/stm32mp251.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp251.dtsi
@@ -114,9 +114,8 @@
 	};
 
 	intc: interrupt-controller@4ac00000 {
-		compatible = "arm,cortex-a7-gic";
+		compatible = "arm,gic-400";
 		#interrupt-cells = <3>;
-		#address-cells = <1>;
 		interrupt-controller;
 		reg = <0x0 0x4ac10000 0x0 0x1000>,
 		      <0x0 0x4ac20000 0x0 0x2000>,
-- 
2.39.5



