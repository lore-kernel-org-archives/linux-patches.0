Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024522;
	b=5ZSIM2C+vtJA3z5z7F1mCjLPquU1PMWWfcsWGsNBkMtlVi0XKbyCiSSTOciei3Wg7Hnw
	 qA6xwsHVYZsWaMuMMf4OKM/X1WlIqhFfTM5izcKx9sAUHaIdP8jWV9S/Fz674U+AxDu/J
	 OirhbFpanpsrHzRzwwn8HLCkZKEC0A0mj9cZNtOaTJJD/ldNDd/ck6S3HhkGZj0sIyb5m
	 wMBp5zAD/R1ott7POadJGHW69BQ/zt9MVOijfr7SDJKvu0JnPCsDIrzxfQ6XHR5Ci4sqN
	 EsHmEnGgrUYxqrcgbTjKYLAwlyfwLxdCKb0rgSOFjIzra1few1sswV9XO4rWhFx99cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tb+PWR82XaUNG8hg1Oht3sO7sCrjnehYZ7T4SwXqPb0=;
	b=fycxbWC2WVj2nU3jwxsE1UYxMJNpXIwdIJrsAOtSuyyqB/8TscdoD5xN+DEdPQM2mTSY
	 Npecd/CgJSqb9iW9b1bcYFCz7hLmwkNhECAqUeojk8wsq0MHwGUbBik75ne+HYoWtElXG
	 Oc5DcJZrBk97DZXEvTjowmaoXcySqGZTT3kAjSIjU+05haWQ60ZPhsYTBzT2Vl6aCdtXo
	 A1nEmLOYHOQC5/MSHuC40VQ8KBq4BNf2UqgDyMNkTL349GYVHzZiJN7NlTX+D8esUWKsj
	 3zNL0ykqFPlzn71tCrZGdDRPOZmCSI0AhyX/k5ssOT3q6i/j+HdNAOuwEiBeqpymqwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qft9V9pM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E16C606A325;
	Wed, 18 Nov 2026 17:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qft9V9pM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D9B1F000C4;
	Wed, 18 Nov 2026 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024522;
	bh=tb+PWR82XaUNG8hg1Oht3sO7sCrjnehYZ7T4SwXqPb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qft9V9pMAfH6/7f30vdNg7zKOAPfczoC7909IXiRBKdy9ay4X5FoEGQHP1KUrgLSw
	 TGuqwrqqwvQsD2CJtO/cDTlIPZlSJxCFL+QObMSe9nsJAClejUybfNE5LPDJjyyVhr
	 6ZdNBwCtGy8sogwk2ql7sokOlglBjplx3xtsK2Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0755/2151] arm64: dts: qcom: monaco-evk: fix SerDes PHY regulator supplies
Date: Wed, 18 Nov 2026 15:41:30 +0100
Message-ID: <20261118150149.563397221@linuxfoundation.org>
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

From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>

[ Upstream commit de7bc562fc363421902db7bdda8e347cc78a5173 ]

The SerDes PHY node was configured with 'phy-supply = <&vreg_l4a>',
which only described one of the two supplies the hardware requires.
While vreg_l4a is the correct 0.9V rail, the 1.2V rail (vreg_l5a)
was missing entirely.

Replace phy-supply with the two named properties vdda-0p9-supply
(vreg_l4a) and vdda-1p2-supply (vreg_l5a).

Fixes: 117d6bc9326b ("arm64: dts: qcom: qcs8300: Add Monaco EVK board")
Signed-off-by: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260804-b4-sgmiieth_serdes_regulator-v2-5-c4bc688177dd@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/monaco-evk.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco-evk.dts b/arch/arm64/boot/dts/qcom/monaco-evk.dts
index e72cf6725a52c..cf8af1aa66bb4 100644
--- a/arch/arm64/boot/dts/qcom/monaco-evk.dts
+++ b/arch/arm64/boot/dts/qcom/monaco-evk.dts
@@ -427,7 +427,8 @@ &remoteproc_gpdsp {
 };
 
 &serdes0 {
-	phy-supply = <&vreg_l4a>;
+	vdda-0p9-supply = <&vreg_l4a>;
+	vdda-1p2-supply = <&vreg_l5a>;
 
 	status = "okay";
 };
-- 
2.53.0



