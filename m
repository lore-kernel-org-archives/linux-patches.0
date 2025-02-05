Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871D9DF59;
	Wed,  5 Feb 2025 14:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767449; cv=none; b=rsvaEgH/YPABO5Cw687S3FTk+tNfuiUIy3o/cYo70wJ6O5+oQN8AklNergZS45RWWL0YRysfclD2hLXZlZ9i58SVTgsm9T11KgLK2UueYUM8yexdMKzQIeLtUV4ds/HI6d1dy6VmKYKveSDNbT5TsJgp+zTlr+aDDkyxFyz9B08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767449; c=relaxed/simple;
	bh=MUfD5cmLmF1oOQjMkTxie6oHNZYeaaDkhfPGebdfbxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8bi9YgY3J9ZxHmL/rPaJWF4gvRqBCw63drEjg8293Qk9MQdmLHW4uLVYYNixh4sZr3zRc4/s7iNDzFFFrRJtStLxcYNj5KpWcZGx4rnulKD4aeXSt2A0qFtjFBpJ9CO44bmnvGVqNsaMnQVDbAMZgnTiQt78e2a26SLJHAkQfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njjTyQ7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njjTyQ7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02B1C4CED1;
	Wed,  5 Feb 2025 14:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767449;
	bh=MUfD5cmLmF1oOQjMkTxie6oHNZYeaaDkhfPGebdfbxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njjTyQ7S0UG0l9tZZ5eVoFs/Ab/FBmbN4NNTCjHQZad1E7tbp1OnTx50PYpp7HGzB
	 rEKqMJIjkz/KAD/pYT44retrZlU7bCd19pRrNzhIkrdjIf7OSCYoAGWU9NslOty6vC
	 mLvMYTWD9KFeaNoPZL/LGRBRsoIyN8VTw/3xNY50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 406/623] arm64: dts: qcom: sc7180-trogdor-pompom: rename 5v-choke thermal zone
Date: Wed,  5 Feb 2025 14:42:28 +0100
Message-ID: <20250205134511.755512586@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



