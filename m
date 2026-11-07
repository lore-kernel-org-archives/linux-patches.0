Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062111;
	b=DPNehycUDCqfX3w3w5n0pQtDXpyZxVTP2mmT4spsqB9nLvxQHtDh/p1zuSgSVdio9jm4
	 2sri+RMOo0y4Y/yN5e7SqwZUToeCkyl0KOF0a2qDQ5vqWkLJaGhFI6+K+DLBrtYVluuMg
	 srdqKpj3xjr2AszngM4Ogczqz7wWwyiajos7xrDK4J3yKDD4Pvhg9ncq1OvuKOs2b191q
	 /635XXYi4i/9z+ne73dET5Tywu1psSzXRSWNRzfObzLdmhCbSL63ve9ZD+TgG3Wvp/jzg
	 d8lS1ePr3tcY+6leafTY/ZK+Zy3z/LcYMYgpfXODG/8k5xIeUjAjfu+tZjl0In3bsSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+7XyvctxT3SiWczyE1RxECDlC+kQUu1f2Xw5HEmD5Wo=;
	b=M/z88gepNCBMyY49iUl5+50d6Xels7UdyO2ht9F6APiKzTQYxQj0jxEWnHMnTVh5LfBr
	 Jl3Y0ZpOgvKpLNUCQ6X7dKtHeshJ6iO597dzJwaQZjgHAs8stuG+X11RxcSNervh3lum+
	 A/QERE6q9fL4LuRi6iIVO+Ory7qLUozTo25pAcjZYaAfXj499fByRy1H1a0N7yy9Hnqa0
	 /5j08QVtngHZllbutYK9FhiFBe/ppzT8llqh/NHckHfI08bHUda9mEuvhCU8VRuPYrJiU
	 9JkacRHZAY70Mk9wOmrRo2ME4SRsO6aeGDBhONNv+7XIdV2C0w7XPMLiT3bsuDphJfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HghsGMN3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC26560A3817;
	Sat,  7 Nov 2026 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HghsGMN3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3DA1F0089F;
	Sat,  7 Nov 2026 14:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062110;
	bh=+7XyvctxT3SiWczyE1RxECDlC+kQUu1f2Xw5HEmD5Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HghsGMN3K6Ici1cjanfd8kCTAw9uxmT0/7yLEgrsi8YNLf+Hm7jFYdf10xHM7Uo3S
	 Ms75RU8YaUaj+KDo0H53HgOFR4td9Uku/E0KMcexoHuxv9dUVBRgCcnp+3ljp33g+O
	 Yx5pkIa386TExJcD1gSZGFrQvWWLU4j7o05mGJXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1083/1536] arm64: dts: qcom: sdm845-xiaomi-polaris: Extend the xbl_mem region
Date: Sat,  7 Nov 2026 08:51:39 -0500
Message-ID: <20261107135028.115258761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index e386b504e978b..7573b404a2a6f 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -31,6 +31,7 @@
 /delete-node/ &mba_region;
 /delete-node/ &slpi_mem;
 /delete-node/ &spss_mem;
+/delete-node/ &xbl_mem;
 
 / {
 	model = "Xiaomi Mi MIX 2S";
@@ -62,6 +63,11 @@ key-vol-up {
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



