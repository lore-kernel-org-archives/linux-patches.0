Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F339A4C97;
	Tue, 11 Nov 2025 00:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822576; cv=none; b=WSDj3E+RWMTwxN5MkmZCik44AKK5d1EO8dLt70wEQhPkK6iKypXaPHYJAti0bB4Z23l1AUEltyg+ak9LspB7VX3MkyQI+hirvbWc4j9sj3YDZb4fpLmL55XlcwJ93KuHc/VboGOS47rpYYtx3qJnDhsa6KxWyBKm5/25iOZXFP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822576; c=relaxed/simple;
	bh=KS6j4HDsgB+RFDksp+DxnRiGuOtws83aNLGBe/Zdfuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YREJwiOa9U16PrfQPynggmNZ1umzEHBY+jdJG8Lf9TLAhR1gmSTFVxbPVex7lCXkfyGC9q+InmKYBhzDvhERFkvtPtZk/UquOaFlsBfCVB+E2bKGfHj12JOSS8Q57gKJJPYiF8n/H9b8SZdvwPkEf1/bbcJjdcAd3Shj+6wwBDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YU0sC5KL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YU0sC5KL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D518C19422;
	Tue, 11 Nov 2025 00:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822575;
	bh=KS6j4HDsgB+RFDksp+DxnRiGuOtws83aNLGBe/Zdfuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YU0sC5KLfJObrBfrdvmC0unceERuL4/SIbrFssC38BYRBiYOO11qEZ3KgVytfkhwG
	 GmLhagkGr/RIMyDkc8w7mExSzYHTQi80xz4YVw7sQLzTSNV49BhJRBor3aJizntENS
	 KXog+e1iMxNeQhUO7500QTwxcJkB2VQQu3Q2LMEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 140/849] arm64: versal-net: Update rtc calibration value
Date: Tue, 11 Nov 2025 09:35:10 +0900
Message-ID: <20251111004539.780468134@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harini T <harini.t@amd.com>

[ Upstream commit b60b74f82e3ed4910a5f96a412e89bdd44875842 ]

As per the design specification
"The 16-bit Seconds Calibration Value represents the number of
Oscillator Ticks that are required to measure the largest time period
that is less than or equal to 1 second.
For an oscillator that is 32.768kHz, this value will be 0x7FFF."

Signed-off-by: Harini T <harini.t@amd.com>
Link: https://lore.kernel.org/r/20250710061309.25601-1-harini.t@amd.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/versal-net.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/xilinx/versal-net.dtsi b/arch/arm64/boot/dts/xilinx/versal-net.dtsi
index fc9f49e57385a..c037a78199670 100644
--- a/arch/arm64/boot/dts/xilinx/versal-net.dtsi
+++ b/arch/arm64/boot/dts/xilinx/versal-net.dtsi
@@ -556,7 +556,7 @@
 			reg = <0 0xf12a0000 0 0x100>;
 			interrupts = <0 200 4>, <0 201 4>;
 			interrupt-names = "alarm", "sec";
-			calibration = <0x8000>;
+			calibration = <0x7FFF>;
 		};
 
 		sdhci0: mmc@f1040000 {
-- 
2.51.0



