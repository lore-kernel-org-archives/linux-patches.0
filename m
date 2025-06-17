Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15074231A37;
	Tue, 17 Jun 2025 16:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177711; cv=none; b=TVCSQNoyaNZ6W2Ii2uiQd2jZq6XHxyHpfaRyKEVnuFYVVcbEIYUqrhmPcNebUFo6YKq422YWWUzpD2ib8nOzDhxhsBYnIbz+ItHRX6yTtZ85nEUqAn1cxmRhmcDEe5O7RmmyYnMyzxskWsNT6HheKTsrERp43ITHpMv9I98tlwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177711; c=relaxed/simple;
	bh=LJe1UAnV7Izsco3pdnEk/mEcHUCEjmsGwlDQU0ajEqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2G1l7n8ihxZQzmOf12Ri52+Zq6iLcbFbFJvUzVJgUHn4AZnmqzS2IqS0odHe49I4LicP2d7fPm6ps8jJHQZbZiX/PzRsNLw4VIQEhwZpSUZOst2RipU0Oi1wkNge+34aYXs+A071vmdIyXp6Z7d2/jsWHQZzaM2NBAe4g5dE0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUOARiBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUOARiBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703F1C4CEE3;
	Tue, 17 Jun 2025 16:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177710;
	bh=LJe1UAnV7Izsco3pdnEk/mEcHUCEjmsGwlDQU0ajEqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUOARiBNFxZZAXQSZKq6XbpBC8hKzQm8+l2pMkLoTFCGKTLfblx+NkZFjUVUI3XPT
	 BUdujOuO41jjdOaYfN6T5eiB9NOKCqRnPuHPtmcc9qIAm7nVjSEH/mPM8oveLuiARL
	 oP0pwixNlkQ/BXd0ZQCXGNJEpUaRdD4L92NdhsAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 349/780] arm64: dts: qcom: sdm845-starqltechn: remove wifi
Date: Tue, 17 Jun 2025 17:20:57 +0200
Message-ID: <20250617152505.668145914@linuxfoundation.org>
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

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit 2d3dd4b237638853b8a99353401ab8d88a6afb6c ]

Starqltechn has broadcom chip for wifi, so sdm845 wifi part
can be disabled.

Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device tree for starqltechn")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device  tree for starqltechn")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20250225-starqltechn_integration_upstream-v9-2-a5d80375cb66@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index d37a433130b98..6fc30fd1262b8 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -418,14 +418,6 @@
 	status = "okay";
 };
 
-&wifi {
-	vdd-0.8-cx-mx-supply = <&vreg_l5a_0p8>;
-	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
-	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
-	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
-	status = "okay";
-};
-
 &tlmm {
 	gpio-reserved-ranges = <0 4>, <27 4>, <81 4>, <85 4>;
 
-- 
2.39.5



