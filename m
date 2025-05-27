Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA30227FB2A;
	Tue, 27 May 2025 16:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364982; cv=none; b=Xx0wDvZ1U3hVpp+4V3loq2vkDvKd03kFYe6s8tMrvdv86z4dgasgXA4lvLkAV2wE+RI2okLcM9i0z+lAzlt4nSL4Ybhr0/fR1hi/w6xazgqqk4uOYiIcU6KLaI4FrB5g0eD6xCaJ6N8Bbleh21vRjO+Wkrcw4c1tE0oqZDCXKk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364982; c=relaxed/simple;
	bh=H6UE5znIQa3Zf8M9ftDkTdF5g3vxdRUOj2KeeErqx3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6Y/V9dv5MKQLBnx5k9K/rf7CCob1wjpovja9FLPFaGlRelc/1JodR+cPYlnkqnsc1FBBHIoA+RRCJUNGghoKFDxtggvbB54QtADJlF/P9WRAVMQ4EKfgeB8yAf0fxI7ir6bK8zDtdUv6pNc/QcHx3SzJOvg0NA+BY1XdrHF0+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4U9qtzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4U9qtzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C701C4CEE9;
	Tue, 27 May 2025 16:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364982;
	bh=H6UE5znIQa3Zf8M9ftDkTdF5g3vxdRUOj2KeeErqx3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4U9qtzIaQ6MW8vO7au0sKSgFKIxhGbiEH4zqW+NYppuYHvlas7Q3FjEwj18Vcbyu
	 9fM0SHPTRJu6NfeYGm4qLjSfZxcnmbfzj+yRWTgqBYt1BXYc7wwWP6hdKMVUlA8TGS
	 pQKznQBJyGPTKqGXpKtdy0qntSDKvjSG6LsYdNiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 212/626] arm64: tegra: p2597: Fix gpio for vdd-1v8-dis regulator
Date: Tue, 27 May 2025 18:21:45 +0200
Message-ID: <20250527162453.629463518@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>

[ Upstream commit f34621f31e3be81456c903287f7e4c0609829e29 ]

According to the board schematics the enable pin of this regulator is
connected to gpio line #9 of the first instance of the TCA9539
GPIO expander, so adjust it.

Signed-off-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Link: https://lore.kernel.org/r/20250224-diogo-gpio_exp-v1-1-80fb84ac48c6@tecnico.ulisboa.pt
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
index 63b94a04308e8..38d49d612c0c1 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1686,7 +1686,7 @@ vdd_1v8_dis: regulator-vdd-1v8-dis {
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
 		regulator-always-on;
-		gpio = <&exp1 14 GPIO_ACTIVE_HIGH>;
+		gpio = <&exp1 9 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 		vin-supply = <&vdd_1v8>;
 	};
-- 
2.39.5



