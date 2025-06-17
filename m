Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21772DFF2A;
	Tue, 17 Jun 2025 15:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175277; cv=none; b=EY/l0jYPm9cw59Xgjk28VraHWKq6bBoItn6o3R31Cd7wfieWCPPZWWyZe8Wiz/0G8Sbs3cIyX2yYTIgiDh8LLTEIDw6JdkxEBC2kyphdcHl9ySB3UYyU6Do0CrapZHSKGYfwfa/uW6ccq0gpez+ooZd/rgFykq9/CdhFLRnpyoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175277; c=relaxed/simple;
	bh=HNvDORzfiLhn4SBh6CJ7qyvsLofssKmZeAQYMM8qFLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocGsYdJmjpYn21T+8FNR5fGRoPAdlQp2mf1PT3ZyWIknyAFhdBE710mCrq+6FkT+qCbvDYy7PEUmrbWx3yUk6TD7JpF8fji7MXlpRd1IYQ0M7tKZ6uvrQBn6vbaUUS7RQ/LjzzDt8WzB2+XKWAa+CwDi2W4AQ6o54hgtEV4WJXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AVYNz9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AVYNz9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30777C4CEE7;
	Tue, 17 Jun 2025 15:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175277;
	bh=HNvDORzfiLhn4SBh6CJ7qyvsLofssKmZeAQYMM8qFLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AVYNz9Vm5HJdEePylBkRvHhZGHSRPdiOovCxH2muWJbWzsumFvZz5aGuS4+/hCMT
	 EQTrXHBzJmGhuTn25eMe4rRlEBX74iHA4W3A+/bkOXdsPUS6fFmHLLVdR1+Xagy9ay
	 fCmr2AkWOHTo5JZW7DLdfowv1cSu84+jCGxswMdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/356] arm64: dts: qcom: sdm845-starqltechn: remove excess reserved gpios
Date: Tue, 17 Jun 2025 17:24:35 +0200
Message-ID: <20250617152344.664191464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit fb5fce873b952f8b1c5f7edcabcc8611ef45ea7a ]

Starqltechn has 2 reserved gpio ranges <27 4>, <85 4>.
<27 4> is spi for eSE(embedded Secure Element).
<85 4> is spi for fingerprint.

Remove excess reserved gpio regions.

Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device tree for starqltechn")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Link: https://lore.kernel.org/r/20250225-starqltechn_integration_upstream-v9-5-a5d80375cb66@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index 8a0d63bd594b3..5948b401165ce 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -418,7 +418,8 @@
 };
 
 &tlmm {
-	gpio-reserved-ranges = <0 4>, <27 4>, <81 4>, <85 4>;
+	gpio-reserved-ranges = <27 4>, /* SPI (eSE - embedded Secure Element) */
+			       <85 4>; /* SPI (fingerprint reader) */
 
 	sdc2_clk_state: sdc2-clk-state {
 		pins = "sdc2_clk";
-- 
2.39.5



