Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040618;
	b=uRtShZ2oE8n8vs8BBePITT6XvMxI8ImU1qD75WVJ5OiB0xg1EWTiHBjriRDGWsnQfPAM
	 N6UM7S/egeVxpB/tp+hf5MeeuqytCUz4yjHLBvDg25T+BKpG8/vhfQnFt8xjdL2580LUx
	 EPebIu22QLwOCW7jU8n6XGPdeQT9E5LQS2aX6eKlg7kxDlRURvT0N5ng9BZnnJxg9csM+
	 YmKLbgS9CuCUCv3AiF1y5GJpubCOQfPsKfUPl+ZqmfeSPK1rrrlIgUElp0oBTZuckgZEj
	 Itxf/2CQzsBAK3sh5KljpYv8tlExo3ROXU46loLVcBJyc8vqUNuyuEyppbH5qo0qCuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x3ko3KHp2rnITQUXH5tuQp8stAGBZr0ATiUwjPyGAjs=;
	b=f2n+HssMFuX0eE0o7SZtCKz3grBm2TM4aibJGg5qk8EZqdpS8JXNa/sNt5wZ7DCXIwI+
	 pE3JAADw4idPi1DJpRaehVv29RQ11vAAAGv8oexYmmr1C40ywJjRua0j3uj1axHGJAH11
	 2ClBcFrmbX3N3r3M1Sy04rFrSIRD1qMM+DLrmYmvqpdwTOCt5edXrSeXBE/bUWziT8rf4
	 Gv11DKC7wLgQGjOoQK4Uwq1BGUV+lXtzdihBDGU0khVJxJrLIlQs9licwGqGoOkQDZQrz
	 76jAJvxklvRqO26W7fGvQKJMbUQ+PIJLlU5NSJDVvPD9p3AkaZE7851YqGMVPzQcogA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1cXgG20;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F3460A2604;
	Wed, 18 Nov 2026 22:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1cXgG20
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF7B1F000CA;
	Wed, 18 Nov 2026 22:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040617;
	bh=x3ko3KHp2rnITQUXH5tuQp8stAGBZr0ATiUwjPyGAjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1cXgG20FaRLYFZjeEhoWOVew+hGU8kbM+q2jIdFgEcmzKIsRRoG+1GRjyZa1EYLd
	 NuwOrXhdV4yP9iBZcuWMEmMfFyQnvn5+7v2TheI40O8zqTNa7rcfmNAZv3ndGFxsz2
	 7xQos6OwZuRLWunAKCrAe8/9pKKUGOZpLmwagfzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Igor Velkov <iav@iav.lv>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2521/3318] arm64: dts: amlogic: meson-sm1-odroid-hc4: run the SPI NOR at 40 MHz
Date: Wed, 18 Nov 2026 15:52:23 +0100
Message-ID: <20261118150436.993534523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dd29856a49f02..dd4f49cd4107e 100644
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



