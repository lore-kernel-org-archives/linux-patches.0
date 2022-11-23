Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98981C33
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7BFC43470;
	Wed, 23 Nov 2022 09:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196626;
	bh=WQgWoIxcMvvnZZafRCxtiN5LFqGHXRKys8eheEvIfWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpdTSBoxDJt+yR/Dul1x7Y9PDpydmAWnmYSRu0SYbygM/4PQnUZ2rZ5iTr92AQoCo
	 5uWSvdHoieoBVekI4rX6stPxu7hdcJ+3NrXbuMtUXTay+cjrHwrQladoBLIq7qKyNA
	 75TeUCzqGdEVCdmXVpwPbYXEgnmRvMhSx462JUtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 6.0 084/314] arm64: dts: qcom: sc8280xp: fix UFS PHY serdes size
Date: Wed, 23 Nov 2022 09:48:49 +0100
Message-Id: <20221123084629.273553742@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 8703d55bd5eac642275fe91b34ac62ad0ad312b5 ]

The size of the UFS PHY serdes register region is 0x1c8 and the
corresponding 'reg' property should specifically not include the
adjacent regions that are defined in the child node (e.g. tx and rx).

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Andrew Halaney <ahalaney@redhat.com> #Qdrive3/sa8540p-adp-ride
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220915141601.18435-1-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 2a702abcf51e..6d82dea3675b 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -885,7 +885,7 @@ ufs_mem_hc: ufs@1d84000 {
 
 		ufs_mem_phy: phy@1d87000 {
 			compatible = "qcom,sc8280xp-qmp-ufs-phy";
-			reg = <0 0x01d87000 0 0xe10>;
+			reg = <0 0x01d87000 0 0x1c8>;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			ranges;
@@ -953,7 +953,7 @@ ufs_card_hc: ufs@1da4000 {
 
 		ufs_card_phy: phy@1da7000 {
 			compatible = "qcom,sc8280xp-qmp-ufs-phy";
-			reg = <0 0x01da7000 0 0xe10>;
+			reg = <0 0x01da7000 0 0x1c8>;
 			#address-cells = <2>;
 			#size-cells = <2>;
 			ranges;
-- 
2.35.1



