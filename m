Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036140;
	b=JJ8DF2tTJdczJ4OPYbyGan7wkvASSkkxoImeavDD3TY+ygqX22sKG5M6RFK5wGNfomL7
	 jYaS9Ywqony5/wl/ACIxPXYpWwNlbhZyt7wBehfVVEKUncPhQxBHBXxNJJpQwjzCp11En
	 2wKt9US7uWOqTlwei70ztI1C6+Os9WgbQvHR+EsRq1EjQy7G1N6ToGrB0WbcGT/+NBGca
	 kddrInYGXurDA64nXQ3hfaJdVcF13D8XNrvYhN2FBPy/6Sjhms4lcwYJlhRpRHnfhSsZ5
	 xbkRaVTuPH+Lfvwea7y/o3/TMs4tjvW8qTqvKpl6ENokbYK23wG5aXzCCkeRZXkiP7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3cs29r9YvgDJzZC0eUn78uQL5Iv70Hx1oWxDjiVlM4o=;
	b=zp1hoOqhgRPMgtmG8DPDClsxfUk+P+yPKypcftQxmYaPQXiPo0ddFiPuATsyW+pTcBde
	 iyeiHELhSUg7rXVz2gJ5c0E/JkLozsK7TEhhvz2yFwXPAu//PN1cenioEh9wqcABwYI9j
	 OPu44ycNuiXTwE02jB4LfSeRQ7UtLAE3JPVMoVypar+ehgtDAA5mv5RxgSpTHqDp9HwDe
	 iC8/aqmOuuuCZ3DwmnTjgtCmyK7hnZLMZUA4KGzjvZgBI5lV5dgvsq0KRnW0N6QgviGxW
	 B1fy4UAo+qkktvrZ5zA18C7ubM+8/WzgQXJBl2g4g2jHSYUWLaHwmWPeRWVi+wDRDgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HntRIgCn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3B6606A325;
	Wed, 18 Nov 2026 21:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HntRIgCn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC411F000C4;
	Wed, 18 Nov 2026 21:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036139;
	bh=3cs29r9YvgDJzZC0eUn78uQL5Iv70Hx1oWxDjiVlM4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HntRIgCnm9Q2hNvoTg2eOY++WErozk0/rwG6Ft5eZimW4vBpJjCl9YG0BixktG9y8
	 7Bt3rBPOCGZUdk6WQUN3+3gFgKtuROVXZQXtIzpmqEcPL4KPBHzujHy/Uusj/2GvmX
	 lsAWh3rhuElp4Qr46GcYrWXUYSGifkXLsazLgGxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0952/3318] arm64: dts: qcom: sdm845-xiaomi-beryllium: Extend the xbl_mem region
Date: Wed, 18 Nov 2026 15:26:14 +0100
Message-ID: <20261118150348.176861917@linuxfoundation.org>
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
 .../arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
index f0a185b559ec0..57801790881b9 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
@@ -26,6 +26,7 @@
 /delete-node/ &slpi_mem;
 /delete-node/ &spss_mem;
 /delete-node/ &rmtfs_mem;
+/delete-node/ &xbl_mem;
 
 / {
 	chassis-type = "handset";
@@ -54,6 +55,11 @@ key-vol-up {
 
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



