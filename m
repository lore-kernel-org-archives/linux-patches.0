Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6828760887;
	Tue, 23 Jan 2024 00:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970944; cv=none; b=B/Oak9PFN6Tj4Y+4/r9vRzy0Ux+XnBfkKcfACJp89cMjgCsvjqauXLdYwW63dH3sRna+1DDjiSRC0JsZ/Ja0WJ81UW/Pj6v+UxfNRQTDZ7HH6h5GHrbyGbSnq0WKWb5M+7AO1hVia/F5YcBo+jdws1wvGa7Re78CJgaps3SdX/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970944; c=relaxed/simple;
	bh=mVw0bpTvq/x/ZrG8rNKoQx3B1IuYcc+3mgWwJqc0Iuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7CIuoIhhyEq1Y6kVgVXrK68ZerDWGf6IRG8ag9vpaqTnc9MVB2XCLxB6HrPrVt/TxzM5n8xw/mzbZeTdX4HmropwQKTu76Cdgc+/2isW6vc8tjB3xqcU5pD72cgS6ROdpcVaHF8/HI/snuxyI2k6yFsvHFtRalEHkpLqXHFl0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmsoNDyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmsoNDyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A232C43390;
	Tue, 23 Jan 2024 00:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970944;
	bh=mVw0bpTvq/x/ZrG8rNKoQx3B1IuYcc+3mgWwJqc0Iuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmsoNDyD2uQI/iX/P0tbX3TwX1JLcjHPFrb5+0kyhfb2GYEV8ZyExzP8awf+6wYlK
	 jWnfBUCSdRr23qJx6VgSxQsMYTF48UDHXSdDt45FMUrSoHf7pQwsPG/L+ch4X0GkVF
	 HZA+jEuxtOQjAY3pOafABzksWLdHeMP9y49h5dTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/417] arm64: dts: renesas: white-hawk-cpu: Fix missing serial console pin control
Date: Mon, 22 Jan 2024 15:54:42 -0800
Message-ID: <20240122235755.717511677@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit fc67495680f60e88bb8ca43421c1dd628928d581 ]

The pin control description for the serial console was added, but not
enabled, due to missing pinctrl properties in the serial port device
node.

Fixes: 7a8d590de8132853 ("arm64: dts: renesas: white-hawk-cpu: Add serial port pin control")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/8a51516581cd71ecbfa174af9c7cebad1fc83c5b.1702459865.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi b/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi
index 895f0bd9f754..541b1e73b65e 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779g0-white-hawk-cpu.dtsi
@@ -125,6 +125,9 @@ &extalr_clk {
 };
 
 &hscif0 {
+	pinctrl-0 = <&hscif0_pins>;
+	pinctrl-names = "default";
+
 	status = "okay";
 };
 
-- 
2.43.0



