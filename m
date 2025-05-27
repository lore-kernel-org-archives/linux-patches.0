Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF812110E;
	Tue, 27 May 2025 17:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367122; cv=none; b=F8jc0QPul+HJ30z9HXc5eW9XQOuwgvfQQ0cEtK6wqcBFGyxs2Nh+cmB3IVtOuVU23cOefo6+sbVxcxvXx3E64+asjyZzt8VgMlRC8yci/mxnqstTbfGhugkuN4iBcMw2zGJTgeYbm2EguJfxOgl6wbyeVKt52RqIPrlBusXpKRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367122; c=relaxed/simple;
	bh=liYBRF3gh+SfThZgMZDxut9odWCiDffMuMbuuq68nBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEKmTBX5w+E26dkdKnRfc+ddfXyIwZKLSoy4R59o7iGa/qM8Q399dKORbH+cInMC4X3ywRsVNWwPurEslo6/90SEZDiLI7LbA7ywbhrrz3hNXA1rjKHIxrTqVvUr99O6Rny8Sc347ZGkjAUquodJnoGFuAFaWHJYXRGRvCY5FXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAGckLrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAGckLrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AB2C4CEE9;
	Tue, 27 May 2025 17:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367122;
	bh=liYBRF3gh+SfThZgMZDxut9odWCiDffMuMbuuq68nBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAGckLrVN1QjfXG0ijz4im4hFZove4yPMKrpPc6CtpFFJ4b+ugIZFekLIKdfnoSt+
	 7/7gBy+X6seAR/pCB1faUjghjXgdMbPDAvPd92QrAL+VxX9PRUVWRHEUPn1bghlBIb
	 Dg0R14EbvuABrLcZxPe+wnulpuXNp9b/kKmBnoIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 256/783] arm64: tegra: p2597: Fix gpio for vdd-1v8-dis regulator
Date: Tue, 27 May 2025 18:20:53 +0200
Message-ID: <20250527162523.525060493@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



