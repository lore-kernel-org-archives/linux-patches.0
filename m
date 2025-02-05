Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3BB1FCF66;
	Wed,  5 Feb 2025 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766879; cv=none; b=fSYi5ILlsf7INlV4EOceTns1M0QhL0DxQ3N/7ddZN567sGX+jTh5c5+CRHnlzIoJYJgpp397XA61f9XpGcGTaYJ6ztI7itx71b0+QP8ecuWVfmOtEW4mgJNwnuocj4m2EMW80pG0psQuuGkKNrfsls67MX1HS7rg4ctDm0wO36w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766879; c=relaxed/simple;
	bh=HsGHCdJIUUM9YUAoSjGYEW7ZG+8Vt1qn81fzVSVwczU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbL3+Ic8YRZ7VQ6ro5CIq4oWLOAaEimTTNghxZCzKbbMgsAowNJRbwIHY9CmWxroex2dhKMLq2tzK7Bti8uI0VirOfEXTcpu8+uoreCpw96da3R71WcTWG49HGleqM0ed7VrRAZ1wX3VODr5ZlQ31j8MfPKhaa//htuddQQRTzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18OCUQ3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18OCUQ3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDB5C4CED1;
	Wed,  5 Feb 2025 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766879;
	bh=HsGHCdJIUUM9YUAoSjGYEW7ZG+8Vt1qn81fzVSVwczU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18OCUQ3w3spZ6VrgFhagTKJVksDvRm6EaHv1flGyAVCZFpQLULr+6Z5ebDrpu1C4g
	 zULIOZtROx9lvIXqFjpXtnBSz7JQVz4rFJcOOvnXGMc7m9JLiJvlEVoYry3mKpyPjt
	 o790+fcjAg97ptoblhfTtKnllQgB72hUxypMieeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 375/590] arm64: dts: qcom: sc7180-trogdor-pompom: rename 5v-choke thermal zone
Date: Wed,  5 Feb 2025 14:42:10 +0100
Message-ID: <20250205134509.617399885@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 9180b38d706c29ed212181a77999c35ae9ff6879 ]

Rename the 5v-choke thermal zone to satisfy the bindings.

This fixes:
sc7180-trogdor-pompom-r2-lte.dts: thermal-zones: '5v-choke-thermal' does not match any of the regexes: '^[a-zA-Z][a-zA-Z0-9\\-]{1,10}-thermal$', 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/thermal/thermal-zones.yaml#

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241230-topic-misc-dt-fixes-v4-4-1e6880e9dda3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
index ac8d4589e3fb7..f7300ffbb4519 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
@@ -12,11 +12,11 @@
 
 / {
 	thermal-zones {
-		5v-choke-thermal {
+		choke-5v-thermal {
 			thermal-sensors = <&pm6150_adc_tm 1>;
 
 			trips {
-				5v-choke-crit {
+				choke-5v-crit {
 					temperature = <125000>;
 					hysteresis = <1000>;
 					type = "critical";
-- 
2.39.5



