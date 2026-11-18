Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055032;
	b=B2UaAwE5zM+pUicoc9oinR9GiRP6srRcDOvxXftkCMLrTu8K6QgSyrxwXLxWRai27KoE
	 HxYbaaURFNxEDtr6urldW+lSgj6CRWIzDF7iLT11MTES141SGvKbcObSULV0hJi1e7v0t
	 xZpm2mkXMtxsihNYs3RBAkpMDfpUwuiHG+LPlAYuae53g9fIvMeOc+SkNNS4Q65gR5ZXT
	 eV4/VZBIq+aWSz6vzkJIA85pNDCF9/Y8h3gzJaqGeV3SGhVAeOtwnwMNn/2RQqC3yrNuE
	 dBXFf9x1Kcg2KI1y3qpUV1KWn0h4PC3BWha1ViwZIXtkCsTW9iFw6b1pB2mjJnwu9/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W7fqV7P3v1pGN/aGGg0jgdZUY9uf9J2l7DaFbti73bg=;
	b=YMrxvdsR7B7sjawcxZfPSP+ipcqpZg4D9iAqLEBzdS2MMDch13Nf/mn8zcZ31oxWWQeT
	 G3NSfOEim/m9jj5vSiEdWv3WSpbh6o60BnGbeL3Yo1q5rCTlGX0n2NYaULrgAIusMRB29
	 OwOf9Y/T+XrxJ9RxC6bt622DbT59Md0LpmYesZJlHeMkK8Ruz3cBMdo2FF9S4FOCWOm+k
	 OFyZIXsA9/KMXkssI4J01P0x86wIWPDV7iEW0cGvnjzisiHngV5WSu6v1QGAH5YefX6r1
	 zslianMUIVQneGuo6YGyXOFTl0UHkNMtKjAxrTE89jRi5igIQJq2ZViiWDtUA7Qw+og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zWLe5Pyr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08667606A32C;
	Thu, 19 Nov 2026 02:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zWLe5Pyr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B551F000C6;
	Thu, 19 Nov 2026 02:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055031;
	bh=W7fqV7P3v1pGN/aGGg0jgdZUY9uf9J2l7DaFbti73bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zWLe5PyrumIhTl6bNLsZ70xSOB8XxGaTahmOry66v5AGSeoJUqsn6tI6p1G1fD8Ac
	 4P+y1TkVl9sh4HmRKaTzgSK4mKlNcW9KDYe/YRGjonvxB0JI+R/hq3LmSDqtkA/EZx
	 uz5BulLXu1ic08cMjOPqKPupB4pQ0+rFfTJf9Mco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1486/2214] ARM: dts: stm32: Drop bias-disable from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a
Date: Wed, 18 Nov 2026 15:52:42 +0100
Message-ID: <20261118150110.665476982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit 3572825773791f4258b553391f4e2187df321731 ]

Drop bias-disable property from STM32MP15xx DHCOM SoM sdmmc1_b4_pins_a
to fix the following DT checker warning. The bias-pull-up property is
the only bias-related property that has to be present in those pinctrl
node subnodes.

"
arch/arm/boot/dts/st/stm32mp153c-dhcom-drc02.dtb: pinctrl@50002000 (st,stm32mp157-pinctrl): sdmmc1-b4-0:pins1: {'pinmux': [10253, 10509, 10765, 11021, 12813], 'slew-rate': 1, 'drive-push-pull': True, 'bias-disable': True, 'bias-pull-up': True} is valid under each of {'required': ['bias-pull-up']}, {'required': ['bias-disable']}
"

Fixes: 7cd8567d988a ("ARM: dts: stm32: Enable internal pull-ups for SDMMC1 on DHCOM SoM")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://lore.kernel.org/r/20260828150111.173089-1-marex@nabladev.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index 8c41f819f7769..39503921b7b6b 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -481,9 +481,11 @@ &sdmmc1_b4_pins_a {
 	 * - mandatory on SoMs without SD voltage translator
 	 */
 	pins1 {
+		/delete-property/ bias-disable;
 		bias-pull-up;
 	};
 	pins2 {
+		/delete-property/ bias-disable;
 		bias-pull-up;
 	};
 };
-- 
2.53.0



