Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEA7157050;
	Mon, 29 Jan 2024 17:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548326; cv=none; b=Hu7YwVzBEXnMhIXZ3+luYKQJxxwhZWBjBptJCmTM+I5aX5EW/WojG5q9AjCKfVbcRpNmINHb6gvq5jM9CthRMgTfUHnFxb3GmtPqDM3msiQiD16F71acTQ0ijA+k7bEzpTh5kSIGB9GfzIyMQoJpKbhxq53Uzx2IqjMEa2/not4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548326; c=relaxed/simple;
	bh=yKMNwnZ7gAFlGtaU7XttzNMbr+YVCktR4bCty6wYPcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXxXRLnYy1Sar2Y8XxEzKE6bvkDh9M6+OUXv0tIzMR0QgAUvwPs3i+yfoi6H9MYKF/xtAiuuN/6eXkyXX2t95IwH7xFqIWB9HbkXeQfo2mbrm0ltmCB3W2mWJhgugYzPqqpSxF2eFUOooszZaoB+LpMQ+uUtwQYuel17w459YG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3klMUrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3klMUrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077BCC433F1;
	Mon, 29 Jan 2024 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548326;
	bh=yKMNwnZ7gAFlGtaU7XttzNMbr+YVCktR4bCty6wYPcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3klMUrsmTuokB2ykZexhgkhnUj2TPCmTPNFLcWJ9rIfnGKeZznlhSt9QMWUc1alV
	 n22knuZW6I19AL/3gVcx/uJlWKS3kOrndnXZDTeVaVt9HQ8kWG37fUko61McLdUMVW
	 gPLW1rNC/vRlZ2mnjCfg7oLzV3PtURm0//JrDM5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 326/346] ARM: dts: exynos4212-tab3: add samsung,invert-vclk flag to fimd
Date: Mon, 29 Jan 2024 09:05:57 -0800
Message-ID: <20240129170026.065577702@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit eab4f56d3e75dad697acf8dc2c8be3c341d6c63e ]

After more investigation, I've found that it's not the panel driver
config that needs to be modified to invert the data polarity, but
the FIMD config.

Add the missing invert-vclk option that is required to get the display
to work correctly.

Fixes: ee37a457af1d ("ARM: dts: exynos: Add Samsung Galaxy Tab 3 8.0 boards")
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Link: https://lore.kernel.org/r/20240105-tab3-display-fixes-v2-1-904d1207bf6f@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/samsung/exynos4212-tab3.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/samsung/exynos4212-tab3.dtsi b/arch/arm/boot/dts/samsung/exynos4212-tab3.dtsi
index d7954ff466b4..e5254e32aa8f 100644
--- a/arch/arm/boot/dts/samsung/exynos4212-tab3.dtsi
+++ b/arch/arm/boot/dts/samsung/exynos4212-tab3.dtsi
@@ -434,6 +434,7 @@ &exynos_usbphy {
 };
 
 &fimd {
+	samsung,invert-vclk;
 	status = "okay";
 };
 
-- 
2.43.0



