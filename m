Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211126;
	b=meTBEporoDfWhsvu5E408dAfnPfFCQhtOJ7gP+9YkKaK2I8ayYiDLhfp+82Fje/UtHFm
	 2IojcOLFWCr05NsHf5MnRkVv1xmdoDmMGcO/2l492DFuIuNC7jxqVXtqw4HJsAUbNlWPJ
	 WBETN7aDU4kqiBqUzmSzsdsSgGvkgsy/juQCVmOrWVe6sXzPzPtPegKzlGBeoOouhjZzy
	 RJAbYKBybubSlsW47oehxsZRZiZl4Rxw3O6VdwvytQe4MsruW9LaMPChbsY3GnOB7grVj
	 mq7CnCNOd2C+nO8kuQlQYLAIg6fW8APdwkRSVNMcab8J/8Umk2Frw8Ef1CQy4tc+TZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m7akp7VlxwhUdzJ4zg4oBqEPOcV7OizcKc6+KrlWQ9c=;
	b=UOlxCpaHCYfMVX+w41uuWP6sp64mZh1oOqmGXHEz9qDCLo8q0gYaECmWeJPg5fimVPhj
	 xwDOb2seJ/8YW76sEQ5xqvNelnt31zdlVYQkJNIIMaUkdnP5HJx/mXHn7FceY5qx5d9CQ
	 eLoYAIuavirWUIvNbcHnbJtGUKwBHWrY/VrJH8szo/OpSwkankJA5caGa3nI4IRTSJ+Tc
	 e0aMMZOJmfqE/JrYEE5I6sBKgef71wqv0DUvGridr84Hiee8vDIALmY+9xXmqLrIeBXrU
	 +0vtdh74GZvzMu2BgPae/pMhcl97KN0ApLip2P7MQWaG1wNDHL1qJDLQ3U4VqiV84Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KV+5D2xY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C8960A6F62;
	Wed, 28 Oct 2026 18:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KV+5D2xY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573D21F01829;
	Wed, 28 Oct 2026 18:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211125;
	bh=m7akp7VlxwhUdzJ4zg4oBqEPOcV7OizcKc6+KrlWQ9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KV+5D2xYvYIZo6hOwp+xSLJMjZshUyoLnM1PiHLygUm9/XQcddVir+E3tkyeDmW7u
	 C9nyssv1I8KCBFTDh61uww88fTS3X+m2jVVcDq6wTQIWPKqZzk+vfs9Y2YJDjElQdh
	 ygpOdJffi1a87QriJTOvDn2dGGJY2pco0nHqZFTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Connolly <caleb.connolly@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 266/571] arm64: dts: qcom: sdm845-db845c: Mark cont splash memory region as reserved
Date: Wed, 28 Oct 2026 17:56:53 +0100
Message-ID: <20261028170014.315085326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index cf2df9e2ccf30..798c566674f8b 100644
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



