Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049111;
	b=ZkriU1jBlr7ZPL8pXAiqVe0FZSqFKqDb9CNwGRy7WAEebXJI/ZFDVFyTmF8wArTTe7pi
	 cUJsthcUdUJjuX8SCwDVRjheK4AiGaZNfm9te0EqUHhUbtDBg3dZVu27UJ4Dtarm8zPuZ
	 dGAHldsXr4rz9+6Xtrw2ux9euydCYdRIpYEubkqltbZYuYgFkzr9Aol9rKhZcOW6UNsHA
	 F/Y5ERlJG4whsyVgcRUeWARTOP5/l0zZVjeG9b4Zq6Qgr7LdHMeCQbQO2mug8LY+3Cc5s
	 WTtUyBkjpm9dqCL8kSOiQf/0jq3jl9AwWEWbJt4xHMHBViEWYOycJmYvc5Hv8J2yKKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1UzgObiJWRazU8QH+hAAMP2HNn0uJufHm0RUxOA0vCI=;
	b=JgyQHmKqJ1h9Ceq64hbV5IXiBo79XgKoqzQkvhbn3xqS+nihhDRgcl+34su3y2vs06Sd
	 DjYEeEIizZNW3+51+dn6+Ap7ARsqTbPspDI6usR+qy2EAELc29R3XuxPFuQj4BBEUwM2I
	 id1qMMbAhxVg5oSz0p05CxkCoqcVhQFTQfrW6GmF0qPvU9ZAn9Oqy8V05OE9oO9aDtrjk
	 s9bugGr2PUjBmowkowUhPDOP8erh4U52lN6r06ljv/1ZDVEcFpEfjNZbKhoIQE7xxqA0p
	 8Tq/irPw/8uMdeApY3E2gkidDGwiv+HOIl7Ea7+BdhtNRpIhEjAO44jbPrU0HcnqseA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ijhU0j0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD1F606A320;
	Thu, 19 Nov 2026 00:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ijhU0j0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE66F1F000C4;
	Thu, 19 Nov 2026 00:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049111;
	bh=1UzgObiJWRazU8QH+hAAMP2HNn0uJufHm0RUxOA0vCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ijhU0j0lZNFWQerxw24kPwcen8J/1CRTKGxeUY7Htg1vSHHYyQpwcBrhNy/q7xl4
	 h8tZMGnQOo3oVRZdiakPIgGNYoCfdt2KshVYCpUKiLRnO7ItGnCpOorrq+0YAeBCFi
	 tHG0lpMCcM743RhOpxHkmgiYvb7lYQZEWhC2jZq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Igor Velkov <iav@iav.lv>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2183/2857] arm64: dts: amlogic: meson-sm1-odroid-hc4: run the SPI NOR at 40 MHz
Date: Wed, 18 Nov 2026 15:53:37 +0100
Message-ID: <20261118150320.004090644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

[ Upstream commit b44e2be772f866985cafdf90355285069ea68495 ]

At 104 MHz, reads return corrupted data: bit 0 of the first byte of a
transfer flips from 0 to 1 part of the time. The same byte read as the
second byte of a transfer was correct in all 100 reads. One 4 KiB block
read 200 times came back wrong 157 times. Writes are unaffected.

flashcp verifies while it writes, so a bootloader update erases blocks
it should skip and can abort halfway, with the flash half written.

The Hardkernel vendor device tree for this board uses 40 MHz. At 40 MHz
the same tests pass: 200 block reads with no mismatch, and 14 flashcp
runs with no block erased.

Tested on ODROID-HC4 with an XT25F128B.

Fixes: 7178f340e929 ("arm64: dts: meson-sm1-odroid-hc4: add spifc node to ODROID-HC4")
Assisted-by: LLM
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Igor Velkov <iav@iav.lv>
Link: https://patch.msgid.link/20261002-hc4-spi-nor-v2-2-8366a4f91049@iav.lv
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
index ffd2aef45617b..22e7bdacd85bf 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
@@ -134,7 +134,7 @@ flash@0 {
 		#size-cells = <1>;
 		compatible = "jedec,spi-nor";
 		reg = <0>;
-		spi-max-frequency = <104000000>;
+		spi-max-frequency = <40000000>;
 	};
 };
 
-- 
2.53.0



