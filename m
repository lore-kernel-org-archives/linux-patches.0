Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030612;
	b=fKrExfPkcosNvmax1w/ZL33KcMNI+jJxug89jfjlBdNpbLHcrTLyoO2vQ0K7sp9jHX+M
	 wcnZKY7i465Or3lmGW6YT4Q7VG3BTB+xQFzWrsOpjA5YSDQYh7Se+1YyN5FJ7z+MXS4Pl
	 qTG+zaZj2joqt0eJYoNDE/idwUr60kbd8ytki9ZC8eb7b0SiGoP1Svwpu4qQ4jFiwPp5z
	 gds5tX6mnoOw5IPNHoNCWTf+88W7He8m6uRXfxdDW2c8sOrc2M6Uq57FG/lASYdtTckw9
	 zafhJNBHRBJ4KQ5IkMKQUf1+6stblp+kufLQvxzF1OKA1qrDHIBrnCu34dZ9j6YzWQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xxvbBdZhw86rtgC/9//n2HLk6sRCGu2XDH1WN7rzSa8=;
	b=SYbf2SXQMgvhXbi+XEbvdqsjFEhAlR3UUOwQ60nLsMw29mhyat2Fj2Xjiji2vw1HZc7n
	 ld01gy2BjrhBXn5lZAsRATexq82kX1JvX1Ffi35GZj7S07ncQuBnYP/MHderdrGz/sf/g
	 Do1jGN/aXbbEo9UHFHtuOrq1ILChgzJ3Hwy7Svi4Vkw1gMn7RxpjFntc3gJC+nW7eqTxr
	 mItyMrTxa/WO/tGXyJh7b/XPwz4XAC9Hd7ftrykyrSdOXy2OLI0i/aNxvSpl/OvC+QBXS
	 zTDFBxb4PuyQF4Fe6xoUHvlTAYKwxKlBo0RIL4dTzkD2+lH8cBDljHSWe60LKc1ZtAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3z202Pv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D57606E7FD;
	Wed, 18 Nov 2026 19:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3z202Pv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456BD1F000C4;
	Wed, 18 Nov 2026 19:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030612;
	bh=xxvbBdZhw86rtgC/9//n2HLk6sRCGu2XDH1WN7rzSa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3z202PvHRsvfaFwIH7rjgjCKzzDmYAcXu/djDYEaHHMLz75gRB7S6rRxhejN+oMj
	 aCFnEnhN+MhykSe2yvwLI0N7PKXISt7ABFJ/YebGVq2DO6aDom5PghgToYQxhMj+nE
	 hJI3+hw/9hsidhGwV8Pd5W5Du9WO4jKyCO+WzNjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Igor Velkov <iav@iav.lv>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0766/1756] arm64: dts: amlogic: meson-sm1-odroid-hc4: run the SPI NOR at 40 MHz
Date: Wed, 18 Nov 2026 15:48:13 +0100
Message-ID: <20261118150040.122182451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 68d0bf032efd4..b14b713414f73 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
@@ -132,7 +132,7 @@ flash@0 {
 		#size-cells = <1>;
 		compatible = "jedec,spi-nor";
 		reg = <0>;
-		spi-max-frequency = <104000000>;
+		spi-max-frequency = <40000000>;
 	};
 };
 
-- 
2.53.0



