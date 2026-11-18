Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045196;
	b=arBwidTluKK8rSfLb0k+/Nb8Tsp5LS7R8qDVkcfii3SoGnMWADpzP6+A6B/zA23CRh09
	 1v8i6cE2hhRk/F4cd5JgORgw+9Fjo1u5xY2pAKa9KsT9+bzRvVSxqw4TTQzeWi0Nsaswl
	 yo45+OfXNQFYIGWsWO2NgiuXc86x575OsnTCXvcebG2r+v+5mCTrYko8RvOBZtsevwlM3
	 3sZIFAk+pbY+hrnOdU6HPeSSb/5ddXw3YHhBmL+1yFIRDIOCKrw0Z6b5D5U+SFHgUe8Jb
	 OUzlG21vP8RjluutZGdJHYxldxYM59tAwmQ5eI3BNao6ulMsoIdyjxVX+CPt0QeFPYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rCwi+MESQskoTmkx01gxerNlNXIR6U0OsI/bNPAxhpw=;
	b=ANk7DKMoUAjhUoMEHuXn2qaAyGmdSJE9pxlxrMXo6/j5YCY1suf2GgBYaZnPpwPvNFK6
	 VcWJ78HrWABDubSrE2Sfgg0oxiQqx0xHNB3uN5PDJyH3lEAGy5QiBD++gjr7nTeBqr/Gt
	 VbnTZ6zuyr0JvAoRHccQB1T60AhvdZ9j0Ak4gkwt6Uolx9ajSLZSUk85MVrbsUP6FpPdZ
	 WtgJxE4tv9wJBsOt9HIxFZ1Nfcl7NUzGKdOIK9RxfK4rxsM/kxnCHkd5/2wZCEfsR//x2
	 cB16CiiOWg9yOW5wbaJ2+ZlK+L0lZE+X45VCI0nwg6eQPFORwbK1NU9EmVjN/LJmigg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VjqI/+PU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85895606A325;
	Wed, 18 Nov 2026 23:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VjqI/+PU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4EF1F000C4;
	Wed, 18 Nov 2026 23:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045196;
	bh=rCwi+MESQskoTmkx01gxerNlNXIR6U0OsI/bNPAxhpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjqI/+PUYQRlOS8dvr48lAuUV7yJ2Sj6Kjgq7d110o6L7MCgR073+jgp2OiYF8nD5
	 iT7C1ngFmskONpPi8rAGAdp09ZnvT2xdbjhb25qIrA8A0z92yGuHpwvTRkXWD3WgMj
	 a006dVh8sc1UwAnk9YdXntpq6OOG9irOoHRjwQn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0834/2857] arm64: dts: qcom: sdm845-xiaomi-polaris: Extend the xbl_mem region
Date: Wed, 18 Nov 2026 15:31:08 +0100
Message-ID: <20261118150231.600661708@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 38458f12419f456b16385c118bcacd76899d99b9 ]

Xiaomi's Oreo-era tree still had the CAF 1 MiB region, the 2 MiB version
arrived with the Pie import. This isn't a board-layout quirk, it tracks
the firmware. The later XBL wants one extra MiB below the old region.

Cc: stable@vger.kernel.org
Fixes: be497abe19bf ("arm64: dts: qcom: Add support for Xiaomi Mi Mix2s")

Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260916-sdm845-xbl-mem-v1-2-6e3c88507997@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index 3eeda63989279..2cad70aad95b3 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -30,6 +30,7 @@
 /delete-node/ &mba_region;
 /delete-node/ &slpi_mem;
 /delete-node/ &spss_mem;
+/delete-node/ &xbl_mem;
 
 / {
 	model = "Xiaomi Mi MIX 2S";
@@ -61,6 +62,11 @@ key-vol-up {
 	};
 
 	reserved-memory {
+		xbl-mem@85d00000 {
+			reg = <0 0x85d00000 0 0x200000>;
+			no-map;
+		};
+
 		adsp_mem: memory@8c500000 {
 			reg = <0 0x8c500000 0 0x1e00000>;
 			no-map;
-- 
2.53.0



