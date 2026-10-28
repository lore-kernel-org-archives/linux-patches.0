Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208796;
	b=ceqJPI4LPzko1UV3DdIeA0oK8QNvccIiqHF6qCdd5Qrn9uW0yl/WMmyLHKWkI+ev0jKO
	 uWVvW2i7LyJGVqHPuq/TeuvvJ7LOeZMaA5bicH5+SpDoh6jF8V1ilve/VKgOgOtn96l9r
	 OAB59HTBv/vpQejHWqr4fd4JE4CqGgiU4p+N3CVeM++y5L3LxfYjOlP7jNyxOFSTsL/0P
	 ye1XVqCd0NGdcPoNEl9O/EmLDjCEbPOS2bumZ8J0+APB54Ha8NGicNAL7wOZbJsGcwy+8
	 pm8kjxAIIHhuFYHb+GP+pB2CRua28wafXPS8xrpUlzvN1GwuVr7MfSLMajgFevqNtXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oPipVxR6ziUbxIy+l9U1ITPU8ZCD9X3yA42Jd+bus98=;
	b=nA0nC6OBg6rClohQtDFm6kbnq/oh2RtbZWPGottMaiaUqyT4G7RFlyZ3ZYhZcD2qkkFZ
	 lNP1LfCwOouYEnNncKoyk7TUJYBobJtZCYvEu1A09D19yVLphn4vRruBvjD5O5UpJCEC/
	 9IZAtPdcD549Wwt0bx4c6ZJWSbgEkwCbSabh8ddGdFXwheMaGAQsE8DNQVXDOJ+JwFxvz
	 3E2hebdDfl6HHWQyh0mVsqViBCRtIqh0pt2pq5ACR/pv4PK5rF7lTQWSlKJ/16xbUAyVg
	 b8xGcnEPToKaozZ+z4DEKgs4d0NqJSmFrCMb3PBhbwYW7Ua4/Gy0GPDEXnCdb/sYlTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l22cvLrf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E7A606A31D;
	Wed, 28 Oct 2026 17:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l22cvLrf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402301F01825;
	Wed, 28 Oct 2026 17:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208795;
	bh=oPipVxR6ziUbxIy+l9U1ITPU8ZCD9X3yA42Jd+bus98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l22cvLrf0gnKSZ4WTxnG94JT7Bcarb9C7g51o8gLyQjY641qh6oEsaYYHwcmZPlin
	 mS+waGqaMeSCppDBYlEhL8ksAqb7KlQfmMcD8Mcuexn4klPzvuekrHTuEydsc70kA4
	 ok76xg4ab/jB4YZl8VlwbVlGQxx8oBKhy1nc62UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/516] arm64: dts: qcom: sdm845-db845c: Mark cont splash memory region as reserved
Date: Wed, 28 Oct 2026 17:56:38 +0100
Message-ID: <20261028170009.325636557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Pundir <amit.pundir@linaro.org>

[ Upstream commit 110e70fccce4f22b53986ae797d665ffb1950aa6 ]

Adding a reserved memory region for the framebuffer memory
(the splash memory region set up by the bootloader).

It fixes a kernel panic (arm-smmu: Unhandled context fault
at this particular memory region) reported on DB845c running
v5.10.y.

Cc: stable@vger.kernel.org # v5.10+
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230726132719.2117369-2-amit.pundir@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index e327e398d99ed..2af8c37be459b 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -85,6 +85,14 @@ hdmi_con: endpoint {
 		};
 	};
 
+	reserved-memory {
+		/* Cont splash region set up by the bootloader */
+		cont_splash_mem: framebuffer@9d400000 {
+			reg = <0x0 0x9d400000 0x0 0x2400000>;
+			no-map;
+		};
+	};
+
 	lt9611_1v8: lt9611-vdd18-regulator {
 		compatible = "regulator-fixed";
 		regulator-name = "LT9611_1V8";
@@ -488,6 +496,7 @@ &i2c14 {
 };
 
 &mdss {
+	memory-region = <&cont_splash_mem>;
 	status = "okay";
 };
 
-- 
2.53.0



