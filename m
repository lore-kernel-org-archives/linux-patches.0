Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052389;
	b=1VBFiztr7J1WbzF/qjcc7HCsie/loAk+6jAghbkDc/d9kAQTLTNpkXXgEqfusSTM2sVb
	 +pqHrYX5V1Lh34O5Yof2EQblaDPzFZIxBHONp1+G6e+RBk0qBeMCqLj6MNiClpfY4oeh7
	 7mNpdKDyH3vbPEUYkccjyNWXPY7BsUHylMStMDpgue9SstE5t5uehdAdIqOUicX2G4C6b
	 qHcxkKU5pfy4qsTKqq9FVX6upqTgxCfBoIyaUyCzLZoVJiNUVAnGhcYxEWfYM8U+dUs8t
	 hvvyY9JxU+DUgRITfXfAGssJttT91RxMA/XO1DNJFmPlQS9OFtMi30kNpQLRFHDdHsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6k1V4WE3V/YFp3C0EgQof4f1aU2heAaw+JJItOiXpng=;
	b=IzLxgjbgyf5JYRnHMWOV+CCptc783LFLLnKJ23mN2Wappql2G4Ks2lYZwCtInY3R2Ha5
	 wenX5iXA2NGyvCaXd4dS44fK+OeF0pp7ur4oMf0v4kubejCuSq9TrcjPWKBEakUY6We1F
	 AVqKj/VPMRGCZVRRui5+ZrclSfsJrF/19y5qCewEvH56rjTSij+SIQq4jDhz/yz5qUDSw
	 +JpJ4+LSp6kwhWBw+7Y/it5u7idV5U2qUjJVw9Es4EnrOytO2/2Ip1w0SHbFQlZz1Wbqy
	 s04WCnvpMGqweFo6Xd9fFcfkUoMFzwAljWnK3iiO2DWI3Is3o1owZmc3PankDQ499kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGZ3GpsE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E876606A332;
	Thu, 19 Nov 2026 01:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGZ3GpsE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BDA1F000C4;
	Thu, 19 Nov 2026 01:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052389;
	bh=6k1V4WE3V/YFp3C0EgQof4f1aU2heAaw+JJItOiXpng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uGZ3GpsEzpdJ5Kh6r/v9ADlKaeVcR7ZLjpDlIeiVGsA1OBIwUAd2mmHT8F/1CJcKd
	 yf/ohVxHCivzX3XF2SKId68mTgYGcsqi6Gz9CBZ5Wpsy622Enrp8cSH81hzL/JxRY8
	 Hxzu1/oB3KE9XgdQcH5nTJ9T49lPsSuYaCJsLNJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0546/2214] arm64: dts: qcom: sdm845-xiaomi-beryllium: Extend the xbl_mem region
Date: Wed, 18 Nov 2026 15:37:02 +0100
Message-ID: <20261118150032.856974801@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 511c4fea32708a065e03503c0e4d44f48990c530 ]

Xiaomi's Oreo-era tree still had the CAF 1 MiB region, the 2 MiB version
arrived with the Pie import. This isn't a board-layout quirk, it tracks
the firmware. The later XBL wants one extra MiB below the old region.

Cc: stable@vger.kernel.org
Fixes: 77809cf74a8c ("arm64: dts: qcom: Add support for Xiaomi Poco F1 (Beryllium)")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-sdm845-xbl-mem-v1-1-6e3c88507997@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
index a4ff9e67a1684..caedda2fc5250 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
@@ -25,6 +25,7 @@
 /delete-node/ &slpi_mem;
 /delete-node/ &spss_mem;
 /delete-node/ &rmtfs_mem;
+/delete-node/ &xbl_mem;
 
 / {
 	model = "Xiaomi Pocophone F1";
@@ -54,6 +55,11 @@ vol-up {
 
 	/* Reserved memory changes from downstream */
 	reserved-memory {
+		xbl-mem@85d00000 {
+			reg = <0 0x85d00000 0 0x200000>;
+			no-map;
+		};
+
 		tz_mem: memory@86200000 {
 			reg = <0 0x86200000 0 0x4900000>;
 			no-map;
-- 
2.53.0



