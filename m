Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FCD1684B0;
	Wed,  5 Feb 2025 14:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766609; cv=none; b=urtUsPH5Hn3RnLcAISMX/lzjd80bIwVD9ioYwvSMBVUjEB2be2DNvepqYcSDW1fpvZbJfvVUZUHID9i/EdiQuuVFFq/3+XMg0VfgdfW3XRyQVuoCgcnNSOj0t3m+/XtbQzBhMYWSTolxrKSQCugdwD2NAqICf8WVHA7K3s3VPzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766609; c=relaxed/simple;
	bh=q+BXet4NAClAhK7g7RutEheia3jm/RYDd64udsqvsXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuY/h/9F279que14Igy457HxKiK9/G8PqPApde/rKG9dZ6OuC0bGsGCa2My602VDZ4DURF/mfUAKZ0v1hSUmV4WZBZ19rFIj3rqO7o55UjQE0jz89P8DNIHesiNExwhqnkUgm9l5FsgT6Lzaf54qfZ4WQBnVT851nrk8+4LTIcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAOJjB57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAOJjB57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31337C4CED6;
	Wed,  5 Feb 2025 14:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766608;
	bh=q+BXet4NAClAhK7g7RutEheia3jm/RYDd64udsqvsXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAOJjB57wXFVUlLSKHF2h56e2SM9z+VZWfkaC6tpFLU6GbDL4/nEwJPZfng9em8TK
	 lJnI6lHbXLH5pe2UXsowl0/S//WRc9v1urui4Km+NKWROYBOBg9FSGbOs+KcNwwoTZ
	 0faOtzDlD67dVtYD3uFSljTwggHAH2qWfirCL0nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Burton <ross.burton@arm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/590] arm64: defconfig: remove obsolete CONFIG_SM_DISPCC_8650
Date: Wed,  5 Feb 2025 14:41:34 +0100
Message-ID: <20250205134508.244097599@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index 5fdbfea7a5b29..8fe7dbae33bf9 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1347,7 +1347,6 @@ CONFIG_SM_DISPCC_6115=m
 CONFIG_SM_DISPCC_8250=y
 CONFIG_SM_DISPCC_8450=m
 CONFIG_SM_DISPCC_8550=m
-CONFIG_SM_DISPCC_8650=m
 CONFIG_SM_GCC_4450=y
 CONFIG_SM_GCC_6115=y
 CONFIG_SM_GCC_8350=y
-- 
2.39.5



