Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708B7155725;
	Wed,  5 Feb 2025 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767208; cv=none; b=IXUeSJg2CdgMYVtq2KL+NfNdzbgt9R5CB4l0NQ8CX2XiNWRC7b9CGKzwIZGKn0i4JSKMCdXbsbOyxWICF0GE/cxT1QF45YXcUxR93D66aQlcm+ufJoqc7p0+mb76dC7csH6DMBnPRHJ4EaLqvJBdB0x4gI2CuZ++yhQjivJ17Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767208; c=relaxed/simple;
	bh=t27KmhzJMaQs1M80wqTHgBWKQT5ambGQtkR3X9812IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVE0votXxEj/IO+aAapFLZmNKwfGcdz5xnHsj6kTlH49Ks3cCpEoP4eXfpgIsDULt+eoHHCg06e6fjX7WdckLrNrU1ffJdRHukcCo/zHxXBmaARlzOFRwQweIFErNEjlKAHEaEb24chR+Nlsuurqrhbfv9xtzAU11VMTZoVJ8aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWLJfk/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWLJfk/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0927C4CED1;
	Wed,  5 Feb 2025 14:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767208;
	bh=t27KmhzJMaQs1M80wqTHgBWKQT5ambGQtkR3X9812IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWLJfk/s10gDFcZ8aNzXZw4oBhe7UQp5kse949TrViunmUnIj51gMSFqH9RKd1eVQ
	 xyIkxcK/jrsMknYPIfwcbVucp6A24hh14PyaXStVJoCa6XK/VsOptcMzWMeBCJHcwS
	 +eDmxOl0+8opIU9aSKYbW3VVzKUayeRDcNHbLWew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Burton <ross.burton@arm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 372/623] arm64: defconfig: remove obsolete CONFIG_SM_DISPCC_8650
Date: Wed,  5 Feb 2025 14:41:54 +0100
Message-ID: <20250205134510.452017520@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Burton <ross.burton@arm.com>

[ Upstream commit 9be2923ff9641d6491b8ea43791382966505435f ]

This option was removed from the Kconfig in commit 802b83205519 ("clk:
qcom: fold dispcc-sm8650 info dispcc-sm8550") but it was not removed
from the defconfig.

Fixes: 802b83205519 ("clk: qcom: fold dispcc-sm8650 info dispcc-sm8550")
Signed-off-by: Ross Burton <ross.burton@arm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241213-clkmaster-v1-1-dcbf7fad37b1@arm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/configs/defconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index c62831e615863..c6d6a31a8f48c 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1352,7 +1352,6 @@ CONFIG_SM_DISPCC_6115=m
 CONFIG_SM_DISPCC_8250=y
 CONFIG_SM_DISPCC_8450=m
 CONFIG_SM_DISPCC_8550=m
-CONFIG_SM_DISPCC_8650=m
 CONFIG_SM_GCC_4450=y
 CONFIG_SM_GCC_6115=y
 CONFIG_SM_GCC_8350=y
-- 
2.39.5



