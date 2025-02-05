Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B518634E;
	Wed,  5 Feb 2025 14:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765558; cv=none; b=CZzB9jgqFwOFj+DvZdBqrwfkynvScbtO8WCndCVR0i7yfUO1Si6h+hLHccyTIoRZOzYyTCtqvofifh0cNHJS3YoUC4EUDNlidK+0ChZb1EpA62rafLep4YhJkIfVHYlAtZoV6VM2y0BlX6xXejKcQsYY6pfcT/ndm3XQiThrDlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765558; c=relaxed/simple;
	bh=55hFzPckFSmXqi0GmusrSnzS+k61plCTIA2XYTOOvNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eb0EOeao4JVkkw8YFOSp4kmQszuGWobMZ9uI5sDJ/oEPTZKVM1i9Bh/H/cHCZTvEQx3qy0TSkLJzKFib/q/Ge5cOw+4zX9XRqUtkkW8nEOJgcZTGjc8R7uERlMLWV7L5dFEk0Op2QmjkVk94x61H3o2879h3Obrb92tmFgAukak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rU5BXxvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rU5BXxvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0B0C4CED1;
	Wed,  5 Feb 2025 14:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765558;
	bh=55hFzPckFSmXqi0GmusrSnzS+k61plCTIA2XYTOOvNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rU5BXxvNmfM20dhQYAIHsp7VsKbHimM4tPgQN+tJR3einO55cgNnTsJ9QeuxaQJon
	 ynlz0gu4ddaQAP/U6TVoTuRXDlT0jdO05YqECAz5YBb1+yEurxP/Lg/xWFOPCg7iid
	 JISkNC3INTU+NprznO1gjhlQgk+c8btwI20f/uN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/393] arm64: dts: qcom: sc7180-trogdor-pompom: rename 5v-choke thermal zone
Date: Wed,  5 Feb 2025 14:42:59 +0100
Message-ID: <20250205134430.259134981@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b5ef846e2191e..7a05d502620f3 100644
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



