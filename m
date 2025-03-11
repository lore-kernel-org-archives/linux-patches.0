Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8D025DCFA;
	Tue, 11 Mar 2025 15:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706571; cv=none; b=Szxl188JMOUQCDKr2YILSXhc+Hr22Rp82HASgkjsQzgfXFbDLJiz9Nbl/FTTBUQix0KxgkvDBLrcIG+Qkb/HMXQQMKaYIYWKrWZiiMjDTxscOcuoztD4Xktgwsff5FG3JMSk8BEeryZKl+79x6u4S2zv2PorJFRVBT+iVRHGbSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706571; c=relaxed/simple;
	bh=YAXx8Zb2mEv523JFEhXoD80MrJ9IXGKshwukvALRT30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYzb75m+stp82QezruEzNZ6RkRYaELUdem9xwoDQcLVGFttZizqaLJTjXzr9UkWIJ5lkvzf8Tj4vchGOPobF3LGgDwHo5iueVfezTXI/DbpfpkEB/q76B5EHZZkTWZYeHvm+gkBHQJBLMshiEKU791CPHBWZD2+ejeILbnaSh7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5/VfDTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5/VfDTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30249C4CEE9;
	Tue, 11 Mar 2025 15:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706570;
	bh=YAXx8Zb2mEv523JFEhXoD80MrJ9IXGKshwukvALRT30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5/VfDTELfuYjzjxXxBbKPjgmtHOv79xVNZXhbMHvSUzhiJC63cUVa5c4hvNpGS5H
	 y3D3xhixVRi0Ax5r4cdPKnjPu/p3Ttt3Gb5bQueoPaD4uxmvJsYSzhQohQBp5tuK+j
	 jShq4mzmm95xqfFVzDAPTEWpbpQcbQfx9Da3jCLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/462] arm64: dts: qcom: sm8250: correct sleep clock frequency
Date: Tue, 11 Mar 2025 15:55:42 +0100
Message-ID: <20250311145801.352018547@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 75420e437eed69fa95d1d7c339dad86dea35319a ]

The SM8250 platform uses PM8150 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 9ff8b0591fcf ("arm64: dts: qcom: sm8250: use the right clock-freqency for sleep-clk")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-13-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index ec356fe07ac8a..025503ce88780 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -75,7 +75,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



