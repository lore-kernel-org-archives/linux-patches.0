Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4145430FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD624C433C7;
	Wed, 20 Sep 2023 12:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212945;
	bh=G3b2wGdFkgGKI0oayS/Qaz+kVDhMzG1W8wqevEfcplM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWywWYRjABBnDoH2WcXJL130G6pUUpvP2hGbRIjqoK2pPLNcbrhRG+EwCw9eNM90a
	 xo23e+KsyNDNtLst7xjjI2cqvknNLsxANNSIHNB/DHp+yoCGv7AUu9O1+LPFt1bWrK
	 Ujd+7IiZaovy4R/B4IBS7fwwavgub5vsVtOIONv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/367] ARM: dts: s5pv210: correct ethernet unit address in SMDKV210
Date: Wed, 20 Sep 2023 13:28:01 +0200
Message-ID: <20230920112901.270754244@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 28ab4caccd17d7b84fd8aa36b13af5e735870bad ]

The SROM bank 5 is at address 0xa8000000, just like the one put in "reg"
property of ethernet node.  Fix the unit address of ethernet node.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200907183313.29234-2-krzk@kernel.org
Stable-dep-of: 982655cb0e7f ("ARM: dts: samsung: s5pv210-smdkv210: correct ethernet reg addresses (split)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210-smdkv210.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/s5pv210-smdkv210.dts b/arch/arm/boot/dts/s5pv210-smdkv210.dts
index 1e1570d66d890..7459e41e8ef13 100644
--- a/arch/arm/boot/dts/s5pv210-smdkv210.dts
+++ b/arch/arm/boot/dts/s5pv210-smdkv210.dts
@@ -39,7 +39,7 @@ pmic_ap_clk: clock-0 {
 		clock-frequency = <32768>;
 	};
 
-	ethernet@18000000 {
+	ethernet@a8000000 {
 		compatible = "davicom,dm9000";
 		reg = <0xA8000000 0x2 0xA8000002 0x2>;
 		interrupt-parent = <&gph1>;
-- 
2.40.1



