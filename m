Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025163;
	b=PlzVz3YzsrXUqojqsdWCkdvENzHbzuukR6QHjM8WH8cHwuWO2PUJQCfjm6nXI2wpn1R4
	 CPmGgMeiQBslAPXInlwDSbwS4oDeDmu+JNa8u1bLl5MBTLrbKrPFmnst4n2KuMDIzy3lv
	 bnv6ghFFh6mAMlEELmY3L5LrLS1PKWMprhWCraxYxKu/RxBE/okF7t6zLBnvTs4gk+edL
	 eQV093Q+tmP/2pujF0U+mjATwAVcxoTbBQZes5A3eqbECKdQNO2Ed3zLtC807Ye/mHb9C
	 hQ3WB9jcRc8N1klx2vjGMwhDf/T/RIUc3tp8B/uyf3fxllaSnzoAbzMTWtLkiuqCJGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hw8lnkjc+BTHLc124xinblJ5TRofYyvGtSc8w7UYTk0=;
	b=Pf5etIau/7G9dLhM46XqR0RGWr/ZrOWcNuYKHKSSH+QxUHZO7mG/PwT9wr5cyEpOQabm
	 KtX+0TCWZAR5nn7BlNLjUQiC9yPvLmzA00v1zFebp0FBoIwxmZs1SLIeULUNLSUX+Edpk
	 wyBjzrUk3mzhyJzqrbJHLd9jCsB0B/AAkvjuT9o71JvNlHwVTmM+NfoSyIkD9B9S90dmf
	 nyHRvbNkmGG3/UOwyPFOCm4GIIYxQFEKBiphMA23rzAaALW7KB0Z7GDVnPjbm9JZpXqaA
	 hQWKj3hDS3yTXFvri1EK9fG6l429m6Ngx7iA3As4JEH+++O15la/gx7TCyir661tKqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCLb22PK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D37C606A32A;
	Wed, 18 Nov 2026 18:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCLb22PK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F681F000C5;
	Wed, 18 Nov 2026 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025163;
	bh=hw8lnkjc+BTHLc124xinblJ5TRofYyvGtSc8w7UYTk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCLb22PKC5QeacKG5KeE+WoUeETV1sQ2lL9gO/z0oQ5rCGO9JHGXns980GHRJFdqa
	 bb0yGbfCNLzZW3B51qlXgA2rkSAbdfXfwu10G5I+ez40NAeOcq+KhQ4u/MSiHhYou1
	 yOunz67jXTn6DLbvkcDVuZ/hbMlYbc4dJq/j+btM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Igor Velkov <iav@iav.lv>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0983/2151] arm64: dts: amlogic: meson-sm1-odroid-hc4: run the SPI NOR at 40 MHz
Date: Wed, 18 Nov 2026 15:45:18 +0100
Message-ID: <20261118150158.290618843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



